import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

/// Service to load and check admin permissions based on user role.
class AdminPermissionService extends GetxService {
  Map<String, dynamic> _permissionsConfig = {};
  Map<String, List<String>> _rolePermissions = {};
  List<Map<String, dynamic>> _menuItems = [];

  Future<AdminPermissionService> init() async {
    try {
      // Load admin_role_permissions.json
      final roleJson = await rootBundle.loadString(
        'assets/config/admin_role_permissions.json',
      );
      _permissionsConfig = jsonDecode(roleJson);
      _parseRolePermissions();

      // Load admin_menu_permissions.json
      final menuJson = await rootBundle.loadString(
        'assets/config/admin_menu_permissions.json',
      );
      final menuConfig = jsonDecode(menuJson);
      _menuItems = List<Map<String, dynamic>>.from(menuConfig['menu'] ?? []);
    } catch (e) {
      print('Error loading permission config: $e');
    }
    return this;
  }

  void _parseRolePermissions() {
    final roles = _permissionsConfig['roles'] as Map<String, dynamic>?;
    if (roles == null) return;

    for (final entry in roles.entries) {
      final role = entry.key;
      final perms = entry.value['permissions'] as List?;
      if (perms != null) {
        _rolePermissions[role] = List<String>.from(perms);
      }
    }
  }

  /// Check if user has a specific permission (e.g., "users.read")
  bool hasPermission(String role, String permission) {
    if (role == 'super_admin') return true;

    final perms = _rolePermissions[role] ?? [];
    return perms.contains(permission) || perms.contains('*');
  }

  /// Get all permissions for a role
  List<String> getPermissions(String role) {
    if (role == 'super_admin') return ['*'];
    return _rolePermissions[role] ?? [];
  }

  /// Filter menu items based on user permissions
  List<Map<String, dynamic>> getAvailableMenu(String role) {
    return _menuItems.where((item) {
      final requiredPerms = List<String>.from(item['permissions'] ?? []);
      return requiredPerms.isEmpty ||
          requiredPerms.any((perm) => hasPermission(role, perm));
    }).toList();
  }

  /// Get menu item by ID
  Map<String, dynamic>? getMenuItem(String id) {
    try {
      return _menuItems.firstWhere((item) => item['id'] == id);
    } catch (e) {
      return null;
    }
  }

  /// Check if user can access a menu item
  bool canAccessMenuItem(String role, String itemId) {
    final item = getMenuItem(itemId);
    if (item == null) return false;

    final requiredPerms = List<String>.from(item['permissions'] ?? []);
    return requiredPerms.isEmpty ||
        requiredPerms.any((perm) => hasPermission(role, perm));
  }
}
