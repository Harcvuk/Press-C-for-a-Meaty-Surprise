import funkin.savedata.FunkinSave;
import flixel.text.FlxBitmapText;
import flixel.graphics.frames.FlxBitmapFont;
import funkin.backend.MusicBeatState;
import funkin.menus.FreeplayState.FreeplaySonglist;
songs = FreeplaySonglist.get().songs;

path = "game/menus/freeplay/";
function create() {
	if (FlxG.sound.music == null || !FlxG.sound.music.playing) {
		CoolUtil.playMusic(Paths.music("freakyMenu"), true, 1, true, 150);
		FlxG.sound.music.persist = true;
	}

	//character stuff (important to be first)
	for(k=>s in songs) if (s.name == Options.freeplayLastSong) curSelected = k;
	for(k=>diff in songs[curSelected]?.difficulties) if (diff == Options.freeplayLastDifficulty) curDifficulty = k;

	//background, CHOOSE PLAYER, and descriptions
	camSRB = new FlxCamera(64,0,320,200,720/200);
	FlxG.cameras.add(camSRB,false);

	choosePlayer = new FunkinSprite(0,8,Paths.image(path+"M_PICKP"));
	add(choosePlayer);
	choosePlayer.camera = camSRB;
	CoolUtil.cameraCenter(choosePlayer,camSRB,0x01);

	//description
	descriptionBox = new FunkinSprite(141,29).makeSolid(174,166,0xFF000052);
	descriptionBox.camera = camSRB;
	add(descriptionBox);

	makeTexties();

	score = new FlxBitmapText(146,121,"Score:",FlxBitmapFont.fromAngelCode("assets/fonts/srb2.png", "assets/fonts/srb2.xml"));
	score.camera = camSRB;
	score.color = 0xFFFFFF00;
	add(score);

	scoreText = new FlxBitmapText(score.x+score.width-2,score.y,"ee",FlxBitmapFont.fromAngelCode("assets/fonts/srb2.png", "assets/fonts/srb2.xml"));
	scoreText.camera = camSRB;
	add(scoreText);

	difficulty = new FlxBitmapText(score.x,score.y+8,"Difficulty:",FlxBitmapFont.fromAngelCode("assets/fonts/srb2.png", "assets/fonts/srb2.xml"));
	difficulty.camera = camSRB;
	difficulty.color = 0xFFFFFF00;
	add(difficulty);

	difficultyText = new FlxBitmapText(difficulty.x+difficulty.width-2,difficulty.y,"ee",FlxBitmapFont.fromAngelCode("assets/fonts/srb2.png", "assets/fonts/srb2.xml"));
	difficultyText.camera = camSRB;
	add(difficultyText);

	getSaveStuff();

	//left side
	charBox = new FunkinSprite(5,29).makeSolid(134,166,0xFF000052);
	charBox.camera = camSRB;
	add(charBox);

	camChars = new FlxCamera(93,115,128,160,720/200);
	FlxG.cameras.add(camChars,false);
	camChars.bgColor = 0;

	songIcons = [];
	for (i => song in songs) {
		var songIcon = new FunkinSprite();
		var iconPath = Paths.getPath("songs/"+song.name+"/icon.png");
		if (Assets.exists(iconPath)) songIcon.loadGraphic(iconPath);
		else songIcon.loadGraphic(Paths.image(path+"icon"));
		songIcon.camera = camChars;
		CoolUtil.cameraCenter(songIcon,camChars);
		songIcon.y += i*songIcon.height;
		add(songIcon);
		songIcons.push(songIcon);

		songIcon.y -= curSelected*songIcon.height;
	}
}

curSelected = 0;
curDifficulty = 0;
function update() {
	if (controls.BACK || FlxG.mouse.justPressedRight) {
		MusicBeatState.skipTransOut = MusicBeatState.skipTransIn = true;
		FlxG.switchState(new MainMenuState());
	}

	if (controls.UP_P || controls.DOWN_P) changeSelection(controls.UP_P ? -1 : 1);
	if (controls.RIGHT_P || controls.LEFT_P) changeDifficulty(controls.RIGHT_P ? 1 : -1);
	if (FlxG.mouse.wheel != 0) changeSelection(-FlxG.mouse.wheel);

	if (controls.ACCEPT || FlxG.mouse.justPressed) {
		PlayState.loadSong(songs[curSelected].name, songs[curSelected].difficulties[curDifficulty]);
		FlxG.switchState(new PlayState());
	}
}

function changeSelection(amount) {
	FlxG.sound.play(Paths.sound("DSMENU1"));
	var oldSelected = curSelected;

	curSelected = FlxMath.wrap(curSelected + amount, 0, songs.length - 1);
	Options.freeplayLastSong = songs[curSelected].name;
	if (curDifficulty > songs[curSelected].difficulties.length-1) curDifficulty = 0;
	Options.freeplayLastDifficulty = curDifficulty;
	//trace(curSelected,songs[curSelected].name);

	for (i => icon in songIcons) {
		FlxTween.cancelTweensOf(icon);
		icon.y = 16 + (i - oldSelected) * icon.height; //forces the tween to end better than using completeTweensOf (i swear that function never works correctly)

		if (oldSelected + amount == curSelected) FlxTween.tween(icon,{y:icon.y-icon.height*amount},9/35); //linear tween if
		else icon.y = 16 + (i - curSelected) * icon.height;
	}

	makeTexties();
	getSaveStuff();
}

function changeDifficulty(amount) {
	FlxG.sound.play(Paths.sound("DSMENU1"));
	curDifficulty = FlxMath.wrap(curDifficulty+amount, 0, songs[curSelected].difficulties.length - 1);
	getSaveStuff();
}

var descriptiones = [];
function makeTexties() {
	for (i in descriptiones) {
		remove(i);
		i.destroy();
	}
	var descPath = "songs/" + songs[curSelected].name + "/desc.txt";
	var descText = Assets.exists(Paths.getPath(descPath)) ? StringTools.replace(Assets.getText(Paths.getPath(descPath)),"\\n","\n") : "no desc";
	var startX = 146;
	var startY = 33;
	var lineHeight = 8;
	var lines = descText.split("\n");
	for (i => line in lines) {
		var parts = line.split("¨");
		var curX = startX;


		for (j => part in parts) {
			if (part.length == 0) continue;

			if (j % 2 == 1 && j > 0 && StringTools.endsWith(parts[j-1]," ")) part = " " + part;

			var desc = new FlxBitmapText();
			desc.font = FlxBitmapFont.fromAngelCode("assets/fonts/srb2.png", "assets/fonts/srb2.xml");
			desc.color = (j % 2 == 1) ? 0xFFFFFF00 : -1;
			desc.text = part;
			desc.setPosition(curX,startY + i * lineHeight);
			desc.camera = camSRB;
			add(desc);
			descriptiones.push(desc);

			curX += desc.width-2;
		}
	}
}

function getSaveStuff() {
	var songScore = FunkinSave.getSongHighscore(songs[curSelected].name, songs[curSelected].difficulties[curDifficulty]).score;
	scoreText.text = songScore;

	difficultyText.text = songs[curSelected].difficulties.length > 1 ? "<" + songs[curSelected].difficulties[curDifficulty] + ">" : songs[curSelected].difficulties[curDifficulty];
}