String getWebBrowserConfigXml(String tileColour) =>
    '''<?xml version='1.0' encoding='utf-8'?>
<browserconfig>
  <msapplication>
    <tile>
      <square70x70logo src='pwa-icons/windows11/SmallTile.scale-100.png' />
      <square150x150logo src='pwa-icons/windows11/Square150x150Logo.scale-100.png' />
      <square310x310logo src='pwa-icons/windows11/LargeTile.scale-100.png' />
      <TileColor>$tileColour</TileColor>
    </tile>
  </msapplication>
</browserconfig>
''';
