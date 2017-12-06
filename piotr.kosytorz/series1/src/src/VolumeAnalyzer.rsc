module VolumeAnalyzer

import IO;
import Set;
import String;

import lang::json::IO;

import Utils;
import Types;

public list[Location] filesResult = [];

/**
 * Calculates file volume
 */
public int getFileVolume(loc file) {
	list[str] lines = readFileLines(file);
	return countLines(lines);
}

/**
 * Calculates the total volume of all files
 */
public int getVolume(set[loc] files, loc project) {
	int volume = 0;
	
 	filesResult = [];
	for(f <- files) {
		int fileVolume = getFileVolume(f);
		volume += fileVolume;
		filesResult += Location(replaceFirst(f.uri, "java+compilationUnit://", project.uri), 0, fileVolume, "");
	}
	
	return volume;
}
