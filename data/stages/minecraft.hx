function password() {
	gf.debugMode = true;
	gf.playAnim("extend");
	for (thing in [sign,hand]) FlxTween.tween(thing,{x:thing.x-120},Conductor.crochet/1000,{startDelay:1,ease:FlxEase.circOut,onComplete: () -> {
		new FlxTimer().start(0.5, () -> {
			gf.playAnim("unextend",true);
			FlxTween.tween(hand,{x:hand.x+120},Conductor.crochet/1000,{ease:FlxEase.circIn});
		});
	}});
}