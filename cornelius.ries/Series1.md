#### Test Quality
For test quality we count all the assert statements Test classes in the code \[1\].
After counting the assert statements we calculate the percentage based on the total number of units in the system.

For benchmarking the test quality we have used the following tresholds:

| rank | percentage |
|------|------------|
| ++   |   95-100%  |
| +    |   80-95%   |
| o    |   60-80%   |
| -    |   20-60%   |
| --   |   0-20%    |

#### Unit Interfacing
For information on how to compute this metric we have looked for different papers and found \[3\].
For unit interfacing we count all the parameters for all methods in the system using the AST.
After gathering the information we calculate a risk profile based on the following scheme:

We seperate the units based on the information below and calculate a percentage against the whole number of units.

| number of parameters      | Risk evaluation              |
|---------------------------|------------------------------|
| <  2 						          | without much risk    |
| == 2                      | moderate risk  |
| == 3                      | high risk           |
| >  4                      | very high risk   |

After that we calculate the score based on the following thresholds:

| rank | moderate | high   | very high |
|------|----------|--------|-----------|
| ++   |   12.1%  |  5.4%  |   2.2%    |
| +    |   14.9%  |  7.2%  |   3.1%    |
| o    |   17.7%  | 10.2%  |   4.8%    |
| -    |   25.2%  | 15.3%  |   7.1%    |
| --   |    -     |   -    |   -       |

