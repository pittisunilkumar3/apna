# PowerShell script to generate Web app icons from a source image

$sourceImage = "c:\Users\pitti\Downloads\json_to_firestore\AppIcons\appstore.png"
$outputDir = "c:\Users\pitti\Downloads\apna_bazar-6e054f59da32cd37eb196c13cfe38613a22337e1\web\icons"

# Check if source image exists
if (-not (Test-Path $sourceImage)) {
    Write-Error "Source image not found: $sourceImage"
    exit 1
}

Write-Host "Generating Web app icons from: $sourceImage" -ForegroundColor Green

# Define all required Web icon sizes
$webSizes = @(
    @{Name="Icon-192.png"; Size=192},
    @{Name="Icon-512.png"; Size=512},
    @{Name="Icon-maskable-192.png"; Size=192},
    @{Name="Icon-maskable-512.png"; Size=512}
)

# Load System.Drawing assembly for image manipulation
Add-Type -AssemblyName System.Drawing

try {
    # Load source image
    $sourceImg = [System.Drawing.Image]::FromFile($sourceImage)
    
    foreach ($webSize in $webSizes) {
        $outputPath = Join-Path $outputDir $webSize.Name
        $size = $webSize.Size
        
        Write-Host "Generating $($webSize.Name) (${size}x${size}px)..."
        
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
    
    Write-Host "`nSuccessfully generated all Web app icons!" -ForegroundColor Green
    Write-Host "Icons saved to: $outputDir" -ForegroundColor Cyan
    
} catch {
    Write-Error "Error generating icons: $_"
    exit 1
}
