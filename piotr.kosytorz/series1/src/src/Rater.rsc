module Rater

/**
 * Module Rater
 * ========================================================================
 * This model provides helper functions that convert raw metrics to desired 
 * ratings represented as defined in ISO/IEC 9126 standard.
 * (http://wiki.di.uminho.pt/twiki/pub/Personal/Joost/PublicationList/HeitlagerKuipersVisser-Quatic2007.pdf)
 */
 
import List;
import Set;
import IO;

import util::Math;

/**
 * Import own modules
 */
import Types;
import Utils;

/**
	Calculate the avarage of multiple ratings for SIG mainainability
*/
public score avarageScore(list[score] scs){
	int i = (0 | it +  sc.v | sc <- scs);
	real size = toReal(size(scs));
	if(size <= 0)
		return scores.e;
	real s = i  / size;
	int x = round(s);
	for(score sc <- scores){
		if(sc.v  == x)
			return sc;
	}
	return scores.e;
}

test bool testAvarageScore(list[score] scs){
	score s = avarageScore(scs);
	if(s.v notin [-2,-1,0,1,2,-99]) return false;
	return true;
}

/**
 * Calculates volume rating 
 * ==========================
 *
 * Includes:
 *   SIG: 200k = small (+)
 *        1.3M = extremaly big (--)
 *
 * - Man years via backfiring function points
 *   Basically a measurement converted from Loc with the following table:
	 +-----------------------------+
	| rank | MY       | Java KLOC |
	|  ++  | 0 − 8    | 0-66      |
	|  +   | 8 − 30   | 66-246    |
	|  o   | 30 − 80  | 246-665   |
	|  -   | 80 − 160 | 655-1,310 |
	|  --  | > 160    | > 1, 310  |
	+-----------------------------+ 
 * 
 */
public score volumeScore(int volume){
	if(volume < 66000) return scores.vh;
	if(volume < 246000) return scores.h;
	if(volume < 665000) return scores.m;
	if(volume < 1310000) return scores.l;
	return scores.vl;
}

test bool testVolumeValues(int volume){
	score s = volumeScore(volume);
	if(s.v notin [-2,-1,0,1,2]) return false;
	return true;
}

test bool testVolumeString(int volume){
	score s = volumeScore(volume);
	if(s.s notin ["--","-","o","+","++"]) return false;
	return true;
}

/**
 * Calculates unit cyclomatic complexity score
 * ================================
 * 
 */
public unitScore unitCCScore(unitsInfo ui, int totalProcjectLOC){
	
	// total number of units
	int totalUnits = size(ui);
	
	/**
	 *  First: evaluate units cc risks based on threshold
    +--------------------------------------+
	| CC    | Risk evaluation              |
	| 1-10  | simple, without much risk    |
	| 11-20 | more complex, moderate risk  |
	| 21-50 | complex, high risk           |
	| > 50  | untestable, very high risk   |
	+--------------------------------------+
	 */
	// count number of lines of units per treshold risk
	
	// sum of lines of code of units with moderate risk
	// sum of lines of code of units with high risk
	// sum of lines of code of units with very high risk
	
	int moderateRiskUnitsLOC = 	(0 | it + i.lc | i <- ui, i.cc > 10 && i.cc <= 20 );
	int highRiskUnitsLOC = 		(0 | it + i.lc | i <- ui, i.cc > 20 && i.cc <= 50);
	int veryHighRiskUnitsLOC = 	(0 | it + i.lc | i <- ui, i.cc > 50);
	
	// count size (as percentage) of risk treshold per total number of units in the system
	int moderateRiskUnitsPercentage = percent(moderateRiskUnitsLOC, totalProcjectLOC);
	int highRiskUnitsPercentage = percent(highRiskUnitsLOC, totalProcjectLOC);
	int veryHighRiskUnitsPercentage = percent(veryHighRiskUnitsLOC, totalProcjectLOC);
	
	/**
	 * Last: return the appropriate score
	 * Source: [Heitlager, 2007]
	 *
	+--------------------------------------+
	|      |     maximum relative LOC      |
	+--------------------------------------+
	| rank | moderate | high | very high   |
	+--------------------------------------+
	| ++   | 25%      | 0%   | 0%          |
	| +    | 30%      | 5%   | 0%          |
	| o    | 40%      | 10%  | 0%          |
	| -    | 50%      | 15%  | 5%          |
	| --   | -        | -    | -           |
	+--------------------------------------+
	 */
	score totalScore = scores.vl;	// defaul score = very low (--)
	
	if		(moderateRiskUnitsPercentage <= 25 &&	highRiskUnitsPercentage == 0		&& veryHighRiskUnitsPercentage == 0) totalScore = scores.vh;	// very high (++)
	else if	(moderateRiskUnitsPercentage <= 30 &&	highRiskUnitsPercentage <= 5		&& veryHighRiskUnitsPercentage == 0) totalScore = scores.h;	// high (+)
	else if	(moderateRiskUnitsPercentage <= 40 &&	highRiskUnitsPercentage <= 10	&& veryHighRiskUnitsPercentage == 0) totalScore = scores.m;	// moderate (o)
	else if	(moderateRiskUnitsPercentage <= 50 &&	highRiskUnitsPercentage <= 15	&& veryHighRiskUnitsPercentage <= 5) totalScore = scores.l;	// low (-)
	
	return <moderateRiskUnitsPercentage, highRiskUnitsPercentage, veryHighRiskUnitsPercentage, totalScore>;
}

