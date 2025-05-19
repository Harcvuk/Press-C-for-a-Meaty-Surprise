import flixel.text.FlxBitmapText;
import flixel.graphics.frames.FlxBitmapFont;
import funkin.backend.MusicBeatState;
import funkin.backend.utils.DiscordUtil as Discord;
import funkin.options.keybinds.KeybindsOptions;
import funkin.options.TreeMenu;
import funkin.options.OptionsMenu;
import funkin.editors.charter.Charter;

var zoom = 3.6;
camPause = new FlxCamera(0,0,Math.ceil(FlxG.width/zoom),Math.ceil(FlxG.height/zoom),zoom);

path = "hud/pause/";
function formatTime(ms) {
	var mins = Std.int(ms / 60000);
	var seconds = (ms % 60000) / 1000;

	var secInt = Std.int(seconds);
	var centi = Std.int((seconds - secInt) * 100);

	var secStr = (secInt < 10 ? "0" : "") + secInt;
	var centiStr = (centi < 10 ? "0" : "") + centi;

	return mins + ":" + secStr + "." + centiStr;
}

function create(e) {
	cameras = [camPause];
	e.cancel();

	camPause.bgColor = 0x80000000;
	FlxG.cameras.add(camPause,false);

	box = new FunkinSprite(50,21).makeSolid(262,54,0xFF010153);
	box.camera = camPause;
	add(box);

	songName = new FlxBitmapText(box.x+8,box.y+7,PlayState.SONG.meta.displayName.toUpperCase());
	score = new FlxBitmapText(box.x+24,box.y+23,"SCORE:");
	time = new FlxBitmapText(score.x,score.y+8,"TIME:");
	combo = new FlxBitmapText(score.x,time.y+8,"COMBO:");

	scoreC = new FlxBitmapText(score.x,score.y,pauseScore + " / " + maxSongScore);
	timeC = new FlxBitmapText(score.x,time.y,(songPos < 0 ? "-:--.--" : formatTime(songPos)) + " / "+ formatTime(instLength));
	comboC = new FlxBitmapText(score.x,combo.y,songCombo + " / " + maxSongCombo);

	for (txt in [songName,score,time,combo]) {
		txt.font = FlxBitmapFont.fromAngelCode("assets/fonts/srb2.png", "assets/fonts/srb2.xml");
		txt.color = 0xFFFFFF00;
		add(txt);
	}

	for (txt in [scoreC,timeC,comboC]) {
		txt.font = FlxBitmapFont.fromAngelCode("assets/fonts/srb2.png", "assets/fonts/srb2.xml");
		txt.alignment="right";
		txt.autoSize = 0;
		txt.fieldWidth = box.width-34;
		add(txt);
	}

	choices = ["CONTINUE","RETRY","OPTIONS","CONTROLS","RETURN TO TITLE",PlayState.chartingMode ? "RETURN TO CHARTER" : "QUIT GAME"];
	choiceStore = [];
	for (s => i in choices) {
		var choice = new FlxBitmapText(58,120+8*s,i,FlxBitmapFont.fromAngelCode("assets/fonts/srb2.png", "assets/fonts/srb2.xml"));
		add(choice);
		choiceStore.push(choice);
		if (s > 3) choice.y += 8;
	}
	choiceStore[0].color = 0xFFFFFF00;

	emblem = new FunkinSprite(34,120,Paths.image(path+"select"));
	add(emblem);
}

curMenu = "main";
function update() {
	if (controls.DOWN_P||controls.UP_P && curMenu == "main") changeSelection(controls.DOWN_P ? 1 : -1);
	if (controls.ACCEPT) switch (curMenu) {
		case "main": choose();
		case "title":
			fromIntro = true;
			//FlxG.switchState(new MainMenuState());
		case "quit":
			//wip
	}
}

curSelected = 0;
function changeSelection(amount) {
	curSelected = FlxMath.wrap(curSelected+amount,0,choiceStore.length-1);
	menuBeep();
	emblem.y = 120 + curSelected * 8;
	if (curSelected > 3) emblem.y += 8;

	for (s=> i in choiceStore) if (s == curSelected) i.color = 0xFFFFFF00; else i.color = -1;
}

function choose() switch (choices[curSelected]) {
	case "CONTINUE": close();
	case "RETRY":
		parentDisabler.reset();
		game.registerSmoothTransition();
		FlxG.resetState();
	case "OPTIONS":
		TreeMenu.lastState = PlayState;
		FlxG.switchState(new OptionsMenu());
	case "CONTROLS":
		persistentDraw = false;
		openSubState(new KeybindsOptions());
	case "RETURN TO TITLE": returnToTitle();
	case "QUIT GAME":
	case "RETURN TO CHARTER": FlxG.switchState(new Charter(PlayState.SONG.meta.name, PlayState.difficulty, false));
}

function returnToTitle() {
	curMenu = "title";

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