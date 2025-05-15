import flixel.text.FlxTextBorderStyle as Border;
import flixel.addons.effects.FlxTrail as Trail;
import EReg;

var names = [
	"HeroEyad: Director and Programmer of Press C for headache",
	"TechyHarcvuk: Director and Made everything for Meaty Surprise",
	"Bitto: Programmer and Charter, Made \"headache-ok\"",
	"mariofy: 3D-Modeler and Animator",
	"Gumbalino: 3D-Modeler and Animator",
	"Hipix: Artist and Animator",
	"douyhe: Composer",
	"Verwex: Birthday Bash invitation",
	"Terionic: Code assistance",
	"Happy Birthday Seezee!"
];

var colors = [
	0xFF00FFFF,
	0xFFFF8000,
	0xFFFF0000,
	0xFF33BB33,
	0xFFAA33DD,
	0xFFFFCC33,
	0xFF0088FF,
	0xFF9933EE,
	0xFF66EE44
];

var credits = [];
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
	for (i in 0...names.length) {
		var text = new FlxText(0, (FlxG.height + 100) + i * spacing, FlxG.width, names[i]).setFormat(Paths.font("sonic2.ttf"), 32, colors[i] ?? 0xFFFFFF00, "center",Border.SHADOW,0xFF000000).screenCenter(0x01); // center horizontally
		text.borderSize *= 2;
		text.y = FlxG.height + 50 + i * spacing;
		add(text);
		credits.push(text);

		FlxTween.tween(text, {y: (FlxG.height / 2 - (names.length * spacing) / 2 + i * spacing)+110}, 1.5, {startDelay: i * 0.15, ease: FlxEase.expoOut});
	}
	credits[credits.length-1].scale.set(2,2);
	credits[credits.length-1].updateHitbox();
	credits[credits.length-1].screenCenter(0x01);
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
				members.remove(i);
				i.destroy();
			}
		}});
	}

	if (FlxG.keys.justPressed.C && canC) {
		canC = false;
		var cFlash = new FunkinSprite(0,0,Paths.image("C"));
		cFlash.camera = camCredits;
		CoolUtil.setSpriteSize(cFlash,1280,720);
		add(cFlash);
		FlxTween.tween(cFlash,{alpha:0},1);
		FlxG.sound.play(Paths.sound("C"));
		FlxG.sound.music.volume = 0;
		new FlxTimer().start(4,() -> FlxG.sound.music.fadeOut(2,1));

		for (credit in credits) {
			credit.text = new EReg("[A-Z]","g").replace(credit.text,"C");
			credit.text = new EReg("[a-z]","g").replace(credit.text,"c");
		}
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

		FlxTween.tween(letter,{y:FlxG.height},10,{onComplete: () -> {
			for (i in [trail,letter]) {
				remove(i);
				members.remove(i);
				i.destroy();
			}
			for (credit in credits) {
				credit.text = new EReg("[A-Z]","g").replace(credit.text,"C");
				credit.text = new EReg("[a-z]","g").replace(credit.text,"c");
			}
		}});
	}
}
