function postCreate() {
    switch (curBeat) {
        case 0:
        player.characters[1].visible = false;
        player.characters[0].visible = true;
        case 84:
        player.characters[1].visible = true;
        player.characters[0].visible = false;
} 
}