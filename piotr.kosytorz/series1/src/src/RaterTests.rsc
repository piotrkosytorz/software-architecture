module RaterTests

extend Rater;

test bool testAvarageScore(list[score] scs){
	score s = avarageScore(scs);
	if(s.v notin [-2,-1,0,1,2,-99]) return false;
	return true;
}


test bool testVolumeValues(int volume){
	score s = volumeScore(volume);
	if(s.v notin [-2,-1,0,1,2]) return false;
	return true;
}

test bool testVolumeString(int volume){
	score s = volumeScore(volume);
	if(s.s notin ["--","-","o","+","++"]) return false;
	return true;
}
