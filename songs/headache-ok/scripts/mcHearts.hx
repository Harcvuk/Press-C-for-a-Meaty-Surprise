import flixel.text.FlxTextBorderStyle as Border;
var hearts = [];
function postCreate() {
	GameOverSubstate.script = "data/deaths/slepTime";
	health = 2;
	//create the health icons
	if (!ultimate) for (i in 0...10) {
		var mcHeart = new FunkinSprite(i * 36 + 460,healthBar.y-20,Paths.image("hud/minecraft/hearts"));
		for (anim in ["full","half","empty"]) mcHeart.addAnim(anim,anim,1,true);
		mcHeart.origin.set(0,0);
		mcHeart.scale.set(4,4);
		mcHeart.updateHitbox();
		mcHeart.camera = camHUD;
		mcHeart.antialiasing = false;
		hearts.push(mcHeart);
		add(mcHeart);
		mcHeart.playAnim("full",true);
	}
	heartY = healthBar.y-20;

	for (hud in [healthBar,healthBarBG,iconP1,iconP2]) hud.visible = false;

	for (hud in [missesTxt,scoreTxt,accuracyTxt]) {
		hud.size *= 2;
		hud.font = Paths.font("minecraft.ttf");
		hud.borderStyle = Border.SHADOW;
		hud.borderSize *= 2;
	}
	accuracyTxt.x -= 200;
	scoreTxt.x += 100;
}

var heartY = 0;
var ticker = 0;
function update(elapsed) {
	if (ultimate) return;
	ticker+=elapsed;
	if (ticker >= 1/20) {
		ticker -= 1/20;
		for (heart in hearts) heart.y = (health*10 <= 4) ? heartY - (FlxG.random.int(0,1)*4) : heartY;
	}

	for (i => heart in hearts) {
		var heartHealth = health*10 - (i * 2);

		//check if the heart should be full, half, or empty
		heart.playAnim(heartHealth >= 1 ? "full" : heartHealth > 0 ? "half" : "empty", true); // wanna hop on real life 🤑
	}
}

var healthLoss = -5/10;
var hitTimer = new FlxTimer();
function onPlayerMiss(e) {
	if (ultimate) return;

	var b = boyfriend.colorTransform;
	b.redOffset = 128;
	hitTimer.start(0.25,() -> b.redOffset = 0);

	FlxG.sound.play(Paths.sound("hitsounds/hit"+FlxG.random.int(1,3)));
	e.healthGain = healthLoss;
	for (i => heart in hearts) {
		var heartHealth = (health+healthLoss)*10 - (i * 2);

		//if the heart is has health, flash white
		var c = heart.colorTransform;
		if (heartHealth > 0) {
			c.redOffset = c.greenOffset = c.blueOffset = 255;
			new FlxTimer().start(0.25, () -> c.redOffset = c.greenOffset = c.blueOffset = 0,2);
		}
	}
}