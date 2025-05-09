import funkin.menus.FreeplayState.FreeplaySonglist;
import funkin.savedata.FunkinSave;
songs = FreeplaySonglist.get().songs;

path = "menu/freeplay/";
function create() {
	if (FlxG.sound.music == null || !FlxG.sound.music.playing) {
		CoolUtil.playMusic(Paths.music("freakyMenu"), true, 1, true, 150);
		FlxG.sound.music.persist = true;
	}

	//background, CHOOSE PLAYER, and descriptions
	camSRB = new FlxCamera(64,0,320,200,720/200);
	FlxG.cameras.add(camSRB,false);

	//DELETE temp WHEN DONE!
	temp = new FunkinSprite(0,0,Paths.image(path+"temp"));
	temp.camera = camSRB;
	temp.alpha = 2/3;
	add(temp);

	choosePlayer = new FunkinSprite(0,8,Paths.image(path+"M_PICKP"));
	add(choosePlayer);
	choosePlayer.camera = camSRB;
	CoolUtil.cameraCenter(choosePlayer,camSRB,0x01);


	descriptionBox = new FunkinSprite(141,29).makeSolid(174,166,0xFF000052);
	descriptionBox.camera = camSRB;
	add(descriptionBox);
	descriptionBox.alpha = 0.5;

	//left side
	descriptionBox = new FunkinSprite(5,29).makeSolid(134,166,0xFF000052);
	descriptionBox.camera = camSRB;
	add(descriptionBox);

	camChars = new FlxCamera(93,115,128,160,720/200);
	FlxG.cameras.add(camChars,false);
	camChars.bgColor = 0;

	//character stuff
	for(k=>s in songs) if (s.name == Options.freeplayLastSong) curSelected = k;
	for(k=>diff in songs[curSelected]?.difficulties) if (diff == Options.freeplayLastDifficulty) curDifficulty = k;

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
	if (controls.BACK || FlxG.mouse.justPressedRight) FlxG.switchState(new MainMenuState());

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
	Options.freeplayLastDifficulty = curDifficulty;
	//trace(curSelected,songs[curSelected].name);

	for (i => icon in songIcons) {
		FlxTween.cancelTweensOf(icon);
		icon.y = 16 + (i - oldSelected) * icon.height; //forces the tween to end better than using completeTweensOf (i swear that function never works correctly)

		if (oldSelected + amount == curSelected) FlxTween.tween(icon,{y:icon.y-icon.height*amount},9/35); //linear tween if
		else icon.y = 16 + (i - curSelected) * icon.height;
	}
}

function changeDifficulty(amount) {
	FlxG.sound.play(Paths.sound("DSMENU1"));
	curDifficulty = FlxMath.wrap(curDifficulty+amount, 0, songs[curSelected].difficulties.length - 1);
}