import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:image/image.dart';
import 'package:path/path.dart' as path;

import '../constants/constants.dart';

class GenerateCommand extends Command {
  // ------------------------------- CONSTRUCTORS ------------------------------
  GenerateCommand() {
    argParser.addFlag('verbose', abbr: 'v');
    argParser.addOption('name', abbr: 'n', mandatory: true);
    argParser.addOption('short-name', abbr: 's', mandatory: true);
    argParser.addOption('description', abbr: 'd', mandatory: true);
    argParser.addOption('icon-path', abbr: 'i', mandatory: true);
    argParser.addOption('path', abbr: 'p');
    argParser.addOption('theme', abbr: 't');
  }

  // -------------------------------- CONSTANTS --------------------------------
  static const String _androidPrefix = 'android/app/src/main/res/mipmap';
  static const String _iOSPrefix =
      'ios/Runner/Assets.xcassets/AppIcon.appiconset';
  static const String _iOSIconPrefix = '$_iOSPrefix/Icon-App';
  static const String _webPrefix = 'web';
  static const String _webFavIconsPrefix = 'web/favicons/favicon';
  static const String _webPwaAndroidIconsPrefix =
      'web/pwa-icons/android/android-launchericon';
  static const String _webPwaIOSIconsPrefix = 'web/pwa-icons/ios';
  static const String _webPwaWindowsPrefix = 'web/pwa-icons/windows11';
  static const String _webPwaWindowsSmallTilePrefix =
      '$_webPwaWindowsPrefix/SmallTile.scale';
  static const String _webPwaWindowsMediumTilePrefix =
      '$_webPwaWindowsPrefix/Square150x150Logo.scale';
  static const String _webPwaWindowsWideTilePrefix =
      '$_webPwaWindowsPrefix/Wide310x150Logo.scale';
  static const String _webPwaWindowsLargeTilePrefix =
      '$_webPwaWindowsPrefix/LargeTile.scale';
  static const String _webPwaWindowsSplashScreenPrefix =
      '$_webPwaWindowsPrefix/SplashScreen.scale';
  static const String _webPwaWindowsStoreLogoPrefix =
      '$_webPwaWindowsPrefix/StoreLogo.scale';
  static const String _webPwaWindowsSquare44LogoPrefix =
      '$_webPwaWindowsPrefix/Square44x44Logo';
  static const String _windowsPrefix = 'windows/runner/resources';
  static const String _macOSPrefix =
      'macos/Runner/Assets.xcassets/AppIcon.appiconset';
  static const String _macOSIconPrefix = '$_macOSPrefix/mac';

