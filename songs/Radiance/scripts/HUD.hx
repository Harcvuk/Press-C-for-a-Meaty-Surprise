import flixel.math.FlxRect;
import funkin.savedata.FunkinSave;
import Date;
import flixel.text.FlxTextBorderStyle as Border;

public var cornerLeft = new FunkinSprite(0,0,Paths.image("hud/2eaked/corner"));
public var cornerRight = new FunkinSprite(0,0,Paths.image("hud/2eaked/corner"));
public var someHealth = new FunkinSprite(0,0,Paths.image("hud/2eaked/healthbar"));
public var someHealthLoss = new FunkinSprite(0,0,Paths.image("hud/2eaked/healthbar"));
public var someHealthBG = new FunkinSprite(0,0,Paths.image("hud/2eaked/healthbar"));
public var hbLimit = new FunkinSprite(0,0,Paths.image("hud/2eaked/barlimit"));

public var iconOppo = new FunkinSprite();
public var iconPlay = new FunkinSprite();

public var nameOppo = new FlxText(151,FlxG.height-25,1000);
public var namePlay = new FlxText(0,FlxG.height-25,FlxG.width-151);

public var scoreText = new FlxText(0,FlxG.height-60,FlxG.width);
public var accuracyText = new FlxText(190,FlxG.height-60,500,"Accuracy: ?");
public var comboText = new FlxText(FlxG.width-690,FlxG.height-60,500,"Combo: 0 ( ? )");
public var timerText = new FlxText(0,10,FlxG.width);

public var leftColor:Int;
public var rightColor:Int;

public var ranks = new FunkinSprite(0,0,Paths.image("hud/2eaked/ranks"));
stats = {
	awesomes:0,
	goods:0,
	bads:0,
	awfuls:0,
};

public var hudItems = [scoreText,accuracyText,comboText,timerText,ranks,nameOppo,namePlay,iconOppo,iconPlay,cornerLeft,cornerRight,hbLimit,someHealth,someHealthLoss,someHealthBG];
static var instLength:Float; //for pause substate

function create() {
	if (PlayState.SONG.meta.customValues?.customHUD != null) return; //if theres a custom hud ignore everything

	comboGroup.visible = false; //death

	//health bar colors (guenro color if it fails)
	leftColor = Options.colorHealthBar ? (dad != null && dad.iconColor != null ? dad.iconColor :0xFF0000C2) : 0xFFFF3333;
	rightColor = Options.colorHealthBar ? (boyfriend != null && boyfriend.iconColor != null ? boyfriend.iconColor : 0xFF0000C2) : 0xFF66FF33;

	//corners and healthbar positioning/coloring
	cornerLeft.setPosition(0,FlxG.height - cornerLeft.height);
	cornerLeft.color = leftColor;

	cornerRight.setPosition(FlxG.width - cornerRight.width,FlxG.height - cornerRight.height);
	cornerRight.color = rightColor;
	cornerRight.flipX = true;

	for (i in [someHealthBG,someHealth,someHealthLoss,hbLimit]) {
		i.screenCenter(0x01);
		i.y = FlxG.height-32;
		if (i != 3) i.y++;
	}
	someHealthBG.color = leftColor;
	someHealth.color = rightColor;

	//icons
	var chars = [dad,boyfriend];
	for (s => icon in [iconOppo,iconPlay]) {
		if (Assets.exists(Paths.image("icons/custom/" + chars[s].icon))) {
			//create downscroll-specific icons by making a "downscroll [ICON NAME]"
			var hasdownscroll = (downscroll && (Assets.exists(Paths.image("icons/custom/downscroll " + chars[s].icon))) ? "downscroll " : "");
			icon.loadSprite(Paths.image("icons/custom/" + hasdownscroll + chars[s].icon));
		}
		else icon.loadSprite(Paths.image("icons/custom/guenro"));

		for (anim in ["normal","lose","win"]) icon.addAnim(anim,anim,24,true);
		icon.playAnim("normal");

		icon.origin.set(icon.frameWidth/2,icon.frameHeight);
		icon.setPosition((s == 0 ? 0 : FlxG.width-icon.width),FlxG.height - icon.height);
	}
	iconPlay.flipX = true;

	//names
	for (s => texty in [nameOppo,namePlay]) {
		formatMost(texty,22,(s==0?"left":"right"));
		if (downscroll) texty.y -= 2;
		if (chars[s].xml.get("name") != null && !Assets.exists(Paths.image("icons/custom/" + chars[s].icon)))
			texty.text = "guenro (no icon for " + chars[s].xml.get("name") + ")";
		else texty.text = (chars[s].xml.get("name") ?? "guenro");
	}
	//ranks
	for (rank in ["P+","P","S","A","B","C","D","NONE"]) ranks.addAnim(rank, rank == "P+" ? "RH" : rank, 24, true);
	ranks.screenCenter(0x01);
	ranks.y = 60;
	ranks.playAnim("NONE");

	//texts
	for (text in [scoreText,accuracyText,comboText,timerText]) formatMost(text,30);
	accuracyText.alignment = "left";
	accuracyText.angle = 2 * (downscroll ? -1 : 1);
	comboText.alignment = "right";
	comboText.angle = -2 * (downscroll ? -1 : 1);

	//add the stuff
	for (thing in hudItems) {
		thing.antialiasing = false;
		thing.camera = camHUD;
		insert(6,thing);
	}

	//zoomfactor the stuff
	for (amajig in [iconOppo,iconPlay,cornerLeft,cornerRight,hbLimit,someHealth,someHealthLoss,someHealthBG]) amajig.zoomFactor = 0.5;

	//downscroll-specific HUD (uglier but it works)
	if (downscroll) {
		for (sprite in [hbLimit,someHealthBG,someHealth,someHealthLoss]) sprite.flipY = true;
		for (sprite in [iconOppo,iconPlay]) sprite.y += 40;
		for (sprite in [cornerLeft,cornerRight]) {
			sprite.loadGraphic(Paths.image("hud/2eaked/cornerdownscroll")); //this does technically mean that downscroll HUD takes up more space but its just 15 more pixels so
			sprite.y = FlxG.height - sprite.height;
		}
	}
}

