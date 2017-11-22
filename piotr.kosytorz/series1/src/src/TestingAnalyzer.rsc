module TestingAnalyzer


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

public int getAsserts(set[Declaration] declarations) {

	int numberOfAsserts = 0;
	
	visit(declarations){
	
    	case Declaration x:class(_, /simpleName(a), _, body) : {
    		if(contains(a, "TestCase")){
	    		visit(body) {
	    			case /assert/ : numberOfAsserts += 1;
	    		}
    		}
    	}
    	
	}
	
	return numberOfAsserts;
}	