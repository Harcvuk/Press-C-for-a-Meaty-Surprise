if (PlayState.SONG.meta.customValues?.lockCam) disableScript();

function postCreate() {
	camGame.followLerp = 1;
	camGame.zoom = defaultCamZoom;
}

function onSongStart() camGame.followLerp = 0.04;

//camera movement per note
public var camNoteOffset = 25;
public var extraCamOffset = FlxPoint.get(0,0);
function onCameraMove(e) {
	var char = e.strumLine.characters[0];
	if (char.animation.curAnim == null) return;

	var anim = char.animation.curAnim.name.substring(4);
	switch (true) {
		case StringTools.startsWith(anim, "UP"): e.position.y -= camNoteOffset;
		case StringTools.startsWith(anim, "DOWN"): e.position.y += camNoteOffset;
		case StringTools.startsWith(anim, "LEFT"): e.position.x -= camNoteOffset;
		case StringTools.startsWith(anim, "RIGHT"): e.position.x += camNoteOffset;
	}
	e.position.x += extraCamOffset.x;
	e.position.y += extraCamOffset.y;
}