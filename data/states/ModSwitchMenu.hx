function create() {
	camera = camMenu = new FlxCamera();
	camMenu.bgColor = 0;
	FlxG.cameras.add(camMenu, false);
}
function destroy() FlxG.cameras.remove(camMenu);