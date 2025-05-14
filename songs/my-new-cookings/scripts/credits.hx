//almost exact recreation of the credits.lua from vs eydooogaming
var whomadeit = "HeroEyad";
var icon = "eyad";
var color = 0xFFFFFF;

function postCreate() {

	icon = new FunkinSprite(5,125,Paths.image("icons/"+icon));
	icon.scale.set(0.8,0.8);
	icon.camera = camHUD;
	icon.alpha = 0;
	add(icon);

	whomadeit = new FunkinText(125,175,0,"Made by: "+whomadeit);
	whomadeit.size = 30;
	whomadeit.borderColor = 0x80FFFFFF;
	whomadeit.borderSize = 30;
	whomadeit.camera = camHUD;
	whomadeit.alpha = 0;
	add(whomadeit);

	for (z in [whomadeit,icon]) FlxTween.tween(z,{alpha:1},1.5,{ease:FlxEase.quartInOut});
}

function beatHit() {
	//the original tried tweening "whoamadeit" instead of "whomadeit", lol
	//also dont ask what the fuck this modulo operation is doing here im just copying - Bitto
	if (curBeat % 16 == 8) FlxTween.tween(icon,{alpha:0},1.5,{ease:FlxEase.quartInOut});
}