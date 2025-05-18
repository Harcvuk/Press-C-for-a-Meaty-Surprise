import flixel.addons.display.FlxBackdrop;
function create() {
	bg = new FlxBackdrop(Paths.image("stages/wood zone/SKY64"));
	insert(0,bg);
	bg.scrollFactor.set(0.8,0.8);
}

function postCreate() camNoteOffset = 2;