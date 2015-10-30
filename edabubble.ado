********************************************************************************
* Description of the Program -												   *
* EDA subroutine used to create bubble plots					 			   *
*                                                                              *
* Program Output -                                                             *
*     Creates series of bubbleplots GPHs and PDFs as well as entries in the    * 
*	  LaTeX document  														   *
*                                                                              *
* Lines -                                                                      *
*     222                                                                      *
*                                                                              *
********************************************************************************
		
*! edabubble
*! v 0.0.0
*! 30OCT2015

// Drop program from memory if already loaded
cap prog drop edabubble

// Define program
prog def edabubble

	// Version used to interpret code
	version 14
	
	// Syntax structure for edabar subroutine
	syntax varlist(min=3) [if] [in], 	root(string asis)					 ///   
										[ scheme(passthru) keepgph			 ///   
										WEIGHTtype(int 0) ]
										
	// Mark only the observations to use
	marksample touse
	
	// Invalid weight code
	if !inrange(`weighttype', 0, 11) {
	
		// Print error message to the console
		di as err "Option not allowed using default (untransformed values of weight variable)"
		
		// Set default behavior
		loc wgt 
		
	} // End IF Block for invalid weight type
	
	// Valid weight codes
	else {
	
		// Raw values
		if `weighttype' == 0 {
		
			// null macro
			loc wgt 
			
		} // End IF Block for default
	
		// If user selects value of 1
		else if `weighttype' == 1 {
		
			// Natural log of variable will define weights
			loc wgt ln
			
		} // End ELSE IF Block for natural log weighted plots
		
		// If user selects value of 2
		else if `weighttype' == 2 {
		
			// Square root of variable will define weights
			loc wgt sqrt
			
		} // End ELSE IF Block for square root weighted plots
		
		// If user selects value of 3
		else if `weighttype' == 3 {
		
			// Exponentiated values
			loc wgt exp
			
		} // End ELSE IF Block for natural log weighted plots
		
		// If user selects value of 4
		else if `weighttype' == 4 {
		
			// Inverse logit weighted variable defines point weights
			loc wgt invlogit
	
		} // End ELSE IF Block for natural log weighted plots
		
		// If user selects value of 5
		else if `weighttype' == 5 {
		
			// Complementary log log of variable defines weights
			loc wgt cloglog
			
		} // End ELSE IF Block for natural log weighted plots
		
		// If user selects value of 6
		else if `weighttype' == 6 {
		
			// Digamma function of variable defines weights
			loc wgt digamma
			
		} // End ELSE IF Block for natural log weighted plots
		
		// If user selects value of 7
		else if `weighttype' == 7 {
		
			// Inverse complementary log log of variable defines weights
			loc wgt invcloglog
			
		} // End ELSE IF Block for natural log weighted plots
		
		// If user selects value of 8
		else if `weighttype' == 8 {
		
			// Natural log of the gamma function of variable defines weights
			loc wgt lngamma
			
		} // End ELSE IF Block for natural log weighted plots
		
		// If user selects value of 9
		else if `weighttype' == 9 {
		
			// Log base 10 defines weights
			loc wgt log10
			
		} // End ELSE IF Block for natural log weighted plots

		// If user selects value of 10
		else if `weighttype' == 10 {
		
			// Logit transformed variable defines weights
			loc wgt logit
			
		} // End ELSE IF Block for natural log weighted plots
		
		// If user selects value of 11
		else {
		
			// Trigamma function of variable defines weights
			loc wgt trigamma
			
		} // End ELSE IF Block for natural log weighted plots
		
	} // End ELSE Block for valid weight type code

	// Add section header to LaTeX file
	file write doc "\subsubsection{Bubble Plots}" _n

	// Generate list of all pairwise combination of continuous variables
	tuples `varlist', asis min(3) max(3)		
			
	// Generate scatter plots for all pairwise combinations of continuous variables
	forv i = 1/`ntuples' {
	
		// Use the first element of the tuple for the x-axis
		loc x : word 1 of `tuple`i''
		
		// Use the second element of the tuple for the y-axis
		loc y : word 2 of `tuple`i''
		
		// Use the third element of the tuple to weight the points
		loc z : word 3 of `tuple`i''
		
		// Create a clone of the weight variable
		qui: g `z'clone = `wgt'(`z')

		// Local macro for legend data
		loc legendlabels label(1 "Scatter Points")

		// Define a macro used to set legend parameters
		loc leg legend(`legendlabels' symy(1.85) symx(1.85))

		// Generate the scatterplot
		tw scatter `y' `x' [aw = `z'clone]  if `touse', 					 ///   
		xti(`: char `x'[title]') yti(`: char `y'[title]') `leg' `scheme'	 ///   
		ti(`: char `y'[title]' "and" `: char `x'[title]')			 		 ///   
		caption("Points Sizes Weighted by " `: char `z'[title]')			 ///   
		note("Created on: `c(current_date)' at: `c(current_time)'") 
		
		// Drop the clone variable
		drop `z'clone
		
		// Export the scatterplot as a .png file
		qui: gr export `"`root'/graphs/bubble`i'.pdf"', as(pdf) replace
		
		// Check if user wants to keep the GPH files
		if "`keepgph'" != "" {
		
			// Define local macro with syntax to remove file
			qui: gr save `"`root'/graphs/bubble`i'.gph"', replace
			
		} // End IF Block to remove .gph files

		// Get LaTeX formatted variable name for use in LaTeX references
		texclean `"`: var l `y''"'
		
		// Store the cleaned y varname in yref
		loc yref `r(clntex)'

		// Get LaTeX formatted variable name for use in LaTeX references
		texclean `"`: var l `x''"'
		
		// Store the cleaned x varname in xref
		loc xref `r(clntex)'

		// Get LaTeX formatted variable name for use in LaTeX references
		texclean `"`: var l `z''"'
		
		// Store the cleaned z varname in zref
		loc zref `r(clntex)'
		
		// Add the scatterplot to the LaTeX document
		file write doc "\begin{figure}[h!]" _n
		file write doc `"\caption{Bubble Plot of `yref', `xref', and `zref' \label{fig:bubble`i'}}"' _n
		file write doc `"\includegraphics[width=\textwidth]{bubble`i'.pdf}"' _n
		file write doc "\end{figure} \newpage\clearpage" _n
		
	} // End Loop over bubble plot permutations
		
// End program definition
end