/**
 * Calculates unit volume score
 * 
 */
public unitScore unitSizeScore(unitsInfo ui, int totalProcjectLOC){
	/**
	 *  First: evaluate units size risks based on threshold
    +--------------------------------------+
	| CC    | Risk evaluation              |
	| <  30 | simple, without much risk    |
	| 30-44 | more complex, moderate risk  |
	| 44-74 | complex, high risk           |
	| >  74  | untestable, very high risk   |
	+--------------------------------------+
	 */	
	// count number of units per treshold risk
	
	// sum of lines of code of units with moderate risk
	// sum of lines of code of units with high risk
	// sum of lines of code of units with very high risk
	
	int moderateRiskUnitsLOC = 	(0 | it + i.lc | i <- ui, i.lc > 30 && i.lc <= 44 );
	int highRiskUnitsLOC = 		(0 | it + i.lc | i <- ui, i.lc > 44 && i.lc <= 74);
	int veryHighRiskUnitsLOC = 	(0 | it + i.lc | i <- ui, i.lc > 74);
	
	// count size (as percentage) of risk treshold per total number of LOC in the system
	int moderateRiskUnitsPercentage = percent(moderateRiskUnitsLOC, totalProcjectLOC);
	int highRiskUnitsPercentage = percent(highRiskUnitsLOC, totalProcjectLOC);
	int veryHighRiskUnitsPercentage = percent(veryHighRiskUnitsLOC, totalProcjectLOC);
	
	// count the aggregated score 
	score totalScore = scores.vl;	// defaul score = very low (--)
	
	/**
	 * Last: return the appropriate score
	 * Source: [Benchmark-based aggregation of metrics to ratings, 2007]
	 *
	+--------------------------------------+
	|      |     maximum relative LOC      |
	+--------------------------------------+
	| rank | moderate | high   | very high |
	+--------------------------------------+
	| ++   |   19.5%  | 10.9%  |   3.9%    |
	| +    |   26.0%  | 15.5%  |   6.5%    |
	| o    |   34.1%  | 22.2%  |   11.0%   |
	| -    |   45.9%  | 31.4%  |   18.1%   |
	| --   |    -     |   -    |   -       |
	+--------------------------------------+
	 */
	
	if		(moderateRiskUnitsPercentage <= 20 &&	highRiskUnitsPercentage <= 11	&& veryHighRiskUnitsPercentage <= 4) totalScore = scores.vh;	// very high (++)
	else if	(moderateRiskUnitsPercentage <= 26 &&	highRiskUnitsPercentage <= 16	&& veryHighRiskUnitsPercentage <= 7) totalScore = scores.h;		// high (+)
	else if	(moderateRiskUnitsPercentage <= 34 &&	highRiskUnitsPercentage <= 22	&& veryHighRiskUnitsPercentage <= 11) totalScore = scores.m;	// moderate (o)
	else if	(moderateRiskUnitsPercentage <= 46 &&	highRiskUnitsPercentage <= 31	&& veryHighRiskUnitsPercentage <= 18) totalScore = scores.l;	// low (-)
	
	return <moderateRiskUnitsPercentage, highRiskUnitsPercentage, veryHighRiskUnitsPercentage, totalScore>;
}

/**
 * Calculates unit volume score
 * 
 */
