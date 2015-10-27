********************************************************************************
* Description of the Program -												   *
* EDA subroutine used to create heatmap of correlations between continuous 	   *
* variables in the dataset.													   *
*                                                                              *
* Program Output -                                                             *
*     Creates heatmap GPH and PDF as well as entries in the LaTeX document     *
*                                                                              *
* Lines -                                                                      *
*     144                                                                      *
*                                                                              *
********************************************************************************
		
*! edaheat
*! v 0.0.0
*! 27OCT2015

// Drop program from memory if already loaded
cap prog drop edaheat

// Define program
prog def edaheat, rclass

	// Stata version used to interpret syntax
	version 14
	 
	// Define the syntax structure of the program
	syntax varlist(min=2) [if] [in], root(string asis) [ keepgph ]
	
	// Mark observations to use
	marksample touse
	
	// Add section header to LaTeX file
	file write doc "\section{Correlations} \newpage\clearpage" _n

	// Add subsection header
	file write doc "\subsection{Correlations Between Continuous Variables} \newpage\clearpage" _n

	// Preserve current state of the data
	preserve
	
		// Keep only cases satisfying if/in condition
		keep if `touse'
		
		// Keep only the listed variables
		keep `varlist'
		
		// Loop over variables to get variable labels
		foreach v of var `varlist' {
		
			// Get variable label
			loc `v'lab : var l `v'
			
			// Check for null strings
			if `"``v'lab'"' == "" {
			
				// Assign the variable name to the label macro
				loc `v'lab "`v'"
				
			} // End IF Block for null variable label handling
			
		} // Emd Loop to get variable labels
		
		// Get pairwise correlation coefficient estimates
		pwcorr `varlist'
		
		// Store the correlation matrix
		mat edaheatmat = r(C)
		
		// Assign rownames to matrix
		mat rownames edaheatmat = `varlist'
		
		// Assign column names to matrix
		mat colnames edaheatmat = `varlist'
		
		// Clear existing data from memory
		clear
		
		// Load the correlation matrix as the data
		qui: svmat edaheatmat
		
		// Generate an id variable
		qui: g xvar = _n
		
		// Store the maximum value of _n
		loc maxn = `c(N)'
		
		// Normalize the data
		reshape long edaheatmat, i(xvar) j(yvar)
		
		// Loop over ids to assign variable labels
		forv i = 1/`maxn' {
		
			// Get the ith word from varlist and use that to get the 
			la def xvar `i' `"`: word `i' of `varlist'lab'"', modify
			
		} // End Loop to define value labels
		
		// Assign value labels
		la val xvar xvar
		la val yvar xvar
		
		#d ;
		
		// Create a contour plot for the correlations
		cap: qui: tw contour edaheatmat yvar xvar, heatmap xlab(1(1)`maxn', val 
		labsize(tiny) angle(90)) ylab(1(1)`maxn', val labsize(tiny) angle(0) 
		nogrid) graphr(ic(white) fc(white) lc(white))  ccut(-1(.2)1) ysca(rev) 
		ccolor("127 59 8" "179 88 6" "224 130 20" "253 184 99" "254 224 182" 
		"216 218 235" "178 171 210" "128 115 172");
		
		tw contour edaheatmat yvar xvar, heatmap xlab(1(1)`maxn', val 
		labsize(tiny) angle(90)) ylab(1(1)`maxn', val labsize(tiny) angle(0) 
		nogrid) graphr(ic(white) fc(white) lc(white))  ccut(-1(.2)1) ysca(rev) 
		ccolor("127 59 8" "179 88 6" "224 130 20" "253 184 99" "254 224 182" 
		"247 247 247" "216 218 235" "178 171 210" "128 115 172" "84 39 136" 
		"45 0 75") xti("Continuous Variables") yti("Continuous Variables") 
		zti("Estimated" "Correlation Coefficient")
		ti("Correlations Between Continuous Variables");

		#d cr
		
		// Export the graph to pdf
		gr export `"`root'/graphs/edaheatmap.pdf"', as(pdf) replace

		// Check for keepgph option
		if "`keepgph'" != "" {
		
			// If not turned on syntax to delete Stata GPH file
			qui: gr save `"`root'/graphs/edaheatmap.gph"', replace
		
		} // End IF Block for gph save definition
			
		// Include in the LaTeX document
		file write doc "\begin{figure}[h!]" _n
		file write doc `"\caption{Correlation Heatmap \label{fig:heatmap}}"' _n
		file write doc `"\includegraphics[width=\textwidth]{edaheatmap.pdf}"' _n
		file write doc "\end{figure} \newpage\clearpage" _n
			
		// Return the matrix used for the heat map from the function
		ret mat edacorr = edaheatmat
		
	// Restore data to previous state
	restore
	
// End of program definition
end

