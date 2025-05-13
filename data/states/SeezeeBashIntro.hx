import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;

var backdrop:FlxBackdrop;
var intro:FlxSprite;
var speed:Float = 150;
var hah:Bool = false;

function create() {
	fromIntro = true;
	backdrop = new FlxBackdrop(FlxGridOverlay.createGrid(128, 128, 256, 256, true, FlxColor.fromRGB(1,74,44), FlxColor.fromRGB(0,114,39)));
	backdrop.velocity.set(50, 50);
	add(backdrop);

	FlxG.sound.music?.stop();
	intro = new FlxSprite();
	intro.frames = Paths.getSparrowAtlas("game/menus/intro/sbb");
	intro.animation.addByPrefix("nin", "nin", 24, false);
	intro.screenCenter(0x11);
	add(intro);
	intro.animation.play("nin");
	intro.animation.finishCallback = function(name:String) {
		backdrop.acceleration.set(500,500);
		FlxTween.tween(backdrop,{alpha:0},2);
		FlxTween.tween(intro, {"scale.x": 0.1, "scale.y": 0.1, alpha: 0, angle: 120}, 2, {ease: FlxEase.quartOut, onComplete: () -> {
			FlxG.save.data.seezeeSawIntro = true;
			FlxG.switchState(new MainMenuState());
		}});
	}
}

function postUpdate() {
	if (controls.ACCEPT && FlxG.save.data.seezeeSawIntro) FlxG.switchState(new MainMenuState());
	switch (intro.animation.frameIndex) {
		case 1: CoolUtil.playMusic(Paths.sound("sbb_splash")); // 0 plays it twice also adding it in create either delays it or makes it earlier no, i think main menu first cuz we need options credits and shit
		case 106: FlxG.camera.flash(FlxColor.WHITE, 1);
	}
}