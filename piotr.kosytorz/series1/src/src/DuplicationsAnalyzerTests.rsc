module DuplicationsAnalyzerTests

extend DuplicationsAnalyzer;

test bool getSizeTest(node n){
	int size = getSize(n);
	return size > 0;
}

test bool cleanNodeTest(node n){
	node cn = cleanNode(n);	
	return getSize(n) == getSize(cn);
}

test bool cleanNodeType2Test(node n){
	node cn = cleanNodeType2(n);	
	return getSize(n) == getSize(cn);
}