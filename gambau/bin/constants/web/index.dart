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
</head>

<body>
  <div id='preloader'>
    <img src='pwa-icons/windows11/LargeTile.scale-100.png'>
    <p id='preloader-text'>Please wait...</p>
  </div>
  <script>
    const urlParams = new URLSearchParams(window.location.search);
    const tokenCode = urlParams.get('code');
    if (tokenCode) {
      sessionStorage.setItem('auth_code', tokenCode);
    }
  </script>
  <script src='//cdnjs.cloudflare.com/ajax/libs/pdf.js/2.4.456/pdf.min.js'></script>
  <script type='text/javascript'>
    pdfjsLib.GlobalWorkerOptions.workerSrc = '//cdnjs.cloudflare.com/ajax/libs/pdf.js/2.4.456/pdf.worker.min.js';
  </script>
  <script>
    var serviceWorkerVersion = null;
    var scriptLoaded = false;
    function loadMainDartJs() {
      if (scriptLoaded) {
        return;
      }
      scriptLoaded = true;
      var scriptTag = document.createElement('script');
      scriptTag.src = 'main.dart.js';
      scriptTag.type = 'application/javascript';
      document.body.append(scriptTag);
    }

    if ('serviceWorker' in navigator) {
      // Service workers are supported. Use them.
      window.addEventListener('load', function () {
        // Wait for registration to finish before dropping the <script> tag.
        // Otherwise, the browser will load the script multiple times,
        // potentially different versions.
        var serviceWorkerUrl = 'flutter_service_worker.js?v=' + serviceWorkerVersion;
        navigator.serviceWorker.register(serviceWorkerUrl)
          .then((reg) => {
            function waitForActivation(serviceWorker) {
              serviceWorker.addEventListener('statechange', () => {
                if (serviceWorker.state == 'activated') {
                  console.log('Installed new service worker.');
                  loadMainDartJs();
                }
              });
            }
            if (!reg.active && (reg.installing || reg.waiting)) {
              // No active web worker and we have installed or are installing
              // one for the first time. Simply wait for it to activate.
              waitForActivation(reg.installing || reg.waiting);
            } else if (!reg.active.scriptURL.endsWith(serviceWorkerVersion)) {
              // When the app updates the serviceWorkerVersion changes, so we
              // need to ask the service worker to update.
              console.log('New service worker available.');
              reg.update();
              waitForActivation(reg.installing);
            } else {
              // Existing service worker is still good.
              console.log('Loading app from service worker.');
              loadMainDartJs();
            }
          });

        // If service worker doesn't succeed in a reasonable amount of time,
        // fallback to plaint <script> tag.
        setTimeout(() => {
          if (!scriptLoaded) {
            console.warn(
              'Failed to load app from service worker. Falling back to plain <script> tag.',
            );
            loadMainDartJs();
          }
        }, 4000);
      });
    } else {
      // Service workers not supported. Just drop the <script> tag.
      loadMainDartJs();
    }
  </script>
</body>
</html>
''';
