function getNoteskin(ID) {return strumLines.members[ID].characters[0]?.xml?.get("noteskin") ?? "default";}

function onStrumCreation(e) {
	var noteskin = getNoteskin(e.player);
	e.strum.antialiasing = false;
	e.sprite = "game/notes/"+noteskin;
	if (noteskin == "mario") {
		e.strum.x += 10;
		e.strum.y += 10;
	}
}

function onNoteCreation(e) {
	var noteskin = getNoteskin(e.strumLineID);
	e.note.antialiasing = false;
	e.noteSprite = "game/notes/"+noteskin;
}