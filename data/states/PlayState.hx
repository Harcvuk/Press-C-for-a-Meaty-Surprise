public var lerpScore:Int = 0;
public var intendedScore:Int = 0;

function update(elapsed){
	intendedScore = songScore;
	lerpScore = Math.floor(FlxMath.lerp(intendedScore, lerpScore, Math.exp(-elapsed * 24)));
	scoreTxt.text = 'Score: ' + lerpScore;
}