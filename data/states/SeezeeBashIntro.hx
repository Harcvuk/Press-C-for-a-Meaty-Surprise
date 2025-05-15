<<<<<<< HEAD
=======
import flixel.addons.display.FlxGridOverlay;
>>>>>>> 0bef9782e698104af63c4044d0374ab0e7dce37a
import flixel.addons.text.FlxTypeText;
import funkin.backend.MusicBeatState;

function create() {
	fromIntro = true;

	FlxG.sound.music?.stop();
	intro = new FunkinSprite(0,0,Paths.image("game/menus/intro/sbb"));
	intro.addAnim("nin", "nin", 24, false);
	intro.screenCenter(0x11);
	add(intro);

	ngc = new FunkinSprite(0,0,Paths.image("ngc"));
	ngc.addAnim("idle", "idle", 10, true);
	ngc.alpha = 0;
	ngc.antialiasing = false;
	ngc.screenCenter();
	ngc.scale.set(2.5,2.5);
	ngc.x -= 320;
	ngc.y += 50;
	add(ngc);

	harc = new FunkinSprite(0,0,Paths.image("harc"));
	harc.alpha = 0;
	harc.antialiasing = false;
	harc.screenCenter();
	add(harc);
	harc.x += 280;
	harc.y += 50;

	broughtBy = new FlxTypeText(0, ngc.y - 50, FlxG.width, "Brought to you by", 16);
	broughtBy.setFormat(Paths.font("sonic2.ttf"), 64, FlxColor.WHITE, "center");
	broughtBy.screenCenter(0x11);
	broughtBy.y -= 100;
	add(broughtBy);

	intro.playAnim("nin");
	intro.animation.finishCallback = () -> {
		ngc.playAnim("idle");
		new FlxTimer().start(1,() -> broughtBy.start());
		FlxTween.tween(intro, {"scale.x": 0.1, "scale.y": 0.1, alpha: 0, angle: 120}, 2, {ease: FlxEase.quartOut, onComplete: () -> {
			for (i in [ngc,harc]) FlxTween.tween(i, {alpha: 1}, 1, {ease: FlxEase.quartOut, startDelay: 1}).then(FlxTween.tween(i, {alpha: 0}, 1, {ease: FlxEase.quartOut,startDelay:1}));
			FlxTween.tween(broughtBy, {alpha: 0}, 1, {ease: FlxEase.quartOut, startDelay: 3, onComplete: () -> {
				FlxG.save.data.seezeeSawIntro = true;
				MusicBeatState.skipTransOut = true;
				FlxG.switchState(new MainMenuState());
			}});
		}});
	}
}

function postUpdate() {
	if (controls.ACCEPT && FlxG.save.data.seezeeSawIntro) FlxG.switchState(new MainMenuState());
	switch (intro.animation.frameIndex) {
		case 1: CoolUtil.playMusic(Paths.sound("sbb_splash"), false, 1, false); // 0 plays it twice also adding it in create either delays it or makes it earlier no, i think main menu first cuz we need options credits and shit
		case 106: FlxG.camera.flash(FlxColor.WHITE, 1);
	}
}