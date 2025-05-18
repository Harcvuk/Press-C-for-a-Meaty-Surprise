import flixel.text.FlxBitmapText;
import flixel.graphics.frames.FlxBitmapFont;

public var camSRB:FlxCamera;

path = "HUD/SRB2/";
function create() {
	//make the srb2
	camSRB = new FlxCamera(0,0,FlxG.width/2,FlxG.height/2,2);
	camSRB.bgColor = 0;
	FlxG.cameras.insert(camSRB,1,false);

	//nights sprites
	bgnights = new FunkinSprite(16,300,Paths.image(path + "NiGHTS/DRILLBAR")); //NiGHTS bar bg

	//NiGHTS bar (no it's not too small thats how it is in srb2)
	healthNights = new FunkinSprite(20,306,Paths.image(path + "NiGHTS/DRILLCOL")); //health

	for (night in [bgnights,healthNights]) if (downscroll) night.y -= 200;

	//text
	mainHUD = new FunkinSprite(16,10,Paths.image(path + "ScorTim")); //score,time,
	comboYellow = new FunkinSprite(16,74,Paths.image(path + "Combo")); //combo
	lives = new FunkinSprite(16,322,Paths.image(path + "lives")); //lives counter

	//set stuff and add
	for (hudElement in [mainHUD,comboYellow,lives]) {
		hudElement.camera = camSRB;
		hudElement.origin.set(0,0);
		add(hudElement);
	}
	bgnights.camera = camSRB;
	bgnights.origin.set(0,0);
	bgnights.scale.set(2,2); //ok bro

	healthNights.addAnim("red","red",1,true);
	healthNights.addAnim("black","black",1,true);
	healthNights.addAnim("green","green",1,true);
	healthNights.addAnim("white","white",1,true);
	healthNights.scale.set(2,2);
	healthNights.camera = camSRB;
	healthNights.origin.set(0,0);

	if (!ultimate) for (i in [bgnights,healthNights]) add(i);

	sonicScoreText = new FlxBitmapText(55.9,16.5,"0",FlxBitmapFont.fromAngelCode("assets/fonts/sonic2/sonic2.png", "assets/fonts/sonic2/sonic2.xml"));
	sonicTimeText = new FlxBitmapText(8,48.3,"0:00",FlxBitmapFont.fromAngelCode("assets/fonts/sonic2/sonic2.png", "assets/fonts/sonic2/sonic2.xml"));
	sonicComboText = new FlxBitmapText(8,80.5,"0",FlxBitmapFont.fromAngelCode("assets/fonts/sonic2/sonic2.png", "assets/fonts/sonic2/sonic2.xml"));
	livesCounterText = new FlxBitmapText(-36,343,"3",FlxBitmapFont.fromAngelCode("assets/fonts/srb2nums/srb2nums.png", "assets/fonts/srb2nums/srb2nums.xml"));

	for (i in [sonicScoreText,sonicTimeText,sonicComboText,livesCounterText]) {
		i.camera = camSRB;
		i.origin.set(0,0);
		i.scale.set(2,2);
		i.alignment = "right";
		i.autoSize = 0;
		i.fieldWidth = 112;
		add(i);
	}
}

function postCreate() {
	//hide the original HUD
	for (i in [missesTxt, accuracyTxt, scoreTxt, healthBar,healthBarBG,iconP1,iconP2]) i.visible = false;

	livesCounterText.text = 3 - PlayState.deathCounter;
	if (PlayState.deathCounter >= 5) { //5 deaths and we add an emoji laughing at you
		pfft = new FunkinSprite(135,320,Paths.image(path + "pfft"));
		pfft.camera = camSRB;
		pfft.origin.set(0,0);
		pfft.scale.set(0.1,0.1);
		add(pfft);
	}
}

function stepHit() {
	//10% health or less and the bar flashes
	if (health <= 0.2 && (curStep % 2 != 0)) healthNights.playAnim("red"); else healthNights.playAnim("green");
}

function postUpdate() {
	camSRB.zoom = 1.25 + (camHUD.zoom * 0.75); //also needs to bump too ok?

	//visual bug fix (health + default health gain)
	healthNights.scale.x = health >= 2 ? 96*health : 192;

	sonicScoreText.text = songScore; //needs to show score ok?
	sonicTimeText.text = (Conductor.songPosition < 0 ? "0:00" : formatTime(Conductor.songPosition)); //needs to show the time ok?
	sonicComboText.text = combo; //these comments are useless ok?
}

function formatTime(timeMS:Int) {
	var seconds = timeMS / 1000;
	var mins = Math.floor(seconds/60);
	var secs = Math.floor(seconds % 60);
	return (mins + ":" + (secs < 10 ? "0" + secs : secs));
}
