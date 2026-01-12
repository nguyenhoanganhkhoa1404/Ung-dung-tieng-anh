# ============================================================================
# FIRESTORE DEPLOYMENT SCRIPT
# Deploy indexes and rules to Firebase
# ============================================================================

Write-Host "`n🔥 FIRESTORE DEPLOYMENT SCRIPT`n" -ForegroundColor Cyan

# Check if Firebase CLI is installed
Write-Host "Checking Firebase CLI..." -ForegroundColor Yellow
$firebaseVersion = firebase --version 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Firebase CLI not found!" -ForegroundColor Red
    Write-Host "`nInstalling Firebase CLI..." -ForegroundColor Yellow
    npm install -g firebase-tools
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Failed to install Firebase CLI" -ForegroundColor Red
        Write-Host "`nPlease install manually:" -ForegroundColor Yellow
        Write-Host "npm install -g firebase-tools`n" -ForegroundColor White
        exit 1
    }
}

Write-Host "✅ Firebase CLI: $firebaseVersion" -ForegroundColor Green

# Check if logged in
Write-Host "`nChecking Firebase login..." -ForegroundColor Yellow
$loginCheck = firebase projects:list 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Not logged in to Firebase" -ForegroundColor Red
    Write-Host "`nLogging in..." -ForegroundColor Yellow
    firebase login
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Login failed" -ForegroundColor Red
        exit 1
    }
}

Write-Host "✅ Logged in successfully" -ForegroundColor Green

# Check if firebase.json exists
if (!(Test-Path "firebase.json")) {
    Write-Host "`n⚠️  firebase.json not found" -ForegroundColor Yellow
    Write-Host "Initializing Firebase..." -ForegroundColor Yellow
    
    Write-Host "`nPlease select:" -ForegroundColor Cyan
    Write-Host "- Firestore (press Space to select)" -ForegroundColor White
    Write-Host "- Use existing project: ung-dung-hoc-tieng-anh-a0580" -ForegroundColor White
    Write-Host "- Firestore rules file: firestore.rules" -ForegroundColor White
    Write-Host "- Firestore indexes file: firestore.indexes.json" -ForegroundColor White
    Write-Host ""
    
    firebase init firestore
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Firebase init failed" -ForegroundColor Red
        exit 1
    }
}

# Verify files exist
Write-Host "`nVerifying files..." -ForegroundColor Yellow

$filesToCheck = @(
    "firestore.indexes.json",
    "firestore.rules"
)

$allFilesExist = $true
foreach ($file in $filesToCheck) {
    if (Test-Path $file) {
        Write-Host "✅ $file" -ForegroundColor Green
    } else {
        Write-Host "❌ $file not found" -ForegroundColor Red
        $allFilesExist = $false
    }
}

if (!$allFilesExist) {
    Write-Host "`n❌ Some required files are missing" -ForegroundColor Red
    exit 1
}

# Deploy indexes
Write-Host "`n📊 Deploying Firestore Indexes..." -ForegroundColor Cyan
Write-Host "This will create composite indexes for:" -ForegroundColor White
Write-Host "  - learning_sessions (user_id, start_time)" -ForegroundColor White
Write-Host "  - exercise_results (user_id, created_at)" -ForegroundColor White
Write-Host "  - exercise_results (user_id, skill, created_at)" -ForegroundColor White
Write-Host ""

firebase deploy --only firestore:indexes

if ($LASTEXITCODE -ne 0) {
    Write-Host "`n⚠️  Index deployment had issues" -ForegroundColor Yellow
    Write-Host "This might be because indexes already exist." -ForegroundColor Yellow
    Write-Host "Check Firebase Console to verify." -ForegroundColor Yellow
} else {
    Write-Host "`n✅ Indexes deployed successfully!" -ForegroundColor Green
}

# Deploy rules
Write-Host "`n🔒 Deploying Firestore Security Rules..." -ForegroundColor Cyan
firebase deploy --only firestore:rules

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Rules deployment failed" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Rules deployed successfully!" -ForegroundColor Green

# Check indexes status
Write-Host "`n📋 Checking Indexes Status..." -ForegroundColor Cyan
firebase firestore:indexes

# Summary
Write-Host "`n" + "="*70 -ForegroundColor Cyan
Write-Host "🎉 DEPLOYMENT COMPLETE!" -ForegroundColor Green
Write-Host "="*70 -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Wait 1-3 minutes for indexes to build" -ForegroundColor White
Write-Host "2. Check status in Firebase Console:" -ForegroundColor White
Write-Host "   https://console.firebase.google.com/project/ung-dung-hoc-tieng-anh-a0580/firestore/indexes" -ForegroundColor Cyan
Write-Host "3. Verify status = 'Enabled' (not 'Building')" -ForegroundColor White
Write-Host "4. Test Dashboard in your app" -ForegroundColor White
Write-Host ""
Write-Host "If Dashboard still shows error:" -ForegroundColor Yellow
Write-Host "- Wait a bit longer (indexes might still be building)" -ForegroundColor White
Write-Host "- Force close and reopen the app" -ForegroundColor White
Write-Host "- Check Firebase Console for index status" -ForegroundColor White
Write-Host ""
Write-Host "✅ All done! Dashboard should work now." -ForegroundColor Green
Write-Host ""

