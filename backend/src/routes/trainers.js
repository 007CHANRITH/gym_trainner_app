const express = require('express');
const router = express.Router();
const { verifyToken, handleError, sendSuccess } = require('../middleware/auth');
const DatabaseService = require('../services/database');

/**
 * GET /api/v1/trainers
 * Get all trainers with optional filters and pagination
 */
router.get('/', async (req, res) => {
  try {
    const { limit = 10, offset = 0, speciality, minRating, search } = req.query;

    // Simple query without ordering to avoid complex index requirement
    let filters = [{ field: 'userType', operator: '==', value: 'trainer' }];

    if (speciality) {
      filters.push({ field: 'speciality', operator: '==', value: speciality });
    }

    // Get trainers without complex ordering first
    const result = await DatabaseService.query(
      'users',
      filters,
      null, // Skip ordering while index builds
      parseInt(limit),
      parseInt(offset)
    );

    // Filter by minRating in application code if provided
    if (minRating) {
      result.items = result.items.filter(t => (t.rating || 0) >= parseFloat(minRating));
    }

    // Sort by rating in application code
    result.items.sort((a, b) => (b.rating || 0) - (a.rating || 0));

    // Transform items to include trainerId field
    result.items = result.items.map(trainer => ({
      ...trainer,
      trainerId: trainer.id, // Ensure trainerId is set
      specialty: trainer.speciality || trainer.specialty || '', // Support both spellings
      reviews: trainer.rating ? Math.round(trainer.rating * 10) : 0, // Calculate reviews count
      sessions: trainer.rating ? Math.round(trainer.rating * 10) : 0
    }));

    return sendSuccess(res, result);

  } catch (error) {
    return handleError(res, error);
  }
});

/**
 * GET /api/v1/trainers/:trainerId
 * Get specific trainer details
 */
router.get('/:trainerId', async (req, res) => {
  try {
    const trainer = await DatabaseService.getDoc('users', req.params.trainerId);

    if (!trainer || trainer.userType !== 'trainer') {
      return res.status(404).json({
        success: false,
        error: {
          message: 'Trainer not found',
          code: 'NOT_FOUND',
          status: 404
        }
      });
    }

    return sendSuccess(res, trainer);

  } catch (error) {
    return handleError(res, error);
  }
});

/**
 * GET /api/v1/trainers/:trainerId/availability
 * Get trainer's availability slots
 */
router.get('/:trainerId/availability', async (req, res) => {
  try {
    const result = await DatabaseService.query('availability', [
      { field: 'trainerId', operator: '==', value: req.params.trainerId },
      { field: 'available', operator: '==', value: true }
    ]);

    return sendSuccess(res, result);

  } catch (error) {
    return handleError(res, error);
  }
});

/**
 * POST /api/v1/trainers/:trainerId/availability
 * Add availability slots (trainer only)
 */
router.post('/:trainerId/availability', verifyToken, async (req, res) => {
  try {
    // Verify user is the trainer or admin
    if (req.userId !== req.params.trainerId && req.userRole !== 'admin') {
      return res.status(403).json({
        success: false,
        error: {
          message: 'Unauthorized',
          code: 'FORBIDDEN',
          status: 403
        }
      });
    }

    const { date, startTime, endTime, price } = req.body;

    if (!date || !startTime || !endTime || !price) {
      return res.status(400).json({
        success: false,
        error: {
          message: 'date, startTime, endTime, and price are required',
          code: 'INVALID_REQUEST',
          status: 400
        }
      });
    }

    const slot = await DatabaseService.createDoc('availability', {
      trainerId: req.params.trainerId,
      date: new Date(date),
      startTime,
      endTime,
      price: parseFloat(price),
      available: true,
      booked: false
    });

    return sendSuccess(res, slot, 'Availability slot created', 201);

  } catch (error) {
    return handleError(res, error);
  }
});

/**
 * POST /api/v1/trainers/apply
 * Apply as trainer (requires authentication)
 */
router.post('/apply', verifyToken, async (req, res) => {
  try {
    const { speciality, experience, certificateUrl, bio, phone } = req.body;

    if (!speciality || !experience) {
      return res.status(400).json({
        success: false,
        error: {
          message: 'speciality and experience are required',
          code: 'INVALID_REQUEST',
          status: 400
        }
      });
    }

    // Create or update trainer application
    const application = await DatabaseService.createDoc('trainer_applications', {
      userId: req.userId,
      speciality,
      experience: parseInt(experience),
      certificateUrl,
      bio,
      phone,
      status: 'pending',
      appliedAt: new Date()
    });

    return sendSuccess(res, application, 'Trainer application submitted', 201);

  } catch (error) {
    return handleError(res, error);
  }
});

/**
 * GET /api/v1/trainers/:trainerId/reviews
 * Get trainer's reviews and ratings
 */
router.get('/:trainerId/reviews', async (req, res) => {
  try {
    const { limit = 10, offset = 0 } = req.query;

    const result = await DatabaseService.query(
      'reviews',
      [{ field: 'trainerId', operator: '==', value: req.params.trainerId }],
      { field: 'createdAt', direction: 'desc' },
      parseInt(limit),
      parseInt(offset)
    );

    return sendSuccess(res, result);

  } catch (error) {
    return handleError(res, error);
  }
});

/**
 * POST /api/v1/trainers/:trainerId/reviews
 * Post a review for trainer
 */
router.post('/:trainerId/reviews', verifyToken, async (req, res) => {
  try {
    const { rating, comment, bookingId } = req.body;

    if (!rating || !comment) {
      return res.status(400).json({
        success: false,
        error: {
          message: 'rating and comment are required',
          code: 'INVALID_REQUEST',
          status: 400
        }
      });
    }

    const review = await DatabaseService.createDoc('reviews', {
      trainerId: req.params.trainerId,
      userId: req.userId,
      bookingId,
      rating: parseInt(rating),
      comment,
      createdAt: new Date()
    });

    // Update trainer's average rating
    const reviews = await DatabaseService.query('reviews', [
      { field: 'trainerId', operator: '==', value: req.params.trainerId }
    ]);

    const avgRating = reviews.items.length > 0
      ? (reviews.items.reduce((sum, r) => sum + r.rating, 0) / reviews.items.length).toFixed(1)
      : 0;

    await DatabaseService.updateDoc('users', req.params.trainerId, {
      rating: parseFloat(avgRating),
      reviews: reviews.items.length
    });

    return sendSuccess(res, review, 'Review posted successfully', 201);

  } catch (error) {
    return handleError(res, error);
  }
});

module.exports = router;
