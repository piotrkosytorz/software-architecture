module module1::fizz

import List;
import IO;

list[str] buzz1(){
	ret  = [];
	
	for(y <- [1..100]){
		if(y % 3 == 0 && y % 5 == 0){
			ret  +=  "FizzBuzz";
		} else if(y % 3 == 0){
			ret  +=  "Fizz";
		} else if(y % 5 == 0){
			ret  +=  "Buzz";
		} else {
			ret  +=  "<y>";
		}
	}
	return ret;
}

void buzz2(){
	for(y <- [1..100]){
		switch(< y % 3 == 0, y % 5 == 0>){
			case <true, true> : println("FizzBuzz");
			default: println(y);
		}
	}
}