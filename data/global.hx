import funkin.backend.utils.WindowUtils;
import funkin.backend.utils.DiscordUtil as Discord;
import funkin.menus.BetaWarningState;
import funkin.menus.credits.CreditsMain;
import lime.graphics.Image;
import haxe.crypto.Sha256;
//dev stuff delete later
import funkin.backend.scripting.GlobalScript;
import funkin.backend.assets.ModsFolder;

FlxG.save.data.seezeeSawIntro ??= false;
FlxG.save.data.MeatyunlockedSongs ??= [];

static var fromIntro = true; //for seezee to skip the intro movement if not coming from the intro

static var redirectStates:Map<Class<FlxState>, String> = [
	TitleState => "SeezeeBashIntro",
	MainMenuState => "pressCMain"
	FreeplayState => "PressCplay",
	CreditsMain => "Credits",
];

function preStateSwitch() {
	for (redirectState in redirectStates.keys())
		if (Std.isOfType(FlxG.game._requestedState, redirectState))
			FlxG.game._requestedState = new ModState(redirectStates.get(redirectState));

	var isSeezee = Sha256.encode(Discord?.user?.userId) == "dc793b1d9e78b66ad18637d9e176aadd09bf3ea96fa2dfc35553c493deda4615";
	WindowUtils.winTitle = isSeezee ? "Press C for a Meaty Surprise!! - Happy Birthday Seezee!" : "Press C for a Meaty Surprise!!";
	window.setIcon(Image.fromBytes(Assets.getBytes("images/windowIcon.png")));
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