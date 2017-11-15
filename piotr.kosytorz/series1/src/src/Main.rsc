module Main

/**
 * Series 1
 * 
 * Cornelius Ries
 * Piotr Kosytorz
 */

import IO;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import List;

import util::ValueUI;

/**
 * Own modules import
 */
import Utils;
import Rater;
import Types;
import Analyzer;

/**
 * Tetst code (java projects) location
 */
public loc smallSqlLoc = |project://smallsql0.21_src/src/smallsql|;
public loc hsqldbLoc = |project://src/org/hsqldb|;
 
/**
 * The main method
 */
public void generteReport(loc location) {
 	
 	// m3 object
 	M3 m = createM3FromEclipseProject(location);

	// project files
 	set[loc] files = extractFilesFromM3(m);	
 	
 	// project volume (sum)
	int volume = totalVolume(files);			
	
	// units analysis 
	unitsInfo = analyzeFiles(files);
	
	// scores
	score volumeS = volumeScore(unitsInfo.locs);
	unitScore unitCCS = unitCCScore(volume, unitsInfo.units);
	unitScore unitVS = unitVScore(volume, unitsInfo.units);
	//dupScore dupS = duplicationScore(unitsInfo.locs, unitsInfo.dups);
	
	//text(units);
	
	// report generation
	println("Project volume (LOCs): <volume>.");
	println("Project volume score: <volumeS>");
	println("Cyclomatic complexity score: <unitCCS>");
	println("Unit volume score: <unitVS>");
 }