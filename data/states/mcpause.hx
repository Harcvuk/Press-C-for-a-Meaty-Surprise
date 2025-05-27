import funkin.backend.Conductor;
import funkin.menus.PauseSubState;
import funkin.game.PlayState;
import flixel.text.FlxTextBorderStyle;
var open = FlxG.sound.load(Paths.sound("mcpause/select"));

function create(e) {
	boxes = new FlxGroup();
	grpText = new FlxGroup();
	textCam = new FlxCamera();
    textCam.bgColor = 0x80000000;
    
	// add(temp=new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK)).alpha = 0.5;
	var i = 0;
    for(e in menuItems) {
        var offset = 252+(i * 50);
        var box:FlxSprite = new FlxSprite(500, offset).loadGraphic(Paths.image('hud/mcpause/button_unhighlited'));
        box.setGraphicSize(Std.int(box.width * 2.05));
        box.screenCenter(0x01);
		box.camera = textCam;
        boxes.add(box);
        add(box);
    
        var nin:FlxText = new FlxText(500, offset-4, 0, e, 16).setFormat(Paths.font("minecraft.ttf"), 20, FlxColor.WHITE, "center", FlxTextBorderStyle.SHADOW, FlxColor.BLACK);
		nin.borderSize = 2;
        nin.borderColor = 0x99000000;
		nin.screenCenter(0x01);
		nin.camera = textCam;
        grpText.add(nin);
		i++;
	}
	
	add(grpText);
}

function onChangeItem(){
	var ok = 'hud/mcpause/button_';
	FlxG.sound.play(open);
	new FlxTimer().start(0.01, ()->{
		for(e in boxes.members)
			e.loadGraphic(Paths.image(ok+'unhighlited'));

		boxes.members[curSelected].loadGraphic(Paths.image(ok+'highlighted'));
	});
}

function destroy()
	FlxG.cameras.remove(textCam, false);

function postCreate()
{
	FlxG.cameras.add(textCam, false);
	FlxTween.num(0, 0.5, 5, {}, function(num) {pauseMusic.volume = num;});
	for (i=>item in grpMenuShit.members)
		item.visible = false;
		
	for (label in [levelInfo, levelDifficulty, deathCounter, multiplayerText])
		label.visible = false;
}