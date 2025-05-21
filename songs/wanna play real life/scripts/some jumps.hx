var la = boyfriend;
var laY = la.y;
var jumpSpeed = 1500;
function update() {
	if (FlxG.keys.pressed.C && la.y == laY) {
		FlxTween.cancelTweensOf(la,["y"]);
		la.y = laY;
		FlxTween.tween(la,{y:laY - 300},Conductor.crochet/jumpSpeed,{ease:FlxEase.sineOut}).then(FlxTween.tween(la,{y:laY},Conductor.crochet/jumpSpeed,{ease:FlxEase.sineIn}));
		if (FlxG.random.bool(25)) {
			FlxG.sound.play(Paths.sound("marJump"));
			FlxTween.cancelTweensOf(la,["angle"]);
			la.angle = 0;
			FlxTween.tween(la,{angle:360*FlxG.random.sign()},Conductor.crochet/(jumpSpeed/2),{onComplete: () -> la.angle = 0});
		} else FlxG.sound.play(Paths.sound("marJumpy"));
	}
}