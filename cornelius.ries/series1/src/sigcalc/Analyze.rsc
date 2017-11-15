module sigcalc::Analyze

import IO;
import Set;
import List;

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::m3::AST;

import sigcalc::Types;
import sigcalc::Util;

// analyze a project
public analysisInfo analyzeProject(loc project){
	println("Loading Model ...");
	M3 m = createM3FromEclipseProject(project);
	println("Model loading finished...");
	set[loc] files = {};
	int volume = 0;
	unitsInfo units = [];
	println("Analyzing units ...");
	for(<to,from> <- m.containment, to.scheme == "java+compilationUnit"){
		println("Collecting <to> ...");
		volume += calcVolume(to);
		files += to;
	}
	println("Analyzing ...");
	analysisInfo info  = analyzeProjectOpt(files);
	info.locs = volume;
	return info;
}

// analyze a project and save results to data file
public void analyzeProjectSave(loc project, loc dataFile){
	analysisInfo info  = analyzeProject(project);
	saveData(dataFile, info);
}

// analyze Unit CC, Unit Size and Duplications
private analysisInfo analyzeProjectOpt(set[loc] files) {
	set[Declaration] decs = createAstsFromFiles(files, true);
	list[tuple[str, loc]] allBlocks = [];
	unitsInfo units = [];
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
		// calculate unit size and complexity
		case Declaration x:method(_,_,_,_,e) : {
    		list[str] lines = readFileLines(x.src);
			int lc = countLines(lines);
			
    		int cc = 1;
    		visit(e){
    			case /\if(exp,_) : cc += 1;
    			case /\if(exp,_,_) : cc += 1;
    			case /\case(_) : cc += 1;
    			case /\defaultCase() : cc += 1;
    			case /\foreach(_,_,_) : cc += 1;
    			case /\for(_,_,_,_) : cc += 1;
    			case /\for(_,_,_) : cc += 1;
    			case /\while(exp,_) : cc += 1;
    		}
    		units += <x.decl, lc, cc>;
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
	return <0, units, toSet(allDups)>;
}

private int countConditions(Expression exp){
	int x = 0;
	visit(exp){
    	case /&&/ : x += 1;		
    	case /||/ : x += 1;	
    }
    return x;
}
