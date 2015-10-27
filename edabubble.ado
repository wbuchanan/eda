********************************************************************************
* Description of the Program -												   *
* EDA subroutine used to create bubble plots					 			   *
*                                                                              *
* Program Output -                                                             *
*     Creates series of bubbleplots GPHs and PDFs as well as entries in the    * 
*	  LaTeX document  														   *
*                                                                              *
* Lines -                                                                      *
*     102                                                                      *
*                                                                              *
********************************************************************************
		
*! edabubble
*! v 0.0.0
*! 27OCT2015

// Drop program from memory if already loaded
cap prog drop edabubble

// Define program
prog def edabubble

	// Version used to interpret code
	version 14
	
	// Syntax structure for edabar subroutine
	syntax varlist(min=3) [if] [in], 	root(string asis)					 ///   
										[ scheme(passthru) keepgph	]
										
	// Mark only the observations to use
	marksample touse

	// Add section header to LaTeX file
	file write doc "\subsubsection{Weighted Scatterplots (Bubble Plots)}" _n

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
		
		// Local macro for legend data
		loc legendlabels label(1 "Scatter Points")

		// Generate the scatterplot
		tw scatter `y' `x' [aw = `z']  if `touse', xti(`: char `x'[title]')  ///   
		yti(`: char `y'[title]') legend(`legendlabels') `scheme'			 ///   
		ti("Joint Distribution of `y' and `x' and " 						 ///   
		"Points Sizes Weighted by `z'")										 ///   
		note("Created on: `c(current_date)' at: `c(current_time)'") 
		
		// Export the scatterplot as a .png file
		qui: gr export `"`root'/graphs/bubble`i'.pdf"', as(pdf) replace
		
		// Check if user wants to keep the GPH files
		if "`keepgph'" != "" {
		
			// Define local macro with syntax to remove file
			qui: gr save `"`root'/graphs/bubble`i'.gph"', replace
			
		} // End IF Block to remove .gph files

		// Get LaTeX formatted variable name for use in LaTeX references
		texclean "`y'", r
		
		// Store the cleaned y varname in yref
		loc yref `r(clntex)'

		// Get LaTeX formatted variable name for use in LaTeX references
		texclean "`x'", r
		
		// Store the cleaned x varname in xref
		loc xref `r(clntex)'

		// Get LaTeX formatted variable name for use in LaTeX references
		texclean "`z'", r
		
		// Store the cleaned z varname in zref
		loc zref `r(clntex)'
		
		// Add the scatterplot to the LaTeX document
		file write doc "\begin{figure}" _n
		file write doc `"\caption{Bubble Plot of `yref', `xref', and `zref' \label{fig:bubble`i'}}"' _n
		file write doc `"\includegraphics{bubble`i'.pdf}"' _n
		file write doc "\end{figure} \newpage\clearpage" _n
		
	} // End Loop over bubble plot permutations
		
// End program definition
end