public unitScore unitInterfaceScore(unitsInfo ui){

	// total number of units
	int totalUnits = size(ui);

	/**
	 *  First: evaluate units interface risks based on threshold
    +----------------------------------------------------------+
	| number of parameters      | Risk evaluation              |
	| <  2 						| simple, without much risk    |
	| == 2                      | more complex, moderate risk  |
	| == 3                      | complex, high risk           |
	| >  4                      | untestable, very high risk   |
	+----------------------------------------------------------+
	 */	
	// count number of units per treshold risk
	
	// sum of lines of code of units with moderate risk
	// sum of lines of code of units with high risk
	// sum of lines of code of units with very high risk
	
	int moderateRiskUnits = 	(0 | it + 1 | i <- ui, i.np == 2);
	int highRiskUnits = 		(0 | it + 1 | i <- ui, i.np == 3);
	int veryHighRiskUnits = 	(0 | it + 1 | i <- ui, i.np > 4);
	
	// count size (as percentage) of risk treshold per total number of LOC in the system
	int moderateRiskUnitsPercentage = percent(moderateRiskUnits, totalUnits);
	int highRiskUnitsPercentage = percent(highRiskUnits, totalUnits);
	int veryHighRiskUnitsPercentage = percent(veryHighRiskUnits, totalUnits);
	
	// count the aggregated score 
	score totalScore = scores.vl;	// defaul score = very low (--)
	
	/**
	 * Last: return the appropriate score
	 * Source: [Benchmark-based aggregation of metrics to ratings, 2007]
	 *
	+--------------------------------------+
	|      |     maximum relative LOC      |
	+--------------------------------------+
	| rank | moderate | high   | very high |
	+--------------------------------------+
	| ++   |   %  | %  |   %    |
	| +    |   %  | %  |   %    |
	| o    |   %  | %  |   %   |
	| -    |   %  | %  |   %   |
	| --   |    -     |   -    |   -       |
	+--------------------------------------+
	 */
	
	if		(moderateRiskUnitsPercentage <= 12 &&	highRiskUnitsPercentage <= 5	&& veryHighRiskUnitsPercentage <= 2) totalScore = scores.vh;	// very high (++)
	else if	(moderateRiskUnitsPercentage <= 15 &&	highRiskUnitsPercentage <= 7	&& veryHighRiskUnitsPercentage <= 3) totalScore = scores.h;		// high (+)
	else if	(moderateRiskUnitsPercentage <= 18 &&	highRiskUnitsPercentage <= 10	&& veryHighRiskUnitsPercentage <= 5) totalScore = scores.m;	// moderate (o)
	else if	(moderateRiskUnitsPercentage <= 25 &&	highRiskUnitsPercentage <= 15	&& veryHighRiskUnitsPercentage <= 7) totalScore = scores.l;	// low (-)
	
	return <moderateRiskUnitsPercentage, highRiskUnitsPercentage, veryHighRiskUnitsPercentage, totalScore>;
}

/**
	Calculates the duplication score based on the amount of duplicated code
	and the total lines of code in the system
*/
public dupScore duplicationScore(int duplicatedCode, int volume) {

	int rd = percent(duplicatedCode, volume);
	
	score r = scores.vl;
	if(rd <= 3) r = scores.vh;
	else if(rd <= 5) r = scores.h;
	else if(rd <= 10) r = scores.m;
	else if(rd <= 20) r = scores.l;
	
	return <rd, r>;
}

/**
	Calculates the testing score based on the amount of asserts
	and the total amount of units in the system
*/
public testingScore testingScore(int numberOfAsserts, int numberOfUnits){
	
	int testingPercentage = percent(numberOfAsserts, numberOfUnits);
	
	/**
	* Last: return the appropriate score
	* Source: [Heitlager, 2007]
	*
	+---------------------+
	|      |              |
	+---------------------+
	| rank |  Percentage  |
	+---------------------+
	| ++   |  95-100%     |
	| +    |  80-95%      |
	| o    |  60-80%      |
	| -    |  20-60%      |
	| --   |  0-20%       |
	+---------------------+
	*/
	
	if(testingPercentage <= 20) return <testingPercentage,scores.vl>;
	if(testingPercentage <= 60) return <testingPercentage,scores.l>;
	if(testingPercentage <= 80) return <testingPercentage,scores.m>;
	if(testingPercentage <= 95) return <testingPercentage,scores.h>;
	return <testingPercentage,scores.vh>;
}