function postCreate() {
	for (i in [missesTxt, scoreTxt, accuracyTxt, healthBar,healthBarBG,iconP1,iconP2]) i.visible = false; //bye old things
	allowGitaroo = false; //DIE
	FlxG.camera.zoom = defaultCamZoom; //game does not restart zoom correctly upon pressing "restart song"
	PauseSubState.script = "data/states/pauses/"+ (PlayState.SONG.meta.customValues?.customPause ?? "2eakpause"); //some pauses
	FlxG.mouse.visible = false; //hide the mouse its useless
	instLength = inst.length;
}

public function addIconAnimation(side:String,animation:String,animationName:String,fps:Float,loops:Bool) {
	var which = side == "dad" ? iconOppo : iconPlay;
	which.addAnim(animation,animationName,fps,loops);
	//trace("gave " + side + " animation " + animation + " from animation name " + animationName + " at " + fps + " fps. loops? " + loops);
}

//update stuff
oldHealth = 1;
function formatTime(variable) return Math.floor(variable/60000)+":"+CoolUtil.addZeros(Math.floor((variable/1000)%60),2);
public var scoreName = "Score: ";
function update() {
	if (oldHealth != health) onHealthUpdate(); //custom health function for icon changes

	scoreText.text = scoreName + songScore; //no saving if botplay
	scoreText.color = validScore ? -1 : 0xFF800000;

	var timerType = FlxG.save.data?.tueakedTimerType ?? "countUp";
	timerText.text = switch(timerType) {
		case "countUp": (songPos < 0 ? "0:00" : formatTime(songPos)) + " / "+ formatTime(instLength);
		case "countDown": formatTime(instLength-songPos);
		case "countLess": "";
	}
}

//health bar shenanigans
someHealthNums = 0.5;
someRectangles = new FlxRect();
someHealthNumsLoss = 0.5;
someRectanglesLoss = new FlxRect();
someHealth.onDraw = () -> {
	someHealthNums = lerp(someHealthNums, health/maxHealth, 0.075);

	var precentWidth:Float = (someHealth.width * (1 - someHealthNums));
	someRectangles.set(precentWidth, 2, someHealth.width-precentWidth, someHealth.height);
	someHealth.clipRect = someRectangles;
	someHealth.draw();
}

