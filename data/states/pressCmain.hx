import flixel.addons.display.FlxBackdrop as BG;
import funkin.options.OptionsMenu;
import funkin.menus.credits.CreditsMain;
import funkin.menus.ModSwitchMenu;
import funkin.editors.EditorPicker;
import flixel.text.FlxBitmapText;
import flixel.graphics.frames.FlxBitmapFont;

var path = "game/menus/mainMenu/";
function create() {
	if (FlxG.sound.music == null || !FlxG.sound.music.playing) {
		CoolUtil.playMusic(Paths.music("freakyMenu"), true, 1, true, 150);
		FlxG.sound.music.persist = true;
	}

	//MAIN
	sky = new BG(Paths.image(path+"TITLESKY"),0x01);
	CoolUtil.setSpriteSize(sky,(FlxG.height/200)*sky.width,FlxG.height);
	sky.velocity.x = 5*35*3.6; //5pps at 35fps, 3.6 to account for scale difference
	add(sky);

	wing = new FunkinSprite(0,0,Paths.image(path+"TTWING"));
	wing.scale.set(3.6,3.6);
	wing.updateHitbox();
	wing.screenCenter();
	add(wing);

	sonic = new FunkinSprite(0,0,Paths.image(path+"TTCOVER"));
	sonic.scale.set(3.6,3.6);
	sonic.updateHitbox();
	sonic.screenCenter();

	seezee = new FunkinSprite(0,0,Paths.image(path+"TTSONIC"));
	seezee.scale.set(3.6,3.6);
	seezee.updateHitbox();
	seezee.screenCenter();
	seezee.x += 63;
	seezee.y -= 112;
	seezee.addAnim("pop","pop",2,false);
	seezee.addAnim("wag","wag",2,true);
	new FlxTimer().start(32/35, () -> {
		add(seezee);
		add(sonic);
		seezee.playAnim("pop");
		seezee.animation.finishCallback = () -> {
			remove(sonic);
			seezee.playAnim("wag");
		}
	});

	//choices menu
	camMenu = new FlxCamera(0,0,FlxG.width/3.6,FlxG.height/3.6,3.6);
	FlxG.cameras.add(camMenu,false);
	camMenu.alpha = 0;
	camMenu.bgColor = 0x80000000;

	menuNames = ["1 PLAYER","OPTIONS","CREDITS","C","QUIT GAME"];
	menuOptions = [];
	for (s => option in menuNames) {
		var option = new FlxBitmapText(0,158+s*8,option,FlxBitmapFont.fromAngelCode("assets/fonts/srb2.png", "assets/fonts/srb2.xml"));
		CoolUtil.cameraCenter(option,camMenu,0x01);
		option.camera = camMenu;
		menuOptions.push(option);
		add(option);
	}
	menuOptions[0].color = 0xFFFFFF00;
}

var menuing = false;
function update() {

	if (controls.ACCEPT || FlxG.mouse.justPressed) if (!menuing) {
		curSelected = 0;
		for (s => i in menuOptions) i.color = s == curSelected ? 0xFFFFFF00 : -1;
		menuing = true;
		camMenu.alpha = 1;
	} else switch (menuNames[curSelected]) {
		case "1 PLAYER": FlxG.switchState(new FreeplayState());
		case "OPTIONS": FlxG.switchState(new OptionsMenu());
		case "CREDITS": FlxG.switchState(new CreditsMain());
		case "C": randomMeat();
		case "QUIT GAME": window.close();
	}

	if (controls.BACK || FlxG.mouse.justPressedRight) if (!menuing) FlxG.switchState(new TitleState()); //temporary
	else {
		menuing = false;
		camMenu.alpha = 0;
	}

	if (controls.SWITCHMOD) {
		openSubState(new ModSwitchMenu());
		persistentUpdate = false;
		persistentDraw = true;
	}

	if (FlxG.keys.justPressed.SEVEN) {
		persistentUpdate = false;
		persistentDraw = true;
		openSubState(new EditorPicker());
	}

	if (!menuing) return;
	if (controls.UP_P || controls.DOWN_P) changeSelection(controls.UP_P ? -1 : 1);
	if (FlxG.mouse.wheel != 0) changeSelection(-FlxG.mouse.wheel);
}

var curSelected = 0;
function changeSelection(amount) {
	FlxG.sound.play(Paths.sound("DSMENU1"));
	curSelected = FlxMath.wrap(curSelected + amount, 0, menuOptions.length - 1);
	for (s => i in menuOptions) i.color = s == curSelected ? 0xFFFFFF00 : -1;
}

var meats = [];
for (meat in Paths.getFolderContent("images/meat/")) meats.push(meat.substr(0,meat.length-4));

var meatSounds = [];
for (meat in Paths.getFolderContent("sounds/meat/")) meatSounds.push(meat.substr(0,meat.length-4));
var rareMeatSounds = [];
for (meat in Paths.getFolderContent("sounds/rareMeat/")) rareMeatSounds.push(meat.substr(0,meat.length-4));
var meatImage = new FunkinSprite();
function randomMeat() {
	meatImage.loadGraphic(Paths.image("meat/"+FlxG.random.getObject(meats)));
	meatImage.camera = camMenu;
	add(meatImage);
	CoolUtil.setSpriteSize(meatImage,camMenu.width,camMenu.height);
	FlxTween.cancelTweensOf(meatImage);
	meatImage.alpha = 1;
	FlxTween.tween(meatImage,{alpha:0},1,{ease:FlxEase.circIn});

	if (FlxG.random.bool(10)) FlxG.sound.play(Paths.sound("rareMeat/"+FlxG.random.getObject(rareMeatSounds)));
	else FlxG.sound.play(Paths.sound("meat/"+FlxG.random.getObject(meatSounds)));
	FlxG.sound.music.volume = 0.25;
	FlxTween.cancelTweensOf(FlxG.sound.music);
	FlxTween.tween(FlxG.sound.music,{volume:1},0.5);
}