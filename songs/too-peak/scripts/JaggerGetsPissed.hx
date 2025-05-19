function postCreate() player.characters[1].visible = false;
function swapJaggers() for (i in [player.characters[1],player.characters[0]]) i.visible = !i.visible;