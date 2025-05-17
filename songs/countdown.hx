function postCreate() {
	meat = new FunkinSprite(0,0,Paths.image("countdown"));
	for (s => anim in ["three","two","one","go"])meat.addAnim(s,anim,2,false);
	meat.camera = camHUD;
	meat.screenCenter();
	meat.antialiasing = true;
	mid = FlxPoint.get(meat.x,meat.y);
	meat.scale.set(0.8,0.8);
}

function onCountdown(e) {
	e.spritePath = null;

	if ([0,1,2,3].contains(e.swagCounter)) meat.playAnim(e.swagCounter);
	switch (e.swagCounter) {
		case 0:
			add(meat);
			meat.angle = -15;
			FlxTween.tween(meat,{x:meat.x-50,y:meat.y+50*(downscroll ? -1 : 1)},Conductor.crochet/2000,{ease:FlxEase.expoOut});
			if (FlxG.random.bool(2)) e.soundPath = "introP";
		case 1:
			meat.angle = 5;
			FlxTween.tween(meat,{x:mid.x+50,y:mid.y,angle:25},Conductor.crochet/2000,{ease:FlxEase.expoOut});
		case 2:
			FlxTween.tween(meat,{x:mid.x-50,y:mid.y-50,angle:meat.angle-360-16},Conductor.crochet/2000,{ease:FlxEase.expoOut});
		case 3:
			meat.screenCenter();
			meat.angle = 0;
			meat.scale.set(1,1);
			FlxTween.tween(meat.scale,{x:0.8,y:0.8},Conductor.crochet/1000,{ease:FlxEase.elasticOut});
			FlxTween.tween(meat,{alpha:0},Conductor.crochet/2000,{ease:FlxEase.quartIn, startDelay:Conductor.crochet/2000});
	}
}