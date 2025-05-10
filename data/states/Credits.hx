import flixel.text.FlxTextBorderStyle as Border;
import flixel.addons.effects.FlxTrail as Trail;

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

var credits:Array<FlxText> = [];
var logo:FunkinSprite;

function create() {
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
var matrixLetters = ["S","e","z","Z"];
function update(elapsed) {
	if (controls.BACK || FlxG.mouse.justPressedRight) FlxG.switchState(new MainMenuState());

	timings += elapsed;
	if (timings >= 0.25) {
		timings -= 0.25;

		var number = new FlxText();
		number.text =  FlxG.random.getObject(matrixLetters);
		number.scale.set(2,2);
		number.updateHitbox();
		number.setPosition(FlxG.random.int(-1,128)*10,-number.height);
		number.color = FlxG.random.getObject(matrixColors);
		insert(0,number);

		var trail = new Trail(number, null, 20, 10, 0.4, 0.05);
		insert(0,trail);

		FlxTween.tween(number,{y:FlxG.height*3},FlxG.random.int(6,30),{onComplete: () -> {
			for (i in [trail,number]) {
				remove(i);
				members.remove(i);
				i.destroy();
			}
		}});


	}
}
