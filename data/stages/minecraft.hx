function password() {
	for (thing in [sign,hand]) FlxTween.tween(thing,{x:thing.x-120},Conductor.crochet/1000,{ease:FlxEase.circOut}).then(
	FlxTween.tween(hand,{x:hand.x+120},Conductor.crochet/1000,{ease:FlxEase.circIn}));
}