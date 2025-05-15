// made it disabled if you don't start the song from the beginning - terios

import funkin.editors.charter.Charter;

function postCreate() {
  if (PlayState.instance.chartingMode && Charter.startHere) return;
  camHUD.fade(FlxColor.BLACK, 0);
}

function onSongStart() {
  if (PlayState.instance.chartingMode && Charter.startHere) return;
  camHUD.fade(FlxColor.BLACK, 12.5, true);
}
