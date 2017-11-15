module sigcalc::Rating

import List;
import Set;
import IO;

import util::Math;

import sigcalc::Types;
import sigcalc::Util;

// calculate the average score for a list of scores
public score calcScore(list[score] scs){
	int i = (0 | it +  sc.v | sc <- scs);
	real s = i  / toReal(size(scs));
	int x = s >= 0 ? floor(s) : ceil(s);
	for(score sc <- scores){
		if(sc.v  == x)
			return sc;
	}
	throw "Could not compute score";
}

// calculate the volume score
public score volumeScore(int volume){
	if(volume < 66000) return scores.vh;
	if(volume < 246000) return scores.h;
	if(volume < 665000) return scores.m;
	if(volume < 1310000) return scores.l;
	return scores.vl;
}

// calculate unit complexity score
// first divide units based on unit cc threshold
// then calculate the percentages based on total loc
// return the appropriate score
public unitScore unitCCScore(int volume, unitsInfo ui){
	
	int mlc = (0 | it + i.lc | i <- ui, i.cc > 10 && i.cc <= 20);
	int hlc = (0 | it + i.lc | i <- ui, i.cc > 21 && i.cc <= 50);
	int vhlc = (0 | it + i.lc | i <- ui, i.cc > 50);
	
	int rmlc = percent(mlc, volume);
	int rhlc = percent(hlc, volume);
	int rvhlc = percent(vhlc, volume);
	
	score s = scores.vl;
	if(rmlc <= 25 && rhlc == 0 && rvhlc == 0) s = scores.vh;
	else if(rmlc <= 30 && rhlc <= 5 && rvhlc == 0) s =  scores.h;
	else if(rmlc <= 40 && rhlc <= 10 && rvhlc == 0) s =  scores.m;
	else if(rmlc <= 50 && rhlc <= 15 && rvhlc <= 5) s =  scores.l;
	
	return <floor(rmlc), floor(rhlc), floor(rvhlc), s>;
}

// calculate unit complexity score
// first divide units based on unit size threshold
// then calculate the percentages based on total loc
// return the appropriate score
public unitScore unitLCScore(int volume, unitsInfo ui){
	
	int mlc = (0 | it + i.lc | i <- ui, i.lc > 10 && i.lc <= 20);
	int hlc = (0 | it + i.lc | i <- ui, i.lc > 21 && i.lc <= 50);
	int vhlc = (0 | it + i.lc | i <- ui, i.lc > 50);
	
	int rmlc = percent(mlc, volume);
	int rhlc = percent(hlc, volume);
	int rvhlc = percent(vhlc, volume);
	
	score s = scores.vl;
	if(rmlc <= 25 && rhlc == 0 && rvhlc == 0) s = scores.vh;
	else if(rmlc <= 30 && rhlc <= 5 && rvhlc == 0) s =  scores.h;
	else if(rmlc <= 40 && rhlc <= 10 && rvhlc == 0) s =  scores.m;
	else if(rmlc <= 50 && rhlc <= 15 && rvhlc <= 5) s =  scores.l;
	
	return <floor(rmlc), floor(rhlc), floor(rvhlc), s>;
}

// For duplication i  count the lines of duplicated code and compute a percentage
public dupScore duplicationScore(int volume, dupsInfo dups){
	
	int duplicatedCode = 0;
	for(set[loc] dup <- dups){
		duplicatedCode += (0 | it + 1 + el.end.line - el.begin.line | el <- tail(toList(dup)));
	}
	
	int rd = percent(duplicatedCode, volume);

	score r = scores.vl;
	if(rd <= 3) r = scores.vh;
	else if(rd <= 5) r = scores.h;
	else if(rd <= 10) r = scores.m;
	else if(rd <= 20) r = scores.l;
	
	return <rd, r>;
}