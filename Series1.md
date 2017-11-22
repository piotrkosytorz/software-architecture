# Series 1

This documents contains our notes and answers to the questions about software metrics (practical lab Series 1).

## Relevant questions

The following are the questions stated in practical lab Series 1:

1. Which metrics are used?
1. How are these metrics computed?
1. How well do these metrics indicate what we really want to know about these systems and how can we judge that?
1. How can we improve any of the above?

## Answers

### Which metrics are used?

The following metrics were proposed: 

* Volume,
* Unit Size,
* Unit Complexity,
* Duplication.

SIG model metrics:

* Maintainability (overall),
* Analysability,
* Changeability,
* Testability.

### How are these metrics computed?

We used the following strategies to count specific metrics:

#### Volume
The basic measure for volume (according to \[1\]) is the number of lines of code in the project. 
In our soultion we count all lines of code in the whole project of all `.java` files (including tests). 
To reach the best results we purify the source code files before counting the number of lines per file by:
* Trimming all lines of code (removing white spaces from the beginning and the end of line)
* After trimming - removing all empty lines in given file
* Removing single-line comment (where the line starts with `//`)
* Removing multi-line comments - `/* ... */`(in all variants such as a comment beginning in one line just after code, etc.)
We *do count curly braces* as lines of code.  

**Volume rating per unit**

As given in \[1\], we use the following table to as conversion basis to obtain the SIG volume score:

| rank | MY       | Java KLOC |
|------|----------|-----------|
|  ++  | 0 − 8    | 0-66      |
|  +   | 8 − 30   | 66-246    |
|  o   | 30 − 80  | 246-665   |
|  -   | 80 − 160 | 655-1,310 |
|  --  | > 160    | > 1, 310  |

#### Unit Size
Simillary to volume, Uint size is a count of lines of code per unit. We use Rascal's AST parser and retrieve units it. We purify each unit in simmilar way as described above (see: Volume) and count number of lines per unit. 

For benchmarking the unit size (possibly simmilar to SIG standards) we have used the following tresholds taken from \[3\]:

| CC    | Risk evaluation              |
|-------|------------------------------|
| <  30 | simple, without much risk    |
| 30-44 | more complex, moderate risk  |
| 44-74 | complex, high risk           |
| >  74 | untestable, very high risk   |

Maximum relative LOC:

| rank | moderate | high   | very high |
|------|----------|--------|-----------|
| ++   |   19.5%  | 10.9%  |   3.9%    |
| +    |   26.0%  | 15.5%  |   6.5%    |
| o    |   34.1%  | 22.2%  |   11.0%   |
| -    |   45.9%  | 31.4%  |   18.1%   |
| --   |    -     |   -    |   -       |


#### Unit Complexity
The default code complexity per unit is defined to be 1.
Based on information provided in \[1\] and \[2\], we decided to count the following statements as an increment of code complexity per unit: 
* case
* defaultCase
* catch
* do
* if
* conditional
* for
* foreach
* while
* &&
* ||

According to \[1\] we perform the following operations to optain the SIG score for CC:

First: Evaluate cc risks per unit based on thresholds from the following table:

| CC    | Risk evaluation              |
|-------|------------------------------|
| 1-10  | simple, without much risk    |
| 11-20 | more complex, moderate risk  |
| 21-50 | complex, high risk           |
| > 50  | untestable, very high risk   |

Finally: Score units per number of units falling int the following tresholds:
	 
Maximum relative LOC:
	  
| rank | moderate | high | very high   |
|------|----------|------|-------------|
| ++   | 25%      | 0%   | 0%          |
| +    | 30%      | 5%   | 0%          |
| o    | 40%      | 10%  | 0%          |
| -    | 50%      | 15%  | 5%          |
| --   | -        | -    | -           |


### How well do these metrics indicate what we really want to know about these systems and how can we judge that?

**TODO**: *Explain per metric and case, give examples.*

### How can we improve any of the above?

**TODO**: *Propose improvements, give examples.*

# References

\[1\] I. Heitlager, T. Kuipers, and J. Visser. A Practical Model for Measuring Maintainability. *In Quality of Information and Communications Technology*, 2007. QUATIC 2007. 6th International Conference on the, pages 30–39, Sept 2007.

\[2\] Jurgen J. Vinju and Michael W. Godfrey. What Does Control Flow Really Look Like? Eyeballing the Cyclomatic Complexity Metric. International Working 

\[3\] Alves, T.L., Correia, J.P., and Visser, J. (2011). Benchmark-based aggregation of metrics to ratings. In Proceedings - Joint Conference of the 21st International Workshop on Software Measurement, IWSM 2011 and the 6th International Conference on Software Process and Product Measurement, MENSURA 2011, pp. 20–29.
