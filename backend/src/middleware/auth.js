const admin = require('firebase-admin');

/**
 * Verify Firebase ID Token middleware
 * Extracts and validates the token from Authorization header
 */
const verifyToken = async (req, res, next) => {
  try {
    const token = req.headers.authorization?.split('Bearer ')[1];

    if (!token) {
      return res.status(401).json({
        success: false,
        error: {
          message: 'No authentication token provided',
          code: 'NO_TOKEN',
          status: 401
        }
      });
    }

    const decodedToken = await admin.auth().verifyIdToken(token);
    req.userId = decodedToken.uid;
    req.userEmail = decodedToken.email;
    req.decodedToken = decodedToken;

    next();
  } catch (error) {
    console.error('Token verification error:', error);
    return res.status(401).json({
      success: false,
      error: {
        message: 'Invalid or expired token',
        code: 'INVALID_TOKEN',
        status: 401
      }
    });
  }
};

/**
 * Check if user has admin role
 */
const verifyAdmin = async (req, res, next) => {
  try {
    const userRecord = await admin.auth().getUser(req.userId);
    const isAdmin = userRecord.customClaims?.role === 'admin' ||
                    userRecord.customClaims?.role === 'super_admin';

    if (!isAdmin) {
      return res.status(403).json({
        success: false,
        error: {
          message: 'Admin access required',
          code: 'FORBIDDEN',
          status: 403
        }
      });
    }

    req.userRole = userRecord.customClaims?.role;
    next();
  } catch (error) {
    console.error('Admin verification error:', error);
    return res.status(403).json({
      success: false,
      error: {
        message: 'Unable to verify admin status',
        code: 'FORBIDDEN',
        status: 403
      }
    });
  }
};

/**
 * Error handler utility
 */
const handleError = (res, error, statusCode = 500) => {
  console.error('Error:', error);

  const status = error.statusCode || statusCode;
  const message = error.message || 'Internal Server Error';

  return res.status(status).json({
    success: false,
    error: {
      message,
      code: error.code || 'INTERNAL_ERROR',
      status
    }
  });
};

/**
 * Success response utility
 */
const sendSuccess = (res, data = null, message = 'Success', statusCode = 200) => {
  return res.status(statusCode).json({
    success: true,
    data,
    message
  });
};

module.exports = {
  verifyToken,
  verifyAdmin,
  handleError,
  sendSuccess
};
