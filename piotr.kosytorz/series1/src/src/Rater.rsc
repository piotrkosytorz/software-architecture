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

/**
 * Calculates unit cyclomatic complexity score
 * ================================
 * 
 */
public unitScore unitCCScore(unitsInfo ui){
	
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
	// count number of units per treshold risk
	
	// number of units with moderate risk
	// number of units with high risk
	// number of units with very high risk
	
	int moderateRiskUnits = 	(0 | it + 1 | i <- ui, i.cc > 10 && i.cc <= 20 );
	int highRiskUnits = 		(0 | it + 1 | i <- ui, i.cc > 21 && i.cc <= 50);
	int veryHighRiskUnits = 	(0 | it + 1 | i <- ui, i.cc > 50);
	
	// count size (as percentage) of risk treshold per total number of units in the system
	int moderateRiskUnitsPercentage = percent(moderateRiskUnits, totalUnits);
	int highRiskUnitsPercentage = percent(highRiskUnits, totalUnits);
	int veryHighRiskUnitsPercentage = percent(veryHighRiskUnits, totalUnits);
	
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
	
	return <floor(moderateRiskUnitsPercentage), floor(highRiskUnitsPercentage), floor(veryHighRiskUnitsPercentage), totalScore>;
}

/**
 * Calculates unit volume score
 * 
 */
public unitScore unitSizeScore(unitsInfo ui){
	
	// total number of units
	int totalUnits = size(ui);
	
	// count number of units per treshold risk
	
	// number of units with moderate risk
	// number of units with high risk
	// number of units with very high risk
	
	int moderateRiskUnits = 	(0 | it + 1 | i <- ui, i.lc > 10 && i.lc <= 20 );
	int highRiskUnits = 		(0 | it + 1 | i <- ui, i.lc > 21 && i.lc <= 50);
	int veryHighRiskUnits = 	(0 | it + 1 | i <- ui, i.lc > 50);
	
	// count size (as percentage) of risk treshold per total number of units in the system
	int moderateRiskUnitsPercentage = percent(moderateRiskUnits, totalUnits);
	int highRiskUnitsPercentage = percent(highRiskUnits, totalUnits);
	int veryHighRiskUnitsPercentage = percent(veryHighRiskUnits, totalUnits);
	
	// count the aggregated unit size score 
	
	score totalScore = scores.vl;	// defaul score = very low (--)
	
	if		(moderateRiskUnitsPercentage <= 25 &&	highRiskUnitsPercentage == 0		&& veryHighRiskUnitsPercentage == 0) totalScore = scores.vh;	// very high (++)
	else if	(moderateRiskUnitsPercentage <= 30 &&	highRiskUnitsPercentage <= 5		&& veryHighRiskUnitsPercentage == 0) totalScore = scores.h;	// high (+)
	else if	(moderateRiskUnitsPercentage <= 40 &&	highRiskUnitsPercentage <= 10	&& veryHighRiskUnitsPercentage == 0) totalScore = scores.m;	// moderate (o)
	else if	(moderateRiskUnitsPercentage <= 50 &&	highRiskUnitsPercentage <= 15	&& veryHighRiskUnitsPercentage <= 5) totalScore = scores.l;	// low (-)
	
	return <floor(moderateRiskUnitsPercentage), floor(highRiskUnitsPercentage), floor(veryHighRiskUnitsPercentage), totalScore>;
}