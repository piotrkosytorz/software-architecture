module sigcalc::Main

import IO;

//import sigcalc::Util;
import sigcalc::Types;
import sigcalc::Analyze;
import sigcalc::Report;

// test projects
public loc testProject = |project://JavaTestProject|;
public loc smallsql = |project://smallsql0.21_src|;
public loc hsqldb = |project://hsqldb-2.3.1|;

public loc testDataFile = |project://series1/data.txt|;
public loc testReportFile = |project://series1/report.html|;
public loc testSmallSqlFile = |project://series1/report_smallsql.html|;
public loc testHSqlFile = |project://series1/report_hsql.html|;

public void analyzeAndReport(loc project, loc reportFile){

	analysisInfo info = analyzeProject(project);
	generateReport(info, reportFile);

}
