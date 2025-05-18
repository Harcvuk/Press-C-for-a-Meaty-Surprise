import flixel.ui.FlxButton;
import funkin.editors.ui.UITextBox;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import haxe.crypto.Sha256;
import flixel.text.FlxTextBorderStyle as Border;


var source = [
	{password: "a84f08c5ab6d3b28ddea1fd4c56e957a98cac426f65863dfdf93e29048e36a37", song: "my-new-cookings", difficulty: "hard"}, // this is "cookings"
	{password: "8b1131e107b88a5acbef97b6cecc18a74b9f57fc110dd7523b5b85bc2967aaaa", song: "wanna play real life", difficulty: "Real"}, // this is "real life"
	{password: "dc9f28b12dd1818ee42ffc92ecb940386214598837348d30d3c6c0b7b57e34c9", song: "peakingtrial", difficulty: "Peak"},  // this is "fire"
];  {password: "59888a40ad3be41833d56b3ba1d96e40256389f583dd80d6be0a93171151b62f", song: "too-peak", difficulty: "hard"} // this is "spooks"

var inputKey:UITextBox;
function create() {
	add(var bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE).screenCenter(0x11));

	var grid = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, FlxColor.fromRGB(1,74,44), FlxColor.fromRGB(0,114,39)));
	grid.velocity.set(40, 40);
	grid.scrollFactor.set(0, 0);
	add(grid);

	text = new FlxText(0, 150, 1280, "PASSWORD SCRIPT!!!!!!!!!").setFormat(Paths.font("vcr.ttf"), 80, FlxColor.WHITE, "center");
	text.setFormat(Paths.font("vcr.ttf"), 80, -1, "center",Border.OUTLINE,0xFF000000);
	text.borderSize *= 3;

	add(text);

	inputKey = new UITextBox(850, 30, "", 400, 60);
	inputKey.screenCenter(0x11);
	inputKey.x -= 200;
	add(inputKey);

	var buttonKey = new FlxButton(850, 450, "Enter", onButtonKey);
	buttonKey.screenCenter(0x01);
	buttonKey.scale.set(3, 3);
	add(buttonKey);
}
function update(elapsed:Float) {
	if (FlxG.keys.justPressed.ESCAPE) {
		CoolUtil.playMenuSFX(2);
		FlxG.switchState(new MainMenuState());
	}
}

function onButtonKey() {
	var enteredPassword = inputKey.label.text;
	var hashedEnteredPassword = Sha256.encode(enteredPassword);
	for (passwords in source) {
		if (hashedEnteredPassword == passwords.password) {
			CoolUtil.playMenuSFX(1);
			trace('Password correct (' + enteredPassword + ')');
			FlxG.camera.flash(FlxColor.WHITE, 0.4);
			if (!FlxG.save.data.MeatyunlockedSongs.contains(passwords.song)) FlxG.save.data.MeatyunlockedSongs.push(passwords.song);
			else trace("song already unlocked idk why you went back here");
			new FlxTimer().start(0.85, function(tmr:FlxTimer) {
				PlayState.loadSong(passwords.song, passwords.difficulty);
				FlxG.switchState(new PlayState());
			});
			return;
		}
	}
	CoolUtil.playMenuSFX(2);
	trace('Incorrect password (' + enteredPassword + ')');
}

var color = 0;
function postUpdate(elapsed) {
	color = FlxMath.wrap(color+3,0,360);
	text.color = FlxColor.fromHSB(color, 1, 1);
}