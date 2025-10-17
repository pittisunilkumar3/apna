# Script to fix Android app icon with proper adaptive icon support

$sourceImage = "c:\Users\pitti\Downloads\json_to_firestore\AppIcons\appstore.png"
$androidRes = "c:\Users\pitti\Downloads\apna_bazar-6e054f59da32cd37eb196c13cfe38613a22337e1\android\app\src\main\res"

Write-Host "Fixing Android app icon configuration..." -ForegroundColor Green

# Load System.Drawing assembly
Add-Type -AssemblyName System.Drawing

try {
    # Load source image
    $sourceImg = [System.Drawing.Image]::FromFile($sourceImage)
    
    # Generate foreground image (slightly smaller with padding for adaptive icon)
    Write-Host "Generating adaptive icon foreground..." -ForegroundColor Cyan
    
    # Create drawable-xxxhdpi foreground (this will be the base for adaptive icons)
    $drawableFolders = @("drawable-mdpi", "drawable-hdpi", "drawable-xhdpi", "drawable-xxhdpi", "drawable-xxxhdpi")
    $foregroundSizes = @(108, 162, 216, 324, 432) # Sizes for adaptive icon foreground
    
    for ($i = 0; $i -lt $drawableFolders.Length; $i++) {
        $folder = $drawableFolders[$i]
        $size = $foregroundSizes[$i]
        $drawablePath = Join-Path $androidRes $folder
        
        # Create folder if it doesn't exist
        if (-not (Test-Path $drawablePath)) {
            New-Item -ItemType Directory -Path $drawablePath -Force | Out-Null
        }
        
        $outputPath = Join-Path $drawablePath "ic_launcher_foreground.png"
        
        Write-Host "  Generating $folder/ic_launcher_foreground.png (${size}x${size}px)..."
        
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
        $padding = $size * 0.25
        $innerSize = $size - ($padding * 2)
        
        # Draw resized image with padding
        $graphics.DrawImage($sourceImg, $padding, $padding, $innerSize, $innerSize)
        
        # Save as PNG
        $newImg.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
        
        # Cleanup
        $graphics.Dispose()
        $newImg.Dispose()
    }
    
    $sourceImg.Dispose()
    
    Write-Host ""
    Write-Host "Successfully generated adaptive icon resources!" -ForegroundColor Green
    Write-Host "Android icon should now display correctly." -ForegroundColor Cyan
    
} catch {
    Write-Error "Error: $_"
    exit 1
}
