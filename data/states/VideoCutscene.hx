public static var camSubstateGlobal:FlxCamera = null;

function onClosePost() {
	FlxG.cameras.remove(camSubstateGlobal, true);

	borderItUp(camGlobal, true);
}

function postCreate() {
	//Setup a Substate Global Camera
	camSubstateGlobal = new FlxCamera();
	camSubstateGlobal.bgColor = 0;

	FlxG.cameras.add(camSubstateGlobal, false);


	if (PlayState.instance != null) genPopcornTransition(camSubstateGlobal);
}

function update(elapsed) {
	if (skippable && video.position > 0 && (controls.ACCEPT || FlxG.mouse.justPressed)) video.onEndReached.dispatch();

	if (!FlxG.state.persistentDraw && video.position > 0) FlxG.state.persistentDraw = true;
}

function update(elapsed) {
	if (FlxG.keys.pressed.F5) {
	trace("Sorry, you can't reload during this cutscene.");

	}

}