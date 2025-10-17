# Script to properly fix Android app icon with adaptive icon support
# This version includes better error handling and validation

$sourceImage = "c:\Users\pitti\Downloads\json_to_firestore\AppIcons\appstore.png"
$androidRes = "c:\Users\pitti\Downloads\apna_bazar-6e054f59da32cd37eb196c13cfe38613a22337e1\android\app\src\main\res"

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Android Icon Fix - Adaptive Icon Generator" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Check if source image exists
if (-not (Test-Path $sourceImage)) {
    Write-Error "Source image not found: $sourceImage"
    exit 1
}

Write-Host "Source image found: $sourceImage" -ForegroundColor Green
Write-Host ""

# Load System.Drawing assembly
Add-Type -AssemblyName System.Drawing

try {
    # Load source image
    $sourceImg = [System.Drawing.Image]::FromFile($sourceImage)
    Write-Host "Source image loaded successfully (${$sourceImg.Width}x${$sourceImg.Height})" -ForegroundColor Green
    Write-Host ""
    
    # Clean up old foreground files
    Write-Host "Cleaning up old foreground icons..." -ForegroundColor Yellow
    Get-ChildItem -Path $androidRes -Recurse -Filter "ic_launcher_foreground.png" -ErrorAction SilentlyContinue | Remove-Item -Force
    Write-Host "Cleanup complete" -ForegroundColor Green
    Write-Host ""
    
    # Generate foreground image for adaptive icons
    Write-Host "Generating adaptive icon foreground resources..." -ForegroundColor Cyan
    Write-Host ""
    
    # Define drawable folders and their sizes
    $drawableFolders = @(
        @{Folder="drawable-mdpi"; Size=108},
        @{Folder="drawable-hdpi"; Size=162},
        @{Folder="drawable-xhdpi"; Size=216},
        @{Folder="drawable-xxhdpi"; Size=324},
        @{Folder="drawable-xxxhdpi"; Size=432}
    )
    
    foreach ($drawable in $drawableFolders) {
        $folder = $drawable.Folder
        $size = $drawable.Size
        $drawablePath = Join-Path $androidRes $folder
        
        # Create folder if it doesn't exist
        if (-not (Test-Path $drawablePath)) {
            New-Item -ItemType Directory -Path $drawablePath -Force | Out-Null
            Write-Host "  Created folder: $folder" -ForegroundColor Yellow
        }
        
        $outputPath = Join-Path $drawablePath "ic_launcher_foreground.png"
        
        Write-Host "  Generating $folder/ic_launcher_foreground.png (${size}x${size}px)..." -ForegroundColor White
        
        # Create new bitmap with target size
        $newImg = New-Object System.Drawing.Bitmap($size, $size)
        $graphics = [System.Drawing.Graphics]::FromImage($newImg)
        
        # Clear with transparency
        $graphics.Clear([System.Drawing.Color]::Transparent)
        
        # Set high quality rendering
        $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
        $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
        $graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
        
        # Calculate padding (adaptive icons need 25% safe zone)
        $padding = [int]($size * 0.25)
        $innerSize = $size - ($padding * 2)
        
        # Draw resized image with padding
        $graphics.DrawImage($sourceImg, $padding, $padding, $innerSize, $innerSize)
        
        # Save as PNG with proper format
        $newImg.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
        
        # Verify file was created
        if (Test-Path $outputPath) {
            $fileSize = (Get-Item $outputPath).Length
            Write-Host "    Created successfully ($fileSize bytes)" -ForegroundColor Green
        } else {
            Write-Host "    ERROR: File not created!" -ForegroundColor Red
        }
        
        # Cleanup
        $graphics.Dispose()
        $newImg.Dispose()
    }
    
    $sourceImg.Dispose()
    
    Write-Host ""
    Write-Host "================================================" -ForegroundColor Cyan
    Write-Host "  Adaptive icon resources generated successfully!" -ForegroundColor Green
    Write-Host "================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "1. Run: flutter clean" -ForegroundColor White
    Write-Host "2. Run: flutter build apk (or appbundle)" -ForegroundColor White
    Write-Host ""
    
} catch {
    Write-Host ""
    Write-Host "ERROR: $_" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}
