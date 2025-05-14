import flixel.text.FlxTextBorderStyle as Border;
var byed = false;
var eyadY = 0;
var eyad = dad;

function postCreate() {
	eyadY = eyad.y;

	eyeOfRa = new FunkinSprite(0,0,Paths.image("Explosioneffectgreenscreen"));
	eyeOfRa.addAnim("ra","ra",24,false);
	sparkles = new FunkinSprite(0,0,Paths.image("HDGreenScreenStarDustEffect"));
	sparkles.addAnim("sparkle","sparkle",24,false);
	for (i in [eyeOfRa,sparkles]) {
		i.addAnim("no","no",24,false);
		i.camera = camHUD;
		insert(0,i);
		i.playAnim("no");
		i.setGraphicSize(FlxG.width,FlxG.height);
		i.screenCenter();
	}

	eyadText = new FunkinText(0,0,FlxG.width,"D");
	eyadText.camera = camHUD;
	eyadText.screenCenter(0x10);
	eyadText.setFormat(Paths.font("vcr.ttf"), 120, -1, "center",Border.OUTLINE,0xFF000000);
	eyadText.borderSize *= 10;
	add(eyadText);
	eyadText.x = -eyadText.width;
}

function goodbye() {
	FlxTween.cancelTweensOf(eyad);
	if (!byed) FlxTween.tween(eyad,{y:eyad.y-1000},Conductor.crochet/1000,{ease:FlxEase.expoIn});
	else eyad.y = eyadY;
	byed = !byed;
}

function ra() {
	eyad.playAnim("eye of ad",true,false,0,"LOCK");
	eyeOfRa.playAnim("ra",true);
	camGame.scroll.set(-104,500);
	camGame.followLerp = 0;
}

function gong() eyeOfRa.playAnim("ra",true);
function sparkle() sparkles.playAnim("sparkle",true);
function bye() {
	gf.moves = true;
	gf.velocity.x = 500;
	gf.playAnim("walk",true,false,0,"LOCK");
}

var colour = 0;
function DJEYAD(what) {
	eyadText.text = what;
	switch (what) {
		case "D","DJ":
			FlxTween.cancelTweensOf(eyadText);
			eyadText.x = -eyadText.width/2;
			FlxTween.tween(eyadText,{x:0},1,{ease:FlxEase.circOut});
		case "DJ EYAD IS HERE","EYAD IS HERE!":
			var c = eyadText.colorTransform;
			c.redOffset = c.greenOffset = c.blueOffset = 100;
			FlxTween.cancelTweensOf(eyadText);
			FlxTween.tween(eyadText,{"colorTransform.redOffset":0,"colorTransform.greenOffset":0,"colorTransform.blueOffset":0},1,{ease:FlxEase.circOut});
			if (what == "EYAD IS HERE!") {
				eyadText.color = FlxColor.fromHSB(colour, 1, 1);
				colour += 72;
			}
		case "die": remove(eyadText);
	}
}

function eyadTextKill() {
	eyadText.moves = true;
	var fall = downscroll ? -eyadText.height - 500 : FlxG.height+500;
	FlxTween.tween(eyadText,{y:eyadText.y - 100 * (-downscroll*2+1)},1.5,{ease:FlxEase.expoOut}).then(FlxTween.tween(eyadText,{y:fall},1.5,{ease:FlxEase.expoIn}));
	FlxTween.tween(eyadText,{"scale.x":2,"scale.y":2,angle:30},3,{ease:FlxEase.circOut});
}