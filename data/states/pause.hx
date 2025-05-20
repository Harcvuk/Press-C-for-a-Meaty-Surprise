import flixel.text.FlxBitmapText;
import flixel.graphics.frames.FlxBitmapFont;
import funkin.backend.MusicBeatState;
import funkin.options.keybinds.KeybindsOptions;
import funkin.options.TreeMenu;
import funkin.options.OptionsMenu;
import funkin.editors.charter.Charter;

var zoom = 3.6;
camPause = new FlxCamera(0,0,Math.ceil(FlxG.width/zoom),Math.ceil(FlxG.height/zoom),zoom);

path = "hud/pause/";
function formatTime(ms) {
	var mins = Std.int(ms / 60000);
	var seconds = (ms % 60000) / 1000;

	var secInt = Std.int(seconds);
	var centi = Std.int((seconds - secInt) * 100);

	var secStr = (secInt < 10 ? "0" : "") + secInt;
	var centiStr = (centi < 10 ? "0" : "") + centi;

	return mins + ":" + secStr + "." + centiStr;
}

mainMenuSprites = [];
function create(e) {
	cameras = [camPause];
	e.cancel();

	camPause.bgColor = 0x80000000;
	FlxG.cameras.add(camPause,false);

	//main menu
	box = new FunkinSprite(50,21).makeSolid(262,54,0xFF010153);
	box.camera = camPause;
	add(box);

	songName = new FlxBitmapText(box.x+8,box.y+7,PlayState.SONG.meta.displayName.toUpperCase());
	score = new FlxBitmapText(box.x+24,box.y+23,"SCORE:");
	time = new FlxBitmapText(score.x,score.y+8,"TIME:");
	combo = new FlxBitmapText(score.x,time.y+8,"COMBO:");

	scoreC = new FlxBitmapText(score.x,score.y,pauseScore + " / " + maxSongScore);
	timeC = new FlxBitmapText(score.x,time.y,(songPos < 0 ? "-:--.--" : formatTime(songPos)) + " / "+ formatTime(instLength));
	comboC = new FlxBitmapText(score.x,combo.y,songCombo + " / " + maxSongCombo);

	for (txt in [songName,score,time,combo]) {
		txt.font = FlxBitmapFont.fromAngelCode("assets/fonts/srb2.png", "assets/fonts/srb2.xml");
		txt.color = 0xFFFFFF00;
		add(txt);
	}

	for (txt in [scoreC,timeC,comboC]) {
		txt.font = FlxBitmapFont.fromAngelCode("assets/fonts/srb2.png", "assets/fonts/srb2.xml");
		txt.alignment="right";
		txt.autoSize = 0;
		txt.fieldWidth = box.width-34;
		add(txt);
	}

	choices = ["CONTINUE","RETRY","OPTIONS","CONTROLS","RETURN TO TITLE",PlayState.chartingMode ? "RETURN TO CHARTER" : "QUIT GAME"];
	choiceStore = [];
	for (s => i in choices) {
		var choice = new FlxBitmapText(58,120+8*s,i,FlxBitmapFont.fromAngelCode("assets/fonts/srb2.png", "assets/fonts/srb2.xml"));
		add(choice);
		choiceStore.push(choice);
		if (s > 3) choice.y += 8;
	}
	choiceStore[0].color = 0xFFFFFF00;

	emblem = new FunkinSprite(34,120,Paths.image(path+"select"));
	add(emblem);

	for (i in [box,songName,score,time,combo,scoreC,timeC,comboC,emblem].concat(choiceStore)) mainMenuSprites.push(i);

	//title menu (easier to just use a single sprite)
	notCaring = new FunkinSprite(0,81,Paths.image(path+"notCaring"));
	CoolUtil.cameraCenter(notCaring,camPause,1);
	notCaring.visible = false;
	add(notCaring);

	//quit screen
	quitBG = new FunkinSprite().makeSolid(1,1,0xFF000052);
	quitText = new FlxBitmapText(0,0,"ege",FlxBitmapFont.fromAngelCode("assets/fonts/srb2.png", "assets/fonts/srb2.xml"));
	for (i in [quitBG,quitText]) {
		i.visible = false;
		add(i);
	}
	quitText.alignment = "center";
}

curMenu = "main";
function update() {
	if (controls.DOWN_P||controls.UP_P && curMenu == "main") changeSelection(controls.DOWN_P ? 1 : -1);
	if (controls.ACCEPT || (curMenu != "main" && FlxG.keys.justPressed.Y)) switch (curMenu) {
		case "main": choose();
		case "title":
		if (PlayState.chartingMode && Charter.undos.unsaved) {
			PlayState.instance.saveWarn(false);
			return;
		}
		PlayState.resetSongInfos();
		Charter.instance?.__clearStatics();

		FlxG.sound.music?.stop();
		FlxG.sound.music = null;

		fromIntro = true;
		FlxG.switchState(new MainMenuState());
		case "quit": window.close();
	}

	if (controls.BACK || (curMenu != "main" && FlxG.keys.justPressed.N)) switch (curMenu) {
		case "main": close();
		case "title","quit":
			for (i in mainMenuSprites) i.visible = true;
			notCaring.visible = false;
			for (i in [quitBG,quitText]) i.visible = false;
			curMenu = "main";
	}
}

curSelected = 0;
function changeSelection(amount) {
	curSelected = FlxMath.wrap(curSelected+amount,0,choiceStore.length-1);
	menuBeep();
	emblem.y = 120 + curSelected * 8;
	if (curSelected > 3) emblem.y += 8;

	for (s=> i in choiceStore) if (s == curSelected) i.color = 0xFFFFFF00; else i.color = -1;
}

function choose() switch (choices[curSelected]) {
	case "CONTINUE": close();
	case "RETRY":
		parentDisabler.reset();
		game.registerSmoothTransition();
		FlxG.resetState();
	case "OPTIONS":
		TreeMenu.lastState = PlayState;
		FlxG.switchState(new OptionsMenu());
	case "CONTROLS":
		persistentDraw = false;
		openSubState(new KeybindsOptions());
	case "RETURN TO TITLE": returnToTitle();
	case "QUIT GAME": quitGame();
	case "RETURN TO CHARTER": FlxG.switchState(new Charter(PlayState.SONG.meta.name, PlayState.difficulty, false));
}

function returnToTitle() {
	curMenu = "title";
	for (i in mainMenuSprites) i.visible = false;
	notCaring.visible = true;
}

function quitGame() {
	curMenu = "quit";
	for (i in mainMenuSprites) i.visible = false;
	for (quit in [quitBG,quitText]) quit.visible = true;

	quitText.text = FlxG.random.getObject(quitTexts) + "\n\n(Press 'Y' to quit)";
	quitText.updateHitbox();
	CoolUtil.cameraCenter(quitText,camPause);

	quitBG.scale.set(quitText.width + 24, quitText.height + 5);
	quitBG.updateHitbox();
	CoolUtil.cameraCenter(quitBG,camPause);

	quitText.y = quitBG.y + 3;
}