  // ---------------------------------- FIELDS ---------------------------------
  final _configs = {
    'android': [
      _Config(48, 48, '$_androidPrefix-mdpi/ic_launcher.png'),
      _Config(72, 72, '$_androidPrefix-hdpi/ic_launcher.png'),
      _Config(96, 96, '$_androidPrefix-xhdpi/ic_launcher.png'),
      _Config(144, 144, '$_androidPrefix-xxhdpi/ic_launcher.png'),
      _Config(192, 192, '$_androidPrefix-xxxhdpi/ic_launcher.png'),
    ],
    'ios': [
      _Config(20, 20, '$_iOSIconPrefix-20x20@1x.png'),
      _Config(40, 40, '$_iOSIconPrefix-20x20@2x.png'),
      _Config(60, 60, '$_iOSIconPrefix-20x20@3x.png'),
      _Config(29, 29, '$_iOSIconPrefix-29x29@1x.png'),
      _Config(58, 58, '$_iOSIconPrefix-29x29@2x.png'),
      _Config(87, 87, '$_iOSIconPrefix-29x29@3x.png'),
      _Config(40, 40, '$_iOSIconPrefix-40x40@1x.png'),
      _Config(80, 80, '$_iOSIconPrefix-40x40@2x.png'),
      _Config(120, 120, '$_iOSIconPrefix-40x40@3x.png'),
      _Config(120, 120, '$_iOSIconPrefix-60x60@2x.png'),
      _Config(180, 180, '$_iOSIconPrefix-60x60@3x.png'),
      _Config(76, 76, '$_iOSIconPrefix-76x76@1x.png'),
      _Config(152, 152, '$_iOSIconPrefix-76x76@2x.png'),
      _Config(167, 167, '$_iOSIconPrefix-83.5x83.5@2x.png'),
      _Config.removeAlpha(1024, 1024, '$_iOSIconPrefix-1024x1024@1x.png'),
    ],
    'web': [
      _Config.ico(64, 64, '$_webFavIconsPrefix.ico'),
      _Config(16, 16, '$_webFavIconsPrefix-16x16.png'),
      _Config(32, 32, '$_webFavIconsPrefix-32x32.png'),
      _Config(96, 96, '$_webFavIconsPrefix-96x96.png'),
      _Config(48, 48, '$_webPwaAndroidIconsPrefix-48-48.png'),
      _Config(72, 72, '$_webPwaAndroidIconsPrefix-72-72.png'),
      _Config(96, 96, '$_webPwaAndroidIconsPrefix-96-96.png'),
      _Config(144, 144, '$_webPwaAndroidIconsPrefix-144-144.png'),
      _Config(192, 192, '$_webPwaAndroidIconsPrefix-192-192.png'),
      _Config(512, 512, '$_webPwaAndroidIconsPrefix-512-512.png'),
      _Config(16, 16, '$_webPwaIOSIconsPrefix/16.png'),
      _Config(20, 20, '$_webPwaIOSIconsPrefix/20.png'),
      _Config(29, 29, '$_webPwaIOSIconsPrefix/29.png'),
      _Config(32, 32, '$_webPwaIOSIconsPrefix/32.png'),
      _Config(40, 40, '$_webPwaIOSIconsPrefix/40.png'),
      _Config(50, 50, '$_webPwaIOSIconsPrefix/50.png'),
      _Config(57, 57, '$_webPwaIOSIconsPrefix/57.png'),
      _Config(58, 58, '$_webPwaIOSIconsPrefix/58.png'),
      _Config(60, 60, '$_webPwaIOSIconsPrefix/60.png'),
      _Config(64, 64, '$_webPwaIOSIconsPrefix/64.png'),
      _Config(72, 72, '$_webPwaIOSIconsPrefix/72.png'),
      _Config(76, 76, '$_webPwaIOSIconsPrefix/76.png'),
      _Config(80, 80, '$_webPwaIOSIconsPrefix/80.png'),
      _Config(87, 87, '$_webPwaIOSIconsPrefix/87.png'),
      _Config(100, 100, '$_webPwaIOSIconsPrefix/100.png'),
      _Config(114, 114, '$_webPwaIOSIconsPrefix/114.png'),
      _Config(120, 120, '$_webPwaIOSIconsPrefix/120.png'),
      _Config(128, 128, '$_webPwaIOSIconsPrefix/128.png'),
      _Config(144, 144, '$_webPwaIOSIconsPrefix/144.png'),
      _Config(152, 152, '$_webPwaIOSIconsPrefix/152.png'),
      _Config(167, 167, '$_webPwaIOSIconsPrefix/167.png'),
      _Config(180, 180, '$_webPwaIOSIconsPrefix/180.png'),
      _Config(192, 192, '$_webPwaIOSIconsPrefix/192.png'),
      _Config(256, 256, '$_webPwaIOSIconsPrefix/256.png'),
      _Config(512, 512, '$_webPwaIOSIconsPrefix/512.png'),
      _Config(1024, 1024, '$_webPwaIOSIconsPrefix/1024.png'),
      _Config(71, 71, '$_webPwaWindowsSmallTilePrefix-100.png'),
      _Config(89, 89, '$_webPwaWindowsSmallTilePrefix-125.png'),
      _Config(107, 107, '$_webPwaWindowsSmallTilePrefix-150.png'),
      _Config(142, 142, '$_webPwaWindowsSmallTilePrefix-200.png'),
      _Config(284, 284, '$_webPwaWindowsSmallTilePrefix-400.png'),
      _Config(150, 150, '$_webPwaWindowsMediumTilePrefix-100.png'),
      _Config(188, 188, '$_webPwaWindowsMediumTilePrefix-125.png'),
      _Config(225, 225, '$_webPwaWindowsMediumTilePrefix-150.png'),
      _Config(300, 300, '$_webPwaWindowsMediumTilePrefix-200.png'),
      _Config(600, 600, '$_webPwaWindowsMediumTilePrefix-400.png'),
      _Config(310, 150, '$_webPwaWindowsWideTilePrefix-100.png', 67.0),
      _Config(388, 188, '$_webPwaWindowsWideTilePrefix-125.png', 67.0),
      _Config(465, 225, '$_webPwaWindowsWideTilePrefix-150.png', 67.0),
      _Config(620, 300, '$_webPwaWindowsWideTilePrefix-200.png', 67.0),
      _Config(1240, 600, '$_webPwaWindowsWideTilePrefix-400.png', 67.0),
      _Config(310, 310, '$_webPwaWindowsLargeTilePrefix-100.png'),
      _Config(388, 388, '$_webPwaWindowsLargeTilePrefix-125.png'),
      _Config(465, 465, '$_webPwaWindowsLargeTilePrefix-150.png'),
      _Config(620, 620, '$_webPwaWindowsLargeTilePrefix-200.png'),
      _Config(1240, 1240, '$_webPwaWindowsLargeTilePrefix-400.png'),
      _Config(620, 300, '$_webPwaWindowsSplashScreenPrefix-100.png', 50.0),
      _Config(775, 375, '$_webPwaWindowsSplashScreenPrefix-125.png', 50.0),
      _Config(930, 450, '$_webPwaWindowsSplashScreenPrefix-150.png', 50.0),
      _Config(1240, 600, '$_webPwaWindowsSplashScreenPrefix-200.png', 50.0),
      _Config(2480, 1200, '$_webPwaWindowsSplashScreenPrefix-400.png', 50.0),
      _Config(50, 50, '$_webPwaWindowsStoreLogoPrefix-100.png'),
      _Config(63, 63, '$_webPwaWindowsStoreLogoPrefix-125.png'),
      _Config(75, 75, '$_webPwaWindowsStoreLogoPrefix-150.png'),
      _Config(100, 100, '$_webPwaWindowsStoreLogoPrefix-200.png'),
      _Config(200, 200, '$_webPwaWindowsStoreLogoPrefix-400.png'),
      _Config(44, 44, '$_webPwaWindowsSquare44LogoPrefix.scale-100.png'),
      _Config(55, 55, '$_webPwaWindowsSquare44LogoPrefix.scale-125.png'),
      _Config(66, 66, '$_webPwaWindowsSquare44LogoPrefix.scale-150.png'),
      _Config(88, 88, '$_webPwaWindowsSquare44LogoPrefix.scale-200.png'),
      _Config(176, 176, '$_webPwaWindowsSquare44LogoPrefix.scale-400.png'),
      _Config(16, 16, '$_webPwaWindowsSquare44LogoPrefix.targetsize-16.png'),
      _Config(20, 20, '$_webPwaWindowsSquare44LogoPrefix.targetsize-20.png'),
      _Config(24, 24, '$_webPwaWindowsSquare44LogoPrefix.targetsize-24.png'),
      _Config(30, 30, '$_webPwaWindowsSquare44LogoPrefix.targetsize-30.png'),
      _Config(32, 32, '$_webPwaWindowsSquare44LogoPrefix.targetsize-32.png'),
      _Config(36, 36, '$_webPwaWindowsSquare44LogoPrefix.targetsize-36.png'),
      _Config(40, 40, '$_webPwaWindowsSquare44LogoPrefix.targetsize-40.png'),
      _Config(44, 44, '$_webPwaWindowsSquare44LogoPrefix.targetsize-44.png'),
      _Config(48, 48, '$_webPwaWindowsSquare44LogoPrefix.targetsize-48.png'),
      _Config(60, 60, '$_webPwaWindowsSquare44LogoPrefix.targetsize-60.png'),
      _Config(64, 64, '$_webPwaWindowsSquare44LogoPrefix.targetsize-64.png'),
      _Config(72, 72, '$_webPwaWindowsSquare44LogoPrefix.targetsize-72.png'),
      _Config(80, 80, '$_webPwaWindowsSquare44LogoPrefix.targetsize-80.png'),
      _Config(96, 96, '$_webPwaWindowsSquare44LogoPrefix.targetsize-96.png'),
      _Config(256, 256, '$_webPwaWindowsSquare44LogoPrefix.targetsize-256.png'),
      _Config(16, 16,
          '$_webPwaWindowsSquare44LogoPrefix.altform-unplated_targetsize-16.png'),
      _Config(20, 20,
          '$_webPwaWindowsSquare44LogoPrefix.altform-unplated_targetsize-20.png'),
      _Config(24, 24,
          '$_webPwaWindowsSquare44LogoPrefix.altform-unplated_targetsize-24.png'),
      _Config(30, 30,
          '$_webPwaWindowsSquare44LogoPrefix.altform-unplated_targetsize-30.png'),
      _Config(32, 32,
          '$_webPwaWindowsSquare44LogoPrefix.altform-unplated_targetsize-32.png'),
      _Config(36, 36,
          '$_webPwaWindowsSquare44LogoPrefix.altform-unplated_targetsize-36.png'),
      _Config(40, 40,
          '$_webPwaWindowsSquare44LogoPrefix.altform-unplated_targetsize-40.png'),
      _Config(44, 44,
          '$_webPwaWindowsSquare44LogoPrefix.altform-unplated_targetsize-44.png'),
      _Config(48, 48,
          '$_webPwaWindowsSquare44LogoPrefix.altform-unplated_targetsize-48.png'),
      _Config(60, 60,
          '$_webPwaWindowsSquare44LogoPrefix.altform-unplated_targetsize-60.png'),
      _Config(64, 64,
          '$_webPwaWindowsSquare44LogoPrefix.altform-unplated_targetsize-64.png'),
      _Config(72, 72,
          '$_webPwaWindowsSquare44LogoPrefix.altform-unplated_targetsize-72.png'),
      _Config(80, 80,
          '$_webPwaWindowsSquare44LogoPrefix.altform-unplated_targetsize-80.png'),
      _Config(96, 96,
          '$_webPwaWindowsSquare44LogoPrefix.altform-unplated_targetsize-96.png'),
      _Config(256, 256,
          '$_webPwaWindowsSquare44LogoPrefix.altform-unplated_targetsize-256.png'),
      _Config(16, 16,
          '$_webPwaWindowsSquare44LogoPrefix.altform-lightunplated_targetsize-16.png'),
      _Config(20, 20,
          '$_webPwaWindowsSquare44LogoPrefix.altform-lightunplated_targetsize-20.png'),
      _Config(24, 24,
          '$_webPwaWindowsSquare44LogoPrefix.altform-lightunplated_targetsize-24.png'),
      _Config(30, 30,
          '$_webPwaWindowsSquare44LogoPrefix.altform-lightunplated_targetsize-30.png'),
      _Config(32, 32,
          '$_webPwaWindowsSquare44LogoPrefix.altform-lightunplated_targetsize-32.png'),
      _Config(36, 36,
          '$_webPwaWindowsSquare44LogoPrefix.altform-lightunplated_targetsize-36.png'),
      _Config(40, 40,
          '$_webPwaWindowsSquare44LogoPrefix.altform-lightunplated_targetsize-40.png'),
      _Config(44, 44,
          '$_webPwaWindowsSquare44LogoPrefix.altform-lightunplated_targetsize-44.png'),
      _Config(48, 48,
          '$_webPwaWindowsSquare44LogoPrefix.altform-lightunplated_targetsize-48.png'),
      _Config(60, 60,
          '$_webPwaWindowsSquare44LogoPrefix.altform-lightunplated_targetsize-60.png'),
      _Config(64, 64,
          '$_webPwaWindowsSquare44LogoPrefix.altform-lightunplated_targetsize-64.png'),
      _Config(72, 72,
          '$_webPwaWindowsSquare44LogoPrefix.altform-lightunplated_targetsize-72.png'),
      _Config(80, 80,
          '$_webPwaWindowsSquare44LogoPrefix.altform-lightunplated_targetsize-80.png'),
      _Config(96, 96,
          '$_webPwaWindowsSquare44LogoPrefix.altform-lightunplated_targetsize-96.png'),
      _Config(256, 256,
          '$_webPwaWindowsSquare44LogoPrefix.altform-lightunplated_targetsize-256.png'),
    ],
    'windows': [
      _Config.ico(256, 256, '$_windowsPrefix/app_icon.ico'),
    ],
    'macos': [
      _Config(16, 16, '$_macOSIconPrefix-16x16@1x.png'),
      _Config(32, 32, '$_macOSIconPrefix-16x16@2x.png'),
      _Config(32, 32, '$_macOSIconPrefix-32x32@1x.png'),
      _Config(64, 64, '$_macOSIconPrefix-32x32@2x.png'),
      _Config(128, 128, '$_macOSIconPrefix-128x128@1x.png'),
      _Config(256, 256, '$_macOSIconPrefix-128x128@2x.png'),
      _Config(256, 256, '$_macOSIconPrefix-256x256@1x.png'),
      _Config(512, 512, '$_macOSIconPrefix-256x256@2x.png'),
      _Config(512, 512, '$_macOSIconPrefix-512x512@1x.png'),
      _Config(1024, 1024, '$_macOSIconPrefix-512x512@2x.png'),
    ],
  };

