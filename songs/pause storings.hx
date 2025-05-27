static var instLength:Float; //for pause substate
static var pauseScore:Float;
static var songCombo:Float;
static var maxSongScore:Float;
maxSongCombo = maxSongScore = 0;

function postCreate() {
	instLength = inst.length;
}

function postUpdate() {
	pauseScore = songScore;
	songCombo = combo;
}

static var maxSongCombo:Float = 0;
function onPostNoteCreation(e) {
	if (e.strumLineID != 1 || e.note.isSustainNote) return;
	maxSongCombo++;
	maxSongScore = maxSongCombo * 300;
}