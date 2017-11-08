module module1::even

import List;
import IO;

list[int] even1(int  N){
	ret = [];
	ret = for(y <- [0..N], y % 2 == 0)
			append y;
	return ret;	
}

list[int] even2(int  N){
	return for(y <- [0..N], y % 2 == 0)
			append y;
}

list[int] even3(int  N){
	return [y | y <- [0..N ],  y % 2 == 0];
}