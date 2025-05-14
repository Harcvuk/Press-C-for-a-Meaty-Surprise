function plop() puddle.playAnim("plop",true);

function superPlop() {
	boyfriend.alpha = 0;
	gf.alpha = 0;
	plop();
	camGame.scroll.set(970,870);
	camGame.followLerp = 0;
	camHUD.alpha = 0;
}