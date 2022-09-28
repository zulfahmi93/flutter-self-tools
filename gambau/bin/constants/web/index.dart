String getWebIndexHtml(
  String name,
  String description,
  String themeColour,
) =>
    '''<!DOCTYPE html>
<html>
<head>
  <base href='\$FLUTTER_BASE_HREF'>

  <meta charset='UTF-8'>
  <meta content='IE=Edge' http-equiv='X-UA-Compatible'>
  <meta name='application-name' content='$name'>
  <meta name='description' content='$description'>
  <meta name='theme-color' content='$themeColour'>

  <!-- Preloader stylesheet -->
  <link rel='stylesheet' href='style.css'>

  <!-- iOS meta tags & icons -->
  <meta name='apple-mobile-web-app-capable' content='yes'>
  <meta name='apple-mobile-web-app-status-bar-style' content='black'>
  <meta name='apple-mobile-web-app-title' content='$name'>
  <link rel='apple-touch-icon' sizes='57x57' href='pwa-icons/ios/57.png'>
  <link rel='apple-touch-icon' sizes='60x60' href='pwa-icons/ios/60.png'>
  <link rel='apple-touch-icon' sizes='72x72' href='pwa-icons/ios/72.png'>
  <link rel='apple-touch-icon' sizes='76x76' href='pwa-icons/ios/76.png'>
  <link rel='apple-touch-icon' sizes='114x114' href='pwa-icons/ios/114.png'>
  <link rel='apple-touch-icon' sizes='120x120' href='pwa-icons/ios/120.png'>
  <link rel='apple-touch-icon' sizes='144x144' href='pwa-icons/ios/144.png'>
  <link rel='apple-touch-icon' sizes='152x152' href='pwa-icons/ios/152.png'>
  <link rel='apple-touch-icon' sizes='180x180' href='pwa-icons/ios/180.png'>

  <!-- Android meta tags & icons -->
  <link rel='icon' type='image/png' sizes='192x192' href='pwa-icons/android/android-launchericon-192-192.png'>

  <!-- Windows meta tags & icons -->
  <meta name='msapplication-TileColor' content='$themeColour'>
  <meta name='msapplication-TileImage' content='pwa-icons/windows11/Square150x150Logo.scale-100.png'>

  <!-- favicons -->
  <link rel='icon' type='image/png' sizes='32x32' href='favicons/favicon-32x32.png'>
  <link rel='icon' type='image/png' sizes='96x96' href='favicons/favicon-96x96.png'>
  <link rel='icon' type='image/png' sizes='16x16' href='favicons/favicon-16x16.png'>

  <title>$name</title>
  <link rel='manifest' href='manifest.json'>

  <script>
    // The value below is injected by flutter build, do not touch.
    var serviceWorkerVersion = null;
  </script>
  <!-- This script adds the flutter initialization JS code -->
  <script src="flutter.js" defer></script>
</head>

<body>
  <div id='preloader'>
    <img src='pwa-icons/windows11/LargeTile.scale-100.png'>
    <p id='preloader-text'>Please wait...</p>
  </div>
  <script>
    window.addEventListener('load', function(ev) {
      // Download main.dart.js
      _flutter.loader.loadEntrypoint({
        serviceWorker: {
          serviceWorkerVersion: serviceWorkerVersion,
        }
      }).then(function(engineInitializer) {
        return engineInitializer.initializeEngine();
      }).then(function(appRunner) {
        return appRunner.runApp();
      });
    });
  </script>
</body>
</html>
''';
