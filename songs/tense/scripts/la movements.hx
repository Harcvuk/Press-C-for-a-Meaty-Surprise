laX = dad.x;
laY = dad.y;
var la = dad;
function postCreate() {
	la.moves = true;
}
function onDadHit(e) {
	if (!e.isSustainNote) la.x = laX;
	switch (e.direction) {
		case 0: la.velocity.x = -20;
		case 1: if (la.y != laY) {
			FlxTween.cancelTweensOf(la);
			FlxTween.tween(la,{y:laY},0.1);
		}
		case 2:
			if (la.y != laY) return;
			FlxTween.cancelTweensOf(la);
			la.y = laY;
			FlxTween.tween(la,{y:laY - 20},Conductor.crochet/2000,{ease:FlxEase.sineOut,onComplete:() -> if (la.animation.curAnim.name == "singUP") la.playAnim("fall",true,false,0,"LOCK")}).then(FlxTween.tween(la,{y:laY},Conductor.crochet/2000,{ease:FlxEase.sineIn, onComplete:() -> if (la.animation.curAnim.name == "fall") la.playAnim("idle",true,false,0,"DANCE")}));
	}
}

var jumpAnims = ["singUP","fall"];
function update() {
	if (la.animation.curAnim.name != "singLEFT") {
		la.velocity.x = 0;
		la.x = laX;
	}
	if (jumpAnims.contains(la.animation.curAnim.name) && la.y == laY) la.playAnim("idle");
}