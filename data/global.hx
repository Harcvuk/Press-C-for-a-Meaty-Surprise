import funkin.backend.utils.WindowUtils;
import flixel.input.keyboard.FlxKey;

var hero = [72,69,82,79];
var typed = "";

function preStateSwitch() {
    WindowUtils.title = window.title = "Press C for a Meaty Surprise!";
}

function update() {
    for (k in hero) {
        if (FlxG.keys.justPressed[k]) {
            typed += FlxKey.toString(k);
            if (typed.length > 4) typed = typed.substr(typed.length - 4);
            if (typed == "HERO") FlxG.switchState(new UI(true, "PasswordState"));
        }
    }
}