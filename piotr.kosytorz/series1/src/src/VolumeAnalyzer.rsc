module VolumeAnalyzer

import IO;
import Set;
import String;

import lang::json::IO;

import Utils;
import Types;

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
public int getVolume(set[loc] files, loc reportFolder, loc project) {
	int volume = 0;
	
	// write a report of all files to json
 	list[Location] locs = [];
	for(f <- files) {
		int fileVolume = getFileVolume(f);
		volume += fileVolume;
		locs += Location(replaceFirst(f.uri, "java+compilationUnit://", project.uri), 0, fileVolume);
	}
	writeJSON(reportFolder + "files.json", locs);
	
	return volume;
}
