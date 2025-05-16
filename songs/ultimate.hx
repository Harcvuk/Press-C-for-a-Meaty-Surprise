function postCreate() {
	if (!ultimate) return;
	missesTxt.destroy();
	healthBar.visible = healthBarBG.visible = iconP1.visible = iconP2.visible = false;
}

function onPlayerMiss(event) if (ultimate) health = -1;