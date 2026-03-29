# Backend Environment Setup

Complete guide to configure your backend API.

## 📋 What You Need

1. Node.js 16+ installed
2. Firebase project (already have it ✓)
3. Firebase service account JSON
4. Text editor/IDE

---

## 🔑 Firebase Service Account Setup

### Get Firebase Credentials

1. **Open Firebase Console**
   - Go to https://console.firebase.google.com
   - Select your project

2. **Generate Service Account**
   - Click ⚙️ (Settings) → Project settings
   - Click "Service Accounts" tab
   - Click "Generate New Private Key"
   - A JSON file downloads automatically

3. **Save to Backend**
   ```
   backend/
   └── config/
       └── firebase-service-account.json  ← Paste here
   ```

   The file looks like:
   ```json
   {
     "type": "service_account",
     "project_id": "your-project-id",
     "private_key_id": "xxx",
     "private_key": "-----BEGIN PRIVATE KEY-----\n...",
     "client_email": "firebase-adminsdk-xxxxx@your-project.iam.gserviceaccount.com",
     "client_id": "xxx",
     "auth_uri": "https://accounts.google.com/o/oauth2/auth",
     "token_uri": "https://oauth2.googleapis.com/token"
   }
   ```

### ⚠️ SECURITY WARNING
- **NEVER commit this file to GitHub**
- **NEVER share** with anyone
- Add to `.gitignore`:
  ```
  backend/config/firebase-service-account.json
  .env
  ```

---

## 🗂️ .env File Setup

### Step 1: Copy Template
```bash
cd backend
cp .env.example .env
```

### Step 2: Edit `.env`

Open `backend/.env` and fill in:

```env
# Server
NODE_ENV=development
PORT=5000

# Firebase Configuration
FIREBASE_PROJECT_ID=your-gym-trainer-project  # From service account JSON
FIREBASE_DATABASE_URL=https://your-gym-trainer-project.firebaseio.com

# Optional - Email notifications
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-app-password

# Optional - Stripe payments
STRIPE_SECRET_KEY=sk_test_xxx
STRIPE_PUBLISHABLE_KEY=pk_test_xxx

# URLs
API_BASE_URL=http://localhost:5000
FRONTEND_URL=http://localhost:8080
```

### How to Find Your Values

**FIREBASE_PROJECT_ID:**
- Open Firebase Console
- Look at the top banner or Settings → General
- Example: `gym-trainer-app-abc123`

**FIREBASE_DATABASE_URL:**
- Settings → General tab
- Format: `https://PROJECT_ID.firebaseio.com`

---

## 🚀 Installation Steps

### 1. Navigate to Backend
```bash
cd /Users/microstore/android_studio_projects/Gym-Trainer-Booking-App/backend
```

### 2. Install Dependencies
```bash
npm install
```

Output should show:
```
added 150 packages in 2m
```

### 3. Create Folders
```bash
mkdir -p config
```

### 4. Add Firebase Credentials
Place `firebase-service-account.json` in the `config` folder.

### 5. Create .env File
```bash
cp .env.example .env
```

Then edit `.env` with your Firebase credentials.

### 6. Test Installation
```bash
npm run dev
```

You should see:
```
🚀 Server running on port 5000
📍 Environment: development
🔥 Health: http://localhost:5000/health
```

### 7. Test Health Endpoint
Open browser: http://localhost:5000/health

Response:
```json
{
  "status": "ok",
  "timestamp": "2024-03-29T10:00:00.000Z",
  "uptime": 2.3,
  "environment": "development"
}
```

✅ **Backend is running!**

---

## 📁 File Structure After Setup

```
backend/
├── node_modules/                          # Dependencies (auto-created)
├── config/
│   └── firebase-service-account.json      # ← Your Firebase credentials
├── src/
│   ├── middleware/
│   │   └── auth.js
│   ├── services/
│   │   └── database.js
│   └── routes/
│       ├── auth.js
│       ├── users.js
│       ├── trainers.js
│       ├── bookings.js
│       └── admin.js
├── index.js
├── package.json
├── .env                                   # ← Your environment variables
├── .env.example                           # ← Template (reference only)
├── .gitignore                             # ← Git ignores .env & config/
├── BACKEND_README.md
┌── DEPLOYMENT_GUIDE.md
└── ENVIRONMENT_SETUP.md                   # ← This file
```

---

## 🔄 Development Workflow

### Start Server (with auto-reload)
```bash
npm run dev
```

### Run Production Build
```bash
npm start
```

### Stop Server
Press `Ctrl + C`

---

## 🧪 Quick Test

### Test Register
```bash
curl -X POST http://localhost:5000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "Test@123",
    "fullName": "Test User",
    "userType": "user"
  }'
```

Expected response:
```json
{
  "success": true,
  "data": {
    "uid": "user123",
    "email": "test@example.com",
    "displayName": "Test User",
    "role": "user"
  },
  "message": "User registered successfully"
}
```

### Test Get Trainers
```bash
curl http://localhost:5000/api/v1/trainers?limit=5
```

---

## 🆘 Common Issues

### ❌ "Cannot find module 'firebase-admin'"
**Solution:** Run `npm install` again

### ❌ "FIREBASE_PROJECT_ID is not set"
**Solution:** Check `.env` file exists and is correct

### ❌ "Unable to parse key data: secretKey is undefined"
**Solution:** Firebase credentials JSON is invalid or missing in `config/firebase-service-account.json`

### ❌ "Address already in use :::5000"
**Solution:** Port 5000 is already running
```bash
# Kill the process
lsof -ti:5000 | xargs kill -9

# Or use different port
PORT=5001 npm run dev
```

---

## ✅ Verification Checklist

- ✅ `backend/config/firebase-service-account.json` exists
- ✅ `backend/.env` is configured with correct values
- ✅ `npm install` completed successfully
- ✅ `npm run dev` starts server without errors
- ✅ `http://localhost:5000/health` returns status 200
- ✅ Register endpoint works

---

## 🎯 Next Step

Once setup is complete:
1. Test a few API endpoints (register, get trainers)
2. Follow `DEPLOYMENT_GUIDE.md` to deploy to production
3. Update Flutter app's API base URL to your deployed server
4. Start making API calls from Flutter! 🚀

---

**Need help?** Check `BACKEND_README.md` for API documentation.
