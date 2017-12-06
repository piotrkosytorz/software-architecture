module DuplicationsAnalyzer

import IO;
import List;
import String;
import Types;
import Map;
import Set;
import Type;
import Node;

import Utils;
import Types;

import util::ValueUI;

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::m3::AST;
import analysis::m3::AST;

import lang::json::IO;

public list[Duplication] duplicationResult = [];

public void detectClones(set[Declaration] decs, int sizeThreshold){

	map[node, lrel[node, loc]] buckets = collectBuckets(decs, sizeThreshold);

	set[lrel[node,loc]] dups = toSet(collectDuplications(buckets));
	
	set[lrel[node,loc]] filteredDups = filterSubClones(dups);
	
	generateOutput(filteredDups);

}

private map[node, lrel[node, loc]] collectBuckets(set[Declaration] decs, int sizeThreshold){
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
	node nn = cleanNode(n);
	nn = cleanNodeType2(nn);
	if (buckets[nn]?) {
		buckets[nn] += <n, src>;	
	} else {
		buckets[nn] = [<n, src>];
	}
	return buckets;
}

private list[lrel[node,loc]] collectDuplications(map[node, lrel[node, loc]] buckets){
	return for(key <- buckets){
		lrel[node,loc] duplications = buckets[key];
		if(size(duplications) > 1){
			append duplications;
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
	return any(<n2,l2> <- duplicate2, contains(l2, l));
}

private bool contains(loc l1, loc l2){
	if(l1.uri == l2.uri && l1 > l2)
		return true;
	else
		return false;
}

private node cleanNode(node n){
	return visit(n){
		case Declaration x : {
			x.src = unknownSource;
			x.decl = unresolvedDecl;
			x.typ = \any();
			x.modifiers = [];
			x.messages = [];
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
			x.typ = \any();
			insert x;
		}
		case Type x : {
			x.name = unresolvedType;
			x.typ = \any();
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

private void generateOutput(set[lrel[node,loc]] duplications){
	int i = 0;
	duplicationResult = [];
	for(lrel[node,loc] duplication <- duplications){
		list[Location] locs = ([] | it + Location(l.uri, l.begin.line, l.end.line, readFile(l)) | <n,l> <- duplication, l != unknownSource);
		int cloneType = detectCloneType(duplication);
		Duplication output = Duplication(i, locs, cloneType);
		duplicationResult += output;
		i += 1;
	}
}

private int detectCloneType(lrel[node,loc] duplication){
	int ret = 0;
	
	tuple[node n, loc l] node1 = duplication[0];
	tuple[node n, loc l] node2 = duplication[1];
	node1Clean = cleanNode(node1.n);
	node2Clean = cleanNode(node2.n);

	if(node1Clean == node2Clean) 
		ret = 1;
	else
		ret = 2;
	
	return ret;
}