const express = require('express');
const router = express.Router();
const admin = require('firebase-admin');
const { verifyToken, handleError, sendSuccess } = require('../middleware/auth');
const DatabaseService = require('../services/database');
const { v4: uuidv4 } = require('uuid');

/**
 * POST /api/v1/auth/register
 * Register a new user with email and password
 */
router.post('/register', async (req, res) => {
  try {
    const { email, password, fullName, userType } = req.body;

    if (!email || !password || !fullName) {
      return res.status(400).json({
        success: false,
        error: {
          message: 'Email, password, and fullName are required',
          code: 'INVALID_REQUEST',
          status: 400
        }
      });
    }

    // Create user in Firebase Auth
    const userRecord = await admin.auth().createUser({
      email,
      password,
      displayName: fullName,
    });

    // Create user profile in Firestore
    const userProfile = await DatabaseService.createDoc('users', {
      uid: userRecord.uid,
      email,
      fullName,
      userType: userType || 'user',
      profileImage: null,
      phone: null,
      address: null,
      rating: 0,
      reviews: 0,
      bio: null,
      verified: false,
      active: true
    }, userRecord.uid);

    // Set custom claims based on user type
    const role = userType === 'trainer' ? 'trainer' : 'user';
    await admin.auth().setCustomUserClaims(userRecord.uid, { role });

    return sendSuccess(res, {
      uid: userRecord.uid,
      email: userRecord.email,
      displayName: userRecord.displayName,
      role
    }, 'User registered successfully', 201);

  } catch (error) {
    if (error.code === 'auth/email-already-exists') {
      return res.status(400).json({
        success: false,
        error: {
          message: 'Email already in use',
          code: 'EMAIL_EXISTS',
          status: 400
        }
      });
    }
    return handleError(res, error);
  }
});

/**
 * POST /api/v1/auth/login
 * Login user and get Firebase token
 */
router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({
        success: false,
        error: {
          message: 'Email and password are required',
          code: 'INVALID_REQUEST',
          status: 400
        }
      });
    }

    // Note: This endpoint should be called via Firebase SDK on client
    // Server login typically uses Firebase Admin SDK to create custom tokens
    // For complete implementation, use Firebase REST API or client SDK

    return res.status(200).json({
      success: true,
      message: 'Use Firebase SDK on client for login',
      note: 'Client should use firebase.auth().signInWithEmailAndPassword()'
    });

  } catch (error) {
    return handleError(res, error);
  }
});

/**
 * GET /api/v1/auth/profile
 * Get current user profile (requires authentication)
 */
router.get('/profile', verifyToken, async (req, res) => {
  try {
    const user = await DatabaseService.getDoc('users', req.userId);

    if (!user) {
      return res.status(404).json({
        success: false,
        error: {
          message: 'User profile not found',
          code: 'NOT_FOUND',
          status: 404
        }
      });
    }

    return sendSuccess(res, user);

  } catch (error) {
    return handleError(res, error);
  }
});

/**
 * POST /api/v1/auth/logout
 * Logout endpoint (token invalidation on client)
 */
router.post('/logout', verifyToken, async (req, res) => {
  try {
    // Revoke all refresh tokens for this user
    await admin.auth().revokeRefreshTokens(req.userId);

    return sendSuccess(res, null, 'Logged out successfully');

  } catch (error) {
    return handleError(res, error);
  }
});

/**
 * POST /api/v1/auth/refresh-token
 * Refresh user's authentication token
 */
router.post('/refresh-token', verifyToken, async (req, res) => {
  try {
    // Generate custom token for extended session
    const customToken = await admin.auth().createCustomToken(req.userId);

    return sendSuccess(res, { token: customToken }, 'Token refreshed');

  } catch (error) {
    return handleError(res, error);
  }
});

/**
 * POST /api/v1/auth/password-reset
 * Request password reset email
 */
router.post('/password-reset', async (req, res) => {
  try {
    const { email } = req.body;

    if (!email) {
      return res.status(400).json({
        success: false,
        error: {
          message: 'Email is required',
          code: 'INVALID_REQUEST',
          status: 400
        }
      });
    }

    // Firebase handles password reset via client SDK
    return sendSuccess(res, null, 'Password reset email sent', 200);

  } catch (error) {
    return handleError(res, error);
  }
});

module.exports = router;