  // -------------------------------- PROPERTIES -------------------------------
  @override
  String get description => 'Generate app icons for all supported platforms.';

  @override
  String get name => 'generate';

  // --------------------------------- METHODS ---------------------------------
  @override
  Future<void> run() async {
    final verbose = argResults?['verbose'] as bool;
    final name = argResults?['name'] as String;
    final shortName = argResults?['short-name'] as String;
    final description = argResults?['description'] as String;
    final iconPath = argResults?['icon-path'] as String;
    final projectPath = argResults?['path'] as String?;
    final theme = argResults?['theme'] as String?;

    final normalisedTheme = _normaliseHex(theme);
    final themeColour = _hexToColour(normalisedTheme);

    final directory =
        projectPath != null ? Directory(projectPath) : Directory.current;
    final directoryStr = directory.path;

    final androidDir = path.join(directoryStr, 'android');
    final iOSDir = path.join(directoryStr, 'ios');
    final webDir = path.join(directoryStr, 'web');
    final windowsDir = path.join(directoryStr, 'windows');
    final macOSDir = path.join(directoryStr, 'macos');

    final hasAndroid = await Directory(androidDir).exists();
    final hasIOS = await Directory(iOSDir).exists();
    final hasWeb = await Directory(webDir).exists();
    final hasWindows = await Directory(windowsDir).exists();
    final hasMacOS = await Directory(macOSDir).exists();

    final iconFile = File(iconPath);
    if (!await iconFile.exists()) {
      stderr.writeln('[WARNING] Icon does not exist!');
      return;
    }

    final bytes = await iconFile.readAsBytes();
    final image = decodeImage(bytes);
    if (image == null) {
      stderr.writeln('[WARNING] Unknown icon image format!');
      return;
    }
    if (image.width < 1024 || image.height < 1024) {
      stderr.writeln('[WARNING] Icon should have minimum size of 1024x1024!');
      return;
    }
    if (image.width != image.height) {
      stderr.writeln('[WARNING] Icon should be a square image!');
      return;
    }

    if (hasAndroid) {
      await _generateImages(
        image: image,
        directory: directoryStr,
        verbose: verbose,
        configs: _configs['android']!,
        themeColour: themeColour,
      );
    }
    if (hasIOS) {
      await _generateImages(
        image: image,
        directory: directoryStr,
        verbose: verbose,
        configs: _configs['ios']!,
        themeColour: themeColour,
      );
      await File(path.join(directoryStr, _iOSPrefix, 'Contents.json'))
          .writeAsString(iOSContentsJson, flush: true);
    }
    if (hasWeb) {
      await _generateImages(
        image: image,
        directory: directoryStr,
        verbose: verbose,
        configs: _configs['web']!,
        themeColour: themeColour,
      );

      final webThemeColour = normalisedTheme != null
          ? '#${normalisedTheme.substring(0, 6)}'
          : '#ffffff';

      final browserConfigXml = getWebBrowserConfigXml(webThemeColour);
      await File(path.join(directoryStr, _webPrefix, 'browserconfig.xml'))
          .writeAsString(browserConfigXml, flush: true);

      final indexHtml = getWebIndexHtml(
        name,
        description,
        webThemeColour,
      );
      await File(path.join(directoryStr, _webPrefix, 'index.html'))
          .writeAsString(indexHtml, flush: true);

      final manifestJson = getWebManifestJson(
        name,
        shortName,
        description,
        webThemeColour,
      );
      await File(path.join(directoryStr, _webPrefix, 'manifest.json'))
          .writeAsString(manifestJson, flush: true);

      await File(path.join(directoryStr, _webPrefix, 'style.css'))
          .writeAsString(webStyleCss, flush: true);
    }
    if (hasWindows) {
      await _generateImages(
        image: image,
        directory: directoryStr,
        verbose: verbose,
        configs: _configs['windows']!,
        themeColour: themeColour,
      );
    }
    if (hasMacOS) {
      await _generateImages(
        image: image,
        directory: directoryStr,
        verbose: verbose,
        configs: _configs['macos']!,
        themeColour: themeColour,
      );
      await File(path.join(directoryStr, _macOSPrefix, 'Contents.json'))
          .writeAsString(macOSContentsJson, flush: true);
    }
  }

