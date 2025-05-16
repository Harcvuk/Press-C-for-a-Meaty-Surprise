// made it disabled if you don't start the song from the beginning - terios

import funkin.editors.charter.Charter;

function postCreate() {
	if (PlayState.instance.chartingMode && Charter.startHere) return;
	camHUD.fade(0xFF000000, 0);

	defaultCamZoom = 4;
}

function onSongStart() {
	if (PlayState.instance.chartingMode && Charter.startHere) return;
	camHUD.fade(0xFF000000, Conductor.crochet/1000*16, true);
}