public var healthLossColor = 0xFFB32424;
someHealthLoss.onDraw = () -> {
	someHealthNumsLoss = (someHealthNums < someHealthNumsLoss) ? lerp(someHealthNumsLoss, health/maxHealth, 0.05) : someHealthNums;

	var precentWidth:Float = (someHealthLoss.width * (1 - someHealthNumsLoss));
	someRectanglesLoss.set(precentWidth, 2, someHealthLoss.width-precentWidth, someHealthLoss.height);
	someHealthLoss.colorTransform.color = healthLossColor;
	someHealthLoss.clipRect = someRectanglesLoss;
	someHealthLoss.draw();
}

//rank calculation
oldRank = "NONE";
function onRatingUpdate() {
	comboText.text = ("Combo: " + combo + " ( " + checkFC() + " )");
	accuracyText.text = "Accuracy: " + FlxMath.roundDecimal(accuracy*100,2) + "%"; //round to 2 decimal places

	ranks.playAnim(rankCalc() ,false);
	if (oldRank != ranks.animation.curAnim.name) {
		oldRank = ranks.animation.curAnim.name;
		FlxTween.cancelTweensOf(ranks,["scale.x","scale.y"]);
		ranks.scale.set(1.4/1.2,1.4);
		ranks.angle += FlxG.random.float(4,7) * FlxG.random.sign();
		FlxTween.tween(ranks,{"scale.x":1,"scale.y":1,angle:0},(Conductor.crochet/750),{ease: FlxEase.backOut});
	}
}

//FC text calc
public function checkFC() return switch (true) {
	case misses != 0: "-" + misses;
	case stats.awfuls + stats.bads > 0: "FC";
	case stats.goods > 0: "GFC";
	default: "SFC";
}

//rank calc
function rankCalc() return switch (true) {
	case accuracy >= 0.97 && (misses + stats.awfuls + stats.bads == 0):
		stats.goods <= 10 ? "P+" : "P";
	case accuracy >= 0.90:
		misses < 2 ? "S" : "A"; //yup you get ONE miss
	case accuracy >= 0.85: "B";
	case accuracy >= 0.80: "C";
	case accuracy > 0 && accuracy < 0.80: "D";
	default: "NONE";
}

//ratings
leftOrRight = FlxG.random.sign();
function showRate(ratingFrame) {
	var ratingSprite = new FunkinSprite(0,150,Paths.image("hud/2eaked/ratings"));
	ratingSprite.camera = camHUD;
	ratingSprite.addAnim(ratingFrame,ratingFrame,0,true);
	ratingSprite.playAnim(ratingFrame);
	ratingSprite.moves = true;

	ratingSprite.screenCenter(0x01);
	add(ratingSprite);
	ratingSprite.scale.set(1.2,1.2);
	var dFlip = (downscroll ? -1 : 1);
	ratingSprite.angle = FlxG.random.int(7,12) * leftOrRight;
	ratingSprite.velocity.y = dFlip * (-100 - FlxG.random.int(1,3)*10); //lil jump
	ratingSprite.velocity.x = dFlip * (((100 * dFlip) - ratingSprite.velocity.y) * Math.sin((ratingSprite.angle * (Math.PI / 2) / 90))); //it moves in the direction its tilting towards
	ratingSprite.acceleration.y = 500 * dFlip;
	FlxTween.tween(ratingSprite.scale,{x:1,y:1},Conductor.crochet/2000,{ease:FlxEase.quartOut});
	FlxTween.tween(ratingSprite,{alpha:0},Conductor.crochet/750,{ease:FlxEase.quartIn, onComplete:() -> {remove(ratingSprite); ratingSprite.destroy();}});
	leftOrRight *= FlxG.random.sign(20);
}

function onPlayerMiss(e) {
	if (["Missable Note","Unpressable Note","Note that makes you huh"].contains(e.noteType)) return;

	comboText.text = ("Combo: " + combo + " ( " + checkFC() + " )");
	showRate("miss");
}

function onPlayerHit(event) {
	event.showRating = false;
	if (event.note.isSustainNote) return;

	var ratingFrame:String;
	switch (event.rating) {
		case "sick":
			stats.awesomes++;
			FlxG.random.bool(0.05) || FlxG.save.data.tueakedSaddam ? ratingFrame = "saddam" : ratingFrame = "awesome";
		case "good":
			stats.goods++;
			ratingFrame = "good";
		case "bad":
			stats.bads++;
			ratingFrame = "bad";
		case "shit":
			stats.awfuls++;
			ratingFrame = "awful";
	}
	showRate(ratingFrame);
}

