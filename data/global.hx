import funkin.backend.utils.WindowUtils;
import funkin.backend.utils.DiscordUtil as Discord;
import funkin.menus.BetaWarningState;
import funkin.menus.credits.CreditsMain;
//dev stuff delete later
import funkin.backend.scripting.GlobalScript;
import funkin.backend.assets.ModsFolder;

FlxG.save.data.seezeeSawIntro ??= false;

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

	// if the player is offline lol
	if (Discord.user != null) WindowUtils.winTitle = (Discord.user.userId == "457176118110191617") ? "Press C for a Meaty Surprise!! - Happy Birthday Seezee!" : "Press C for a Meaty Surprise!!";
}

//actually reload the global script by pressing ctrl f5 (dev stuff delete later)
function update(elapsed) if (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.F5) {
	trace("reloading global script");
	GlobalScript.onModSwitch(ModsFolder.currentModFolder);
}