import flixel.addons.display.FlxBackdrop;
import funkin.backend.MusicBeatState;

path = "HUD/SRB2/";
function create() {
	camCount = new FlxCamera();
	camCount.zoom = 4;
	camCount.bgColor = 0;
	FlxG.cameras.add(camCount,false);

	count = new FunkinSprite();
	count.antialiasing = false;
	count.camera = camCount;
	count.screenCenter();
}

function onCountdown(e) {
	e.spritePath = null;
	switch (e.swagCounter) {
		case 0: add(count); e.soundPath = FlxG.random.bool(2) ? "introP" : "srb2/Count";
		case 3: e.soundPath = "srb2/Go";
		case 4: remove(count); count.destroy();
		default: e.soundPath = (e.swagCounter >= 0) ? "srb2/Count" : "";
	}

	if (e.swagCounter < 0 || e.swagCounter > 3) return;
	count.loadGraphic(Paths.image(path + "countdown/" + e.swagCounter));
	count.screenCenter(0x01);
	count.y = 400;
	FlxTween.tween(count, {"y": 402}, 3/35);
}