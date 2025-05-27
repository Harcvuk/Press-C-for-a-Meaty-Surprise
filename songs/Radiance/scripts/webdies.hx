function onPlayerMiss() {
	FlxTween.cancelTweensOf(boyfriend,["color"]);
	boyfriend.color = 0xFFFF0000;
	FlxTween.color(boyfriend,Conductor.stepCrochet*0.008,boyfriend.color,-1,{ease:FlxEase.circOut});
}