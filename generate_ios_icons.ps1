# PowerShell script to generate iOS app icons from a source image

$sourceImage = "c:\Users\pitti\Downloads\json_to_firestore\AppIcons\appstore.png"
$outputDir = "c:\Users\pitti\Downloads\apna_bazar-6e054f59da32cd37eb196c13cfe38613a22337e1\ios\Runner\Assets.xcassets\AppIcon.appiconset"

# Check if source image exists
if (-not (Test-Path $sourceImage)) {
    Write-Error "Source image not found: $sourceImage"
    exit 1
}

Write-Host "Generating iOS app icons from: $sourceImage" -ForegroundColor Green

# Define all required iOS icon sizes
$iconSizes = @(
    @{Name="Icon-App-20x20@1x.png"; Size=20},
    @{Name="Icon-App-20x20@2x.png"; Size=40},
    @{Name="Icon-App-20x20@3x.png"; Size=60},
    @{Name="Icon-App-29x29@1x.png"; Size=29},
    @{Name="Icon-App-29x29@2x.png"; Size=58},
    @{Name="Icon-App-29x29@3x.png"; Size=87},
    @{Name="Icon-App-40x40@1x.png"; Size=40},
    @{Name="Icon-App-40x40@2x.png"; Size=80},
    @{Name="Icon-App-40x40@3x.png"; Size=120},
    @{Name="Icon-App-50x50@1x.png"; Size=50},
    @{Name="Icon-App-50x50@2x.png"; Size=100},
    @{Name="Icon-App-57x57@1x.png"; Size=57},
    @{Name="Icon-App-57x57@2x.png"; Size=114},
    @{Name="Icon-App-60x60@2x.png"; Size=120},
    @{Name="Icon-App-60x60@3x.png"; Size=180},
    @{Name="Icon-App-72x72@1x.png"; Size=72},
    @{Name="Icon-App-72x72@2x.png"; Size=144},
    @{Name="Icon-App-76x76@1x.png"; Size=76},
    @{Name="Icon-App-76x76@2x.png"; Size=152},
    @{Name="Icon-App-83.5x83.5@2x.png"; Size=167},
    @{Name="Icon-App-1024x1024@1x.png"; Size=1024}
)

# Load System.Drawing assembly for image manipulation
Add-Type -AssemblyName System.Drawing

try {
    # Load source image
    $sourceImg = [System.Drawing.Image]::FromFile($sourceImage)
    
    foreach ($iconSize in $iconSizes) {
        $outputPath = Join-Path $outputDir $iconSize.Name
        $size = $iconSize.Size
        
        Write-Host "Generating $($iconSize.Name) (${size}x${size}px)..."
        
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
    
    $sourceImg.Dispose()
    
    Write-Host "`nSuccessfully generated all iOS app icons!" -ForegroundColor Green
    Write-Host "Icons saved to: $outputDir" -ForegroundColor Cyan
    
} catch {
    Write-Error "Error generating icons: $_"
    exit 1
}
