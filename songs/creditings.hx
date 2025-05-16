import flixel.addons.display.FlxBackdrop;
import haxe.Json;
import flixel.text.FlxTextBorderStyle as Border;

//credits
creditsPre = "songs/" + curSong + "/credits";

var path = "hud/credits/";
var camCredits = new FlxCamera();
function postCreate() {

	FlxG.cameras.add(camCredits,false);
	camCredits.bgColor = 0;

	creditsGroup = new FlxSpriteGroup();
	creditsGroup.camera = camCredits;
	creditsGroup.alpha = 0;

	topbar = new FlxBackdrop(Paths.image(path+"top"),0x01);
	bottombar = new FlxBackdrop(Paths.image(path+"bottom"),0x01);
	for (s => bar in [topbar,bottombar]) {
		bar.velocity.x = -50*(2*s-1);
		bar.y = 300*s;
		creditsGroup.add(bar);
	}

	middle = new FunkinSprite(0,topbar.height).makeSolid(FlxG.width,300-bottombar.height,0x8000FF80);
	creditsGroup.add(middle);

	creditsGroup.screenCenter(0x10);
	add(creditsGroup);

	var cFont = Paths.font(PlayState.SONG.meta.customValues?.creditsFont ?? "modernDOS.ttf");
	var cOutline = Reflect.field(Border,PlayState.SONG.meta.customValues?.creditsOutline ?? "OUTLINE");

	songName = new FlxText(0,0,FlxG.width/2,PlayState.SONG.meta.displayName);
	songName.setFormat(cFont,50,0xFF007F00,"center",cOutline,0xFF000000);
	songName.borderSize = 2;
	songName.y = creditsGroup.height/2 - songName.height/2 - 40;
	creditsGroup.add(songName);

	var theComposer = PlayState.SONG.meta.customValues?.composer ?? "Someone";
	byWho = new FlxText(0,0,FlxG.width/2,"By: " + theComposer);
	byWho.setFormat(cFont,45,0xFF007F00,"center",cOutline,0xFF000000);
	byWho.borderSize = 2;
	byWho.y = creditsGroup.height/2 - byWho.height/2 + 40;
	creditsGroup.add(byWho);


	var creditsPath = Paths.getPath((Assets.exists(Paths.getPath(creditsPre + "-" + PlayState.difficulty + ".txt")) ? creditsPre + "-" + PlayState.difficulty : creditsPre)+".txt");
	var extraCredits = Assets.exists(creditsPath) ? Assets.getText(creditsPath) : "you forgot the credits\nmoron";
	miscCredits = new FlxText(FlxG.width/2,0,FlxG.width/2,extraCredits);
	miscCredits.setFormat(cFont,40,0xFF005F00,"center",cOutline,0xFF000000);
	miscCredits.borderSize = 2;
	miscCredits.y = creditsGroup.height/2 - miscCredits.height/2;
	creditsGroup.add(miscCredits);
}

var active = false;
function creditings(time) {
	if (time == "") time = 2;
	active = !active;

	FlxTween.tween(creditsGroup,{alpha:active},(Conductor.crochet/1000)*time);
}

function update() camCredits.zoom = camHUD.zoom;