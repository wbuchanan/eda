# EDA (Exploratory Data Analysis)

Stata program that automates the generation of exploratory data analysis reports.  The program classifies variables as categorical/continuous variables and uses this information to define what types of graphs and tables to use.

## Use case
Since Exploratory Data Analysis can take a substantial amount of time in addition to the time needed to clean/prep data, this is intended to be used as a program that would be called at the end of the workday/overnight to produce permutations of univariate and bivariate visualizations and tables.  Then instead of spending time coding myriad possible combinations of variables to examine, a researcher could browse through a PDF generated through LaTeX while the computer does the work of compiling the results for them.

## Dependencies
This program requires a few other user-written programs to execute:

`tuples`
`spineplot`
`estout`

You can find information about these packages using:

```Stata
ssc d tuples
ssc d spineplot
ssc d estout
```








