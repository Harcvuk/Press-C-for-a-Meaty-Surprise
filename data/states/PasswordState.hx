import flixel.ui.FlxButton;
import funkin.editors.ui.UITextBox;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import haxe.crypto.Sha256;

/*Made and Programmed by HeroEyad, Credit me if this is used
	Otherwise I will get Saul Goodman to sue you!
	that's how you do it and you can setup a background or whatever lol!
	Just make sure to add the password to the json file in the format:
		[{"password": "hashedPassword", "song": "songName", "difficulty": "hard"}] (or any other difficulty)
		And make sure to hash the password using sha256 before adding it to the varaible.
    if you're not sure what to use for Sha256 encoding just go there https://emn178.github.io/online-tools/sha256.html
 */
var source = [
	{password: "fadb68f2a094c1db2f6fa959ec350a9c51507a14ae7f2324c00b082f2493efaa", song: "tutorial", difficulty: "easy"}, // this is "coolpassword"
    {password: "a595a45d227e801a36e0905ebaacf64940baa22ba3eaed0f4fb18f406a53b603", song: "stress", difficulty: "hard"} // this is "tankman"
];

var inputKey:UITextBox;
override function create() {
	add(var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE).screenCenter(0x11));

    var grid:FlxBackdrop = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x33FFFFFF, 0x0));
    grid.velocity.set(40, 40);
    grid.scrollFactor.set(0, 0);
    add(grid);

    var text:FlxText = new FlxText(225, 150, 0, "Enter Password").setFormat(Paths.font("vcr.ttf"), 100, FlxColor.WHITE, "center");
    add(text);
    
    inputKey = new UITextBox(850, 30, "", 400, 60);
    inputKey.screenCenter(0x11);
    inputKey.x -= 200;
    add(inputKey);
    
	var buttonKey = new FlxButton(850, 450, "Enter", onButtonKey);
	buttonKey.screenCenter(0x01);
	buttonKey.scale.set(3, 3);
	add(buttonKey);

	FlxG.mouse.visible = true;
}
function update(elapsed:Float) {
	if (FlxG.keys.justPressed.ESCAPE) {
        CoolUtil.playMenuSFX(2);
		FlxG.switchState(new MainMenuState());
		FlxG.mouse.visible = false;
	}
}
function onButtonKey() {
	var enteredPassword:String = inputKey.label.text;
	var hashedEnteredPassword:String = Sha256.encode(enteredPassword);
	for (passwords in source) {
		if (hashedEnteredPassword == passwords.password) {
			CoolUtil.playMenuSFX(1);
			trace('Password correct (' + enteredPassword + ')');
			FlxG.camera.flash(FlxColor.WHITE, 0.4);
			FlxG.mouse.visible = false;
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