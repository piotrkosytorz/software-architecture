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
public unitScore unitCCScore(int volume, unitsInfo ui){
	
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
	int mlc = 	(0 | it + i.lc | i <- ui, i.cc > 10 && i.cc <= 20);	// moderate risk
	int hlc = 	(0 | it + i.lc | i <- ui, i.cc > 20 && i.cc <= 50);	// high risk
	int vhlc = 	(0 | it + i.lc | i <- ui, i.cc > 50);				// very high risk
	
	// Then: calculate the percentages based on total loc
	int rmlc = percent(mlc, volume);
	int rhlc = percent(hlc, volume);
	int rvhlc = percent(vhlc, volume);
	
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
	score s = scores.vl;
	if(rmlc <= 25 && rhlc == 0 && rvhlc == 0) s = scores.vh;
	elseif(rmlc <= 30 && rhlc <= 5 && rvhlc == 0) s = scores.h;
	elseif(rmlc <= 40 && rhlc <= 10 && rvhlc == 0) s = scores.m;
	elseif(rmlc <= 50 && rhlc <= 15 && rvhlc <= 5) s = scores.l;
	
	return <floor(rmlc), floor(rhlc), floor(rvhlc), s>;
}

/**
 * Calculates unit volume score
 */
public unitScore unitVScore(int volume, unitsInfo ui){
	
	int mlc = (0 | it + i.lc | i <- ui, i.lc > 10 && i.lc <= 20);
	int hlc = (0 | it + i.lc | i <- ui, i.lc > 21 && i.lc <= 50);
	int vhlc = (0 | it + i.lc | i <- ui, i.lc > 50);
	
	int rmlc = percent(mlc, volume);
	int rhlc = percent(hlc, volume);
	int rvhlc = percent(vhlc, volume);
	
	score s = scores.vl;
	if(rmlc <= 25 && rhlc == 0 && rvhlc == 0) s = scores.vh;
	else if(rmlc <= 30 && rhlc <= 5 && rvhlc == 0) s =  scores.h;
	else if(rmlc <= 40 && rhlc <= 10 && rvhlc == 0) s =  scores.m;
	else if(rmlc <= 50 && rhlc <= 15 && rvhlc <= 5) s =  scores.l;
	
	return <floor(rmlc), floor(rhlc), floor(rvhlc), s>;
}