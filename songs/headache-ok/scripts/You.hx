function postCreate() {
	PauseSubState.script = "data/states/mcpause";
	camGame.followLerp = 0;

	you = new FunkinSprite(0,0,Paths.image("You"));
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

function stepHit() {
	if (curStep % 2 == 0 && curStep >= 0) {
		if (you.color == 0xFFFFFF00) you.color = -1;
		else you.color = 0xFFFFFF00;
	}
}