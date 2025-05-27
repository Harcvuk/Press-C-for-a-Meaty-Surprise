// Settings
starAmount = 6; //amount of stars (6 by default)
imgPath = "HUD/2eaked/star"; //graphic ("HUD/2eaked/star" by default)
memleaksound = "bumper"; //sound for "memory leak" ("bumper" by default)

//-------------------------DON'T CHANGE ANYTHING PAST THIS LINE-------------------------//
tueakedSickColor = FlxG.save.data.tueakedSickColor;
tueakedSickType = FlxG.save.data.tueakedSickType;
stars = []; //temp star storage
spinSpeed = 5; // speed of the spiral animation

function onPlayerHit(e) {
	e.showSplash = false; //no need for the original sicks
	if (e.note.isSustainNote || e.rating != "sick") return; //dont bother

	var randCol = (FlxColor.fromHSB(FlxG.random.float(0, 360), FlxG.random.float(0.7, 1), FlxG.random.float(0.8, 1)));
	var starStore = [];
	var firstColor = FlxG.random.int(0,1);
	for (i in 0...starAmount) {
		var star = new FunkinSprite(0,0,Paths.image(imgPath));
		formatStar(star,e);
		star.color = switch (tueakedSickColor) {
			case "char": CoolUtil.getColorFromDynamic((e.character.xml.get("sCol" + (((i+firstColor) % 2) + 1))) ?? e.character.iconColor); //use the xml "sCol"s (icon color if null)
			case "random": star.color = (FlxColor.fromHSB(FlxG.random.float(0, 360), FlxG.random.float(0.7, 1), FlxG.random.float(0.8, 1)));
			default: randCol;
		}

		starStore.push(star);
		stars.push(star);
	}

	var randDeviate = FlxG.random.int(-3,3)/(Math.PI/2);
	for (s => star in starStore) switch (tueakedSickType) {
		case "spiral":
			star.angle = ((360/starAmount)*s) + (randDeviate*15); //star spacing
			var time = (Conductor.crochet/800); //1.25
			star.angularVelocity = -360 * (spinSpeed/3);
			FlxTween.tween(star.scale,{x:0,y:0}, time / (spinSpeed/3), {ease: FlxEase.circIn, onComplete: () -> {
				stars.remove(star);
				remove(star); star.destroy();
			}});
		case "splash":
			var spacing = (2*Math.PI / starAmount) * s ; //star spacing: (2PI/starAmount) degrees apart for starAmount stars
			var radius = star.width * 2; //explosion radius
			var targetX = star.x + Math.cos(spacing+randDeviate) * radius;
			var targetY = star.y + Math.sin(spacing+randDeviate) * radius;
			var time = (Conductor.stepCrochet/1000)*2.5;

			star.angle = FlxG.random.float(-30,30);
			FlxTween.tween(star,{x:targetX,y: targetY}, time, {ease: FlxEase.quadOut});
			FlxTween.tween(star.scale,{x:0,y:0}, time, {ease: FlxEase.backIn, onComplete: () -> {
				stars.remove(star);
				remove(star); star.destroy();
			}});
		case "memleak":
			var angle = FlxG.random.float(0, (2*Math.PI)); //random angle in radians
			var speed = FlxG.random.float(50, 300);
			star.velocity.x = Math.cos(angle) * speed;
			star.velocity.y = Math.sin(angle) * speed;
			star.angle = FlxG.random.float(0, 360);
			star.angularVelocity = FlxG.random.float(50, 300) * FlxG.random.sign();
	}
}

function formatStar(star,e) {
	CoolUtil.setSpriteSize(star,30,30); //all images must be the same size
	star.camera = camHUD;
	star.moves = true;

	//center of the note
	star.x = e.note.__strum.x + (e.note.__strum.width / 2) - (star.width / 2);
	star.y = e.note.__strum.y + (e.note.__strum.height / 2) - (star.height / 2);

	insert(members.indexOf(splashHandler),star);
}

var lesMissables = ["Missable Note","Unpressable Note","Note that makes you huh"];
function onPlayerMiss(e) {
	if (!FlxG.save.data.tueakedMissStar || (lesMissables.contains(e.noteType))) return;
	var star = new FunkinSprite(0,0,Paths.image(imgPath));
	formatStar(star,e);
	star.color = 0x505050;
	star.acceleration.y = 1000;
	star.velocity.y = -200;
	star.velocity.x = FlxG.random.int(15,30)*FlxG.random.sign();
	star.angle = -90 + star.velocity.x;

	FlxTween.tween(star.scale,{x:0,y:0},0.5,{startDelay:0.75,onComplete: () -> {remove(star); star.destroy();}});
}

function bump(thing) {
	var bmper = FlxG.sound.load(Paths.sound(memleaksound));
	bmper.volume = 0.3;
	bmper.pitch = FlxG.random.float(0.95, 1/0.95);
	bmper.pan = (thing.x/625)-1;
	bmper.play();
}

function postUpdate(elapsed) for (star in stars) switch (tueakedSickType) {
	case "spiral":
		var radiansAngle = star.angle * Math.PI / 180;
		var movement = spinSpeed*60*elapsed;
		star.x += Math.sin(radiansAngle) * movement;
		star.y += Math.cos(radiansAngle) * movement;
	case "memleak":
		var maxX = FlxG.width - star.width;
		var maxY = FlxG.height - star.height;
		if (star.x < 0 || star.x > maxX) {
			star.x = FlxMath.bound(star.x, 0, maxX);
			star.velocity.x *= -1;
			bump(star);
		}
		if (star.y < 0 || star.y > maxY) {
			star.y = FlxMath.bound(star.y, 0, maxY);
			star.velocity.y *= -1;
			bump(star);
		}
}
