var intro:FlxSprite;

function create() {
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
        FlxTween.tween(intro, {"scale.x": 0.1, "scale.y": 0.1, alpha: 0, angle: 120}, 2, {ease: FlxEase.quartOut, onComplete: () -> FlxG.switchState(new TitleState())});
    };
}

function postUpdate() {
    switch (intro.animation.frameIndex) {
        case 1: // 0 plays it twice also adding it in create either delays it or makes it earlier no, i think main menu first cuz we need options credits and shit
            CoolUtil.playMusic(Paths.sound("sbb_splash"));
        case 106:
            FlxG.camera.flash(FlxColor.WHITE, 1);
    }
}