  Future<void> _generateImages({
    required Image image,
    required String directory,
    required bool verbose,
    required List<_Config> configs,
    int? themeColour,
  }) async {
    for (final config in configs) {
      if (verbose) {
        print('[VERBOSE] Generating ${config.outputPath}');
      }
      final resized = config.isSquare
          ? copyResize(
              image,
              width: config.width,
              height: config.height,
              interpolation: Interpolation.average,
            )
          : await _generateNonSquareImages(
              image: image,
              directory: directory,
              verbose: verbose,
              config: config,
              themeColour: themeColour,
            );
      if (config.removeAlpha) {
        resized.channels = Channels.rgb;
      }
      final bytes = config.ico ? encodeIco(resized) : encodePng(resized);
      final output = await File(path.join(directory, config.outputPath))
          .create(recursive: true);
      await output.writeAsBytes(bytes, flush: true);
    }
  }

  Future<Image> _generateNonSquareImages({
    required Image image,
    required String directory,
    required bool verbose,
    required _Config config,
    int? themeColour,
  }) async {
    final resized = copyResize(
      image,
      width: (config.height * config.placementPercentage / 100.0).ceil(),
      height: (config.height * config.placementPercentage / 100.0).ceil(),
      interpolation: Interpolation.average,
    );

    final emptyImage = Image(config.width, config.height);
    if (themeColour != null) {
      emptyImage.fill(themeColour);
    }

    return copyInto(
      emptyImage,
      resized,
      center: true,
      blend: false,
    );
  }

