import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

/// Centralized admin API service for all admin operations.
/// Handles verification, data fetching, mutations, and audit logging.
class AdminApiService extends GetxService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  late String _adminId;
  late String? _adminRole;

  Future<AdminApiService> init() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    _adminId = user.uid;
    await _verifyAdminRole();
    return this;
  }

  Future<void> _verifyAdminRole() async {
    try {
      final doc = await _firestore.collection('users').doc(_adminId).get();
      final role = doc.data()?['role'] as String?;

      if (role == null ||
          ![
            'admin',
            'super_admin',
            'support_admin',
            'finance_admin',
            'moderator',
            'read_only_admin',
          ].contains(role)) {
        throw Exception('User is not an admin');
      }

      _adminRole = role;
    } catch (e) {
      throw Exception('Failed to verify admin role: $e');
    }
  }

  String get adminId => _adminId;
  String? get adminRole => _adminRole;
  bool get hasPermission => _adminRole != null;

  // ─── USERS MANAGEMENT ─────────────────────────────────────────────────────

  Future<Map<String, dynamic>> searchUsers({
    required String? searchQuery,
    required String? status,
    required String sortBy,
    required int limit,
    DocumentSnapshot? lastDoc,
  }) async {
    try {
      Query query = _firestore.collection('users');

      // Apply filters
      if (status != null && status.isNotEmpty) {
        query = query.where('accountStatus', isEqualTo: status);
      }

      // Sort
      if (sortBy == 'createdAt') {
        query = query.orderBy('createdAt', descending: true);
      } else if (sortBy == 'status') {
        query = query
            .orderBy('accountStatus')
            .orderBy('createdAt', descending: true);
      }

      // Pagination
      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }

      query = query.limit(limit + 1);
      final snap = await query.get();

      // Search in-memory if query provided
      var docs = snap.docs;
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final q = searchQuery.toLowerCase();
        docs =
            docs.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final name = (data['name'] as String?)?.toLowerCase() ?? '';
              final email = (data['email'] as String?)?.toLowerCase() ?? '';
              return name.contains(q) || email.contains(q);
            }).toList();
      }

      final hasMore = docs.length > limit;
      if (hasMore) docs = docs.sublist(0, limit);

      return {
        'users':
            docs
                .map(
                  (doc) => {
                    'id': doc.id,
                    ...doc.data() as Map<String, dynamic>,
                  },
                )
                .toList(),
        'hasMore': hasMore,
        'lastDoc': docs.isNotEmpty ? docs.last : null,
      };
    } catch (e) {
      rethrow;
    }
  }

  Future<void> suspendUser({
    required String userId,
    required String reason,
  }) async {
    try {
      final batch = _firestore.batch();
      final userRef = _firestore.collection('users').doc(userId);

      // Update user status
      batch.update(userRef, {
        'accountStatus': 'suspended',
        'suspendedAt': FieldValue.serverTimestamp(),
        'suspendReason': reason,
      });

      // Audit log
      await batch.commit();
      await _logAudit(
        action: 'user.suspend',
        target: userId,
        before: {'accountStatus': 'active'},
        after: {'accountStatus': 'suspended', 'suspendReason': reason},
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> reactivateUser(String userId) async {
    try {
      final batch = _firestore.batch();
      final userRef = _firestore.collection('users').doc(userId);

      batch.update(userRef, {
        'accountStatus': 'active',
        'suspendedAt': FieldValue.delete(),
        'suspendReason': FieldValue.delete(),
      });

      await batch.commit();
      await _logAudit(
        action: 'user.reactivate',
        target: userId,
        before: {'accountStatus': 'suspended'},
        after: {'accountStatus': 'active'},
      );
    } catch (e) {
      rethrow;
    }
  }

  // ─── TRAINER APPLICATIONS ─────────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getTrainerApplications({
    required String status,
  }) async {
    try {
      final snap =
          await _firestore
              .collection('trainerApplications')
              .where('status', isEqualTo: status)
              .orderBy('submittedAt', descending: true)
              .get();

      return snap.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> approveTrainerApplication({
    required String applicationId,
    required String userId,
  }) async {
    try {
      final batch = _firestore.batch();

      // Update application
      batch.update(
        _firestore.collection('trainerApplications').doc(applicationId),
        {
          'status': 'approved',
          'approvedAt': FieldValue.serverTimestamp(),
          'approvedBy': _adminId,
        },
      );

      // Promote user to trainer
      batch.update(_firestore.collection('users').doc(userId), {
        'role': 'trainer',
      });

      await batch.commit();
      await _logAudit(
        action: 'trainer.approve',
        target: applicationId,
        before: {'status': 'pending', 'userRole': 'user'},
        after: {'status': 'approved', 'userRole': 'trainer'},
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> rejectTrainerApplication({
    required String applicationId,
    required String reviewerNotes,
  }) async {
    try {
      await _firestore
          .collection('trainerApplications')
          .doc(applicationId)
          .update({
            'status': 'rejected',
            'rejectedAt': FieldValue.serverTimestamp(),
            'rejectedBy': _adminId,
            'reviewerNotes': reviewerNotes,
          });

      await _logAudit(
        action: 'trainer.reject',
        target: applicationId,
        before: {'status': 'pending'},
        after: {'status': 'rejected', 'notes': reviewerNotes},
      );
    } catch (e) {
      rethrow;
    }
  }

  // ─── BOOKINGS MANAGEMENT ──────────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getBookingsFiltered({
    required DateTime? dateFrom,
    required DateTime? dateTo,
    required String? status,
    required String? trainerId,
  }) async {
    try {
      Query query = _firestore.collection('bookings');

      if (status != null && status.isNotEmpty) {
        query = query.where('status', isEqualTo: status);
      }

      if (trainerId != null && trainerId.isNotEmpty) {
        query = query.where('trainerId', isEqualTo: trainerId);
      }

      if (dateFrom != null && dateTo != null) {
        query = query
            .where('scheduledAt', isGreaterThanOrEqualTo: dateFrom)
            .where('scheduledAt', isLessThanOrEqualTo: dateTo);
      }

      final snap = await query.orderBy('scheduledAt', descending: true).get();

      return snap.docs.map((doc) {
        final data = <String, dynamic>{'id': doc.id};
        final docData = doc.data() as Map<String, dynamic>?;
        if (docData != null) data.addAll(docData);
        return data;
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancelBooking({
    required String bookingId,
    required String reason,
  }) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).update({
        'status': 'cancelled',
        'cancelledAt': FieldValue.serverTimestamp(),
        'cancelReason': reason,
        'cancelledBy': _adminId,
      });

      await _logAudit(
        action: 'booking.cancel',
        target: bookingId,
        before: {'status': 'confirmed'},
        after: {'status': 'cancelled', 'reason': reason},
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> reassignBooking({
    required String bookingId,
    required String newTrainerId,
  }) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).update({
        'trainerId': newTrainerId,
        'reassignedAt': FieldValue.serverTimestamp(),
        'reassignedBy': _adminId,
      });

      await _logAudit(
        action: 'booking.reassign',
        target: bookingId,
        before: {},
        after: {'newTrainerId': newTrainerId},
      );
    } catch (e) {
      rethrow;
    }
  }

  // ─── SUPPORT & DISPUTES ───────────────────────────────────────────────────

  Future<void> assignSupportTicket({
    required String ticketId,
    required String assigneeId,
  }) async {
    try {
      await _firestore.collection('supportTickets').doc(ticketId).update({
        'assignedTo': assigneeId,
        'assignedAt': FieldValue.serverTimestamp(),
      });

      await _logAudit(
        action: 'support.assign',
        target: ticketId,
        before: {},
        after: {'assignedTo': assigneeId},
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resolveSupportTicket({
    required String ticketId,
    required String resolution,
  }) async {
    try {
      await _firestore.collection('supportTickets').doc(ticketId).update({
        'status': 'resolved',
        'resolvedAt': FieldValue.serverTimestamp(),
        'resolution': resolution,
      });

      await _logAudit(
        action: 'support.resolve',
        target: ticketId,
        before: {'status': 'open'},
        after: {'status': 'resolved'},
      );
    } catch (e) {
      rethrow;
    }
  }

  // ─── FINANCE & PAYOUTS ────────────────────────────────────────────────────

  Future<void> approvePayout({
    required String payoutId,
    required double amount,
  }) async {
    try {
      const dualApprovalThreshold = 5000.0;
      final requiresDualApproval = amount > dualApprovalThreshold;

      await _firestore.collection('payouts').doc(payoutId).update({
        'status': requiresDualApproval ? 'pending_second_approval' : 'approved',
        'firstApprovedBy': _adminId,
        'firstApprovedAt': FieldValue.serverTimestamp(),
      });

      await _logAudit(
        action: 'payout.approve',
        target: payoutId,
        before: {'status': 'pending'},
        after: {
          'status':
              requiresDualApproval ? 'pending_second_approval' : 'approved',
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> approveDualPayoutFinal({required String payoutId}) async {
    try {
      await _firestore.collection('payouts').doc(payoutId).update({
        'status': 'approved',
        'secondApprovedBy': _adminId,
        'secondApprovedAt': FieldValue.serverTimestamp(),
      });

      await _logAudit(
        action: 'payout.approve_final',
        target: payoutId,
        before: {'status': 'pending_second_approval'},
        after: {'status': 'approved'},
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> markPayoutAsPaid({required String payoutId}) async {
    try {
      await _firestore.collection('payouts').doc(payoutId).update({
        'status': 'paid',
        'paidAt': FieldValue.serverTimestamp(),
      });

      await _logAudit(
        action: 'payout.mark_paid',
        target: payoutId,
        before: {'status': 'approved'},
        after: {'status': 'paid'},
      );
    } catch (e) {
      rethrow;
    }
  }

  // ─── AUDIT LOGGING (Immutable) ────────────────────────────────────────────

  Future<void> _logAudit({
    required String action,
    required String target,
    required Map<String, dynamic> before,
    required Map<String, dynamic> after,
  }) async {
    try {
      const uuid = Uuid();
      final requestId = uuid.v4();

      await _firestore.collection('auditLogs').add({
        'requestId': requestId,
        'actorId': _adminId,
        'action': action,
        'target': target,
        'before': before,
        'after': after,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'completed',
      });
    } catch (e) {
      // Log failures shouldn't break operations, but should be monitored
      print('Audit log write failed: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAuditLogs({
    required int limit,
    DocumentSnapshot? lastDoc,
  }) async {
    try {
      Query query = _firestore
          .collection('auditLogs')
          .orderBy('timestamp', descending: true);

      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }

      final snap = await query.limit(limit).get();

      return snap.docs.map((doc) {
        final data = <String, dynamic>{'id': doc.id};
        final docData = doc.data() as Map<String, dynamic>?;
        if (docData != null) data.addAll(docData);
        return data;
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  // ─── ANALYTICS ────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> getAnalytics() async {
    try {
      final userCount =
          await _firestore
              .collection('users')
              .where('accountStatus', isEqualTo: 'active')
              .count()
              .get();

      final trainerCount =
          await _firestore
              .collection('users')
              .where('role', isEqualTo: 'trainer')
              .count()
              .get();

      final bookingCount =
          await _firestore
              .collection('bookings')
              .where('status', isEqualTo: 'completed')
              .count()
              .get();

      final transactionSnap =
          await _firestore
              .collection('transactions')
              .orderBy('createdAt', descending: true)
              .limit(100)
              .get();

      double totalRevenue = 0;
      for (var doc in transactionSnap.docs) {
        totalRevenue += (doc.data()['amount'] as num?)?.toDouble() ?? 0;
      }

      return {
        'activeUsers': userCount.count,
        'trainers': trainerCount.count,
        'completedBookings': bookingCount.count,
        'monthlyRevenue': totalRevenue,
      };
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }
}
