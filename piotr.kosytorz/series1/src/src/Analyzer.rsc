module Analyzer

import IO;
import ValueIO;
import lang::java::m3::AST;
import List;
import Utils;
import Types;

/**
 * Calculates file volume
 */
public int fileVolume(loc file) {
	list[str] lines = readFileLines(file);
	return countLines(lines);
}

/**
 * Calculates the total volume of all files
 */
public int totalVolume(set[loc] files) {
	int volume = 0;
	
	for(f <- files) {
		volume += fileVolume(f);
	}
	
	return volume;
}

public analysisInfo analyzeFiles(set[loc] files) {
	set[Declaration] declarations = createAstsFromFiles(files, true);
	list[tuple[str, loc]] allBlocks = [];
	unitsInfo units = [];
	
	visit(declarations){
		// ======================================================================
		// collect all possible duplication blocks
		case Statement st:block(x) : {
			loc src = st.src;
			int srcLC = 1 + src.end.line - src.begin.line;
			if(srcLC >=  6){
				str srcC = readFile(src);
				allBlocks += <srcC, src>;
			}
		}
		// ======================================================================
	
		/**
		 * Calculate unit size and complexity
		 * According to suggestion from 
		 * http://wiki.di.uminho.pt/twiki/pub/Personal/Joost/PublicationList/HeitlagerKuipersVisser-Quatic2007.pdf
		 * We have decided to consider single method (function) as unit.
		 	"Since the unit is the
			smallest piece of a system that can be executed and tested
			individually."
		 */
		case Declaration x:method(_,_,_,_,implementation) : {
	    		
	    		// lines count per unit (unit size)
	    		list[str] lines = readFileLines(x.src);
			int lc = countLines(lines);
	    			    		
	    		/** 
	    		 * Cyclomatic complexity
	    		 * 
	    		 * We've decided to use the following instruction to count the CC:
				- case, catch, do-while
				- if, for, foreach
				- while
		 	 * Source: https://homepages.cwi.nl/~jurgenv/papers/SCAM2012.pdf, page 3, Table 1.
		 	 	"The CC of a Java method is calculated
				by adding one for each occurrence of each
				keyword in the first list."
	    		 */
	    		int cc = 1;
	    		visit(implementation) {
	    			case /\case(_) 			: cc += 1;	// params: (Expression expression)
	    			case /\defaultCase() 	: cc += 1;	// params: ()
	    			case /\catch(_,_)		: cc += 1;	// params: (Declaration exception, Statement body)
	    			case /\do(_,exp)			: cc += 1;	// params: (Statement body, Expression condition)
	    			case /\if(exp,_) 		: cc += 1;	// params: (Expression condition, Statement thenBranch)
	    			case /\if(exp,_,_) 		: cc += 1;	// params: (Expression condition, Statement thenBranch, Statement elseBranch)
	    			case /\for(_,_,_,_) 		: cc += 1;	// params: (list[Expression] initializers, Expression condition, list[Expression] updaters, Statement body)
	    			case /\for(_,_,_) 		: cc += 1;	// params: (list[Expression] initializers, list[Expression] updaters, Statement body)
	    			case /\foreach(_,_,_) 	: cc += 1;	// params: (Declaration parameter, Expression collection, Statement body)
	    			case /\while(exp,_) 		: cc += 1;	// params: (Expression condition, Statement body)
	    		}
	    		units += <x.decl, lc, cc>;
	    		
    		}
    	
	}
		
	// ======================================================================
	list[set[loc]] allDups = [];
	// calculate duplicates based on string comparison
	/*
	for(<s,l> <- allBlocks){
		set[loc] blub = ({l} | it + l2 | <s2,l2> <- allBlocks, s2 == s);
		if(size(blub) > 1)
			allDups = allDups + blub;
	}
	*/
	// ======================================================================	
	// because we call toSet duplicate duplication findings are removed
	return <0, units, toSet(allDups)>;
	// ======================================================================
}	
