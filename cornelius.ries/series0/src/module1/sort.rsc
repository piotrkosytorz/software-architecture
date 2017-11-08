module module1::sort

import List;
import IO;

// sort1: uses list indexing and a for-loop

list[int] sort1(list[int] numbers){
	if(size(numbers) > 0){
     for(int i <- [0 .. size(numbers)-1]){
       if(numbers[i] > numbers[i+1]){
         <numbers[i], numbers[i+1]> = <numbers[i+1], numbers[i]>;
         return sort1(numbers);
       }
    }
  }
  return numbers;

}

// sort2: uses list matching and switch

list[int] sort2(list[int] numbers){
  switch(numbers){
    case [*int nums1, int p, int q, *int nums2]:
       if(p > q){
          return sort2(nums1 + [q, p] + nums2);
       } else {
       	  fail;
       }
     default: return numbers;
   }
}

// sort3: uses list matching and while

list[int] sort3(list[int] numbers){
  while([*int nums1, int p, *int nums2, int q, *int nums3] := numbers && p > q)
        numbers = nums1 + [q] + nums2 + [p] + nums3;
  return numbers;
}

// sort4: using recursion instead of iteration, and splicing instead of concat
list[int] sort4([*int nums1, int p, *int nums2, int q, *int nums3]) {
  if (p > q)
    return sort4([*nums1, q, *nums2, p, *nums3]);
  else
    fail sort4;
}

default list[int] sort4(list[int] x) = x;

// sort5: inlines the condition into a when:
list[int] sort5([*int nums1, int p, *int nums2, int q, *int nums3])
  = sort5([*nums1, q, *nums2, p, *nums3])
  when p > q;

default list[int] sort5(list[int] x) = x;