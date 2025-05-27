function getNoteskin(ID) {return strumLines.members[ID].characters[0]?.xml?.get("noteskin") ?? "default";}

function onStrumCreation(e) {
	var noteskin = getNoteskin(e.player);
	e.strum.antialiasing = false;
	e.sprite = "game/notes/"+noteskin;
	switch (noteskin) {
		case "EYAD":
			switch (e.strumID) {
				case 0: e.strum.x += 11; e.strum.y += 3.5 * (downscroll? -1 : 1);
				case 1: e.strum.x += 4;
				case 2: e.strum.x -= 3;
				case 3: e.strum.x -= 11; e.strum.y += 4 * (downscroll? -1 : 1);
			}
	}
}

function onNoteCreation(event) {
	event.cancel();

    var note = event.note;
    if (event.note.isSustainNote) {
        note.loadGraphic(Paths.image('game/notes/marioEnds'), true, 7, 6);
        note.animation.add("hold", [event.strumID]);
        note.animation.add("holdend", [4 + event.strumID]);
    } else {
        note.loadGraphic(Paths.image('game/notes/mario'), true, 17, 17);
        note.animation.add("scroll", [4 + event.strumID]);
    }
    note.scale.set(6, 6);
    note.updateHitbox();
}

function onNoteCreation(e) {
	var noteskin = getNoteskin(e.strumLineID);
	e.note.antialiasing = false;
	e.noteSprite = "game/notes/"+noteskin;
}