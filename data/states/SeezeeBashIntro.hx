var intro:FlxSprite;

function create() {
    intro = new FlxSprite();
    intro.frames = Paths.getSparrowAtlas("game/intro/sbb");
    intro.animation.addByPrefix("nin", "nin", 24, false);
    // for codename there are FlxAxes.XY, X or Y
    // but normally i use 0x01 for X, 0x10 for Y and just 0x11 for XY
    intro.screenCenter(0x11); 
    add(intro);
    intro.animation.play("nin");
    intro.animation.finishCallback = function(name:String) {
        FlxG.switchState(new TitleState());
    };
    CoolUtil.playMusic(Paths.sound("sbb_splash"));
}