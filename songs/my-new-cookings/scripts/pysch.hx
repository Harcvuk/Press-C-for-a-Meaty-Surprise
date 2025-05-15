//modified version of the hud script for seezeed 2 from seezee's box
//yes i know i spelt pysch i just dont care
import flixel.ui.FlxBar;
import flixel.ui.FlxBarFillDirection;
import flixel.text.FlxTextBorderStyle as Border;

var ratingStuff = [
	['You Suck!', 0.2], //0-19
	['Shit', 0.4], //20-39
	['Bad', 0.5], //40-49
	['Bruh', 0.6], //50-59
	['Meh', 0.69], //60-68
	['Nice', 0.7], //69
	['Good', 0.8], //70-79
	['Great', 0.9], //80-89
	['Sick!', 1], //90-99
	['Perfect!!', 1] //100
];

function getRating() {
	for (rating in ratingStuff) if (accuracy < rating[1]) return rating[0];
	return ratingStuff[ratingStuff.length - 1][0];
}

function getRatingFC() return switch (true) {
	case (accuracy == 1): "MFC";
	case (accuracy >= 0.99): "GFC";
	case (misses < 10): "SDBC";
	case (accuracy >= 10): "Clear";
	default: "FC";
}

function postCreate() {
	doIconBop = false;
	infotxt = new FunkinText(healthBarBG.x+110,FlxG.height-40);
	infotxt.setFormat(Paths.font("vcr.ttf"),20,-1,"center",Border.OUTLINE,0xFF000000);
	infotxt.borderSize = 1.25;
	add(infotxt);

	for(text in [scoreTxt,missesTxt,accuracyTxt]) text.visible = false;

	timeBarBG = new FunkinSprite(0,FlxG.height*0.033);
	timeBarBG.loadGraphic(Paths.image("game/timeBar"));
	timeBarBG.screenCenter(0x01);
	add(timeBarBG);

	timeBar = new FlxBar(timeBarBG.x+4,timeBarBG.y+4,FlxBarFillDirection.LEFT_TO_RIGHT,Std.int(timeBarBG.width-8),Std.int(timeBarBG.height-8),inst,'time',0,inst.length);
	timeBar.createFilledBar(0xFF000000,-1);
	timeBar.numDivisions = timeBar.width;
	add(timeBar);

	timeText = new FunkinText(timeBarBG.x,timeBarBG.y-5,Std.int(timeBarBG.width),20);
	timeText.setFormat(Paths.font("vcr.ttf"),32,-1,"center",Border.OUTLINE,0xFF000000);
	timeText.size = 30;
	timeText.borderSize = 2;
	timeText.screenCenter(0x01);
	add(timeText);

	for (e in [timeBarBG,timeBar,timeText,infotxt]) e.camera = camHUD;

	camCombo = new FlxCamera();
	FlxG.cameras.add(camCombo,false);
	camCombo.bgColor = 0;
}

function postUpdate() {
	var ratements = (accuracy == -1) ? "?" : getRating() + " (" + FlxMath.roundDecimal(Math.max(accuracy,0)*100,2) + ") - " + getRatingFC();

	infotxt.text = "Score:" + songScore + " | Misses:" + misses + " | Rating: " + ratements;
	infotxt.screenCenter(0x01);

	comboGroup.cameras = [camCombo];
	comboGroup.x = 400;
	comboGroup.y = 400;

	var timeRemaining = Std.int((inst.length - Conductor.songPosition) / 1000);
	var seconds = CoolUtil.addZeros(Std.string(timeRemaining,60), 2);
	var minutes = Std.int(timeRemaining / 60);
	timeText.text = minutes + ":" + seconds;
}

function onPostCountdown(e) {
	if (![1,2,3].contains(e.swagCounter)) return;
	e.spriteTween?.cancel();

	var spr = e.sprite;
	spr.cameras = camHUD;
	spr.zoomFactor = 0;
	spr.scale.set(1.33,1.33);
	FlxTween.tween(spr, {alpha: 0}, Conductor.crochet/1000, {ease:FlxEase.cubeInOut,onComplete: () -> {
		remove(spr);
		spr.destroy();
	}});
}

function onPlayerHit(e) {
	if (e.isSustainNote) return;
	FlxTween.cancelTweensOf(infotxt,["scale.x","scale.y"]);
	infotxt.scale.set(1.075,1.075);
	FlxTween.tween(infotxt, {"scale.x":1,"scale.y":1},0.2);
}