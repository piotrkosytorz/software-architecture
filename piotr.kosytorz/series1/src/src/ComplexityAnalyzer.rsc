module ComplexityAnalyzer

import Utils;
import Types;

import IO;
import Set;
import List;
import Node;
import String;

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::m3::AST;

import util::ValueUI;

public astInfo analyzeAST(set[Declaration] declarations) {

	unitsInfo units = [];
	int numberOfAsserts = 0;
	
	visit(declarations){
	
		/**
		 * Calculate unit size and complexity
		 * According to suggestion from 
		 * http://wiki.di.uminho.pt/twiki/pub/Personal/Joost/PublicationList/HeitlagerKuipersVisser-Quatic2007.pdf
		 * We have decided to consider single method (function) as unit.
		 	"Since the unit is the
			smallest piece of a system that can be executed and tested
			individually."
		 */
	 	case Declaration x:constructor(_,_,_,implementation) : {
	 	
	 	
	 	
	 	// lines count per unit (unit size)
    		list[str] lines = readFileLines(x.src);
		int lc = countLines(lines);
	 	int cc = 0;
	    		visit(implementation) {
	    			case /\case(_) 					: cc += 1;	// params: (Expression expression)
	    			case /\defaultCase() 			: cc += 1;	// params: ()
	    			case /\catch(_,_)				: cc += 1;	// params: (Declaration exception, Statement body)
	    			case /\do(_,_)					: cc += 1;	// params: (Statement body, Expression condition)
	    			case /\if(_,_) 					: cc += 1;	// params: (Expression condition, Statement thenBranch)
	    			case /\if(_,_,_) 				: cc += 1;	// params: (Expression condition, Statement thenBranch, Statement elseBranch)
	    			case /\conditional(_, _, _)		: cc += 1; 	// params: (Expression expression, Expression thenBranch, Expression elseBranch), example: a ? b : c
	    			case /\for(_,_,_,_) 			: cc += 1;	// params: (list[Expression] initializers, Expression condition, list[Expression] updaters, Statement body)
	    			case /\for(_,_,_) 				: cc += 1;	// params: (list[Expression] initializers, list[Expression] updaters, Statement body)
	    			case /\foreach(_,_,_) 			: cc += 1;	// params: (Declaration parameter, Expression collection, Statement body)
	    			case /\while(_,_) 				: cc += 1;	// params: (Expression condition, Statement body)
		    		case \infix(_, /^\|\||&&$/, _) 	: cc += 1; 	// params: (Expression lhs, str operator, Expression rhs), example: (a && b ), (a || b)
	    		}
	    		units += <x.decl, lc, cc>;
		}
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
	    		int cc = 0;
	    		visit(implementation) {
	    			case /\case(_) 					: cc += 1;	// params: (Expression expression)
	    			case /\defaultCase() 			: cc += 1;	// params: ()
	    			case /\catch(_,_)				: cc += 1;	// params: (Declaration exception, Statement body)
	    			case /\do(_,_)					: cc += 1;	// params: (Statement body, Expression condition)
	    			case /\if(_,_) 					: cc += 1;	// params: (Expression condition, Statement thenBranch)
	    			case /\if(_,_,_) 				: cc += 1;	// params: (Expression condition, Statement thenBranch, Statement elseBranch)
	    			case /\conditional(_, _, _)		: cc += 1; 	// params: (Expression expression, Expression thenBranch, Expression elseBranch), example: a ? b : c
	    			case /\for(_,_,_,_) 				: cc += 1;	// params: (list[Expression] initializers, Expression condition, list[Expression] updaters, Statement body)
	    			case /\for(_,_,_) 				: cc += 1;	// params: (list[Expression] initializers, list[Expression] updaters, Statement body)
	    			case /\foreach(_,_,_) 			: cc += 1;	// params: (Declaration parameter, Expression collection, Statement body)
	    			case /\while(_,_) 				: cc += 1;	// params: (Expression condition, Statement body)
		    		case \infix(_, /^\|\||&&$/, _) 	: cc += 1; 	// params: (Expression lhs, str operator, Expression rhs), example: (a && b ), (a || b)
	    		}
	    		units += <x.decl, lc, cc>;
    		}
    	case Declaration x:class(_, /simpleName(a), _, body) : {
    		if(contains(a, "Test")){
	    		visit(body) {
	    			case /assert/ : numberOfAsserts += 1;
	    		}
    		}
    	}
	}
	return <units, numberOfAsserts>;
}	
