function hudBye(time) {
	FlxTween.tween(camHUD,{alpha:-camHUD.alpha+1},Conductor.crochet/500);
}

function postCreate() {
	camLyrics = new FlxCamera();
	FlxG.cameras.add(camLyrics,false);
	camLyrics.bgColor = 0;

	lyricText = new FunkinText(0,FlxG.height - 200,FlxG.width,"");
	lyricText.size = 30;
	lyricText.borderSize *= 2;
	lyricText.color = 0xFFFFFF00;
	lyricText.alignment = "center";
	lyricText.camera = camLyrics;
	add(lyricText);
}

function lyrics(theString) {
	lyricText.text = theString;
}