# EDA (Exploratory Data Analysis)

Stata program that automates the generation of exploratory data analysis reports.  The program classifies variables as categorical/continuous variables and uses this information to define what types of graphs and tables to use.

## Installation
To install `eda` use the following command from Stata:

```Stata
net inst eda, from(http://wbuchanan.github.io/eda)
```


## Use case
Since Exploratory Data Analysis can take a substantial amount of time in addition to the time needed to clean/prep data, this is intended to be used as a program that would be called at the end of the workday/overnight to produce permutations of univariate and bivariate visualizations and tables.  Then instead of spending time coding myriad possible combinations of variables to examine, a researcher could browse through a PDF generated through LaTeX while the computer does the work of compiling the results for them.

## Usage

You need a dataset open in memory to use `eda`. There are two required options, `output` for the naming of the output files 
and `root` to tell `eda` where to store the output. 

```Stata
sysuse auto // load the data
eda, o("eda-report") root("./") // use current working directory
```

Alternatively, you can restrict the variables to use for `eda` with a varlist: 

```Stata
clear
sysuse auto
eda price mpg weight, o("eda-report-small") root("./") 
```


## Dependencies
This program requires a few other user-written programs to execute:

`tuples`
`spineplot`
`estout`
`brewscheme`

You can install these dependencies using:

```Stata
ssc install tuples
ssc install spineplot
ssc install estout
net install brewscheme, from("https://wbuchanan.github.io/brewscheme")
```


You can find information about these packages using:

```Stata
ssc d tuples
ssc d spineplot
ssc d estout
```
