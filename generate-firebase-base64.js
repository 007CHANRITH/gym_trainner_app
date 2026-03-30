#!/usr/bin/env node
const fs = require('fs');
const path = require('path');

// Read the fresh Firebase credentials file
const credentialsPath = path.join(__dirname, 'backend/config/firebase-service-account.json');
const credentials = JSON.parse(fs.readFileSync(credentialsPath, 'utf-8'));

// Encode to base64
const base64 = Buffer.from(JSON.stringify(credentials)).toString('base64');
console.log('FIREBASE_SERVICE_ACCOUNT_BASE64=' + base64);
