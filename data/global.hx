import funkin.backend.utils.WindowUtils;
//dev stuff delete later
import funkin.backend.scripting.GlobalScript;
import funkin.backend.assets.ModsFolder;
import funkin.backend.utils.DiscordUtil as Discord;
import funkin.menus.BetaWarningState as Beta;


Discord.user.userId == "457176118110191617" ? WindowUtils.winTitle = "Press C for a Meaty Surprise!! - Happy Birthday Seezee!" : WindowUtils.winTitle = "Press C for a Meaty Surprise!!";

var redirectStates:Map<FlxState, String> = [
	Beta => "SeezeeBashIntro", // Existing class => New Class yes
	FreeplayState => "PressCplay"
];
function preStateSwitch() {
	for (redirectState in redirectStates.keys())
		if (Std.isOfType(FlxG.game._requestedState, redirectState) && Assets.exists(Paths.script("data/states/"+redirectStates.get(redirectState))))
			FlxG.game._requestedState = new ModState(redirectStates.get(redirectState));

}

//actually reload the global script by pressing ctrl f5 (dev stuff delete later)
function update(elapsed) if (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.F5) {
	trace("reloading global script");
	GlobalScript.onModSwitch(ModsFolder.currentModFolder);
}
