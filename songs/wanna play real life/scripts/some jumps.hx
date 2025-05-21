var la = boyfriend;
var laY = la.y;

function update() {
    if (FlxG.keys.pressed.C) {
        if (la.y != laY) return;
			FlxTween.cancelTweensOf(la,["y"]);
			la.y = laY;
			FlxTween.tween(la,{y:laY - 300},Conductor.crochet/1200,{ease:FlxEase.sineOut,onComplete:() -> if (la.animation.curAnim.name == "singUP") la.playAnim("fall",true,false,0,"LOCK")}).then(FlxTween.tween(la,{y:laY},Conductor.crochet/1200,{ease:FlxEase.sineIn, onComplete:() -> if (la.animation.curAnim.name == "fall") la.playAnim("idle",true,false,0,"DANCE")}));
			if (FlxG.random.bool(50)) {
				FlxTween.cancelTweensOf(la,["angle"]);
				la.angle = 0;
				FlxTween.tween(la,{angle:360*FlxG.random.sign()},Conductor.crochet/600,{onComplete: () -> la.angle = 0});
            }
    }
}