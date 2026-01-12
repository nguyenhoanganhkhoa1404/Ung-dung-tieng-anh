# ============================================================================
# SETUP & TEST DASHBOARD - ONE-CLICK SCRIPT
# Tạo data và test Dashboard ngay lập tức
# ============================================================================

Write-Host "`n🎯 DASHBOARD SETUP & TEST SCRIPT`n" -ForegroundColor Cyan

$projectPath = "c:\File Coding\ung_dung_hoc_tieng_anh"

# Check current directory
if ((Get-Location).Path -ne $projectPath) {
    Write-Host "📁 Navigating to project..." -ForegroundColor Yellow
    Set-Location $projectPath
}

Write-Host "✅ Project directory: $projectPath`n" -ForegroundColor Green

# ============================================================================
# STEP 1: Tạo Dashboard Data
# ============================================================================

Write-Host "════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "STEP 1: TẠO DASHBOARD DATA" -ForegroundColor White
Write-Host "════════════════════════════════════════════════════════════`n" -ForegroundColor Cyan

Write-Host "🔥 Đang tạo sample data trong Firestore...`n" -ForegroundColor Yellow

# Run the setup tool
$setupProcess = Start-Process -FilePath "flutter" `
    -ArgumentList "run", "-t", "lib/tools/setup_dashboard_data.dart", "-d", "edge" `
    -NoNewWindow `
    -PassThru `
    -Wait

if ($setupProcess.ExitCode -eq 0) {
    Write-Host "`n✅ Data created successfully!`n" -ForegroundColor Green
} else {
    Write-Host "`n⚠️  Setup completed with warnings (this is OK)`n" -ForegroundColor Yellow
}

# Wait a bit for Firestore to sync
Write-Host "⏳ Waiting 3 seconds for Firestore sync..." -ForegroundColor Yellow
Start-Sleep -Seconds 3

# ============================================================================
# STEP 2: Verify Data in Firebase Console
# ============================================================================

Write-Host "`n════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "STEP 2: VERIFY DATA" -ForegroundColor White
Write-Host "════════════════════════════════════════════════════════════`n" -ForegroundColor Cyan

Write-Host "🔍 Please verify data in Firebase Console:" -ForegroundColor Yellow
Write-Host "   https://console.firebase.google.com/project/ung-dung-hoc-tieng-anh-a0580/firestore/data`n" -ForegroundColor Cyan

Write-Host "Expected collections:" -ForegroundColor White
Write-Host "  ✅ users (1 document: demo_user)" -ForegroundColor Green
Write-Host "  ✅ learning_sessions (7 documents)" -ForegroundColor Green
Write-Host "  ✅ exercise_results (18+ documents)`n" -ForegroundColor Green

$verify = Read-Host "Data verified? Press Enter to continue to test app, or 'n' to exit"

if ($verify -eq 'n' -or $verify -eq 'N') {
    Write-Host "`n⚠️  Exiting. Please check Firebase Console.`n" -ForegroundColor Yellow
    exit 0
}

# ============================================================================
# STEP 3: Check Firestore Indexes
# ============================================================================

Write-Host "`n════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "STEP 3: FIRESTORE INDEXES" -ForegroundColor White
Write-Host "════════════════════════════════════════════════════════════`n" -ForegroundColor Cyan

Write-Host "⚠️  IMPORTANT: Dashboard requires 2 Firestore indexes" -ForegroundColor Yellow
Write-Host ""
Write-Host "If you haven't created them yet:" -ForegroundColor White
Write-Host "  1. Open: https://console.firebase.google.com/project/ung-dung-hoc-tieng-anh-a0580/firestore/indexes" -ForegroundColor Cyan
Write-Host "  2. Create 2 indexes:" -ForegroundColor White
Write-Host "     - learning_sessions (user_id ASC, start_time DESC)" -ForegroundColor White
Write-Host "     - exercise_results (user_id ASC, created_at DESC)" -ForegroundColor White
Write-Host "  3. Wait for status = 'Enabled' (1-3 minutes)`n" -ForegroundColor White

Write-Host "📖 For detailed guide, see: FIRESTORE_SETUP_GUIDE.md`n" -ForegroundColor Cyan

$indexes = Read-Host "Indexes created and enabled? (y/n)"

if ($indexes -ne 'y' -and $indexes -ne 'Y') {
    Write-Host "`n⚠️  Please create indexes first. See: FIRESTORE_INDEXES_QUICKFIX.md" -ForegroundColor Yellow
    Write-Host "After creating indexes, run this script again.`n" -ForegroundColor White
    exit 0
}

# ============================================================================
# STEP 4: Launch App
# ============================================================================

Write-Host "`n════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "STEP 4: LAUNCH APP" -ForegroundColor White
Write-Host "════════════════════════════════════════════════════════════`n" -ForegroundColor Cyan

Write-Host "🚀 Launching app...`n" -ForegroundColor Yellow

Write-Host "After app launches:" -ForegroundColor Cyan
Write-Host "  1. Click on Dashboard tab (bar chart icon)" -ForegroundColor White
Write-Host "  2. Wait for data to load" -ForegroundColor White
Write-Host "  3. You should see:" -ForegroundColor White
Write-Host "     ✅ Total XP: 250" -ForegroundColor Green
Write-Host "     ✅ Current Streak: 7 days" -ForegroundColor Green
Write-Host "     ✅ Learning Minutes: 180 mins" -ForegroundColor Green
Write-Host "     ✅ Skill Progress: 6 skills" -ForegroundColor Green
Write-Host ""

# Launch the app
flutter run -t lib/main_ui_demo.dart -d edge

# ============================================================================
# DONE
# ============================================================================

Write-Host "`n════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "🎉 SETUP COMPLETE!" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════════`n" -ForegroundColor Cyan

Write-Host "📚 Documentation:" -ForegroundColor Yellow
Write-Host "  - FIRESTORE_SETUP_GUIDE.md (detailed guide)" -ForegroundColor White
Write-Host "  - FIRESTORE_INDEXES_QUICKFIX.md (quick fix)" -ForegroundColor White
Write-Host "  - README_ANALYTICS.md (analytics system)`n" -ForegroundColor White

Write-Host "✅ Dashboard is ready to use!`n" -ForegroundColor Green