losshealth = 0.20;
winhealth = 0.90; //yup it's not balanced
public var updateIconsOppo = true; //for custom animation shenanigans
public var updateIconsPlay = true;
public var iconOppoPrefix = "";
public var iconPlayPrefix = "";
currentIconOppo = "normal";
currentIconPlay = "normal";

function scaleIcon(icon, scaleX, scaleY, duration:Float) {
	FlxTween.cancelTweensOf(icon, ["scale.x", "scale.y"]);
	icon.scale.set(scaleX, scaleY);
	FlxTween.tween(icon.scale,{x:1,y:1}, duration, {ease: FlxEase.circOut});
}

function onHealthUpdate() {
	var healthPcnt = health / maxHealth;
	var oldHealthPcnt = oldHealth / maxHealth;

	if (oldHealthPcnt < winhealth && healthPcnt >= winhealth) {
		updateIconSprites("win");
		if (updateIconsOppo) scaleIcon(iconOppo, 1 / 0.95, 0.95, Conductor.crochet / 1000);
		if (updateIconsPlay) scaleIcon(iconPlay, 0.95, 1 / 0.95, Conductor.crochet / 1000);
	}
	else if (oldHealthPcnt > losshealth && healthPcnt <= losshealth) {
		updateIconSprites("lose");
		if (updateIconsOppo) scaleIcon(iconOppo, 0.95, 1 / 0.95, Conductor.crochet / 1000);
		if (updateIconsPlay) scaleIcon(iconPlay, 1 / 0.95, 0.95, Conductor.crochet / 1000);
	}
	else if (healthPcnt < winhealth && healthPcnt > losshealth) {
		updateIconSprites("normal");

		if (oldHealthPcnt >= winhealth) {
			if (updateIconsOppo) scaleIcon(iconOppo, 0.95, 1 / 0.95, Conductor.crochet / 1000);
			if (updateIconsPlay) scaleIcon(iconPlay, 1 / 0.95, 0.95, Conductor.crochet / 1000);
		}
		else if (oldHealthPcnt <= losshealth) {
			if (updateIconsOppo) scaleIcon(iconOppo, 1 / 0.95, 0.95, Conductor.crochet / 1000);
			if (updateIconsPlay) scaleIcon(iconPlay, 0.95, 1 / 0.95, Conductor.crochet / 1000);
		}
	}

	oldHealth = health;
}

function updateIconSprites(wins) {
	switch (wins) {
		case "win":
			if (updateIconsOppo) iconOppo.playAnim(iconOppoPrefix + (iconOppo.animation.exists(iconOppoPrefix + "lose") ? "lose" : "normal"));
			if (updateIconsPlay) iconPlay.playAnim(iconPlayPrefix + (iconPlay.animation.exists(iconPlayPrefix + "win") ? "win" : "normal"));
			currentIconOppo = "lose";
			currentIconPlay = "win";
		case "lose":
			if (updateIconsOppo) iconOppo.playAnim(iconOppoPrefix + (iconOppo.animation.exists(iconOppoPrefix + "win") ? "win" : "normal"));
			if (updateIconsPlay) iconPlay.playAnim(iconPlayPrefix + (iconPlay.animation.exists(iconPlayPrefix + "lose") ? "lose" : "normal"));
			currentIconOppo = "win";
			currentIconPlay = "lose";
		case "normal":
			if (updateIconsOppo) iconOppo.playAnim(iconOppoPrefix + "normal");
			if (updateIconsPlay) iconPlay.playAnim(iconPlayPrefix + "normal");
			currentIconOppo = "normal";
			currentIconPlay = "normal";
	}
	iconOppo.origin.set(iconOppo.width / 2, iconOppo.height);
	iconPlay.origin.set(iconPlay.width / 2, iconPlay.height);
}

function formatMost(text,size,align="center",borSize=1) {
	align ??= "center";
	borSize ??= 1;
	text.setFormat(Paths.font("Pangolin/Pangolin-Regular.ttf"),size,-1,align,Border.OUTLINE,0xFF000000);
	text.borderSize *= borSize;
}