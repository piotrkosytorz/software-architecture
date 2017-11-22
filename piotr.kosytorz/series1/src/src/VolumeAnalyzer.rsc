module VolumeAnalyzer

import IO;
import Set;

import Utils;


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
public int getVolume(set[loc] files) {
	int volume = 0;
	
	for(f <- files) {
		volume += getFileVolume(f);
	}
	
	return volume;
}
