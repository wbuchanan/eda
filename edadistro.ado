********************************************************************************
* Description of the Program -												   *
* EDA subroutine used to create distribution assumption plots	 			   *
*                                                                              *
* Program Output -                                                             *
*     Creates series of distribution quality/assumption graph GPHs and PDFs    *	
* 	  as well as entries in the LaTeX document  							   *
*                                                                              *
* Lines -                                                                      *
*     199                                                                      *
*                                                                              *
********************************************************************************
		
*! edadistro
*! v 0.0.0
*! 28OCT2015

// Drop program from memory if already loaded
cap prog drop edadistro

// Define program
prog def edadistro

	// Version used to interpret code
	version 14
	
	// Syntax structure for edabar subroutine
	syntax varlist(min=1) [if] [in], 	root(string asis)					 ///   
										[DISTROPlotopts(string asis)		 ///   
										scheme(passthru)					 ///   
										keepgph	noUNIvariate]
	
	// Mark only the observations to use
	marksample touse

	// Check implementation for univariate vs bivariate graphs
	if "`univariate'" != "nounivariate" {
	
		loc symplotlab "Symmetry Plot for "
		loc quantilelab "Quantiles of Uniform Distribution vs Ordered values of "
		loc qnormlab "Normal Distribution vs Quantiles of "
		loc pnormlab "Standardized Normal Probability Plot for "

		// Add subheading to the LaTeX file
		file write doc "\subsubsection{Distribution Diagnostic Plots}" _n

		// Loop over continuous variables
		foreach v of var `varlist' {

			// Get LaTeX sanitized version of the variable name
			texclean "`v'", r
			
			// Store the variable name in vref
			loc vref `r(clntex)'
			
			// Get LaTeX sanitized version of the variable label
			texclean `"`: var l `v''"'
			
			// Store the label in vlab
			loc vlab `r(clntex)'

			// Loop over the simpler plot types
			foreach plottype in symplot quantile qnorm pnorm {
		
				// Create symmetry plot
				`plottype' `v' if `touse', `scheme' ti("``plottype'lab'`v'") ///	  
				note("Created on: `c(current_date)' at: `c(current_time)'") 	
			
				// Export graph to pdf
				qui: gr export `"`root'/graphs/`plottype'`v'.pdf"', as(pdf) replace
				
				// Check option to keep the GPH file on disk
				if "`keepgph'" != "" {
				
					// Delete Stata GPH file from disk
					qui: gr save `"`root'/graphs/`plottype'`v'.gph"', replace
					
				} // End IF Block for null keep graph option
				
				// Add the graph to the LaTeX file
				file write doc "\begin{figure}[h!]" _n
				file write doc `"\caption{``plottype'lab'`vlab' \label{fig:`plottype'`vref'}}"' _n
				file write doc `"\includegraphics[width=\textwidth]{`plottype'`v'.pdf}"' _n
				file write doc "\end{figure} \newpage\clearpage" _n
				
			} // End Loop over simple plot types
			
			// Create quantiles of variable vs chi-squared distro
			qchi `v' if `touse', `scheme' `: word 1 of `distroplotopts''	 ///   
			ti("Quantiles of `v' vs. " "Quantiles of {&Chi}{superscript:2}") ///	  
			note("Created on: `c(current_date)' at: `c(current_time)'") 
			
			// Export the graph to pdf
			qui: gr export `"`root'/graphs/qchi`v'.pdf"', as(pdf) replace
			
			// Create X^2 Probability plots
			pchi `v' if `touse', `scheme' `: word 2 of `distroplotopts''	 ///   
			ti("{&Chi}{superscript:2} Probability Plots for `v'")			 ///	  
			note("Created on: `c(current_date)' at: `c(current_time)'") 
			
			// Export to pdf
			qui: gr export `"`root'/graphs/pchi`v'.pdf"', as(pdf) replace
			
			// Add the graph to the LaTeX file
			file write doc "\begin{figure}[h!]" _n
			file write doc `"\caption{Chi-Squared Quantiles v. `vlab' \label{fig:qchi`vref'}}"' _n
			file write doc `"\includegraphics[width=\textwidth]{qchi`v'.pdf}"' _n
			file write doc "\end{figure} \newpage\clearpage" _n
			
			// Add the graph to the LaTeX file
			file write doc "\begin{figure}[h!]" _n
			file write doc `"\caption{Chi-Squared Probability `vlab' \label{fig:pchi`vref'}}"' _n
			file write doc `"\includegraphics[width=\textwidth]{pchi`v'.pdf}"' _n
			file write doc "\end{figure} \newpage\clearpage" _n
			
			// Check option to keep the GPH file on disk
			if "`keepgph'" != "" {
			
				// Delete Stata GPH file from disk
				qui: gr save `"`root'/graphs/qchi`v'.gph"', replace
				
				// Delete Stata GPH file from disk
				qui: gr save `"`root'/graphs/pchi`v'.gph"', replace
				
			} // End IF Block for null keep graph option
					
		} // End Loop over continuous variables
		
	} // End IF Block for univariate case
	
	// If univariate does = nounivariate
	else {
	
		// Add section header to LaTeX file
		file write doc "\subsubsection{Quantile Quantile Plots}" _n

		// Generate list of all pairwise combination of continuous variables
		tuples `varlist', asis min(2) max(2)		
				
		// Generate scatter plots for all pairwise combinations of continuous variables
		forv i = 1/`ntuples' {
		
			// Use the first element of the tuple for the x-axis
			loc x : word 1 of `tuple`i''
			
			// Use the second element of the tuple for the y-axis
			loc y : word 2 of `tuple`i''
			
			// Create qqplot
			qqplot `y' `x' if `touse', `scheme' 							 ///	  
			note("Created on: `c(current_date)' at: `c(current_time)'") 
			
			// Export to pdf
			qui: gr export `"`root'/graphs/qq`i'.pdf"', as(pdf) replace
			
			// Get LaTeX sanitized x variable name
			texclean `"`x'"', r
			
			// Store cleaned x variable name in clnx
			loc clnx `r(clntex)'
			
			// Get LaTeX sanitized y variable name
			texclean `"`y'"', r
			
			// Store cleaned y variable name in clny
			loc clny `r(clntex)'
			
			// Get clean version of y var label
			texclean `"`: var l `y''"'
			
			// Store the label in the local macro ylab
			loc ylab `r(clntex)'
			
			// Get clean version of x var label
			texclean `"`: var l `x''"'
			
			// Store the label in the local macro xlab
			loc xlab `r(clntex)'
					
			// Check if user wants to keep the GPH files
			if "`keepgph'" != "" {
			
				// Define local macro with syntax to remove file
				qui: gr save `"`root'/graphs/qq`i'.gph"', replace
				
			} // End IF Block to remove .gph files

			// Add the graph to the LaTeX file
			file write doc "\begin{figure}[h!]" _n
			file write doc `"\caption{Quantiles of `ylab' vs Quantiles of `xlab' \label{fig:qq`clny'`clnx'}}"' _n
			file write doc `"\includegraphics[width=\textwidth]{qq`i'.pdf}"' _n
			file write doc "\end{figure} \newpage\clearpage" _n

		} // End Loop over continuous variable permutations
	
	} // End ELSE Block for bivariate distribution graphs
	
// End of program definition
end

