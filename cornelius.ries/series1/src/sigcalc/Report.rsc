module sigcalc::Report

import IO;
import Set;

import sigcalc::Rating;
import sigcalc::Util;
import sigcalc::Types;

public void loadAndGenerateReport(loc dataFile, loc reportFile){
	analysisInfo info = readData(dataFile);
	generateReport(info, reportFile);
}

public void generateReport(analysisInfo info, loc reportFile){
	
	score vS = volumeScore(info.locs);
	unitScore unitCCS = unitCCScore(info.locs, info.units);
	unitScore unitLCS = unitLCScore(info.locs, info.units);
	dupScore dupS = duplicationScore(info.locs, info.dups);
	
	score maintainability = calcScore([vS, unitCCS.s, unitLCS.s, dupS.s]);
	score analysability = calcScore([vS, unitLCS.s, dupS.s]);
	score changeability = calcScore([unitCCS.s, dupS.s]);
	//score stability = <0,"">;
	score testability = calcScore([unitCCS.s, unitLCS.s]);
	
	//println("Volume Rating: <vS.s>");
	//println("Unit Complexity Rating: <unitCCS.s>");
	//println("Unit Size Rating: <unitLCS.s>");
	//println("Duplication Score: <dupS.s>");
	//println("-------------------------------------");
	//println("Maintainability Rating: <maintainability.s>");
	//println("Analysability Rating: <analysability.s>");
	//println("Changeability Rating: <changeability.s>");
	////println("Stability Rating: <stability.s>");
	//println("Testability Rating: <testability.s>");
	
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
		'                        <info.locs>
		'                    \</td\>
		'                    \<td class=\"test-result-step-description-cell\"\>
		'                        <vS.s>
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
		'                        Medium: <unitLCS.m> High: <unitLCS.h> Very High: <unitLCS.vh> 
		'                    \</td\>
		'                    \<td class=\"test-result-step-description-cell\"\>
		'                        <unitLCS.s.s>
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
		'<for(dup <- info.dups) {> 
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