function postCreate() {
    missesTxt.destroy();
    healthBar.visible = healthBarBG.visible = iconP1.visible = iconP2.visible = false;
}

function onPlayerMiss(event) if (ultimate) health = (2 << 5) * -1;