module Utils

import String;
import List;
import lang::java::jdt::m3::Core;
import util::ValueUI;

public set[loc] extractFilesFromM3(M3 m) { 	
 	set[loc] files = {};		// physical locations of files

	// extracting files from project (only java files)
 	for(<to,from> <- m.containment, to.scheme == "java+compilationUnit"){
		files += to;
	}
	
	return files;
}

public list[str] purifyContents(list[str] contents) {

	list[str] pureContent = [];
	bool unclosedComments = false;
	
	for (line <- contents) {
		lt = trim(line);

		// removing multi-line comments
		
		// version 1: comments take full line(s)
		if(startsWith(lt, "/*")) {
			unclosedComments = true;
		}
		// version 2: comments start in the middle of the line
		elseif(!unclosedComments && contains(lt, "/*")) {
			// unlike in version 1, this line counts as code, so if it is not empty or is not a one-line comment, count it
			if(lt != "" && !startsWith(lt, "//")) {
				pureContent += lt;				
			}	
			unclosedComments = true;
		}
		
		// comment closing is always the same
		if(contains(lt, "*/")) {
			unclosedComments = false;
		}
		
		// removing empty lines and one-line comments, additionally removing multiline comments endings
		if(!unclosedComments && lt != "" && !startsWith(lt, "//") && !startsWith(lt, "*/")) {
			pureContent += lt;
		}
	}
	
	return pureContent;
}

test bool purifyContentsTest(list[str] contents){
	list[str] pcontents = purifyContents(contents);
	return size(pcontents) <= size(contents);
}

test bool purifyContentsTest2(list[str] contents){
	list[str] pcontents = purifyContents(contents);
	for(line <- pcontents){
		if(startsWith(line, "*")) return false;
		if(startsWith(line, "/*")) return false;
		if(startsWith(line, "//")) return false;
		if(startsWith(line, "*/")) return false;
		
	}
	return true;
}

public list[tuple[loc fileLoc, int lineNumber, str lineStr]] purifyBlob(list[tuple[loc fileLoc, int lineNumber, str lineStr]] blob) {
	
	list[tuple[loc fileLoc, int lineNumber, str lineStr]] pureBlob = [];
	
	bool unclosedComments = false;
	
	for (line <- blob) {
		lt = trim(line.lineStr);

		// removing multi-line comments
		
		// version 1: comments take full line(s)
		if(startsWith(lt, "/*")) {
			unclosedComments = true;
		}
		// version 2: comments start in the middle of the line
		elseif(!unclosedComments && contains(lt, "/*")) {
			// unlike in version 1, this line counts as code, so if it is not empty or is not a one-line comment, count it
			if(lt != "" && !startsWith(lt, "//")) {
				pureBlob += <line.fileLoc, line.lineNumber, lt>;				
			}	
			unclosedComments = true;
		}
		
		// comment closing is always the same
		if(contains(lt, "*/")) {
			unclosedComments = false;
		}
		
		// removing empty lines and one-line comments, additionally removing multiline comments endings
		if(!unclosedComments && 
			lt != "" && 
			!startsWith(lt, "//") && 
			!startsWith(lt, "*/") && 
			!startsWith(lt, "import ") &&
			!startsWith(lt, "package ")
			) {
				pureBlob += <line.fileLoc, line.lineNumber, lt>;				
		}
	}
	
	return pureBlob;
	
}

/**
 * Helper function for calcVolume, calculates code lines number per file 
 */
int countLines(list[str] contents) {	
	return size(purifyContents(contents));
}

test bool countLinesTest(list[str] contents){
	int lc = countLines(contents);
	return lc <= size(contents);
}