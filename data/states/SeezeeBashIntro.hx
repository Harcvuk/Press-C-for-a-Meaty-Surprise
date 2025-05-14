import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.text.FlxTypeText;

var backdrop:FlxBackdrop;
var intro:FlxSprite;
var speed:Float = 150;
var hah:Bool = false;
var typeText:FlxTypeText;


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

	ngc = new FlxSprite();
	ngc.frames = Paths.getSparrowAtlas("ngc");
	ngc.animation.addByPrefix("idle", "idle", 10, true);
	ngc.alpha = 0;
	ngc.antialiasing = false;
	ngc.screenCenter(0x11);
	ngc.scale.set(2, 2);
	add(ngc);

	typeText = new FlxTypeText(0, ngc.y - 50, FlxG.width, "Brought to you by", 16);
    typeText.setFormat(Paths.font("sonic2.ttf"), 64, FlxColor.WHITE, "center");
    typeText.screenCenter(0x11);
	typeText.y -= 100;
    add(typeText);
	intro.animation.play("nin");
	intro.animation.finishCallback = function(name:String) {
		backdrop.acceleration.set(500,500);
		FlxTween.tween(backdrop,{alpha:0},2);
		ngc.animation.play("idle");
		FlxTween.tween(intro, {"scale.x": 0.1, "scale.y": 0.1, alpha: 0, angle: 120}, 2, {ease: FlxEase.quartOut, onComplete: () -> {
			typeText.start();
			FlxTween.tween(ngc, {alpha: 1}, 1, {ease: FlxEase.quartOut, startDelay: 1}).then(FlxTween.tween(typeText, {alpha: 0}, 1, {ease: FlxEase.quartOut, startDelay: 1})).then(FlxTween.tween(ngc, {alpha: 0}, 1, {ease: FlxEase.quartOut, startDelay: 0.5, onComplete: () -> {
				FlxG.save.data.seezeeSawIntro = true;
				FlxG.switchState(new MainMenuState());
			}}));
			
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