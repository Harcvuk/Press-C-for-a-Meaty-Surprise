import flixel.text.FlxTextBorderStyle as Border;

var ding:FlxSprite;
var credits:FlxText;
var cleanupTimer:FlxTimer;

var path = "songs/" + PlayState.instance.curSong + "/credits.txt";
var lines:Array<String> = Assets.exists(Paths.getPath(path)) ? CoolUtil.coolTextFile(Paths.getPath(path)) : [];
var def:Array<String> = [
    "Artist: Default",
    "Composer: Default",
    "Programmer: Default",
    "Charter: Default",
];
var displayText = (lines == null || lines.length == 0) ? def.join("\n") : lines.join("\n");
var targetX = (FlxG.width - 1280) / 2;
var running = false;

function postCreate() {

    ding = new FlxSprite(-1280, 150).makeGraphic(1280, 300, FlxColor.BLACK);
    ding.alpha = 0;

    credits = new FlxText(ding.x, ding.y, ding.width, displayText);
    credits.setFormat(
        (PlayState.instance.curSong == "headache-ok") ? Paths.font("minecraft.ttf") : Paths.font("sonic2.ttf"),
        32, 0xFFFFFFFF, "center", Border.SHADOW, 0xFF000000
    );
    credits.borderSize *= 2;
    credits.alpha = 0;

    for (i in [ding, credits]) {
        i.camera = camHUD;
        CoolUtil.cameraCenter(i, camHUD);
        add(i);
    }
}

function startCredits() {
running = true;
    FlxTween.tween(ding, {x: targetX, alpha: 0.6}, 1.2, { ease: FlxEase.expoOut }).then(FlxTween.tween(ding, {x: FlxG.width + 50, alpha: 0}, 1.0, { ease: FlxEase.expoIn, startDelay: 2.0 }));
    FlxTween.tween(credits, {x: targetX, alpha: 1}, 1.4, { ease: FlxEase.expoOut }).then(FlxTween.tween(credits, {x: FlxG.width + 50, alpha: 0, "scale.x" : 0.6, "scale.y": 0.6}, 1.0, { ease: FlxEase.expoIn, startDelay: 2.0, onComplete: () -> running = false}));
}

function postUpdate() {
    if (!running && cleanupTimer == null) {
        cleanupTimer = new FlxTimer().start(5, function(_) {
            for (i in [ding, credits]){remove(i, true); i.destroy(); }
        });
    }
}