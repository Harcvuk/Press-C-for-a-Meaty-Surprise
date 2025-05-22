function getNoteskin(ID) {return strumLines.members[ID].characters[0]?.xml?.get("noteskin") ?? "default";}

function onStrumCreation(e) {
	var noteskin = getNoteskin(e.player);
	e.strum.antialiasing = false;
	e.sprite = "game/notes/"+noteskin;
	switch (noteskin) {
		case "mario":
			e.strum.x += 10;
			e.strum.y += 10;
		case "EYAD":
			switch (e.strumID) {
				case 0: e.strum.x += 11; e.strum.y += 3.5 * (downscroll? -1 : 1);
				case 1: e.strum.x += 4;
				case 2: e.strum.x -= 3;
				case 3: e.strum.x -= 11; e.strum.y += 4 * (downscroll? -1 : 1);
			}
	}
}

function onNoteCreation(e) {
	var noteskin = getNoteskin(e.strumLineID);
	e.note.antialiasing = false;
	e.noteSprite = "game/notes/"+noteskin;
}