function getNoteskin(ID) {return strumLines.members[ID].characters[0]?.xml?.get("noteskin") ?? "mario";}

function onStrumCreation(e) {
	var noteskin = getNoteskin(e.player);
	e.strum.antialiasing = false;
	e.sprite = "game/notes/"+noteskin;
}

function onNoteCreation(e) {
	var noteskin = getNoteskin(e.strumLineID);
	e.note.antialiasing = false;
	e.noteSprite = "game/notes/"+noteskin;
}