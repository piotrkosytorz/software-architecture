module module2::prop4

// Define ColoredTrees with red and black nodes and integer leaves

data ColoredTree = leaf(int N) 
                 | red(ColoredTree left, ColoredTree right)
                 | black(ColoredTree left, ColoredTree right);

public ColoredTree  rb = red(black(leaf(1), red(leaf(2),leaf(3))), black(leaf(3), leaf(4)));

// Count the number of red nodes

int cntRed(ColoredTree t){
   int c = 0;
   visit(t) {
     case red(_,_): c = c + 1; 
   };
   return c;
}

test bool tstCntRed() = cntRed(rb) == 2;

// Compute the sum of all integer leaves

int addLeaves(ColoredTree t){
   int c = 0;
   visit(t) {
     case leaf(int N): c = c + N; 
   };
   return c;
}

test bool tstAddLeaves() = addLeaves(rb) == 13;

// Add green nodes to ColoredTree

data ColoredTree = green(ColoredTree left, ColoredTree right); 

// Transform red nodes into green nodes

ColoredTree makeGreen(ColoredTree t){
   return visit(t) {
     case red(l, r) => green(l, r) 
   };
}
