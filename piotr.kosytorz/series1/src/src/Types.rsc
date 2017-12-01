module Types

/**
 * Module Types
 * ========================================================================
 * Provides custom types for Analyzer and Rater.
 */
 
alias unitInfo = tuple[loc l, int lc, int cc, int np];
alias unitsInfo = list[unitInfo];
alias astInfo = tuple[unitsInfo ui, int numberOfAsserts];
alias dupsInfo = set[set[loc]];
alias analysisInfo = tuple[unitsInfo units, dupsInfo dups];

alias score = tuple[int v, str s];
public tuple[score vh, score h, score m , score l, score vl, score e] scores = <<2,"++">,<1,"+">,<0,"o">,<-1,"-">,<-2,"--">,<-99,"Error">>;

alias unitScore = tuple[int m, int h, int vh, score s];
alias dupScore = tuple[int p, score s];
alias testingScore = tuple[int p, score s];

data Duplication(
	int cloneId = 0,
	list[loc] locations = [],
	int cloneType = 0,
	int lines = 0
);

data Duplication = Duplication(int cloneId, list[loc] locations, int cloneType, int lines);