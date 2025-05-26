function plop() puddle.playAnim("plop",true);

function superPlop() {
	boyfriend.alpha = gf.alpha = 0;
	plop();
	camGame.scroll.set(970,870);
	camGame.followLerp = camHUD.alpha = 0;
}