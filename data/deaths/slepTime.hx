import funkin.editors.charter.Charter;

function create(event) {
	event.cancel();
	FlxG.sound.music?.stop();
	camDied = new FlxCamera();
	camDied.bgColor = 0xFF000000;
	FlxG.cameras.add(camDied,false);

	slepTime = new FunkinSprite(15,0,Paths.image("hud/Slep"));
	slepTime.antialiasing = true;
	slepTime.screenCenter(16);
	slepTime.scale.set(0.7,0.7);
	slepTime.addAnim("slep","slep",24,true);
	slepTime.playAnim("slep");
	slepTime.camera = camDied;
	add(slepTime);
	slepTime.alpha = 0;
	FlxTween.tween(slepTime,{alpha:1},4,{ease:FlxEase.sineOut});

	song = FlxG.sound.load(Paths.music(FlxG.random.bool(0.5) ? "slepPhonk" : "slepTime"));
	song.play();
	song.onComplete = () -> FlxG.switchState(new PlayState());
}
function update() {
	FlxG.sound.music = null;
	if (controls.ACCEPT) FlxG.switchState(new PlayState());
	if (controls.BACK) {
		if (PlayState.chartingMode && Charter.undos.unsaved) {
			PlayState.instance.saveWarn(false);
			return;
		}
		PlayState.resetSongInfos();
		Charter.instance?.__clearStatics();

		FlxG.sound.music?.stop();
		FlxG.sound.music = null;

		FlxG.switchState(PlayState.isStoryMode ? new StoryMenuState() : new FreeplayState());
	}
}