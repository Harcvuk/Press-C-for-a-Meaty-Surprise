var names:Array<String> = [
    "HeroEyad: Director and Programmer of Press C for headache",
    "TechyHarcvuk: Director/Artist/Programmer/Animator/Composer of Meaty Surprise",
    "Bitto: Programmer and Charter",
    "mariofy: 3D-Modeler and Animator",
    "Gumbalino: 3D-Modeler and Animator",
    "Hipix: Artist and Animator",
    "douyhe: Composer",
    "Verwex: for letting us on the birthday bash",
    "Terionic: Code assistant.",
    "Happy Birthday Seezee!"
];

var credits:FlxText;
var logo:FunkinSprite;

function create() {
    logo = new FunkinSprite(0,-35, Paths.image("logo"));
    logo.scale.set(0.8, 0.8);
    logo.screenCenter(0x01);
    add(logo);
    credits = new FlxText(0,275,FlxG.width, names.join("\n")).setFormat(Paths.font("sonic2.ttf"), 32, FlxColor.YELLOW, "center").screenCenter(0x01);
    add(credits);
}

