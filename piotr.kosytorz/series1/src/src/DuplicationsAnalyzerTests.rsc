module DuplicationsAnalyzerTests

extend DuplicationsAnalyzer;

import lang::java::m3::AST;

import util::FileSystem;

import Configuration;

// Random Tests

// There should always be a positive > 0 value because a node has already a size of 1
test bool getSizeTest(node n){
	int size = getSize(n);
	return size > 0;
}

// The cleanNode function should not add / remove any nodes
test bool cleanNodeSizeTest(node n){
	node cn = cleanNode(n);	
	return getSize(n) == getSize(cn);
}

// The cleanNodeType2 function should not add / remove any nodes
test bool cleanNodeType2SizeTest(node n){
	node cn = cleanNodeType2(n);	
	return getSize(n) == getSize(cn);
}

// The size of the map can increase
test bool collectBucketSizeTest(map[node, lrel[node, loc]] buckets, node n, loc src){
	map[node, lrel[node, loc]] bucketsResult = collectBucket(buckets, n, src);
	return size(bucketsResult) >= size(buckets);
}

// The node should be added to the map
test bool collectBucketElementTest(map[node, lrel[node, loc]] buckets, node n, loc src){
	map[node, lrel[node, loc]] bucketsResult = collectBucket(buckets, n, src);
	return n in bucketsResult;
}

// If duplication size < 2 we expect error code (0)
//test bool detectCloneTypeTest(lrel[node,loc] duplication){
//	int ctype = detectCloneType(duplication);
//	return size(duplication) > 1 ? ctype == 2 : ctype == 0;
//}

// For the rascal tests it is always false
test bool containsTest1(lrel[node,loc] duplicate2, loc l){
	bool c = contains(duplicate2, l);
	return c == false;
}

// If l1 contains l2 then l2 should not contain l1 (commutativity)
test bool containsTest2(loc l1, loc l2){
	bool c = contains(l1, l2);
	return c == true ? c != contains(l2, l1) : true;
}

private set[Declaration] getTestAst(){

	set[Declaration] ast = createAstsFromFiles(files(projectLocation + "/test"), true);
	return ast;

}

// Tests using test files

test bool collectBucketsTestWithTestProject(){
	set[Declaration] decs = getTestAst();
	map[node, lrel[node, loc]] buckets = collectBuckets(decs, 20);
	if(18 != size(buckets)) return false;
	return true;
}

test bool collectDuplicationsWithTestProject(){
	set[Declaration] decs = getTestAst();
	map[node, lrel[node, loc]] buckets = collectBuckets(decs, 20);
	list[lrel[node,loc]] dups = collectDuplications(buckets);
	if(13 != size(dups)) return false;
	return true;
}

test bool filterSubClonesWithTestProject(){
	set[Declaration] decs = getTestAst();
	map[node, lrel[node, loc]] buckets = collectBuckets(decs, 20);
	set[lrel[node,loc]] dups = toSet(collectDuplications(buckets));
	set[lrel[node,loc]] filteredDups = filterSubClones(dups);
	if(4 != size(filteredDups)) return false;
	return true;
}

test bool generateOutputWithTestProject(){
	set[Declaration] decs = getTestAst();
	map[node, lrel[node, loc]] buckets = collectBuckets(decs, 20);
	set[lrel[node,loc]] dups = toSet(collectDuplications(buckets));
	set[lrel[node,loc]] filteredDups = filterSubClones(dups);
	int lines = generateOutput(filteredDups);
	if(146 != lines) return false;
	if(size(duplicationResult) != 4) return false;
	return true;
}