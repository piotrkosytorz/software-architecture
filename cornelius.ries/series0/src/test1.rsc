module test1

import IO;
import Node;
import Map;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::m3::AST;

Declaration myModel = createAstFromFile(|file:///home/meld0/software/Blub.java|, false);

void printMethods(){
	visit(myModel){
    	case Declaration m:method(a,b,c,d,e) : println("I found a method <b>. It  returns <getName(a)>. Wants arguments <c>. Throws <d>. And something else <e>.");
    }
}

// case Declaration m : analyzeMethod(m);
void analyzeMethod(node m){
	name = getName(m);
	if(name  == "method")
		println(m[1]);
}

public map[str,int] count(node N){      
  freq = ();                            
  visit(N){                             
    case node M: { name = getName(M);   
                   freq[name] ? 0 += 1; 
                 }
  }
  return freq;
}

public map[str,int] countRelevant(node N, set[str] relevant) = domainR(count(N), relevant); 

// case method(_,name,_,_) : println(name)

// case node M : { name = getName(M); println(name); }