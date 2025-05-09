import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;

var backdrop:FlxBackdrop;
var intro:FlxSprite;
var speed:Float = 150;

function create() {

	    backdrop = new FlxBackdrop(FlxGridOverlay.createGrid(128, 128, FlxG.width, FlxG.height, true, FlxColor.fromRGB(1,74,44), FlxColor.fromRGB(0,114,39)));
    backdrop.velocity.set(50, 50);
    add(backdrop);

	trace("WELCOME");
	FlxG.sound.music?.stop();
	intro = new FlxSprite();
	intro.frames = Paths.getSparrowAtlas("game/menus/intro/sbb");
	intro.animation.addByPrefix("nin", "nin", 24, false);
	// for codename there are FlxAxes.XY, X or Y
	// but normally i use 0x01 for X, 0x10 for Y and just 0x11 for XY
	intro.screenCenter(0x11);
	add(intro);
	intro.animation.play("nin");
	intro.animation.finishCallback = function(name:String) {
		FlxTween.tween(intro, {"scale.x": 0.1, "scale.y": 0.1, alpha: 0, angle: 120}, 2, {ease: FlxEase.quartOut, onComplete: () -> {
			FlxG.save.data.seezeeSawIntro = true;
			FlxG.switchState(new MainMenuState());
		}});
	}
}

function update(elapsed:Float) {
    if (hah) speed = FlxMath.lerp(speed, 3600, elapsed * 1.5);
    backdrop.x -= speed * elapsed;
    backdrop.y -= speed * elapsed;
}
function postUpdate() {
	if (controls.ACCEPT && FlxG.save.data.seezeeSawIntro) FlxG.switchState(new MainMenuState());
	switch (intro.animation.frameIndex) {
		case 1: // 0 plays it twice also adding it in create either delays it or makes it earlier no, i think main menu first cuz we need options credits and shit
			CoolUtil.playMusic(Paths.sound("sbb_splash"));
		case 106:
			FlxG.camera.flash(FlxColor.WHITE, 1);
  case 200:
   hah = true;
	}
}