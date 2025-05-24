import flixel.text.FlxTextBorderStyle as Border;
import flixel.addons.effects.FlxTrail as Trail;
import EReg;
import funkin.backend.utils.WindowUtils;
import funkin.backend.utils.DiscordUtil as Discord;
import haxe.crypto.Sha256;

var credits = [
	{text:"TechyHarcvuk: Director and Artist/Composer/etc. of his own songs",color:0xFFFF8000},
	{text:"HeroEyad: Director and Programmer",color:0xFF00FFFF},
	{text:"Bitto: Composer, Programmer and Charter",color:0xFFFF0000},
	{text:"mariofy: 3D-Modeler and Animator",color:0xFF33BB33},
	{text:"Gumbalino: 3D-Modeler and Animator",color:0xFFAA33DD},
	{text:"Hipix and Douyhe: were there (they couldnt do their things in time for v1)",color:0xFF0088FF},
{text:"Kittycass: Composer (replace if she doesnt get it done in time)",color:0xFFCC8888},
	{text:"Verwex: Birthday Bash invitation",color:0xFF9933EE},
	{text:"Terionic: Code assistance",color:0xFF66EE44},
	{text:"Happy Birthday Seezee!"}
];

var creditTextSprites = [];
function create() {
	FlxG.sound.music.volume = 1;
	camCredits = new FlxCamera();
	FlxG.cameras.add(camCredits);
	camCredits.bgColor = 0xFF002211;

	logo = new FunkinSprite(0, -200, Paths.image("logo"));
	logo.scale.set(0.1, 0.1);
	logo.screenCenter(0x01);
	logo.angle = 90;
	FlxTween.tween(logo, {y:-35, angle:0, "scale.x":0.8, "scale.y":0.8}, 2, {ease: FlxEase.circOut});
	add(logo);

	var spacing = 40;
	for (i in 0...credits.length) {
		var text = new FlxText(0, (FlxG.height + 100) + i * spacing, FlxG.width, credits[i].text).setFormat(Paths.font("sonic2.ttf"), 32, credits[i].color ?? 0xFFFFFF00, "center",Border.SHADOW,0xFF000000).screenCenter(0x01); // center horizontally
		text.borderSize *= 2;
		text.y = FlxG.height + 50 + i * spacing;
		add(text);
		creditTextSprites.push(text);

		FlxTween.tween(text, {y: (FlxG.height / 2 - (credits.length * spacing) / 2 + i * spacing)+110}, 1.5, {startDelay: i * 0.15, ease: FlxEase.expoOut});
	}
	creditTextSprites[credits.length-1].scale.set(2,2);
	creditTextSprites[credits.length-1].updateHitbox();
	creditTextSprites[credits.length-1].screenCenter(0x01);
}

var timings = 0.25;
var matrixColors = [0xFF245724,0xFF1E661E,0xFF008600];
var matrixLetters = ["S","s","z","Z","c","C"];
var canC = true;
function update(elapsed) {
	if (controls.BACK || FlxG.mouse.justPressedRight) FlxG.switchState(new MainMenuState());

	timings += elapsed;
	if (timings >= 0.25) {
		timings -= 0.25;

		var letter = new FlxText();
		letter.text =  FlxG.random.getObject(matrixLetters);
		letter.scale.set(2,2);
		letter.updateHitbox();
		letter.setPosition(FlxG.random.int(-1,128)*10,-letter.height);
		letter.color = FlxG.random.getObject(matrixColors);
		insert(0,letter);

		var trail = new Trail(letter, null, 20, 10, 0.4, 0.05);
		insert(0,trail);

		FlxTween.tween(letter,{y:FlxG.height*3},FlxG.random.int(6,30),{onComplete: () -> {
			for (i in [trail,letter]) {
				remove(i);
				i.destroy();
			}
		}});
	}

	if (FlxG.keys.justPressed.C && canC) {
		canC = false;
		Main.framerateSprite.codenameBuildField.text = "Cccccccc Cccccc " + cificator(Main.releaseCycle) + "\nCccccc " + cificator(engine.commit) + " (" + cificator(engine.hash) + ")";
		var isSeezee = Sha256.encode(Discord?.user?.userId) == "dc793b1d9e78b66ad18637d9e176aadd09bf3ea96fa2dfc35553c493deda4615";
		WindowUtils.winTitle = isSeezee ? "Ccccc C ccc c Ccccc Cccccccc!! - Ccccc Cccccccc Cccccc!" : "Ccccc C ccc c Ccccc Cccccccc!!";
		logo.loadSprite(Paths.image("logoC94"));
		var cFlash = new FunkinSprite(0,0,Paths.image("C"));
		cFlash.camera = camCredits;
		CoolUtil.setSpriteSize(cFlash,1280,720);
		add(cFlash);
		FlxTween.tween(cFlash,{alpha:0},1);
		FlxG.sound.play(Paths.sound("C"));
		FlxG.sound.music.volume = 0;

		for (credit in creditTextSprites) credit.text = cificator(credit.text);
		matrixLetters = ["c","C"];

		var letter = new FlxText();
		letter.text = "C";
		letter.scale.set(100,100);
		letter.updateHitbox();
		letter.screenCenter(0x01);
		letter.y = -letter.height+350;
		letter.color = 0xFF00FF00;
		insert(0,letter);

		var trail = new Trail(letter, null, 20, 10, 0.4, 0.05);
		insert(0,trail);

		FlxTween.tween(letter,{y:FlxG.height},10,{onComplete: () -> for (i in [trail,letter]) {
			remove(i);
			i.destroy();
		}});

		var si = FlxG.sound.load(Paths.sound("si si si"));
		si.play();
		si.pitch = 1/4;
		FlxTween.tween(si,{pitch:4},15);
		si.onComplete = () -> FlxG.sound.music.fadeOut(2,1);
	}
}

function destroy() {
	Main.framerateSprite.codenameBuildField.text = "Codename Engine " + Main.releaseCycle + "\nCommit " + engine.commit + " (" + engine.hash + ")";
}

function cificator(string) {
	var temp = string;
	string = new EReg("[A-Z]","g").replace(string,"C");
	string = new EReg("[a-z]","g").replace(string,"c");

	return string;
}