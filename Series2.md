# Series 2

This documents contains our notes and answers to the questions about software metrics (practical lab Series 2).

Authors

* Cornelius Ries
* Piotr Kosytorz

## About

TODO

## Tool usage

TODO

## Results

TODO

## Duplication Detection

The idea or algotihm of our duplication detection is based on the information from \[1\] and \[2\] 

### How it works (Pseudocode)

```
Build the AST of the project.

For all nodes in AST if size > threshold
- Clean nodes for type 1 detection.
- Clean nodes for type 2 detection.
- Collect nodes in map with cleaned node as key, relation of original node and location as value

For all keys in Map build a set of duplications
- Collect all values
- If size of values > 1 add to set

Filter subclones
- For all duplications
- If another duplication exists for which all locations include the locations of the current one Then
    -
  Else
    Add to new Set
    
For all filtered clones
- Collect them in output format

```

## Visualization

TODO

## Tests

All tests are in seperate files that extend their original rascal module:

* DuplicationsAnalyzerTests
* RaterTests
* UtilsTests

To run the tests, import all the modules above and execute :test in the rascal console.

## References

\[1\] Lazar, F.-M. & Banias, O., 2014. Clone detection algorithm based on the Abstract Syntax Tree approach. Applied Computational Intelligence and Informatics (SACI), 2014 IEEE 9th International Symposium on, pp.73–78.

\[2\] Baxter et al., 1998. Clone detection using abstract syntax trees. Software Maintenance, 1998. Proceedings., International Conference on, pp.368–377.
