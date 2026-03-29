# Backend Deployment Guide

Quick setup and deployment of your Gym Trainer Booking backend.

## ⚡ 5-Minute Setup

### Step 1: Install Dependencies
```bash
cd backend
npm install
```

### Step 2: Configure Firebase
1. Get service account JSON from Firebase Console
2. Save to `backend/config/firebase-service-account.json`
3. Create `.env` file:
```env
NODE_ENV=development
PORT=5000
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_DATABASE_URL=https://your-project.firebaseio.com
```

### Step 3: Run
```bash
npm run dev
```

Visit: http://localhost:5000/health

---

## 🚀 Production Deployment

### Option 1: Deploy to Render (Easiest)

1. **Push to GitHub**
   ```bash
   git add backend/
   git commit -m "Add backend"
   git push
   ```

2. **Go to [render.com](https://render.com)**
   - Sign up with GitHub
   - Click "New +" → "Web Service"
   - Select your repository
   - Set build command: `npm install`
   - Set start command: `npm start`

3. **Add Environment Variables**
   - Create `.env` variables in Render dashboard:
     - `FIREBASE_PROJECT_ID`
     - `FIREBASE_DATABASE_URL`
     - `NODE_ENV=production`

4. **Upload Firebase Credentials**
   - Render doesn't keep files between deployments
   - Option A: Use environment variable for entire JSON
   - Option B: Use Firebase Admin SDK initialization with credentials parameter

5. **Deploy**
   - Render automatically deploys on push

**Your API URL:** `https://your-app-name.onrender.com`

---

### Option 2: Deploy to Railway

1. **Go to [railway.app](https://railway.app)**
   - Sign up with GitHub
   - New Project → Deploy from GitHub repo
   
2. **Configure**
   - Select your repo
   - Set start command: `npm start` (auto-detected usually)
   
3. **Environment Variables**
   - Click "Add Service" → Variables
   - Add all `.env` variables
   - Upload Firebase JSON file as artifact

4. **Get Public URL**
   - Railway provides automatic URL
   - Domain appears in project dashboard

---

### Option 3: Deploy to Heroku (Legacy)

```bash
heroku login
heroku create your-api-name

# Set environment variables
heroku config:set FIREBASE_PROJECT_ID=xxx
heroku config:set FIREBASE_DATABASE_URL=xxx

# Deploy
git push heroku main

# Check logs
heroku logs --tail
```

---

## 📋 Pre-Deployment Checklist

- ✅ Set `NODE_ENV=production`
- ✅ Secure Firebase credentials (never commit to repo)
- ✅ Test all endpoints locally first
- ✅ Add frontend URL to CORS if needed
- ✅ Set up error logging (optional: Sentry)
- ✅ Enable HTTPS (automatic on Render/Railway)

---

## 🔗 Update Flutter App

Once backend is deployed, update your Flutter app:

**File:** `lib/infrastructure/api/api_provider.dart`

```dart
static const String baseUrl = 'https://your-app-name.onrender.com/api/v1';
```

Then run:
```bash
flutter pub get
flutter run
```

---

## 🧪 Test Deployed API

### 1. Health Check
```bash
curl https://your-app-name.onrender.com/health
```

### 2. Register User
```bash
curl -X POST https://your-app-name.onrender.com/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123","fullName":"Test User"}'
```

### 3. Get Trainers
```bash
curl https://your-app-name.onrender.com/api/v1/trainers?limit=10
```

---

## 🆘 Troubleshooting

| Problem | Solution |
|---------|----------|
| 502 Bad Gateway | Check logs on deployment platform, verify Firebase credentials |
| Firebase Error | Ensure service account JSON is properly uploaded/configured |
| Token Error | Make sure Flutter sends proper Authorization header |
| CORS Error | Add frontend domain to CORS in `index.js` |
| Cold Start Slow | Normal for Render free tier, upgrade for better performance |

---

## 📊 Monitoring

**Render Dashboard:**
- Logs visible in real-time
- CPU/Memory usage
- Build history
- Deployment metrics

**Railway Dashboard:**
- Usage analytics
- Log streaming
- Error tracking

---

## 💰 Costs

- **Render**: Free tier (sleeps after 15 min inactivity), $7+/month for always-on
- **Railway**: Pay-as-you-go ($5/month minimum)
- **Heroku**: Discontinued free tier

**Recommendation:** Start with Render free tier for testing, upgrade to $7/month when live.

---

## ✅ Done!

Your backend is now live! 🎉

- API runs at: `https://your-app-name.onrender.com`
- Health check: `/health`
- All endpoints ready for Flutter app

Next: Connect Flutter app to your deployed API.
