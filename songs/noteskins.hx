function getNoteskin(ID) {return strumLines.members[ID].characters[0]?.xml?.get("noteskin") ?? "default";}

function onStrumCreation(e) {
	var noteskin = getNoteskin(e.player);
	if (noteskin == "mario") {
		e.cancel();

		e.strum.antialiasing = false;
		var strum = e.strum;
		strum.loadGraphic(Paths.image('game/notes/mario'), true, 17, 17);
		strum.animation.add("static", [e.strumID]);
		strum.animation.add("pressed", [4 + e.strumID, 8 + e.strumID], 12, false);
		strum.animation.add("confirm", [12 + e.strumID, 16 + e.strumID], 24, false);

		strum.scale.set(6, 6);
		strum.updateHitbox();
		return;
	}
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

function onNoteCreation(e) {
	var noteskin = getNoteskin(e.strumLineID);
	if (noteskin == "mario") {
		e.cancel();

		var note = e.note;
		if (e.note.isSustainNote) {
			note.loadGraphic(Paths.image('game/notes/marioEnds'), true, 7, 6);
			note.animation.add("hold", [e.strumID]);
			note.animation.add("holdend", [4 + e.strumID]);
		} else {
			note.loadGraphic(Paths.image('game/notes/mario'), true, 17, 17);
			note.animation.add("scroll", [4 + e.strumID]);
		}
		note.scale.set(6, 6);
		note.updateHitbox();
		return;
	}
	e.note.antialiasing = false;
	e.noteSprite = "game/notes/"+noteskin;
}