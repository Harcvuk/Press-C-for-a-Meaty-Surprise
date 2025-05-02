function postCreate() {
  camHUD.fade(FlxColor.BLACK, 0);
}

function onSongStart() {
  camHUD.fade(FlxColor.BLACK, 12.5, true);
}
