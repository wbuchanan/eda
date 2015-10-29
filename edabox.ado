********************************************************************************
* Description of the Program -												   *
* EDA subroutine used to create box plots					 			       *
*                                                                              *
* Program Output -                                                             *
*     Creates series of box plots GPHs and PDFs as well as entries in the      * 
*	  LaTeX document  														   *
*                                                                              *
* Lines -                                                                      *
*     107                                                                      *
*                                                                              *
********************************************************************************
		
*! edabox
*! v 0.0.0
*! 28OCT2015

// Drop program from memory if already loaded
cap prog drop edabox

// Define program
prog def edabox

	// Version used to interpret code
	version 14
	
	// Syntax structure for edabar subroutine
	syntax [if] [in], root(string asis)	cat(varlist) cont(varlist)			 ///   
					  [ scheme(passthru) keepgph MISSing ]
										
	// Mark only the observations to use
	marksample touse

	// Set up a counter macro
	loc boxcount = 0

	file write doc "\subsubsection{Box Plots}" _n

	// Loop over all the categorical variables
	foreach ct of var `cat' {

		// Get variable label for categorical variable
		loc catlab : var label `ct'

		// Loop over all of the continuous variables
		foreach cnt of var `cont' { 
		
			// Define a macro used to set legend parameters
			loc leg legend(rows(`:char `ct'[lrows]') symy(1.85) symx(1.85))

			// Increment the boxplot counter
			loc boxcount = `boxcount' + 1
			
			// Generate Box plot
			gr box `cnt' if `touse', over(`ct') asyvars	`scheme' yti("")	 ///   
			ti(`: char `cnt'[title]' "vs" `: char `ct'[title]')	`missing'	 ///  
			note("Created on: `c(current_date)' at: `c(current_time)'") `leg'
						
			// Export to pdf
			qui: gr export `"`root'/graphs/box`boxcount'.pdf"', as(pdf) replace
			
			// Get LaTeX sanitized continuous variable name
			texclean "`cnt'", r
			
			// Store cleaned name in macro y
			loc y `r(clntex)'
			
			// Get LaTeX sanitized categorical variable name
			texclean "`ct'", r
			
			// Store cleaned name in macro x
			loc x `r(clntex)'
			
			// Get the y variable title string
			texclean `"`: var l `cnt''"'
			
			// Store the string
			loc ycap `r(clntex)'
			
			// Get the y variable title string
			texclean `"`: var l `ct''"'
			
			// Store the string
			loc xcap `r(clntex)'

			// Check if user wants to keep the GPH files
			if "`keepgph'" != "" {
			
				// Define local macro with syntax to remove file
				qui: gr save `"`root'/graphs/box`boxcount'.gph"', replace
			
			} // End IF Block to remove .gph files
		
			// Include in the LaTeX document
			file write doc "\begin{figure}[h!]" _n
			file write doc `"\caption{Box Plot of `ycap' by `xcap' \label{fig:box`boxcount'}}"' _n
			file write doc `"\includegraphics[width=\textwidth]{box`boxcount'.pdf}"' _n
			file write doc "\end{figure} \newpage\clearpage" _n
			
		} // End loop over continuous variables for a given categorical variable
		
	} // End loop over categorical variables
	
// End of program definition
end	

