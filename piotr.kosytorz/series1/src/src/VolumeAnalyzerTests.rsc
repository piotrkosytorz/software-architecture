module VolumeAnalyzerTests

extend VolumeAnalyzer;

import util::FileSystem;

import Configuration;

test bool testGetFileVolume(){
	int lineCount = getFileVolume(projectLocation + "/test/Book.java");
	if(lineCount != 39) return false;
	return true;
}

test bool testGetVolume(loc pl){
	int lineCount = getVolume(files(projectLocation + "/test/"), pl);
	if(lineCount != 109) return false;
	return true;
}
