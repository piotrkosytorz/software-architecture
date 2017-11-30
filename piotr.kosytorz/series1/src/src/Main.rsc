module Main

/**
 * Series 1
 * 
 * Cornelius Ries
 * Piotr Kosytorz
 */

import IO;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
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
import DuplicationsAnalyzer3;

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
	astInfo ai = analyzeAST(declarations);
	unitsCompleity = ai.ui;
	
	// testing analysis
	int numberOfAsserts = ai.numberOfAsserts;
	int numberOfUnits = size(unitsCompleity);
	
	// duplications count
	int dupCount = detectClones(files);
	
	// scores
	score volumeS = volumeScore(volume);
	unitScore unitCCS = unitCCScore(unitsCompleity, volume);
	unitScore unitSS = unitSizeScore(unitsCompleity, volume);
	dupScore dupS = duplicationScore(dupCount, volume);
	testingScore testingS = testingScore(numberOfAsserts, numberOfUnits);
		
	// report generation
	println("Project volume (LOCs): <volume>.");
	println("Project volume score: <volumeS>");
	println("Cyclomatic complexity score: <unitCCS>");
	println("Unit size score: <unitSS>");
	println("Duplication score: <dupS>");
	println("Testing score: <testingS>");
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
	set[Declaration] declarations = createAstsFromEclipseProject(location, true);		
	
	// units analysis 
	astInfo ai = analyzeAST(declarations);
	unitsCompleity = ai.ui;
	
	// testing analysis
	int numberOfAsserts = ai.numberOfAsserts;
	int numberOfUnits = size(unitsCompleity);
	
	// duplications count
	int dupCount = detectClones(declarations);
	
	// scores
	score volumeS = volumeScore(volume);
	unitScore unitCCS = unitCCScore(unitsCompleity, volume);
	unitScore unitSS = unitSizeScore(unitsCompleity, volume);
	dupScore dupS = duplicationScore(dupCount, volume);
	testingScore testingS = testingScore(numberOfAsserts, numberOfUnits);
	unitScore interfaceS = unitInterfaceScore(unitsCompleity);
	
	score maintainability = avarageScore([volumeS, unitCCS.s, unitSS.s, dupS.s, testingS.s]);
	score analysability = avarageScore([volumeS, unitSS.s, dupS.s, testingS.s]);
	score changeability = avarageScore([unitCCS.s, dupS.s]);
	score stability = testingS.s;
	score testability = avarageScore([unitCCS.s, unitSS.s, testingS.s]);
	
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
		'                        <volume> LOCs
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
		'                        Low: <100-unitCCS.m-unitCCS.h-unitCCS.vh>% Medium: <unitCCS.m>% High: <unitCCS.h>% Very High: <unitCCS.vh>% 
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
		'                        Low: <100-unitSS.m-unitSS.h-unitSS.vh>% Medium: <unitSS.m>% High: <unitSS.h>% Very High: <unitSS.vh>% 
		'                    \</td\>
		'                    \<td class=\"test-result-step-description-cell\"\>
		'                        <unitSS.s.s>
		'                    \</td\>
		'                \</tr\>
		'				 \<tr class=\"test-result-step-row test-result-step-row-altone\"\>
		'                    \<td class=\"test-result-step-command-cell\"\>
		'                        Unit Interfacing
		'                    \</td\>
		'                    \<td class=\"test-result-step-description-cell\"\>
		'                        Low: <100-interfaceS.m-interfaceS.h-interfaceS.vh>% Medium: <interfaceS.m>% High: <interfaceS.h>% Very High: <interfaceS.vh>% 
		'                    \</td\>
		'                    \<td class=\"test-result-step-description-cell\"\>
		'                        <interfaceS.s.s>
		'                    \</td\>
		'                \</tr\>

		'				 \<tr class=\"test-result-step-row test-result-step-row-altone\"\>
		'                    \<td class=\"test-result-step-command-cell test-result-describe-cell\"\>
		'                        Units
		'                    \</td\>
		'                    \<td class=\"test-result-step-description-cell test-result-describe-cell\"\>
		'                        <numberOfUnits>
		'                    \</td\>
		'                    \<td class=\"test-result-step-description-cell test-result-describe-cell\"\>
		'                        
		'                    \</td\>
		'                \</tr\>
		'				 \<tr class=\"test-result-step-row test-result-step-row-altone\"\>
		'                    \<td class=\"test-result-step-command-cell\"\>
		'                        Duplication
		'                    \</td\>
		'                    \<td class=\"test-result-step-description-cell\"\>
		'                        <dupS.p>% (<dupCount> duplicated lines)
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
		'                        <testingS.p>% (<numberOfAsserts> assert statements)
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
		'    \</body\>
		'\</html\>
		";
	
	writeFile(reportFile, html);
}