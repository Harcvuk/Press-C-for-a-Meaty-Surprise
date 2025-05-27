import flixel.FlxSprite;

camPause = new FlxCamera();
var open = FlxG.sound.load(Paths.sound("mcpause/select"));

boxes = [];
text = [];

var curSelected:Int = 0;

function create(e) {
    cameras = [camPause];
    e.cancel();

    camPause.bgColor = 0x80000000;
	FlxG.cameras.add(camPause,false);

    add(temp=new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK)).alpha = 0.5;

    for (s => ev in menuItems) {
        var offset = 195+(s * 50);
        var box:FlxSprite = new FlxSprite(500, offset).loadGraphic(Paths.image('hud/mcpause/button_unhighlited'));
        box.setGraphicSize(Std.int(box.width * 2.05));
        box.screenCenter(0x01);
        boxes.push(box);
        add(box);
    
        var options = ["Resume", "Restart", "Change Controls", "Options", "Exit"]; // for now
        var nin:FlxText = new FlxText(500, offset-5, 0, options[s], 16).setFormat(Paths.font("minecraft.ttf"), 24, FlxColor.WHITE, "center");
        nin.screenCenter(0x01);
        add(nin);
        text.push(nin);

    }
}

function update() {
    if (controls.ACCEPT) selectOption();
    if (controls.UP_P || controls.DOWN_P) changeSelection(controls.UP_P ? -1 : 1);
}   

function changeSelection(c) {
    curSelected = FlxMath.wrap(curSelected + c, 0, menuItems.length - 1);
    trace(curSelected);
}