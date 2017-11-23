module DuplicationsAnalyzer2

import IO;
import List;
import String;
import Type;
import Map;

import Utils;

import util::ValueUI;

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;

private tuple[str, loc, int] getLineTriple(str lineStr, loc fileLoc, int lineNumber) {
	return <lineStr, fileLoc, lineNumber>;
}

set[loc] location2files (loc location) {
	// m3 object
 	M3 m = createM3FromEclipseProject(location);

	// project files
 	return extractFilesFromM3(m);	
}


public lrel[str content, loc fileLoc, int lineNumber] extractBlocks(set[loc] files) {
	
	lrel[str content, loc fileLoc, int lineNumber] blob = [];

	// for all files -> prepare 6-lines code blocks 
	for (file <- files) {
		list[str] lines = readFileLines(file);
		purifiedLines = purifyContents(lines, true); 
		
		fileSize = size(purifiedLines);
		
		if (fileSize >= 6) {	
			for (i <- [0..fileSize-5]) {
				//println(line);
				// create 6-lines blocks
				
				str hash = "";
				for (j <- [0..6]) {
					hash += purifiedLines[i+j];
				}
				
				blob += <hash, file, i+1>;
			}
		}
	}
	
	// merge group keys (whole groups)
	
	// remove duplicates (by key)
	
	// check all pairs if they are each others' substrings -> yes? remove the shorter one
	
	
	// now all the blocks are in the variable
	return blob;
}

public int detectClones(set[loc] files) {
	blob = extractBlocks(files);
	lrel[int index, str content, loc fileLoc, int lineNumber, int occurs] blob2 = [];
	lrel[str content, loc fileLoc, int lineNumber, int occurs] groups = [];
	list[lrel[int index, str content, loc fileLoc, int lineNumber, int occurs]] grouped = [];
	
	cloneCandidates = distribution(blob.content - dup(blob.content));
		
	// extract clone candidates
	int index = 0;
	for (element <- blob) {
		if (element.content in cloneCandidates) {
			blob2 += <index, element.content, element.fileLoc, element.lineNumber, cloneCandidates[element.content]+1>; 
			index += 1;
		}
	}
	
	int blob2size = size(blob2);
	lrel[int index, str content, loc fileLoc, int lineNumber, int occurs] currentGroup = [];
	currentGroup += blob2[0];
	
	//tuple[str content, loc fileLoc, int lineNumberBegin, int lineNumberEnd, int occurs] currentChunk;
	lrel[str content, loc fileLoc, int lineNumberBegin, int lineNumberEnd, int occurs] chunks = [];
	
	tuple[str content, loc fileLoc, int lineNumberBegin, int lineNumberEnd, int occurs] currentChunk = <blob2[0].content, blob2[0].fileLoc, blob2[0].lineNumber,  blob2[0].lineNumber, blob2[0].occurs>;
	
	// I always itreate from the top to bottom, so the line numbers are always sorted
	for (i <- [1..blob2size]) {
		// detect the biggest chunks of duplicated code 
		// group blocks that have the same location and consecutive lines
		if (!isEmpty(currentGroup) && last(currentGroup).fileLoc == blob2[i].fileLoc && last(currentGroup).lineNumber == (blob2[i].lineNumber-1)) {
			currentGroup += blob2[i];
			currentChunk = <currentChunk.content + blob2[i].content, currentChunk.fileLoc, currentChunk.lineNumberBegin,  blob2[i].lineNumber, min([currentChunk.occurs, blob2[i].occurs])>;
		} else {
			grouped += [currentGroup];
			chunks += currentChunk;
			currentGroup = [blob2[i]];
			currentChunk = <blob2[i].content, blob2[i].fileLoc, blob2[i].lineNumber,  blob2[i].lineNumber, blob2[i].occurs>;
		}
	}
	
	if (!isEmpty(currentGroup)) {
		grouped += [currentGroup];	
		chunks += currentChunk;
	}
	
	// get number of lines of duplicates from the groups (the groups don't contain the "originals"!)
	
	map[str, tuple[loc fileLoc, int lineNumberBegin, int lineNumberEnd, int occurs]] chunksMap = ();
	map[str, tuple[loc fileLoc, int lineNumberBegin, int lineNumberEnd, int occurs]] finalChunks = ();
	
	// lrel[str content, loc fileLoc, int lineNumberBegin, int lineNumberEnd, int occurs] finalChunks = [];
	
	for (chunk <- chunks) {
		chunksMap += (chunk.content: <chunk.fileLoc, chunk.lineNumberBegin, chunk.lineNumberEnd, chunk.occurs >);
	}	
	
	int duplicatesCount = 0;
	
	// sum 
	for (chunk <- toList(chunksMap)) {
		duplicatesCount += (6+chunk[1].lineNumberEnd - chunk[1].lineNumberBegin) * chunk[1].occurs;
	}
	
	return duplicatesCount;

}

