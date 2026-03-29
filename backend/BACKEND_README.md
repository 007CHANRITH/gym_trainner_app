# Gym Trainer Booking App - Backend API

Production-ready Node.js/Express backend with Firebase integration.

## 📋 Features

- ✅ Firebase Authentication integration
- ✅ Firestore database with optimized queries
- ✅ JWT token verification middleware
- ✅ Role-based access control (user, trainer, admin)
- ✅ RESTful API design (matches Flutter frontend)
- ✅ Error handling and validation
- ✅ CORS and security middleware
- ✅ Request logging with Morgan

## 🚀 Quick Start

### 1. **Setup Environment**

```bash
cd backend
npm install
cp .env.example .env
```

### 2. **Configure Firebase**

Get your Firebase Service Account JSON:
1. Go to Firebase Console → Project Settings
2. Download service account JSON
3. Save as `backend/config/firebase-service-account.json`

Update `.env`:
```env
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_DATABASE_URL=https://your-project.firebaseio.com
```

### 3. **Run Server**

**Development:**
```bash
npm run dev
```

**Production:**
```bash
npm start
```

Server runs on `http://localhost:5000`

## 📁 Project Structure

```
backend/
├── index.js                    # Main server file
├── package.json               # Dependencies
├── .env.example              # Environment template
├── config/
│   └── firebase-service-account.json  # Firebase credentials
└── src/
    ├── middleware/
    │   └── auth.js           # Authentication & authorization
    ├── services/
    │   └── database.js       # Firestore database service
    └── routes/
        ├── auth.js           # Authentication endpoints
        ├── users.js          # User management
        ├── trainers.js       # Trainer endpoints
        ├── bookings.js       # Booking management
        └── admin.js          # Admin operations
```

## 🔌 API Endpoints

### Health Check
```bash
GET /health
```

### Authentication
```bash
POST   /api/v1/auth/register              # Register user
POST   /api/v1/auth/login                 # Login (use client SDK)
GET    /api/v1/auth/profile               # Get current user (requires token)
POST   /api/v1/auth/logout                # Logout
POST   /api/v1/auth/refresh-token         # Refresh token
POST   /api/v1/auth/password-reset        # Request password reset
```

### Users
```bash
GET    /api/v1/users                      # Search users
GET    /api/v1/users/:userId              # Get user profile
PUT    /api/v1/users/:userId              # Update profile (auth required)
GET    /api/v1/users/:userId/bookings     # Get user's bookings
GET    /api/v1/users/:userId/favourites   # Get favourite trainers
POST   /api/v1/users/:userId/favourites   # Add to favourites
DELETE /api/v1/users/:userId/favourites/:trainerId  # Remove favourite
```

### Trainers
```bash
GET    /api/v1/trainers                   # Get all trainers
GET    /api/v1/trainers/:trainerId        # Get trainer details
GET    /api/v1/trainers/:trainerId/availability    # Get availability slots
POST   /api/v1/trainers/:trainerId/availability    # Create availability (trainer)
POST   /api/v1/trainers/apply             # Apply as trainer
GET    /api/v1/trainers/:trainerId/reviews         # Get reviews
POST   /api/v1/trainers/:trainerId/reviews         # Post review
```

### Bookings
```bash
POST   /api/v1/bookings                   # Create booking (auth required)
GET    /api/v1/bookings                   # Get user's bookings (auth required)
GET    /api/v1/bookings/:bookingId        # Get booking details
PUT    /api/v1/bookings/:bookingId        # Update booking (auth required)
DELETE /api/v1/bookings/:bookingId        # Cancel booking (auth required)
POST   /api/v1/bookings/:bookingId/complete    # Mark completed
POST   /api/v1/bookings/:bookingId/payment     # Record payment
```

