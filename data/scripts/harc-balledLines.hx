var sound:Sound;

function create() {
	sound = FlxG.random.getObject(Paths.getFolderContent("sounds/trialGameover", true)); // its automatic now haha
}

function beatHit(cur:Int) {
	if(cur != 0) return;

	FlxG.sound.music.volume = 0.2;
	FlxG.sound.play(sound, 1, false, null, true, function()
	{
		if (!isEnding)
			FlxG.sound.music.fadeIn(4, 0.2, 1);
	});
}