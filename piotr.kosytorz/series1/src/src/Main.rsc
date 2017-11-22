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
import lang::java::m3::AST;
import List;

import util::ValueUI;

/**
 * Own modules import
 */
import Utils;
import Rater;
import Types;

import VolumeAnalyzer;
import ComplexityAnalyzer;
import DuplicationsAnalyzer;
import TestingAnalyzer;

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
	int volume = getVolume(files);			
	
	// create the ast
	set[Declaration] declarations = createAstsFromFiles(files, true);		
	
	// units analysis 
	unitsCompleity = getComplexity(declarations);
	
	// testing analysis
	int asserts = getAsserts(declarations);
	
	// scores
	score volumeS = volumeScore(volume);
	unitScore unitCCS = unitCCScore(unitsCompleity, volume);
	unitScore unitSS = unitSizeScore(unitsCompleity, volume);
	//dupScore dupS = duplicationScore(unitsInfo.dups, volume);
		
	// report generation
	println("Project volume (LOCs): <volume>.");
	println("Project volume score: <volumeS>");
	println("Cyclomatic complexity score: <unitCCS>");
	println("Unit size score: <unitSS>");
	//println("Duplication score: <dupS>");
 }
 
/**
 * The same as main but generates some nice html
 */
public void generateReport(loc location, loc reportFile){
	
	// m3 object
 	M3 m = createM3FromEclipseProject(location);

	// project files
 	set[loc] files = extractFilesFromM3(m);	
 	
 	// project volume (sum)
	int volume = getVolume(files);	
	
	// create the ast
	set[Declaration] declarations = createAstsFromFiles(files, true);		
	
	// units analysis 
	unitsCompleity = getComplexity(declarations);
	
	// testing analysis
	int numberOfAsserts = getAsserts(declarations);
	int numberOfUnits = size(unitsCompleity);
	
	// TODO add the duplication calculation
	dupsInfo dups = {};
	
	// scores
	score volumeS = volumeScore(volume);
	unitScore unitCCS = unitCCScore(unitsCompleity, volume);
	unitScore unitSS = unitSizeScore(unitsCompleity, volume);
	testingScore testingS = testingScore(numberOfAsserts, numberOfUnits);
	dupScore dupS = duplicationScore(dups, volume);
	
	score maintainability = avarageScore([volumeS, unitCCS.s, unitSS.s, dupS.s]);
	score analysability = avarageScore([volumeS, unitSS.s, dupS.s]);
	score changeability = avarageScore([unitCCS.s, dupS.s]);
	score stability = testingS.s;
	score testability = avarageScore([unitCCS.s, unitSS.s]);
	
	str html = 
		"
		'\<html\>
		'    \<head\>
		'        \<title\>
		'            Test Report
		'        \</title\>
		'        \<style type=\"text/css\"\>
		'        .test-result-table {
		'            border: 1px solid black;
		'            width: 800px;
		'        }
		'        .test-result-table-header-cell {
		'            border-bottom: 1px solid black;
		'            background-color: silver;
		'        }
		'        .test-result-step-command-cell {
		'            border-bottom: 1px solid gray;
		'        }
		'        .test-result-step-description-cell {
		'            border-bottom: 1px solid gray;
		'        }
		'        .test-result-step-result-cell-ok {
		'            border-bottom: 1px solid gray;
		'            background-color: green;
		'        }
		'        .test-result-step-result-cell-failure {
		'            border-bottom: 1px solid gray;
		'            background-color: red;
		'        }
		'        .test-result-step-result-cell-notperformed {
		'            border-bottom: 1px solid gray;
		'            background-color: white;
		'        }
		'        .test-result-describe-cell {
		'            background-color: tan;
		'            font-style: italic;
		'        }
		'        .test-cast-status-box-ok {
		'            border: 1px solid black;
		'            float: left;
		'            margin-right: 10px;
		'            width: 45px;
		'            height: 25px;
		'            background-color: green;
		'        }
		'        \</style\>
		'    \</head\>
		'    \<body\>
		'        \<h1 class=\"test-results-header\"\>
		'            Analysis Report
		'        \</h1\>
		'
		'        \<table class=\"test-result-table\" cellspacing=\"0\"\>
		'            \<thead\>
		'                \<tr\>
		'                    \<td class=\"test-result-table-header-cell\"\>
		'                        Metric
		'                    \</td\>
		'                    \<td class=\"test-result-table-header-cell\"\>
		'                        Result
		'                    \</td\>
		'                    \<td class=\"test-result-table-header-cell\"\>
		'                        Score
		'                    \</td\>
		'                \</tr\>
		'            \</thead\>
		'            \<tbody\>
		'                \<tr class=\"test-result-step-row test-result-step-row-altone\"\>
		'                    \<td class=\"test-result-step-command-cell\"\>
		'                        Volume
		'                    \</td\>
		'                    \<td class=\"test-result-step-description-cell\"\>
		'                        <volume>
		'                    \</td\>
		'                    \<td class=\"test-result-step-description-cell\"\>
		'                        <volumeS.s>
		'                    \</td\>
		'                \</tr\>
		'				 \<tr class=\"test-result-step-row test-result-step-row-altone\"\>
		'                    \<td class=\"test-result-step-command-cell\"\>
		'                        Unit Complexity
		'                    \</td\>
		'                    \<td class=\"test-result-step-description-cell\"\>
		'                        Medium: <unitCCS.m> High: <unitCCS.h> Very High: <unitCCS.vh> 
		'                    \</td\>
		'                    \<td class=\"test-result-step-description-cell\"\>
		'                        <unitCCS.s.s>
		'                    \</td\>
		'                \</tr\>
		'				 \<tr class=\"test-result-step-row test-result-step-row-altone\"\>
		'                    \<td class=\"test-result-step-command-cell\"\>
		'                        Unit Size
		'                    \</td\>
		'                    \<td class=\"test-result-step-description-cell\"\>
		'                        Medium: <unitSS.m> High: <unitSS.h> Very High: <unitSS.vh> 
		'                    \</td\>
		'                    \<td class=\"test-result-step-description-cell\"\>
		'                        <unitSS.s.s>
		'                    \</td\>
		'                \</tr\>
		'				 \<tr class=\"test-result-step-row test-result-step-row-altone\"\>
		'                    \<td class=\"test-result-step-command-cell\"\>
		'                        Duplication
		'                    \</td\>
		'                    \<td class=\"test-result-step-description-cell\"\>
		'                        <dupS.p>
		'                    \</td\>
		'                    \<td class=\"test-result-step-description-cell\"\>
		'                        <dupS.s.s>
		'                    \</td\>
		'                \</tr\>
		'				 \<tr class=\"test-result-step-row test-result-step-row-altone\"\>
		'                    \<td class=\"test-result-step-command-cell\"\>
		'                        Testing
		'                    \</td\>
		'                    \<td class=\"test-result-step-description-cell\"\>
		'                        <testingS.p>
		'                    \</td\>
		'                    \<td class=\"test-result-step-description-cell\"\>
		'                        <testingS.s.s>
		'                    \</td\>
		'                \</tr\>
		'            \</tbody\>
		'        \</table\>
		'		 \<div style=\" margin-top:25px \" \>
		'        \<table class=\"test-result-table\" cellspacing=\"0\"\>
		'            \<thead\>
		'                \<tr\>
		'                    \<td class=\"test-result-table-header-cell\"\>
		'                        SIG Rating
		'                    \</td\>
		'                    \<td class=\"test-result-table-header-cell\"\>
		'                        Score
		'                    \</td\>
		'                \</tr\>
		'            \</thead\>
		'            \<tbody\>
		'                \<tr class=\"test-result-step-row test-result-step-row-altone\"\>
		'                    \<td class=\"test-result-step-command-cell\"\>
		'                        Maintainability
		'                    \</td\>
		'                    \<td class=\"test-result-step-description-cell\"\>
		'                        <maintainability.s>
		'                    \</td\>
		'                \</tr\>
		'				 \<tr class=\"test-result-step-row test-result-step-row-altone\"\>
		'                    \<td class=\"test-result-step-command-cell\"\>
		'                        Analysability
		'                    \</td\>
		'                    \<td class=\"test-result-step-description-cell\"\>
		'                        <analysability.s>
		'                    \</td\>
		'                \</tr\>
		'				 \<tr class=\"test-result-step-row test-result-step-row-altone\"\>
		'                    \<td class=\"test-result-step-command-cell\"\>
		'                        Changeability
		'                    \</td\>
		'                    \<td class=\"test-result-step-description-cell\"\>
		'                        <changeability.s>
		'                    \</td\>
		'                \</tr\>
		'				 \<tr class=\"test-result-step-row test-result-step-row-altone\"\>
		'                    \<td class=\"test-result-step-command-cell\"\>
		'                        Testability
		'                    \</td\>
		'                    \<td class=\"test-result-step-description-cell\"\>
		'                        <testability.s>
		'                    \</td\>
		'                \</tr\>
		'				 \<tr class=\"test-result-step-row test-result-step-row-altone\"\>
		'                    \<td class=\"test-result-step-command-cell\"\>
		'                        Stability
		'                    \</td\>
		'                    \<td class=\"test-result-step-description-cell\"\>
		'                        <stability.s>
		'                    \</td\>
		'                \</tr\>
		'            \</tbody\>
		'        \</table\>
		'		 \<div style=\" margin-top:25px \" \>
		'        \<table class=\"test-result-table\" cellspacing=\"0\"\>
		'            \<thead\>
		'                \<tr\>
		'                    \<td class=\"test-result-table-header-cell\"\>
		'                        Duplications
		'                    \</td\>
		'                \</tr\>
		'            \</thead\>
		'            \<tbody\>
		'<for(dup <- dups) {> 
		'                \<tr class=\"test-result-step-row test-result-step-row-altone\"\>
		'					\<td class=\"test-result-step-command-cell\"\>
		'<for(dl <- dup)  {>
			<dl> \</br\>
		<}>
		'                    \</td\>
		'                \</tr\>
		'<}>
		'            \</tbody\>
		'        \</table\>
		'    \</body\>
		'\</html\>
		";
	
	writeFile(reportFile, html);
}
 
 public void clones (loc location) {
 	// m3 object
 	M3 m = createM3FromEclipseProject(location);

	// project files
 	set[loc] files = extractFilesFromM3(m);	
 	
 	detectClones(files);
 }