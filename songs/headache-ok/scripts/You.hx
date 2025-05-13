function postCreate() {
	you = new FunkinSprite(0,0,Paths.image("You"));
	you.scale.set(2,2);
	you.updateHitbox();
	you.setPosition(FlxG.width/4-80,200);
	you.antialiasing = true;
	you.camera = camHUD;
	insert(0,you);
}

function onPlayerHit() {
	FlxTween.tween(you,{alpha:0},Conductor.crochet/2000,{onComplete: () -> {
		remove(you);
		you.destroy();
	}});
}