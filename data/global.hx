import Date;
import funkin.backend.utils.WindowUtils;
import funkin.backend.utils.DiscordUtil as Discord;
import funkin.menus.credits.CreditsMain;
import lime.graphics.Image;
import haxe.crypto.Sha256;
//dev stuff delete later
import funkin.backend.scripting.GlobalScript;
import funkin.backend.assets.ModsFolder;

FlxG.save.data.seezeeSawIntro ??= false;
FlxG.save.data.MeatyunlockedSongs ??= [];

static var fromIntro = true; //for seezee to skip the intro movement if not coming from the intro
static var ultimate = false;

var d = Date.now(); // Now.

function new() {
	ultimate = false;
}

static var redirectStates:Map<Class<FlxState>, String> = [
	TitleState => "SeezeeBashIntro",
	MainMenuState => "pressCMain"
	FreeplayState => "PressCplay",
	CreditsMain => "Credits",
];

static var quitTexts = []; //importScript wasnt working for the pause screen so im putting it here
function preStateSwitch() {
	for (redirectState in redirectStates.keys())
		if (Std.isOfType(FlxG.game._requestedState, redirectState))
			FlxG.game._requestedState = new ModState(redirectStates.get(redirectState));

	var isSeezee = Sha256.encode(Discord?.user?.userId) == "dc793b1d9e78b66ad18637d9e176aadd09bf3ea96fa2dfc35553c493deda4615";
	WindowUtils.winTitle = (d.getMonth() == 4 && d.getDate() == 25 && isSeezee) ? "Press C for a Meaty Surprise!! - Happy Birthday Seezee!" : "Press C for a Meaty Surprise!!";
	window.setIcon(Image.fromBytes(Assets.getBytes("images/windowIcon.png")));

	quitTexts = [
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
		"If you're gonna leave, wanna play SSF32?",
		"HeroEyad is trying to\nconnect your computer!",
		"wanna hop on rocket league",
		"im gay. EYAD «",
		"EYAD\nEYAD\nEYAD\n«",
		"Eat my Meat",
		"you should press c\nif you want to get to the password state",
		"Are you stupid that's Pluto\nOOOOH",
		"It was way more quitter than I thought",
		"Meat",
		"Is there an option to mol-"
	];
}

//actually reload the global script by pressing ctrl f5 (dev stuff delete later)
function update(elapsed) if (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.F5) {
	trace("reloading global script");
	GlobalScript.onModSwitch(ModsFolder.currentModFolder);
}

static var exitSound:FlxSound;
static function menuBeep() {
	exitSound = new FlxSound().loadEmbedded(Paths.sound("DSMENU1"), false, false);
	exitSound.persist = true;
	exitSound.play();
}