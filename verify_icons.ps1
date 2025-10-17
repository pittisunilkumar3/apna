# Icon Verification Script
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "App Icon Verification" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

$errors = 0

# Check iOS icons
Write-Host "Checking iOS Icons..." -ForegroundColor Cyan
$iosIconPath = "ios\Runner\Assets.xcassets\AppIcon.appiconset"
$iosIcons = @(
    "Icon-App-20x20@1x.png", "Icon-App-20x20@2x.png", "Icon-App-20x20@3x.png",
    "Icon-App-29x29@1x.png", "Icon-App-29x29@2x.png", "Icon-App-29x29@3x.png",
    "Icon-App-40x40@1x.png", "Icon-App-40x40@2x.png", "Icon-App-40x40@3x.png",
    "Icon-App-50x50@1x.png", "Icon-App-50x50@2x.png",
    "Icon-App-57x57@1x.png", "Icon-App-57x57@2x.png",
    "Icon-App-60x60@2x.png", "Icon-App-60x60@3x.png",
    "Icon-App-72x72@1x.png", "Icon-App-72x72@2x.png",
    "Icon-App-76x76@1x.png", "Icon-App-76x76@2x.png",
    "Icon-App-83.5x83.5@2x.png",
    "Icon-App-1024x1024@1x.png"
)

$iosFound = 0
foreach ($icon in $iosIcons) {
    $path = Join-Path $iosIconPath $icon
    if (Test-Path $path) {
        $iosFound++
    } else {
        Write-Host "Missing: $icon" -ForegroundColor Red
        $errors++
    }
}
Write-Host "Found $iosFound of $($iosIcons.Count) iOS icons" -ForegroundColor Green
Write-Host ""

# Check Android icons
Write-Host "Checking Android Icons..." -ForegroundColor Cyan
$androidRes = "android\app\src\main\res"
$androidFolders = @("mipmap-mdpi", "mipmap-hdpi", "mipmap-xhdpi", "mipmap-xxhdpi", "mipmap-xxxhdpi")
$androidIconNames = @("ic_launcher.png", "launcher_icon.png")

$androidFound = 0
foreach ($folder in $androidFolders) {
    foreach ($iconName in $androidIconNames) {
        $path = Join-Path (Join-Path $androidRes $folder) $iconName
        if (Test-Path $path) {
            $androidFound++
        } else {
            Write-Host "Missing: $folder\$iconName" -ForegroundColor Red
            $errors++
        }
    }
}
$totalAndroidIcons = $androidFolders.Count * $androidIconNames.Count
Write-Host "Found $androidFound of $totalAndroidIcons Android icons" -ForegroundColor Green
Write-Host ""

# Check Web icons
Write-Host "Checking Web Icons..." -ForegroundColor Cyan
$webIconPath = "web\icons"
$webIcons = @("Icon-192.png", "Icon-512.png", "Icon-maskable-192.png", "Icon-maskable-512.png")

$webFound = 0
foreach ($icon in $webIcons) {
    $path = Join-Path $webIconPath $icon
    if (Test-Path $path) {
        $webFound++
    } else {
        Write-Host "Missing: $icon" -ForegroundColor Red
        $errors++
    }
}
Write-Host "Found $webFound of $($webIcons.Count) Web icons" -ForegroundColor Green
Write-Host ""

# Summary
Write-Host "======================================" -ForegroundColor Cyan
if ($errors -eq 0) {
    Write-Host "All icons verified successfully!" -ForegroundColor Green
    Write-Host "Total icons: $($iosFound + $androidFound + $webFound)" -ForegroundColor Green
} else {
    Write-Host "Verification completed with $errors errors" -ForegroundColor Yellow
    Write-Host "Run generate_all_icons.ps1 to fix missing icons" -ForegroundColor Yellow
}
Write-Host "======================================" -ForegroundColor Cyan
