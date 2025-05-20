function onPlayerMiss(e) {
	var anim = e.character.animation.curAnim.name;
	if (anim.substr(anim.length-4,anim.length) == "miss") {
		e.cancelAnim();
		e.character.debugMode = true;
	}
}

function onNoteHit(e) if (e.character.curCharacter == "appleblurt") e.character.debugMode = false;

function postCreate() if (PlayState.difficulty == "D_") boyfriend.visible = false;