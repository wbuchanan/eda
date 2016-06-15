{smcl}
{* *! version 0.0.0 30OCT2015}{...}
{cmd:help eda}
{hline}

{marker edati}{p 2 2 2}{title:{hi:EDA}}{p_end}

{p 4 4 4}{hi:eda {hline 2}} A program for the automated generation of graphs and 
tables used in Exploratory Data Analyses ({help eda##edarefs:Tukey (1977)}. {p_end}

{marker edasyntax}{p 2 2 2}{title:{hi:Syntax}}{p_end}

{p 4 4 4}{cmd:eda} [{opt varlist}] [{opt using}] {ifin} , 
{cmdab:o:utput(}{it:string}{opt )} {cmdab:r:oot(}{it:string}{opt )}
[{cmdab:id:vars(}{it:varlist}{opt )} {cmdab:str:ok}[({it:varlist})]
{cmdab:minn:size(}{it:integer}{opt )} {cmdab:min:cat(}{it:integer}{opt )} 
{cmdab:max:cat(}{it:integer}{opt )} {cmdab:cat:vars(}{it:varlist}{opt )}
{cmdab:cont:vars(}{it:varlist}{opt )} {cmdab:auth:orname(}{it:string}{opt )} 
{cmdab:repo:ortname(}{it:string}{opt )} 
{cmd:scheme(}{it:string}{opt )} {cmd:keepgph} 
{cmdab:grlabl:ength(}{it:integer}{opt )} {cmdab:miss:ing} {cmdab:perc:ent}
{cmdab:nobargr:aphs} {cmdab:bargra:phopts(}{it:string}{opt )}
{cmdab:nopiec:harts} {cmdab:piech:artopts(}{it:string}{opt )}
{cmdab:nohisto:grams} {cmdab:histog:ramopts(}{it:string}{opt )}
{cmdab:kdens:ity} {cmdab:kdenso:pts(}{it:string}{opt )}
{cmdab:fivenum:sum} {cmdab:fnso:pts(}{it:string}{opt )}
{cmdab:nodistro:plots} {cmdab:distrop:lotopts(}{it:string}{opt )}
{cmdab:noladder:plots} {cmdab:noscat:terplots}
{cmd:lfit}[({it:string})] {cmd:qfit}[({it:string})]
{cmd:lowess}[({it:string})] {cmd:fpfit}[({it:string})]
{cmd:lfitci}[({it:string})] {cmd:qfitci}[({it:string})]
{cmd:fpfitci}[({it:string})] {cmdab:nobox:plots} {cmd:nomosaic} 
{cmdab:noheat:map} {cmdab:nobubble:plots} {cmdab:weight:type(}{it:int}{opt )}
{cmdab:comp:ile} {cmdab:pdfl:atex(}{it:string}{opt )} 
]

{marker edadesc}{p 2 2 2}{title:{hi:Description}}{p_end}

{p 4 4 4}{cmd:eda} is a program used to automate the production of an exploratory 
data analysis "report" of a data set.  With minimal user intervention, the 
program will use decision rules to classify variables as continuous vs categorical 
and use these variable lists to generate appropriate visualizations and summary 
statistics based on the properties of categorical and continuous variables.  For 
categorical variables, this means using bar graphs, pie charts, and mosaic plots 
to show univariate and bivariate distributions - as well as one and twoway 
tables of frequencies and percentages.  For continuous data, the program creates 
histograms (with options to overlay a kernel density plot and to include vertical 
reference lines showing Tukey's five number summary), distribution plots (e.g., 
quantile/q-norm, chi-norm, p-norm, etc...), ladder of powers graphs, scatterplots 
(with options to add fractional polynomial smoothers [with/without CI], quadratic 
smoothers [with/without CI], linear smoothers [with/without CI], and lowess 
smoothers [without CI]), weighted scatterplots (a.k.a., bubble plots), and a 
heatmap to illustrate the Pearson correlations.  Additionally, conditional 
distributions are also illustrated via box plots and tables of conditional 
descriptive statistics.  All of the output is place into separate subdirectories 
for graphs and tables and a single LaTeX source document is created to organize 
all of the output in a single document.{p_end}

{p 4 4 4}This program has several dependencies which you can find {help eda##edadeps:here}.  
If these programs are not available, the program will ask if you would like to 
install them.  If any response is no, the program will exit and not continue to 
run.  If the answer is yes to all, it will install each of the dependencies 
sequentially. {p_end}

{p 4 4 4}The help file is divided into several segments that hopefully will make 
it easier for you to find information quickly about the options you need/want to 
use.  {help eda##edaexplain:Required Arguments} contains information about 
parameters that must always have a value for the program to run.  {help eda##edaopts:Optional Arguments} 
is the start of the section of the help file listing all of the optional parameters.  
{help eda##classify:Variable Classification} contains arguments related to the way 
the program classifies variables as categorical/continuous. {help eda##edaglobals:Global Options} 
contains information about options that affect the resulting LaTeX document or the 
production of graphs on a global scale (e.g., everything the program does).  
{help eda##edacatdist:Univariate Graphs - Categorical Variables} contains information 
about the options available for the control/rendering of bar graphs/pie charts.  
{help eda##edacontdist:Univariate Graphs - Continuous Variables} contains information 
about the options available for the control/rendering of histograms, ladder of powers 
graphs, and distribution quality graphs.  {help eda##edascatter:Bivariate Graphs - Continuous Variables} contains 
information about the production/rendering of scatterplots and the associated smoothers available for 
scatterplots.  {help eda##edaboxp:Bivariate Graphs - Conditional Distributions} contains the option 
used to control the production of box plots.  {help eda##edamos:Bivariate Graphs - Categorical Variables} 
contains information used to control the production of mosaic - or {help eda##edadeps:spineplots}.  
{help eda##edamvcont:Multivariate Graphs - Continuous Variables} contains information used to 
control options related to bubble plots and heatmaps.  {help eda##edatex:LaTeX Options} contains 
information about the options used to automatically compile the LaTeX source code and/or 
method to specify the path to the LaTeX binary when creating the compilation script. {p_end}


{marker edaexplain}{p 2 2 2}{title:{hi:Required Arguments}}{p_end}{break}
{p 4 4 8}The following options are required for the program to run and must be 
supplied by the end user.  {p_end}{break}
{p 4 4 8}{cmdab:o:utput} is used to supply the program with the name stub to use 
for the LaTeX source code file.  {it:Note: Do not include the file extension in this argument.}  
For example, o("eda-report") is a suitable value, but o("eda-report.tex") is not.  
The program appends the file extension to this name in the background.{p_end}

{p 4 4 8}{cmdab:r:oot} is used to tell the program where to store the output and 
create two subdirectories (graphs and tables).  If the directory passed to this 
argument does not already exist it will be created.  If the directory exists, 
the user will be prompted with a series of questions asking if the user wants to 
delete individual files in the directory; if the directory is empty, the user 
will be asked if they would like to delete the directory and rebuild it.{p_end}

{marker edaopts}{dlgtab 4 8:Optional Arguments}{break}
{p 4 4 8}These arguments mark the start of the optional arguments that allow the 
user to control what output they would like and provide user defined methods for 
variable classification. {p_end}

{p 8 8 8}{cmdab:id:vars} is an optional argument that takes a variable list 
containing variables that should be excluded from graphs.  For example, if the 
data set includes a numeric patient ID, this option would prevent that variable 
from being included in subsequent graphs/tables since the variable is nominal and 
not intervallic/ratio scale in nature.{p_end}

{p 8 8 8}{cmdab:str:ok} is an optional argument used to allow string formatted 
variables to be included in the program.  Without a variable list, this argument 
will use all string variables and with a variable list will only use the variables 
supplied by the end user.{p_end}

{marker edaclassify}{dlgtab 8 8:Variable Classification}{break}
{p 20 20 20}{help eda##edasyntax:Syntax} {space 15} {help eda##edadesc:Description} {space 15} {help eda##edaex:Examples} {p_end}{break}
{p 14 14 14}These options allow the user to control how variables are classified 
as categorical vs continuous and the minimum number of non-missing values 
required for a variable to be included in subsequent analysis.  For variable 
classification there are three methods available: User provided variable lists,
user defined criteria, or the program defaults.  The program defaults to defining 
a variable as categorical if it has two to nine distinct values and a variable is 
classified as continuous if it has 10 or more distinct values.  Since there are 
heirarchical units that may have > 9 values, the user can also tell the program 
how to classify the variables in the dataset manually by passing variable lists 
to the catvar and contvar options. {p_end}{break}
 
{p 14 14 14}{cmdab:minn:size} is an option used to specify the minnimum number 
of non-missing observations that must be present for a variable to be classified.  
For example, if a given variable is missing for all but 10 observations, setting 
this parameter to a value of 20 would exclude it from all subsequent output.  {p_end} 

{p 14 14 14}{cmdab:min:cat} is an option to set the lower threshold of unique values 
for a variable to be classified as categorical.  This value defaults to 2. {p_end}

{p 14 14 14}{cmdab:max:cat} is an option to set the upper threshold of unique values 
for a variable to be classified as categorical.  This value defaults to 9. {p_end}

{p 14 14 14}{cmdab:cat:vars} is an option to define variables to be treated as 
categorical by the program.  If an argument is passed to this and the contvars 
parameter it will override the mincat and maxcat parameters.  {p_end}

{p 14 14 14}{cmdab:cont:vars} is an option to define variables to be treated as 
continuous by the program.  If an argument is passed to this and the catvars 
parameter it will override the mincat and maxcat parameters. {p_end}

{marker edaglobals}{dlgtab 8 8:Global Options}{break}
{p 20 20 20}{help eda##edasyntax:Syntax} {space 15} {help eda##edadesc:Description} {space 15} {help eda##edaex:Examples} {p_end}{break}
{p 14 14 14}These options affect the performance and/or aesthetics of {hi:all} 
graphs.  The program was designed specifically to leverage the power/flexibility 
provided by {stata `"net desc brewscheme, from("http://www.paces-consulting.org/stata")"': brewscheme}.  
{search brewscheme} provides a flexible interface to help users define customized 
scheme files with a series of aesthetic adjustments from the default Stata 
graphics/schemes.  Although not using a scheme will still result in consistent 
graph aesthetics (due to the use of default schemes), this is the easiest possible 
way to control the aesthetics of the graphs created by this program. {p_end}{break}

{p 14 14 14}{cmdab:auth:orname} is an optional argument used to pass an author 
name to the LaTeX file Title Page.  If no value is specified the program will 
use the value returned in the macro c(username).{p_end}

{p 14 14 14}{cmdab:repo:rtname} is an optional argument used to pass a subtitle 
to the LaTeX file Title page.  If no value is specified the program will use the 
name of the file currently loaded in memory while the program is being executed. {p_end}

{p 14 14 14}{cmd:scheme} is an option used to pass a scheme argument to all of 
the underlying graph commands.  I strongly recommend using {search brewscheme} 
to define a customized scheme file that meets your unique aesthetic and/or 
visual needs and passing that schemefile to this parameter.{p_end}

{p 14 14 14}{cmd:keepgph} is an optional argument used to save the graphs as 
Stata GPH files.  If this is not specified, the graphs are only saved as PDF 
files.{p_end}

{p 14 14 14}{cmdab:grlabl:ength} is an optional argument used to define how long 
a variable label should be before it is split into multiple lines when used in 
graphs.  The program stores strings used for the titles temporarily in the 
variable characteristics. If no value is passed, the program will insert line 
breaks at 50 characters. This is done to help keep titles within the graph 
region and to provide some consistency in the formatting of the titles.  {p_end}

{marker edacatdist}{dlgtab 8 8:Univariate Graphs - Categorical Variables}{break}
{p 20 20 20}{help eda##edasyntax:Syntax} {space 15} {help eda##edadesc:Description} {space 15} {help eda##edaex:Examples} {p_end}{break}
{p 14 14 14}{cmdab:miss:ing} is a parameter passed to the bar, boxplot, pie chart, 
and mosaic plots to include missing values as categories.  It is also used when 
identifying the number of distinct values a variable may take.{p_end}

{p 14 14 14}{cmdab:perc:ent} is used to specify whether bar graphs and pie charts 
should display counts or percentages.  If the option is selected both graph types 
will display percentages.  Otherwise the graphs will display frequencies. {p_end}

{p 14 14 14}{cmdab:nobargr:aphs} is an option used to suppress the production of 
bar graphs for categorical variables by {help eda}. {p_end}

{p 14 14 14}{cmdab:bargra:phopts} is an option to provide additional user options 
to the underlying bar graph commands.  The scheme, missing, legend, title, notes, 
over, and asyvar options are already specified and cannot be modified with this 
option.  The most useful way the option could be used is to set the display of 
bar labels and/or to format/render the values displayed differently.  {p_end}

{p 14 14 14}{cmdab:nopiec:harts} is an option used to suppress the production of 
pie charts for categorical variables by {help eda}. {p_end}

{p 14 14 14}{cmdab:piech:artopts} is used to pass aesthetic options to the 
{help graph_pie:pie chart} graph command.{p_end}

{marker edacontdist}{dlgtab 8 8:Univariate Graphs - Continuous Variables}{break}
{p 20 20 20}{help eda##edasyntax:Syntax} {space 15} {help eda##edadesc:Description} {space 15} {help eda##edaex:Examples} {p_end}{break}
{p 14 14 14}{cmdab:nohisto:grams} is an option used to suppress the production 
of histograms for continuous variables by {help eda}. {p_end}

{p 14 14 14}{cmdab:histog:ramopts} is used to pass optional arguments to the 
graph command creating the histograms. {p_end}

{p 14 14 14}{cmdab:kdens:ity} is an option used to request a kernel density plot 
be overlaid on the histogram. {p_end}

{p 14 14 14}{cmdab:kdenso:pts} is an option used to pass arguments to 
{help kdensity:kdensity} that control the rendering of the kernel density 
estimates overlaid on the histogram.{p_end}

{p 14 14 14}{cmdab:fivenum:sum} is an option used to add reference lines to the 
histogram that show Tukey's Five Number Summary in the background of the graph.{p_end}

{p 14 14 14}{cmdab:fnso:pts} is an option to pass arguments to the 
{help added_line_options:xline} arguments used to draw the locations of the five 
number summary with the histograms.  {p_end}

{p 14 14 14}{cmdab:nodistro:plots} is an option used to suppress the production 
of distribution quality/assumption plots for continuous variables by {help eda}. 
{p_end}

{p 14 14 14}{cmdab:distrop:lotopts} is used to pass options for the rendering of 
the chi squared probability and quantile plots.  To pass the degrees of freedom 
to both of these graphs you would use: distrop("df(3)" "df(2)") as an example.  
The underlying program uses the first word of this argument for the Chi squared 
quantiles plot and the second word is used for the Chi squared probability plots.  
{p_end}

{p 14 14 14}{cmdab:noladder:plots} is an option used to suppress the production  
of ladder of powers graphs for continuous variables by {help eda}. {p_end}

{marker edascatter}{dlgtab 8 8:Bivariate Graphs - Continuous Variables}{break}
{p 20 20 20}{help eda##edasyntax:Syntax} {space 15} {help eda##edadesc:Description} {space 15} {help eda##edaex:Examples} {p_end}{break}
{p 14 14 14}{cmdab:noscat:terplots} is an option used to suppress the production 
of scatterplots for all pairs of continuous variables by {help eda}. {p_end}

{p 14 14 14}{cmd:lfit} is an option to request a linear smoother be overlaid on 
the scatterplot.  Additional options to control the aesthetics for the linear 
smoother can also be passed (see {help twoway_lfit:lfit} for additional 
information). {p_end}

{p 14 14 14}{cmd:qfit} is an option to request a quadratic smoother be drawn with 
the scatterplot.  Additional options to control the aesthetics for the quadratic 
smoother can also be passed (see {help twoway_qfit:qfit} for additional 
information). {p_end}

{p 14 14 14}{cmd:lowess} is an option to request a lowess - or non-parametric 
smoother - be drawn with the scatterplot.  Additional options to control the 
aesthetics for the lowess smoother can also be passed (see 
{help twoway_lowess:lowess} for additional information). {it:Note: the lowess smoother is also called a "loess" smoother in some statistical packages.}{p_end}

{p 14 14 14}{cmd:fpfit} is an option to request a fractional polynomial smoother 
be drawn with the scatterplot.  Additional options to control the aesthetics for 
the fractional polynomial smoother can also be passed (see 
{help twoway_fpfit:fpfit} for additional information). {p_end}

{p 14 14 14}{cmd:lfitci} is an option to request a linear line of best fit  
smoother with confidence intervals be drawn under the scatterplot.  Additional 
options to control the aesthetics for the linear smoother and confidence 
intervals can also be passed (see {help twoway_lfitci:lfitci} for additional 
information). {p_end}

{p 14 14 14}{cmd:qfitci} is an option to request a quadratic line of best fit  
smoother with confidence intervals be drawn under the scatterplot.  Additional 
options to control the aesthetics for the quadratic smoother and confidence 
intervals can also be passed (see {help twoway_qfitci:qfitci} for 
additional information). {p_end}

{p 14 14 14}{cmd:fpfitci} is an option to request a fractional polynomial 
smoother with confidence intervals be drawn under the scatterplot.  Additional 
options to control the aesthetics for the fractional polynomial smoother and 
confidence intervals can also be passed (see {help twoway_fpfitci:fpfitci} for 
additional information). {p_end}

{marker edaboxp}{dlgtab 8 8:Bivariate Graphs - Conditional Distributions}{break}
{p 20 20 20}{help eda##edasyntax:Syntax} {space 15} {help eda##edadesc:Description} {space 15} {help eda##edaex:Examples} {p_end}{break}
{p 14 14 14}{cmdab:nobox:plots} is an option used to suppress the production 
of box and whisker plots for each combination of continuous by categorical 
variables by {help eda}. {p_end}

{marker edamos}{dlgtab 8 8:Bivariate Graphs - Categorical Variables}{break}
{p 20 20 20}{help eda##edasyntax:Syntax} {space 15} {help eda##edadesc:Description} {space 15} {help eda##edaex:Examples} {p_end}{break}
{p 14 14 14}{cmd:nomosaic} is an option used to suppress the production of 
mosaic - or {help spineplot:spineplots} - for all pairs of categorical variables 
by {help eda}. {p_end}

{marker edamvcont}{dlgtab 8 8:Multivariate Graphs - Continuous Variables}{break}
{p 20 20 20}{help eda##edasyntax:Syntax} {space 15} {help eda##edadesc:Description} {space 15} {help eda##edaex:Examples} {p_end}{break}
{p 14 14 14}{cmdab:noheat:map} is an option used to suppress the production 
of a heatmap used to illustrate pairwise correlations between all continuous 
variables by {help eda}. {p_end}

{p 14 14 14}{cmdab:nobubble:plots} is an option used to suppress the production 
of weighted scatterplots - or Bubble Plots - for all pairs of continuous 
variables by {help eda}. {p_end}

{p 14 14 14}{cmdab:weight:type} is an optional parameter used to specify a method 
to transform the weight variable of bubble plots.  The acceptable arguments and 
their meanings are: {p_end}

{marker edawgts}{col 20}{hline 80}
{col 20}{hi:Argument} {col 35}{hi: Transformation}
{col 20}{hline 80}
{col 20}0{col 35}{it:Raw Data (not transformed)}
{col 20}1{col 35}{it:Natural Logarithm of the Variable}
{col 20}2{col 35}{it:Square Root of the Variable}
{col 20}3{col 35}{it:Exponential Function of the Variable}
{col 20}4{col 35}{it:Inverse of the Logit Function of the Variable}
{col 20}5{col 35}{it:Complementary Log Log of the Variable}
{col 20}6{col 35}{it:Digamma Function of the Variable}
{col 20}7{col 35}{it:Inverse of the Complementary Log Log of the Variable}
{col 20}8{col 35}{it:Natural Logarithm of the Gamma Function of the Variable}
{col 20}9{col 35}{it:Base 10 Logarithm of the Variable}
{col 20}10{col 35}{it:Log of the Odds-Ratio of the Variable}
{col 20}11{col 35}{it:2nd Derivative of the Log of the Gamma Function of the Variable}
{col 20}{hline 80}{break}

{p 14 14 14}The transformations are applied to copies of the original data at 
runtime and the copies are removed after the graph is created.  Changing the 
weighting of the variable will affect the scaling of the "bubbles" or points in 
the weighted scatterplot.  These variables are used as arguments to the {help weight} 
parameter of the scatterplot commands (specifically entered as {hi:aweight}s).{p_end}

{marker edatex}{dlgtab 8 8:LaTeX Options}{p_end}{break}
{p 20 20 20}{help eda##edasyntax:Syntax} {space 15} {help eda##edadesc:Description} {space 15} {help eda##edaex:Examples} {p_end}{break}
{p 14 14 14}{cmdab:comp:ile} is an option used to write a batch (if called from 
a machine running Windoze) or bash (for any *nix-based system) script to compile 
the LaTeX source code document and subsequently to execute the script.  If called 
from a *nix-based platform, the {help shell:shellout} will fail if the user does 
not have sudo permissions w/o password entry. {subscript:{it:This is required to modify the file permissions and make it executable for all users with a call to ! sudo chmod a+x scriptname.sh.}}  {p_end}

{p 14 14 14}{cmdab:pdfl:atex} is an option used to specify the location of the 
pdflatex binary.  If pdflatex is already on your operating system's path, you 
should not need to specify this option (the script will just call pdflatex on 
any *nix-based system or pdflatex.exe on Windoze).{p_end}

{marker edarefs}{p 2 2 2}{title:{hi:References}}{p_end}{break}
{p 4 4 4}{help eda##edasyntax:Syntax} {space 15} {help eda##edadesc:Description} {space 15} {help eda##edaex:Examples} {p_end}{break}
{p 4 4 8}Tukey, J. W. (1977).  {it:Exploratory Data Analysis}.  {p_end}

{marker edaex}{p 2 2 2}{title:{hi:Examples}}{p_end}{break}
{p 4 4 4}{help eda##edasyntax:Syntax} {space 15} {help eda##edadesc:Description} {space 15} {help eda##edaex:Examples} {p_end}{break}
{p 4 4 8}All of these examples will assume the same starting point: {stata sysuse auto.dta, clear} 
since the data set is smaller/easier to manage.  You should also install {search brewscheme} and 
create an example palette called {hi: edatest} that will be used in the following 
examples.  My version of this file was created using: {p_end}

{p 8 8 8}brewscheme, scheme(edatest) const(orange) cone(blue) consat(20) scatst(set1) scatc(8) piest(pastel2) piec(6) barst(pastel1) barc(7) linest(accent) linec(7) areast(set2) areac(5) boxst(pastel2) boxc(6) somest(paired) somec(12) {p_end}

{p 4 4 8}The most minimal example is:{p_end}

{p 8 8 8}{stata sysuse auto.dta, clear}{p_end}
{p 8 8 8}{stata eda, r(`"`c(pwd)'/edaexamples"') o("minexample") comp}{p_end}

{p 4 4 8}To apply the styling from the scheme created above to the graphs, simply 
pass the name of the scheme to the scheme parameter: {p_end}

{p 8 8 8}{stata eda, r(`"`c(pwd)'/edaexamples"') o("minexample") comp scheme(edatest)}{p_end}

{p 4 4 8}To add reference lines for Tukey's five number summary to histograms:{p_end}

{p 8 8 8}{stata eda, r(`"`c(pwd)'/edaexamples"') o("minexample") comp scheme(edatest) fivenum}{p_end}

{p 4 4 8}To suppress the creation of a heatmap of the correlations: {p_end}
{p 8 8 8}{stata eda, r(`"`c(pwd)'/edaexamples"') o("minexample") comp scheme(edatest) noheat}{p_end}

{p 4 4 8}To use log transformed variable values for weights in the bubble plots: {p_end}
{p 8 8 8}{stata eda, r(`"`c(pwd)'/edaexamples"') o("minexample") comp scheme(edatest) weight(1)}{p_end}

{p 4 4 8}To get percentages printed in the bargraphs and pie charts: {p_end}
{p 8 8 8}{stata eda, r(`"`c(pwd)'/edaexamples"') o("minexample") comp scheme(edatest) perc}{p_end}

{p 4 4 8}To suppress the creation of bar graphs and pie charts: {p_end}
{p 8 8 8}{stata eda, r(`"`c(pwd)'/edaexamples"') o("minexample") comp scheme(edatest) nobargr nopiec}{p_end}

{marker edaack}{p 2 2 2}{title:{hi:Acknowledgements}}{p_end}
{p 4 4 8}This program makes use of several user written commands including: {p_end}

{marker edadeps}{col 10}{hline 80}
{col 10}{hi:Program} {col 35}{hi: Authors}
{col 10}{hline 80}
{col 10}{search brewscheme:brewscheme}{col 35}{it:Billy Buchanan}
{col 10}{search tuples:tuples}{col 35}{it:Joseph N. Luchman & Nick J. Cox}
{col 10}{search spineplot:spineplot}{col 35}{it:Nick J. Cox}
{col 10}{search estout:estout}{col 35}{it:Ben Jann}
{col 10}{hline 80}

{marker contact}{p 2 2 2}{title:{hi:Author}}{p_end}
{p 4 4 4}Billy Buchanan {p_end}
{p 4 4 4}Data Scientist{p_end}
{p 4 4 4}{browse "http://mpls.k12.mn.us":Minneapolis Public Schools}{p_end}

