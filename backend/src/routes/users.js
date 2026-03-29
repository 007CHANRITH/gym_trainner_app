const express = require('express');
const router = express.Router();
const { verifyToken, handleError, sendSuccess } = require('../middleware/auth');
const DatabaseService = require('../services/database');

/**
 * GET /api/v1/users/:userId
 * Get user profile by ID
 */
router.get('/:userId', async (req, res) => {
  try {
    const user = await DatabaseService.getDoc('users', req.params.userId);

    if (!user) {
      return res.status(404).json({
        success: false,
        error: {
          message: 'User not found',
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
 * GET /api/v1/users
 * Search users by name or email
 */
router.get('/', async (req, res) => {
  try {
    const { query, limit = 10, offset = 0 } = req.query;

    let filters = [];
    if (query) {
      // Search by fullName or email
      filters.push({
        field: 'fullName',
        operator: '>=',
        value: query
      });
    }

    const result = await DatabaseService.query('users', filters, { field: 'createdAt', direction: 'desc' }, limit, offset);

    return sendSuccess(res, result);

  } catch (error) {
    return handleError(res, error);
  }
});

/**
 * PUT /api/v1/users/:userId
 * Update user profile (requires authentication)
 */
router.put('/:userId', verifyToken, async (req, res) => {
  try {
    // Only allow users to update their own profile
    if (req.userId !== req.params.userId) {
      return res.status(403).json({
        success: false,
        error: {
          message: 'Unauthorized to update this profile',
          code: 'FORBIDDEN',
          status: 403
        }
      });
    }

    const { fullName, phone, address, profileImage, bio } = req.body;

    const updateData = {};
    if (fullName) updateData.fullName = fullName;
    if (phone) updateData.phone = phone;
    if (address) updateData.address = address;
    if (profileImage) updateData.profileImage = profileImage;
    if (bio) updateData.bio = bio;

    const updated = await DatabaseService.updateDoc('users', req.userId, updateData);

    return sendSuccess(res, updated, 'Profile updated successfully');

  } catch (error) {
    return handleError(res, error);
  }
});

/**
 * GET /api/v1/users/:userId/bookings
 * Get user's bookings
 */
router.get('/:userId/bookings', async (req, res) => {
  try {
    const { limit = 10, offset = 0, status } = req.query;

    let filters = [{ field: 'userId', operator: '==', value: req.params.userId }];
    if (status) {
      filters.push({ field: 'status', operator: '==', value: status });
    }

    const result = await DatabaseService.query(
      'bookings',
      filters,
      { field: 'bookingDate', direction: 'desc' },
      limit,
      offset
    );

    return sendSuccess(res, result);

  } catch (error) {
    return handleError(res, error);
  }
});

/**
 * GET /api/v1/users/:userId/favourites
 * Get user's favourite trainers
 */
router.get('/:userId/favourites', async (req, res) => {
  try {
    const { limit = 20, offset = 0 } = req.query;

    const result = await DatabaseService.query(
      'favourites',
      [{ field: 'userId', operator: '==', value: req.params.userId }],
      { field: 'createdAt', direction: 'desc' },
      limit,
      offset
    );

    return sendSuccess(res, result);

  } catch (error) {
    return handleError(res, error);
  }
});

/**
 * POST /api/v1/users/:userId/favourites
 * Add trainer to favourites
 */
router.post('/:userId/favourites', verifyToken, async (req, res) => {
  try {
    if (req.userId !== req.params.userId) {
      return res.status(403).json({
        success: false,
        error: {
          message: 'Unauthorized',
          code: 'FORBIDDEN',
          status: 403
        }
      });
    }

    const { trainerId } = req.body;

    if (!trainerId) {
      return res.status(400).json({
        success: false,
        error: {
          message: 'trainerId is required',
          code: 'INVALID_REQUEST',
          status: 400
        }
      });
    }

    const favourite = await DatabaseService.createDoc('favourites', {
      userId: req.userId,
      trainerId,
      addedAt: new Date()
    });

    return sendSuccess(res, favourite, 'Added to favourites', 201);

  } catch (error) {
    return handleError(res, error);
  }
});

/**
 * DELETE /api/v1/users/:userId/favourites/:trainerId
 * Remove trainer from favourites
 */
router.delete('/:userId/favourites/:trainerId', verifyToken, async (req, res) => {
  try {
    if (req.userId !== req.params.userId) {
      return res.status(403).json({
        success: false,
        error: {
          message: 'Unauthorized',
          code: 'FORBIDDEN',
          status: 403
        }
      });
    }

    // Delete all matching favourites
    const favourites = await DatabaseService.query('favourites', [
      { field: 'userId', operator: '==', value: req.userId },
      { field: 'trainerId', operator: '==', value: req.params.trainerId }
    ]);

    if (favourites.items.length > 0) {
      await DatabaseService.deleteDoc('favourites', favourites.items[0].id);
    }

    return sendSuccess(res, null, 'Removed from favourites');

  } catch (error) {
    return handleError(res, error);
  }
});

module.exports = router;
