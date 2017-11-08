module ass1

import IO;
import String;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

public M3 m = createM3FromEclipseProject(|project://JavaTestProject|);

public int countProjectLines(M3 m){
	
	int ret = 0;
	
	list[loc] files = [ to | <to,from> <- m.containment, to.scheme == "java+compilationUnit"];
	for(f <- files){
		ret +=  countLines(f);
	}
	
	return ret;
}

public int countLines(loc file){
	list[str] lines = readFileLines(file);
	int ret = 0;
	for(l <- lines){
		str lt = trim(l);
		if(lt != "" && !startsWith(lt, "//") && !startsWith(lt, "/*") && !startsWith(lt, "*")){
			ret += 1;
		}
	}
	return ret;
}