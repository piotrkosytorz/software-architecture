module DuplicationsAnalyzer3

import IO;
import List;
import String;
import Types;
import Map;
import Set;
import Type;
import Node;

import Utils;

import util::ValueUI;

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::m3::AST;
import analysis::m3::AST;

private int sizeThreshold = 20;

public int detectClones(set[Declaration] decs){

	map[node, lrel[node, loc]] buckets = collectBuckets(decs);

	set[lrel[node,loc]] dups = toSet(collectDuplications(buckets));
	
	set[lrel[node,loc]] filteredDups = filterSubClones(dups);
	
	int duplicatedCode = 0;
	
	for(lrel[node,loc] dup <- filteredDups){
		println("Match");
		for(<n,l> <- dup){
			if(l != unknownSource){	
				iprintln(l);
				duplicatedCode += 1 + l.end.line - l.begin.line;
			}
		}
	}
	
	return duplicatedCode;
}

private map[node, lrel[node, loc]] collectBuckets(set[Declaration] decs){
	map[node, lrel[node, loc]] buckets = ();
	visit(decs){
		// collect all possible duplication blocks
		case Declaration n : {
			if(getSize(n) >= sizeThreshold){
				loc src = n.src;
				if(src == unknownSource){
					// bugfix for variables
					top-down-break visit(n) {
						case Expression e: variable(_,_,_) : {
							src = e.src;
						}
					}
				}	
				buckets = collectBucket(buckets, n, src);
			}
		}
		case Statement n : {
			if(getSize(n) >= sizeThreshold){
				loc src = n.src;
				buckets = collectBucket(buckets, n, src);
			}
		}
		case Expression n : {
			if(getSize(n) >= sizeThreshold){
				loc src = n.src;
				buckets = collectBucket(buckets, n, src);
			}
		}
		
	}
	return buckets;
}

private map[node, lrel[node, loc]] collectBucket(map[node, lrel[node, loc]] buckets, node n, loc src){
	node nn = cleanNode(n, true);
	nn = cleanNodeType2(nn);
	if (buckets[nn]?) {
		buckets[nn] += <n, src>;	
	} else {
		buckets[nn] = [<n, src>];
	}
	return buckets;
}

private list[lrel[node,loc]] collectDuplications(map[node, lrel[node, loc]] buckets){
	return for(bucket <- buckets){
		lrel[node,loc] buks = buckets[bucket];
		if(size(buks) > 1){
			append buks;
		}
	}
}

private set[lrel[node,loc]] filterSubClones(set[lrel[node,loc]] duplicates){
	return ({} | it + duplicate1 | lrel[node,loc] duplicate1 <- duplicates, 
		!any(duplicate2 <- duplicates, 
			all(<n,l> <- duplicate1, contains(duplicate2, l))
		)
	);
}

private bool contains(lrel[node,loc] duplicate2, loc l){
	for(<n2,l2> <- duplicate2)
		if(contains(l2, l))
			return true;
	return false;
}

private bool contains(loc l1, loc l2){
	if(l1.uri == l2.uri && l1 > l2)
		return true;
	else
		return false;
}

private node cleanNode(node n, bool type2){
	return visit(n){
		case Declaration x : {
			x.src = unknownSource;
			x.decl = unresolvedDecl;
			if(type2) {
				x.typ = \any();
				x.modifiers = [];
				x.messages = [];
			}
			insert x;
		}
		case Statement x : {
			x.src = unknownSource;
			x.decl = unresolvedDecl;
			insert x;
		}
		case Expression x : {
			x.src = unknownSource;
			x.decl = unresolvedDecl;
			if(type2) {
				x.typ = \any();
			}
			insert x;
		}
		case Type x : {
			if(type2) {
				x.name = unresolvedType;
				x.typ = \any();
			}
			insert x;
		}
		
	}
}

private node cleanNodeType2(node n){
	return visit (n) {
		case Type _ => lang::java::m3::AST::float()
		case Modifier _ => lang::java::m3::AST::\public()
		case \method(_, _, a, b) => \method(lang::java::m3::AST::float(), "method", a, b)
		case \method(_, _, a, b, c) => \method(lang::java::m3::AST::float(), "method", a, b, c)
		case \parameter(a, _, b) => \parameter(a, "parameter", b)
		case \vararg(a, _) => \vararg(a, "vararg") 
		case \annotationTypeMember(a, _) => \annotationTypeMember(a, "annotationTypeMember")
		case \annotationTypeMember(a, _, b) => \annotationTypeMember(a, "annotationTypeMember", b)
		case \typeParameter(_, a) => \typeParameter("typeParameter", a)
		case \constructor(_, a, b, c) => \constructor("constructor", a, b, c)
		case \interface(_, a, b, c) => \interface("interface", a, b, c)
		case \class(_, a, b, c) => \class("class", a, b, c)
		case \enumConstant(_, a) => \enumConstant("enumConstant", a) 
		case \enumConstant(_, a, b) => \enumConstant("enumConstant", a, b)
		case \methodCall(a, _, b) => \methodCall(a, "methodCall", b)
		case \methodCall(a, b, _, c) => \methodCall(a, b, "methodCall", c)
		case \simpleName(_) => \simpleName("simpleName")
		case \number(_) => \number("125681651")
		case \variable(_, a) => \variable("variable", a) 
		case \variable(_, a, b) => \variable("variable", a, b) 
		case \booleanLiteral(_) => \booleanLiteral(true)
		case \stringLiteral(_) => \stringLiteral("stringLiteral")
		case \characterLiteral(_) => \characterLiteral("a")
	}
}

private int getSize(node n){
	int ret = 0;
	visit(n){
		case node x : ret+=1;
	}
	return ret;
}
