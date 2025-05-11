import funkin.editors.ui.UIState as UI;

function postUpdate() {
	if (FlxG.keys.justPressed.C) FlxG.switchState(new UI(true, "PasswordState")); // i love github mobile.
}