### Admin (admin role required)
```bash
GET    /api/v1/admin/dashboard            # Dashboard statistics
GET    /api/v1/admin/users                # Get all users
GET    /api/v1/admin/trainers/applications        # Get trainer applications
POST   /api/v1/admin/trainers/applications/:id/approve   # Approve trainer
POST   /api/v1/admin/trainers/applications/:id/reject    # Reject trainer
GET    /api/v1/admin/bookings             # Get all bookings
POST   /api/v1/admin/users/:userId/ban    # Ban user
POST   /api/v1/admin/users/:userId/unban  # Unban user
GET    /api/v1/admin/reports              # Get reports
GET    /api/v1/admin/analytics            # Get analytics
```

## 🔐 Authentication

All protected endpoints require Firebase ID token in header:

```
Authorization: Bearer YOUR_FIREBASE_ID_TOKEN
```

**Get token in Flutter:**
```dart
final token = await FirebaseAuth.instance.currentUser!.getIdToken();
```

## 📊 API Response Format

**Success Response:**
```json
{
  "success": true,
  "data": {
    "id": "user123",
    "email": "user@example.com"
  },
  "message": "Success"
}
```

**Error Response:**
```json
{
  "success": false,
  "error": {
    "message": "User not found",
    "code": "NOT_FOUND",
    "status": 404
  }
}
```

## 🗄️ Firestore Collections

```
users/
  - uid (document ID)
  - email
  - fullName
  - userType (user/trainer/admin)
  - rating
  - reviews
  - active
  - createdAt

trainers/
  - uid (document ID)
  - speciality
  - experience
  - certificates
  - availability

bookings/
  - bookingId (doc ID)
  - userId
  - trainerId
  - date
  - startTime
  - endTime
  - price
  - status (confirmed/completed/cancelled)
  - paymentStatus

reviews/
  - trainerId
  - userId
  - rating
  - comment

availability/
  - trainerId
  - date
  - startTime
  - endTime
  - price
  - available
  - booked
```

## 🚢 Deployment

### Deploy to Render (Recommended)

1. Push to GitHub
2. Go to [render.com](https://render.com)
3. Click "New +" → "Web Service"
4. Connect GitHub repo
5. Set environment variables from `.env`
6. Deploy!

### Deploy to Railway

1. Go to [railway.app](https://railway.app)
2. Click "New Project"
3. Deploy from GitHub
4. Add environment variables
5. Railway handles the rest

### Deploy to Heroku

```bash
heroku login
heroku create your-app-name
git push heroku main
```

## 🔑 Environment Variables

Required:
- `FIREBASE_PROJECT_ID`
- `FIREBASE_DATABASE_URL`
- `NODE_ENV` (development/production)
- `PORT`

Optional:
- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`
- `SMTP_HOST` (for emails)
- `STRIPE_SECRET_KEY` (for payments)

## 🧪 Testing

```bash
npm test
```

Test with Postman/Insomnia using the endpoints above.

### Test Example
```bash
# Register
curl -X POST http://localhost:5000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"user@test.com","password":"password","fullName":"John Doe"}'

# Get trainers
curl http://localhost:5000/api/v1/trainers?limit=10

# Create booking (with token)
curl -X POST http://localhost:5000/api/v1/bookings \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"trainerId":"trainer123","availabilityId":"slot456","date":"2024-04-01","startTime":"10:00","endTime":"11:00"}'
```

## 📝 Connecting to Flutter Frontend

Update `lib/infrastructure/api/api_provider.dart`:

```dart
static const String baseUrl = 'https://your-deployed-backend.com/api/v1';
```

Then all your Flutter API calls will work automatically! ✅

## 🐛 Troubleshooting

**"Firebase credentials not found"**
- Check `config/firebase-service-account.json` exists
- Verify `FIREBASE_PROJECT_ID` in `.env`

**"Token verification failed"**
- Ensure token is valid Firebase ID token
- Check Authorization header format: `Bearer TOKEN`

**"CORS error"**
- Add frontend URL to CORS config in `index.js`

**"Port already in use"**
- Change `PORT` in `.env`
- Or kill process: `lsof -ti:5000 | xargs kill -9`

## 📚 Additional Resources

- [Firebase Docs](https://firebase.google.com/docs)
- [Express.js Docs](https://expressjs.com/)
- [Firestore Data Structure](https://cloud.google.com/firestore/docs)

---

**Ready to deploy!** 🚀
