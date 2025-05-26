import flixel.FlxSprite;

camPause = new FlxCamera();
var open = FlxG.sound.load(Paths.sound("mcpause/select"));

function create(e) {
    cameras = [camPause];
    e.cancel();

    camPause.bgColor = 0x80000000;
	FlxG.cameras.add(camPause,false);

    temp=new FunkinSprite(0,0,Paths.image("hud/mcpause/temp"));
    temp.alpha=0.5;
    add(temp);

    playButton = new FlxSprite(435,195);
    playButton.loadGraphic(Paths.image('hud/mcpause/button_unhighlited'));
    playButton.setGraphicSize(Std.int(playButton.width * 2.05));
    playButton.updateHitbox();
    add(playButton);

    playButton = new FlxSprite(435,387);
    playButton.loadGraphic(Paths.image('hud/mcpause/button_unhighlited'));
    playButton.setGraphicSize(Std.int(playButton.width * 2.05));
    playButton.updateHitbox();
    add(playButton);
}

function update() {
    if (controls.ACCEPT) close();
}