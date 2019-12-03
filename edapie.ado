********************************************************************************
* Description of the Program -												   *
* EDA subroutine used to create pie charts						 			   *
*                                                                              *
* Program Output -                                                             *
*     Creates pie chart GPH and PDF as well as entries in the LaTeX document   *
*                                                                              *
* Lines -                                                                      *
*     100                                                                      *
*                                                                              *
********************************************************************************
		
*! edapie
*! v 0.0.2
*! 22sep2019

// Drop program from memory if already loaded
cap prog drop edapie

// Define program
prog def edapie

	// Version used to interpret code
	version 14
	
	// Syntax structure for edabar subroutine
	syntax varlist(min=1) [if] [in], 	root(string asis)					 ///   
										[PIECHartopts(string asis)			 ///   
										scheme(passthru) byseq				 ///   
										keepgph	MISSing byvars(varlist) DEBug ]
										
	// Mark only the observations to use
	marksample touse, strok novarlist
	
	// No byvars argument
	if `"`byvars'"' == "" {

		// Add subheading to the LaTeX file
		file write doc "\subsubsection{Pie Charts}" _n

		// Create bar graphs for the categorical variables
		foreach v of var `varlist' { 

			// Get number of rows for the legend for this variable
			loc leg legend(rows(`:char `v'[lrows]') symy(1.85) symx(1.85))

			// Create pie chart
			gr pie if `touse', over(`v') `piechartopts' ti(`:char `v'[title]')	 ///    
			note("Created on: `c(current_date)' at: `c(current_time)'") 		 ///   
			`missing' `scheme'
			
			// Export to .pdf file
			qui: gr export `"`root'/graphs/pie`v'.pdf"', as(pdf) replace
			
			// Check if user wants to keep the GPH files
			if "`keepgph'" != "" {
			
				// Define local macro with syntax to remove file
				qui: gr save `"`root'/graphs/pie`v'.gph"', replace
				
			} // End IF Block to remove .gph files

			// Get LaTeX formatted variable name
			texclean `"`v'"', r

			// Store the variable name in vref
			loc vref `r(clntex)'

			// Get LaTeX formatted variable label
			texclean `"`: var l `v''"'

			// Store the variable label in vlab
			loc vlab `r(clntex)'

			// Add the graph to the LaTeX file
			file write doc "\begin{figure}[h!]" _n
			file write doc `"\caption{Pie Chart of `vlab' \label{fig:pie`vref'}}"' _n
			file write doc `"\includegraphics[width=\textwidth]{pie`v'.pdf}"' _n
			file write doc "\end{figure}" _n
			file write doc "\hyperlink{tof}{Back to List of Figures}" _n
			file write doc "\hyperlink{toc}{Back to Table of Contents}\newpage\clearpage" _n

		} // End loop over categorical variables
		
	} // End IF Block for no byvars argument
	
	// sequential by graphs
	else if `"`byvars'"' != "" & "`byseq'" != "" {
	
	
	} // End ELSEIF Block for sequential by graphs
	
	// Lattice graphs
	else if `"`byvars'"' != "" & "`byseq'" == "" {
	
	
	} // End ELSE IF Block for Lattice style graphs
		
// End of subroutine definition
end

