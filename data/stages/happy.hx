import funkin.editors.charter.Charter;
import flixel.addons.display.FlxBackdrop;
var swirlo = 0;

function postCreate()
{
	for (i in cpuStrums.notes.members)
		i.noteAngle = 0;

	sky = new FlxBackdrop(Paths.image('stages/radiance/sky'), 0x11);
	sky.scale.set(2, 2);
	sky.scrollFactor.set(0.2, 0.2);
	sky.x = -600;
	sky.velocity.x = -8;
	insert(0, sky);

	sky2 = new FlxBackdrop(Paths.image('stages/radiance/sky2'), 0x11);
	sky2.scale.set(2, 2);
	sky2.scrollFactor.set(0.2, 0.2);
	sky2.x = -600;
	sky2.velocity.x = -8;
	insert(1, sky2);
	sky2.alpha = 0;

	tint = new FunkinSprite().makeSolid(48,32,0xFFffd900);
	tint.scale.set(100,100);
	tint.scrollFactor.set();
	tint.alpha = 0;
	tint.blend = 9;
	add(tint);
	//shift.uHsv = [0.5, 0, 0];

	if (PlayState.instance.chartingMode && Charter.startHere) return;
	camHUD.fade(FlxColor.BLACK, 0.001);
	new FlxTimer().start(3, ()->{camHUD.fade(FlxColor.BLACK, 5, true);});
}

function fall() {
	cpuStrums.notes.forEachAlive(function(i) {
		if (i.noteType == "fake") {
			i.noteAngle = 0;
			i.copyStrumAngle = false;
			var ang = FlxG.random.int(-10,10);
			i.updateNotesPosY = false;
			FlxTween.tween(i, {y: 2000 + i.y}, 0.9, {ease: FlxEase.backIn});
			FlxTween.tween(i.offset, {x: ang*20}, 2, {ease: FlxEase.linear});
			FlxTween.num(0, ang*3, 2, {ease: FlxEase.quadOut}, function(num) {i.angle = num;});
		}
	});
}

function sunset() {
	tint.color = 0xFFfed167;
	FlxTween.tween(sky2, {alpha: 1}, 6, {ease: FlxEase.quadInOut});
	FlxTween.num(0, 1, 6, {ease: FlxEase.quadInOut}, function(num) {tint.alpha = num*0.5;});
}

function onDadHit(e) {
	if (e.note.noteType != "fake") return;
	e.cancel();
	e.deleteNote = false;
	e.strumGlowCancelled = true;
}

function beatHit() {
	nichita.playAnim((curBeat+5) % 2);
}

function stepHit() {
	if (curStep % 2 != 0) sandra.playAnim((curBeat+6) % 2);
	annie.playAnim(Math.floor(curStep/2 + 12) % 4);
}