import flixel.addons.display.FlxBackdrop as BG;
import funkin.options.OptionsMenu;
import funkin.menus.credits.CreditsMain;
import funkin.menus.ModSwitchMenu;
import funkin.editors.EditorPicker;
import flixel.text.FlxBitmapText;
import flixel.graphics.frames.FlxBitmapFont;
import funkin.editors.ui.UIState as UI;
import funkin.backend.MusicBeatState;
import funkin.backend.utils.DiscordUtil as Discord;
import flixel.input.keyboard.FlxKey;

var ultimateSequences = [
	[FlxKey.U, FlxKey.L, FlxKey.T, FlxKey.I, FlxKey.M, FlxKey.A, FlxKey.T, FlxKey.E,]
];
var userInput = [];

var path = "game/menus/mainMenu/";
function create() {
	if (FlxG.sound.music == null || !FlxG.sound.music.playing) {
		CoolUtil.playMusic(Paths.music("freakyMenu"), true, 1, true, 150);
		FlxG.sound.music.persist = true;
	}
	FlxG.sound.music.volume = FlxG.sound.music.pitch = 1;

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

	seezee = new FunkinSprite(0,0,Paths.image(path+"TTSZ"));
	seezee.scale.set(3.6,3.6);
	seezee.updateHitbox();
	seezee.screenCenter();
	seezee.x += 22;
	seezee.y -= 118;
	seezee.addAnim("pop","pop",2,false);
	seezee.addAnim("wag","wag",2,true);
	if (fromIntro) new FlxTimer().start(32/35, () -> {
		add(seezee);
		add(sonic);
		seezee.playAnim("pop");
		seezee.animation.finishCallback = () -> seezee.playAnim("wag");
	});
	else {
		add(seezee);
		add(sonic);
		seezee.playAnim("wag");
	}

	//choices menu
	camMenu = new FlxCamera(0,0,FlxG.width/3.6+1,FlxG.height/3.6,3.6);
	FlxG.cameras.add(camMenu,false);
	camMenu.alpha = 0;
	camMenu.bgColor = 0x80000000;

	versionText = new FlxBitmapText(0,0,"v1.0",FlxBitmapFont.fromAngelCode("assets/fonts/tnyfnt.png", "assets/fonts/tnyfnt.xml"));
	versionText.setPosition(2,camMenu.height-versionText.height);
	versionText.alpha = 0.5;
	versionText.camera = camMenu;
	add(versionText);

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

	quitBG = new FunkinSprite().makeSolid(1,1,0xFF000052);
	quitText = new FlxBitmapText(0,0,"ege",FlxBitmapFont.fromAngelCode("assets/fonts/srb2.png", "assets/fonts/srb2.xml"));
	for (i in [quitBG,quitText]) {
		i.camera = camMenu;
		add(i);
		i.visible = false;
	}
	quitText.alignment = "center";

	quitSecret = new FunkinSprite(0,0);
	quitSecret.camera = camMenu;
	add(quitSecret);
	quitSecret.visible = false;
	quitSecret.scale.set(0.5,0.5);

	if (fromIntro == false) {
		curSelected = 0;
		for (s => i in menuOptions) i.color = s == curSelected ? 0xFFFFFF00 : -1;
		menuing = true;
		camMenu.alpha = 1;
	}
	fromIntro = false;
}

