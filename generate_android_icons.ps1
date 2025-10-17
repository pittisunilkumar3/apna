# PowerShell script to generate Android app icons from a source image

$sourceImage = "c:\Users\pitti\Downloads\json_to_firestore\AppIcons\appstore.png"
$baseDir = "c:\Users\pitti\Downloads\apna_bazar-6e054f59da32cd37eb196c13cfe38613a22337e1\android\app\src\main\res"

# Check if source image exists
if (-not (Test-Path $sourceImage)) {
    Write-Error "Source image not found: $sourceImage"
    exit 1
}

Write-Host "Generating Android app icons from: $sourceImage" -ForegroundColor Green

# Define all required Android icon sizes
$androidSizes = @(
    @{Folder="mipmap-mdpi"; Size=48},
    @{Folder="mipmap-hdpi"; Size=72},
    @{Folder="mipmap-xhdpi"; Size=96},
    @{Folder="mipmap-xxhdpi"; Size=144},
    @{Folder="mipmap-xxxhdpi"; Size=192}
)

# Load System.Drawing assembly for image manipulation
Add-Type -AssemblyName System.Drawing

try {
    # Load source image
    $sourceImg = [System.Drawing.Image]::FromFile($sourceImage)
    
    foreach ($androidSize in $androidSizes) {
        $outputDir = Join-Path $baseDir $androidSize.Folder
        $size = $androidSize.Size
        
        # Create both ic_launcher.png and launcher_icon.png
        $iconNames = @("ic_launcher.png", "launcher_icon.png")
        
        foreach ($iconName in $iconNames) {
            $outputPath = Join-Path $outputDir $iconName
            
            Write-Host "Generating $($androidSize.Folder)/$iconName (${size}x${size}px)..."
            
            # Create new bitmap with target size
            $newImg = New-Object System.Drawing.Bitmap($size, $size)
            $graphics = [System.Drawing.Graphics]::FromImage($newImg)
            
            # Set high quality rendering
            $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
            $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
            $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
            $graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
            
            # Draw resized image
            $graphics.DrawImage($sourceImg, 0, 0, $size, $size)
            
            # Save as PNG
            $newImg.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
            
            # Cleanup
            $graphics.Dispose()
            $newImg.Dispose()
        }
    }
    
    $sourceImg.Dispose()
    
    Write-Host "`nSuccessfully generated all Android app icons!" -ForegroundColor Green
    Write-Host "Icons saved to: $baseDir\mipmap-*" -ForegroundColor Cyan
    
} catch {
    Write-Error "Error generating icons: $_"
    exit 1
}
