module sigcalc::Util

import IO;
import ValueIO;
import String;


import sigcalc::Types;

public int calcVolume(loc file){
	list[str] lines = readFileLines(file);
	return countLines(lines);
}

public int countLines(list[str] lines){
	int ret = 0;
	for(l <- lines){
		str lt = trim(l);
		if(lt != "" && !startsWith(lt, "//") && !startsWith(lt, "/*") && !startsWith(lt, "*") && !startsWith(lt, "*/")){
			ret += 1;
		}
	}
	return ret;
}

public void saveData(loc file, analysisInfo var){
	writeTextValueFile(file, var);
}

public analysisInfo readData(loc file){
	return readTextValueFile(#analysisInfo, file);
}