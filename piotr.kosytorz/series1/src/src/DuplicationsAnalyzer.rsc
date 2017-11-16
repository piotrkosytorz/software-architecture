module DuplicationsAnalyzer

import IO;
import List;
import Utils;

import util::ValueUI;

private tuple[loc, int, str] getMetaDataTouple(loc fileLoc, int lineNumber, str lineStr) {
	return <fileLoc, lineNumber, lineStr>;
}

private bool lineStartsInSourceBlock (tuple[loc fileLoc, int lineNumber, str lineStr] line, list[tuple[loc fileLoc, int firstLineNumber, int lastLineNumber]] sourceBlocks) {
	for (sBlock <- sourceBlocks) {
		if (line.fileLoc == sBlock.fileLoc && line.lineNumber >= sBlock.firstLineNumber && line.lineNumber <= sBlock.lastLineNumber) {
			return true;
		}
	}
	return false;
}

public void detectClones(set[loc] files) {

	// combine files
	
	list[tuple[loc fileLoc, int lineNumber, str lineStr]] blob = [];
	
	duplicatesReport = [];
	detectedAsDuplicates = [];
	list[tuple[loc fileLoc, int firstLineNumber, int lastLineNumber]] detectedAsSources = [];
	int duplicatedLinesOfCode = 0;

	for (location <- files) {
		list[str] lines = readFileLines(location);
		
		int k = 1;	//line number
		for (line <- lines) {
			blob += getMetaDataTouple(location, k, line);
			k += 1;
		}
	}
	
	pureBlob = purifyBlob(blob);
	pureBlobLastIndex = size(pureBlob) - 1;
		
	// determine possible clones
	
	int part1index = 0;		// line 1 index
	for (line <- pureBlob) {
		
		if ((part1index + 7) < pureBlobLastIndex &&
			!lineStartsInSourceBlock(line, detectedAsSources)
		) {
		
			int part2index = 0;
			for (line2 <- pureBlob /*, part2index > (part1index + 6)*/) {
			
				if( part2index > part1index && // compare blocks that are upper in the blob with the ones that are lower & don't compare the same line
					line.lineStr == line2.lineStr
					) {	// start comparing only if lines are equal (optimization)
				
				
					// check consecutive lines 
					
					int i = 0;
					while (part2index+i < pureBlobLastIndex && 
						pureBlob[part1index].fileLoc == pureBlob[part1index+i].fileLoc &&		// file to file
						pureBlob[part2index].fileLoc == pureBlob[part2index+i].fileLoc &&		// file to file
						pureBlob[part1index+i].lineStr == pureBlob[part2index+i].lineStr) {
						i += 1;
					}
										
					if (i>5 && (<line.fileLoc, line.lineNumber> notin detectedAsDuplicates)) {
						duplicatesReport += <<line.fileLoc, line.lineNumber>,<line2.fileLoc,line2.lineNumber>,i>;
						detectedAsSources += <line.fileLoc, line.lineNumber, line.lineNumber+i>;
						detectedAsDuplicates += <line2.fileLoc,line2.lineNumber>;
						duplicatedLinesOfCode += i;
					}
					
				}
				part2index += 1;
			}
		} 
		// x = get 6 lines
		// y = from 7th line: get 6 lines and compare it to x 
		// if it is the same, then record that y duplicates x
		// move y to the next line and repeat 
		// repeat until end of blob
		
		// this gives a (heavily redundant) list of duplications
		part1index += 1;
	}
	
	//text(detectedAsSources);
	//text(detectedAsDuplicates);
	text(duplicatesReport);
	println("Total duplicated lines of code: <duplicatedLinesOfCode>");
	
}