var controlLock = false;
var menuing = false;
var quitting = false;
function update() {
	if (controlLock) return;
	var accept = (controls.ACCEPT || FlxG.mouse.justPressed);
	var back = (controls.BACK || FlxG.mouse.justPressedRight);

	if (FlxG.keys.justPressed.ANY && ((FlxG.keys.firstJustPressed() <= 90 && FlxG.keys.firstJustPressed() >= 65) || (FlxG.keys.firstJustPressed() <= 57 && FlxG.keys.firstJustPressed() >= 48))) { //check for numbers and letters, by character ID
		userInput.push(FlxG.keys.firstJustPressed());
		checkSequence();
	}

	if (accept) if (!menuing) {
		curSelected = 0;
		for (s => i in menuOptions) i.color = s == curSelected ? 0xFFFFFF00 : -1;
		menuing = true;
		camMenu.alpha = 1;
	} else {
		menuBeep();
		switch (menuNames[curSelected]) {
			case "1 PLAYER":
				MusicBeatState.skipTransOut = MusicBeatState.skipTransIn = true;
				FlxG.switchState(new FreeplayState());
			case "OPTIONS": FlxG.switchState(new OptionsMenu());
			case "CREDITS": FlxG.switchState(new CreditsMain());
			case "C": randomMeat();
			case "QUIT GAME":
				for (option in menuOptions) option.visible = false;
				for (quit in [quitBG,quitText]) quit.visible = true;
				randomizeQuit();
				new FlxTimer().start(0, () -> quitting = true); //1 frame of delay so you actually get to see the quit message
		}
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

	if (quitting) {
		if (back || FlxG.keys.justPressed.N) {
			quitting = quitSecret.visible = false;
			for (option in menuOptions) option.visible = true;
			for (quit in [quitBG,quitText]) quit.visible = false;
		}
		if ((accept || FlxG.keys.justPressed.Y) && imageCounter == 0) {
			randomMeatSound();
			controlLock = true;
			var quitScreen = new FunkinSprite(0,0,Paths.image(path+"GAMEQUIT"+(FlxG.random.bool(20) ? "ALT" : "")));
			quitScreen.camera = camMenu;
			camMenu.bgColor = 0xFF171717;
			CoolUtil.cameraCenter(quitScreen,camMenu);
			add(quitScreen);
			new FlxTimer().start(2,() -> window.close());
		}
		return;
	}
	if (menuing) {
		if (controls.UP_P || controls.DOWN_P) changeSelection(controls.UP_P ? -1 : 1);
		if (FlxG.mouse.wheel != 0) changeSelection(-FlxG.mouse.wheel);
		if (back) {
			menuing = false;
			camMenu.alpha = 0;
		}
	} else if (back) FlxG.switchState(new TitleState());
}

function checkSequence() {
	var tempSeqs = ultimateSequences;

	//Filter all temporary sequences based on keys pressed in order
	for (k=>key in userInput) {
		tempSeqs = tempSeqs.filter(x -> key == x[k]);

		if (tempSeqs.length == 0) { //Reset it all if nothing matches
			userInput = [];
			return;
		}
	}

	//Then check if all the available sequences match length, since filtering above will take care of what keystrokes are pressed anyways
	for (i in tempSeqs) {
		if (i.length == userInput.length) {
			ultimate = !ultimate;
			userInput = [];
		}
	}
}

var curSelected = 0;
function changeSelection(amount) {
	menuBeep();
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
chosenMeat = -1;
timesMeated = 0;

function randomMeat() {
	chosenMeat = FlxG.random.int(0,meats.length-1,[chosenMeat]);
	meatImage.loadGraphic(Paths.image("meat/"+meats[chosenMeat]));
	meatImage.camera = camMenu;
	add(meatImage);
	CoolUtil.setSpriteSize(meatImage,camMenu.width,camMenu.height);
	FlxTween.cancelTweensOf(meatImage);
	meatImage.alpha = 1;
	FlxTween.tween(meatImage,{alpha:0},1,{ease:FlxEase.circIn});

	randomMeatSound();

	timesMeated++;
	versionText.text = "v"+(1+timesMeated/10);
	trace(timesMeated);
	if (timesMeated > 199) {
		FlxG.sound.music.volume = 0;
		controlLock = true;
		new FlxTimer().start(Math.max(0.1-((timesMeated-199)/1000),1/240),() -> randomMeat());

		if (timesMeated > 499) {
			MusicBeatState.skipTransOut = MusicBeatState.skipTransIn = true;
			FlxG.resetState();
		}

	}

}

function randomMeatSound() {
	var meat = FlxG.sound.load(FlxG.random.bool(10) ? Paths.sound("rareMeat/"+FlxG.random.getObject(rareMeatSounds)) : Paths.sound("meat/"+FlxG.random.getObject(meatSounds)));
	meat.pitch = FlxG.random.float(0.8,1.25) + (timesMeated < 201 ? 0 : (timesMeated-199)/100);
	meat.play();
	if (timesMeated < 199) {
		FlxG.sound.music.volume = 0.25;
		FlxTween.cancelTweensOf(FlxG.sound.music);
		FlxTween.tween(FlxG.sound.music,{volume:1},0.5);
	}
}

function postUpdate() {
	if (FlxG.keys.justPressed.C) FlxG.switchState(new UI(true, "PasswordState")); // i love github mobile.
}

var quitTexts = [
	//edits of the original quit messages
	"Safestman's tied explosives\nto your freinds, and\nwill activate them if\nyou press the 'Y' key!\nPress 'N' to save them!",
	"What would Holly say if\nshe saw you quitting the game?",
	"Hey!\nWhere do ya think you're goin'?",
	"Forget your studies!\nPlay some more!",
	"You're trying to say you\nlike Bob Tweaked better than\nthis, right?",
	"Don't leave yet -- there's a\nsarmale around that corner!",
	"You'd rather work than play?",
	"Go ahead and leave. See if I care...\n*sniffle*",
	"If you leave now,\nEge will take over the planet!",
	"Don't quit!\nThere are headaches\nto have!",
	"Aw c'mon, just change\na few more clothes!",
	"Did you get all those Chaos Emeralds?",
	"If you leave, I'll use\nmy nin attack on you!",
	"Don't go!\nYou might find the hidden\nsongs!",
	"Hit the 'N' key, "+ (Discord?.user?.globalName ?? "Sonic") +"!\nThe 'N' key!",
	"Are you really going to give up?\nWe certainly would never give you up.",
	"Come on, just ONE more headache!",
	"Press 'N' to unlock\nthe Ultimate Cheat!",
	"Why don't you go back and try\nwriting on that password state to\nsee what happens?",
	"Every time you press 'Y', a\nMeater cries...",
	"You'll be back to play soon, though...\n......right?",
	"Aww, is Headache-ok too\ndifficult for you?",
	//ok these are original
	(Discord?.user?.globalName ?? "GARY").toUpperCase() + " THERES A BOMB!!!!",
	"Press 'N' to get 1 PYRAMILLION dirhams!",
	"Heh.\nRoom for 94 more?",
	"Wet it be, John.\n or I'll get meaty.",
	"Ouuugh I'm peaking\n Peaking so hard mnnng",
	"It's so fucking hot\n out here help me",
	"Did you beat it?\n Not the meat, the game.",
	"cmon "+ (Discord?.user?.globalName ?? "man").toLowerCase() + "\njust one more " + (Discord?.user?.globalName ?? "man").toLowerCase() + " pls",
	"You're not who i'm looking for..",
	"\n#####\npluto",
	"Press Y and I'll make you regret it all.",
	"Im going to birthday\nbash your fucking skull in",
	"Rolling for dog?\nI love gambling.",
	"(Press 'N' to cancel)",
	"Are you sure",
	"If you're gonna leave, wanna play ssf32?",
	"HeroEyad is trying to connect your computer!",
	"wanna hop on rocket league",
	"im gay. EYAD «",
	"EYAD\nEYAD\nEYAD\n«",
	"Eat my Meat",
	"you should press c\nif you want to get to the password state",
	"Are you stupid that's Pluto\nOOOOH",
	"It was way more..",
	"Meat"
];

var imageCounter = 0;
function randomizeQuit() {
	if (FlxG.random.bool(100/256) || imageCounter > 0) {
		imageCounter++;
		quitSecret.visible = true;

		quitSecret.loadSprite(Paths.image(path+"quitImgs/"+imageCounter));
		quitSecret.updateHitbox();
		CoolUtil.cameraCenter(quitSecret,camMenu);
  quitBG.scale.set(quitSecret.width + 24, quitSecret.height + 24);
		quitBG.updateHitbox();
		CoolUtil.cameraCenter(quitBG,camMenu);

		quitText.visible = false;

		if (imageCounter == 3) {
			var staticSound = FlxG.sound.load(Paths.sound("dog/static"));
			staticSound.volume = 0;
			staticSound.play();
			staticSound.fadeOut(5,1);
			controlLock = true;
			FlxTween.tween(FlxG.sound.music,{"pitch":0},5,{ease:FlxEase.sineOut, onComplete: () -> FlxG.sound.music.volume = 0});
			FlxTween.tween(sky,{"velocity.x":0},5,{ease:FlxEase.sineOut});
			var windowNF = FlxG.sound.load(Paths.sound("dog/window95"));
			new FlxTimer().start(7,() -> {
				windowNF.play();
				staticSound.fadeOut(1,0);
			});
			FlxTween.tween(window,{opacity:0},windowNF.length/1000,{startDelay:7, onComplete: () -> window.close()});
		}
		return;
	}
	quitText.visible = true;
	quitText.text = FlxG.random.getObject(quitTexts) + "\n\n(Press 'Y' to quit)";
	quitText.updateHitbox();
	CoolUtil.cameraCenter(quitText,camMenu);

 quitBG.scale.set(quitText.width + 24, quitText.height + 5);
	quitBG.updateHitbox();
	CoolUtil.cameraCenter(quitBG,camMenu);

	quitText.y = quitBG.y + 3;
}

function preUpdate() if (imageCounter == 3 && FlxG.keys.pressed.F5) window.close();
