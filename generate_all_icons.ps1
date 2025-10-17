# Master script to regenerate all app icons for iOS, Android, and Web
# This script will generate all required icon sizes from your source image

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Apna Bazar - App Icon Generator" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$sourceImage = "c:\Users\pitti\Downloads\json_to_firestore\AppIcons\appstore.png"

# Check if source image exists
if (-not (Test-Path $sourceImage)) {
    Write-Error "❌ Source image not found: $sourceImage"
    Write-Host "Please ensure the source image exists at the specified location." -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Source image found: $sourceImage" -ForegroundColor Green
Write-Host ""

# Run iOS icon generation
Write-Host "📱 Generating iOS icons..." -ForegroundColor Cyan
& powershell -ExecutionPolicy Bypass -File ".\generate_ios_icons.ps1"
Write-Host ""

# Run Android icon generation
Write-Host "🤖 Generating Android icons..." -ForegroundColor Cyan
& powershell -ExecutionPolicy Bypass -File ".\generate_android_icons.ps1"
Write-Host ""

# Run Web icon generation
Write-Host "🌐 Generating Web icons..." -ForegroundColor Cyan
& powershell -ExecutionPolicy Bypass -File ".\generate_web_icons.ps1"
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ✅ All icons generated successfully!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Run: flutter clean" -ForegroundColor White
Write-Host "2. Run: flutter build ios (for iOS)" -ForegroundColor White
Write-Host "3. Run: flutter build apk (for Android)" -ForegroundColor White
Write-Host ""
