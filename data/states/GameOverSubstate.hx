function create() {
	switch (PlayState.SONG.meta.name) {
		case 'peakingtrial':
			gameOverSong = 'gameOverPeak'; // Yes I coded this myself, used this for my april fools desire mod. For some reason github is fucking stupid and it removed this file initially
			lossSFXName = "PeakGameOverSFX";
			retrySFX = "PeakgameOverEnd"; // This however is something I didn't use for that mod. But it's a very easy thing to add, so this isn't too big of a deal tbh lmao
		case 'too-peak':
			gameOverSong = 'gameOverTweak';
			lossSFXName = "TweakGameOverSFX";
			retrySFX = "TweakgameOverEnd";
		case 'wanna play real life':
			lossSFXName = "RealGameOverSFX";
	}
}