  String? _normaliseHex(String? hex) {
    if (hex == null) {
      return null;
    }

    final trimmedHex = hex.trim();
    final rawHex = trimmedHex.length == 7 || trimmedHex.length == 9
        ? trimmedHex.substring(1)
        : trimmedHex;
    if (rawHex.length != 6 && rawHex.length != 8) {
      stderr.writeln('[WARNING] Invalid theme colour is given!');
      return null;
    }

    final normalisedHex = rawHex.length == 6 ? '${rawHex}ff' : rawHex;
    return normalisedHex;
  }

  int? _hexToColour(String? normalisedHex) {
    if (normalisedHex == null) {
      return null;
    }

    final redHex = normalisedHex.substring(0, 2);
    final greenHex = normalisedHex.substring(2, 4);
    final blueHex = normalisedHex.substring(4, 6);
    final alphaHex = normalisedHex.substring(6);

    final red = int.parse(redHex, radix: 16);
    final green = int.parse(greenHex, radix: 16);
    final blue = int.parse(blueHex, radix: 16);
    final alpha = int.parse(alphaHex, radix: 16);

    return Color.fromRgba(red, green, blue, alpha);
  }
}

class _Config {
  // ------------------------------- CONSTRUCTORS ------------------------------
  _Config(
    this.width,
    this.height,
    this.outputPath, [
    this.placementPercentage = 100.0,
  ])  : ico = false,
        removeAlpha = false;

  _Config.removeAlpha(
    this.width,
    this.height,
    this.outputPath, [
    this.placementPercentage = 100.0,
  ])  : ico = false,
        removeAlpha = true;

  _Config.ico(
    this.width,
    this.height,
    this.outputPath, [
    this.placementPercentage = 100.0,
  ])  : ico = true,
        removeAlpha = false;

  // ---------------------------------- FIELDS ---------------------------------
  final int width;
  final int height;
  final String outputPath;
  final bool ico;
  final bool removeAlpha;
  final double placementPercentage;

  // -------------------------------- PROPERTIES -------------------------------
  bool get isSquare => width == height;
}
