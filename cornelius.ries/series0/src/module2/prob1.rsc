module module2::prob1

import IO;
import List;

int fact2(int i){
	if(i == 1)
		return i;
	else
		return i * fact2(i-1);
}

int countTZeros(int i){

	if(i<10)
		return 0;
	else if (i % 10 == 0)
		return 1 + countTZeros(i/10);
	else
		return 0;

}

/*List[int] getLast20(int n){
	return for(y  <- [n-19..n+1]){
		append countTZeros(fact(y));
	}
}*/

void printLast20(int n){
	for(y  <- [n-19..n+1]){
		println("<y>! has <countTZeros(fact2(y))> zeros.");
	}
}

void findLumps (int n){
	
	prevNumsZero = 0;
	for(y <- [1..n ]){
		numsZero = countTZeros(fact2(y));
		if(numsZero > prevNumsZero)
			println("<y>! has added <numsZero-prevNumsZero> zeros!");
		prevNumsZero = numsZero;
	}

}