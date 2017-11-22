module Types

/**
 * Module Types
 * ========================================================================
 * Provides custom types for Analyzer and Rater.
 */
 
alias unitsInfo = list[tuple[loc l, int lc, int cc]];
alias dupsInfo = set[set[loc]];
alias analysisInfo = tuple[unitsInfo units, dupsInfo dups];

alias score = tuple[int v, str s];
public tuple[score vh, score h, score m , score l, score vl] scores = <<2,"++">,<1,"+">,<0,"o">,<-1,"-">,<-2,"--">>;

alias unitScore = tuple[int m, int h, int vh, score s];
alias dupScore = tuple[int p, score s];
alias testingScore = tuple[int p, score s];