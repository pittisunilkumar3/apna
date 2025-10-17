# App Icon Generator Scripts

This folder contains automated scripts to regenerate all app icons for your Apna Bazar Flutter application.

## 📁 Generated Scripts

1. **generate_all_icons.ps1** - Master script (runs all icon generators)
2. **generate_ios_icons.ps1** - Generates iOS icons only
3. **generate_android_icons.ps1** - Generates Android icons only
4. **generate_web_icons.ps1** - Generates Web icons only

## 🚀 Quick Start

### Generate All Icons (Recommended)
```powershell
powershell -ExecutionPolicy Bypass -File .\generate_all_icons.ps1
```

### Generate Specific Platform Icons

#### iOS Only:
```powershell
powershell -ExecutionPolicy Bypass -File .\generate_ios_icons.ps1
```

#### Android Only:
```powershell
powershell -ExecutionPolicy Bypass -File .\generate_android_icons.ps1
```

#### Web Only:
```powershell
powershell -ExecutionPolicy Bypass -File .\generate_web_icons.ps1
```

## 📋 Requirements

- **Source Image:** `c:\Users\pitti\Downloads\json_to_firestore\AppIcons\appstore.png`
- **PowerShell:** Windows PowerShell 5.1 or later (pre-installed on Windows)
- **System.Drawing:** .NET Framework (pre-installed on Windows)

## 🔄 When to Regenerate Icons

Regenerate icons whenever:
- You update your app's branding or logo
- You need to test different icon designs
- Icons appear corrupted or missing
- After cloning the repository on a new machine

## 🎯 What Gets Generated

### iOS (21 files)
- All required sizes from 20x20 to 1024x1024 pixels
- iPhone and iPad variants (@1x, @2x, @3x)
- App Store icon (1024x1024)
- Location: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

### Android (10 files)
- 5 density variants (mdpi, hdpi, xhdpi, xxhdpi, xxxhdpi)
- Both `ic_launcher.png` and `launcher_icon.png` in each folder
- Sizes from 48x48 to 192x192 pixels
- Location: `android/app/src/main/res/mipmap-*/`

### Web (4 files)
- Standard icons (192x192, 512x512)
- Maskable icons for Android PWA (192x192, 512x512)
- Location: `web/icons/`

## ✅ Quality Assurance

All icons are generated with:
- High-quality bicubic interpolation
- Maximum smoothing and anti-aliasing
- PNG format with transparency support
- Optimized for each platform's specifications

## 🛠️ After Generating Icons

1. **Clean Flutter cache:**
   ```bash
   flutter clean
   ```

2. **Get dependencies:**
   ```bash
   flutter pub get
   ```

3. **Build for your target platform:**
   ```bash
   # iOS
   flutter build ios
   
   # Android
   flutter build apk
   # or
   flutter build appbundle
   
   # Web
   flutter build web
   ```

4. **Test the app:**
   - Install on a physical device
   - Check icon appearance on home screen
   - Verify icon in app switcher
   - Test on different device sizes

## 🎨 Changing the Source Icon

To use a different icon:

1. Replace the source image at: `c:\Users\pitti\Downloads\json_to_firestore\AppIcons\appstore.png`
2. Or update the `$sourceImage` variable in each script
3. Run `generate_all_icons.ps1` again

## 📝 Notes

- **Source image should be square** (1:1 aspect ratio) for best results
- **Recommended source size:** 1024x1024 pixels or larger
- **Format:** PNG with transparency support
- Icons are automatically resized maintaining aspect ratio
- High-quality rendering prevents pixelation

## ❓ Troubleshooting

### "Source image not found" error
- Verify the source image exists at the specified path
- Check the path in the script matches your image location

### Icons not updating in app
- Run `flutter clean`
- Delete the `build` folder manually
- Rebuild the app completely

### Icons appear blurry
- Use a higher resolution source image (minimum 1024x1024)
- Ensure source image is PNG format
- Check source image is not already compressed

## 📞 Support

For issues or questions, refer to:
- Flutter documentation: https://flutter.dev
- iOS Human Interface Guidelines: https://developer.apple.com/design/human-interface-guidelines/app-icons
- Android Icon Design: https://developer.android.com/guide/practices/ui_guidelines/icon_design

---

**Last Updated:** October 17, 2025
**App:** Apna Bazar
**Version:** 1.0.0
