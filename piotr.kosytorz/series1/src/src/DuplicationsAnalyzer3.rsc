module DuplicationsAnalyzer3

import IO;
import List;
import String;
import Types;
import Map;
import Set;

import Utils;

import util::ValueUI;

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::m3::AST;

public int detectClones(set[loc] files){

	set[Declaration] decs = createAstsFromFiles(files, true);
	list[tuple[str, loc]] allBlocks = [];
	visit(decs){
		// collect all possible duplication blocks
		case Statement st:block(x) : {
			loc src = st.src;
			int srcLC = 1 + src.end.line - src.begin.line;
			if(srcLC >=  6){
				str srcC = readFile(src);
				allBlocks += <srcC, src>;
			}
		}
	}
	list[set[loc]] allDups = [];
	// calculate duplicates based on string comparison
	for(<s,l> <- allBlocks){
		set[loc] blub = ({l} | it + l2 | <s2,l2> <- allBlocks, s2 == s);
		if(size(blub) > 1)
			allDups = allDups + blub;
	}
	// because we call toSet duplicate duplication findings are removed
	set[set[loc]] dups = toSet(allDups);
	
	int duplicatedCode = 0;
	for(set[loc] dup <- dups){
		duplicatedCode += (0 | it + 1 + el.end.line - el.begin.line | el <- tail(toList(dup)));
	}
	return duplicatedCode;
}
