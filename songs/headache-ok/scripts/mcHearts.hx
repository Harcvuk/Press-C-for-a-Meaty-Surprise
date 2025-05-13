import flixel.text.FlxTextBorderStyle as Border;
var hearts = [];
function postCreate() {
	health = 2;
	//create the health icons
	for (i in 0...10) {
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

function update() for (heart in hearts) heart.y = (health*10 <= 4) ? heartY + FlxG.random.int(-1,0) : heartY;

function update() {
	for (i => heart in hearts) {
		var heartHealth = health*10 - (i * 2);

		//check if the heart should be full, half, or empty
		if (heartHealth >= 1) heart.playAnim("full",true);
		else if (heartHealth > 0) heart.playAnim("half",true);
		else heart.playAnim("empty",true);
	}
}

function onPlayerMiss(e) {
	FlxG.sound.play(Paths.sound("hitsounds/hit"+FlxG.random.int(1,3)));
	e.healthGain = -0.2;
	for (i => heart in hearts) {
		var heartHealth = (health-0.2)*10 - (i * 2);

		//if the heart is has health, flash white
		var c = heart.colorTransform;
		if (heartHealth > 0) {
			c.redOffset = c.greenOffset = c.blueOffset = 255;
			new FlxTimer().start(0.25, () -> {
				c.redOffset = c.greenOffset = c.blueOffset = 0;
			},2);
		}
	}
}