module UtilsTests

extend Utils;

test bool purifyContentsTest(list[str] contents, bool ignoreImports){
	list[str] pcontents = purifyContents(contents, ignoreImports);
	return size(pcontents) <= size(contents);
}

test bool purifyContentsTest2(list[str] contents){
	list[str] pcontents = purifyContents(contents, true);
	for(line <- pcontents){
		if(startsWith(line, "*")) return false;
		if(startsWith(line, "/*")) return false;
		if(startsWith(line, "//")) return false;
		if(startsWith(line, "*/")) return false;
		
	}
	return true;
}

test bool countLinesTest(list[str] contents){
	int lc = countLines(contents);
	return lc <= size(contents);
}