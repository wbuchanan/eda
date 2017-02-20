********************************************************************************
* Description of the Program -												   *
* EDA subroutine used to create box plots					 			       *
*                                                                              *
* Program Output -                                                             *
*     Creates series of box plots GPHs and PDFs as well as entries in the      * 
*	  LaTeX document  														   *
*                                                                              *
* Lines -                                                                      *
*     310                                                                      *
*                                                                              *
********************************************************************************
		
*! edabox
*! v 0.0.1
*! 10NOV2015

// Drop program from memory if already loaded
cap prog drop edabox

// Define program
prog def edabox

	// Version used to interpret code
	version 14
	
	// Syntax structure for edabar subroutine
	syntax [if] [in], root(string asis)	cat(varlist) cont(varlist)			 ///   
					  [ scheme(passthru) keepgph MISSing byvars(varlist) byseq ]
										
	// Mark only the observations to use
	marksample touse, strok novarlist
	
	// If no byvars argument is passed
	if "`byvars'" == "" {

		// Set up a counter macro
		loc boxcount = 0

		file write doc "\subsection{Box Plots}" _n

		// Loop over all the categorical variables
		foreach ct of var `cat' {
				
			file write doc `"\subsubsection{Distributions by `ct'}"' _n
			
			// Get variable label for categorical variable
			loc catlab : var label `ct'

			// Loop over all of the continuous variables
			foreach cnt of var `cont' { 
			
				qui: levelsof `ct', loc(categoryvalues)
				loc obexclude 
				foreach v of loc categoryvalues {
					qui: su `cnt' if `ct' == `v'
					if `r(N)' <= 5 loc obexclude `obexclude' `v'
				}
				if length("`obexclude'") != 0 {
					loc obexclude & !inlist(`ct', `: subinstr loc obexclude " " ", ", all')
				}
				
				// Define a macro used to set legend parameters
				loc leg legend(rows(`:char `ct'[lrows]') symy(1.85) symx(1.85))

				// Increment the boxplot counter
				loc boxcount = `boxcount' + 1
				
				// Generate Box plot
				gr box `cnt' if `touse' `obexclude', over(`ct') asyvars	`scheme' yti("")	 ///   
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
		
	} // End IF Block for normal boxplots
	
	// If the byvars parameter has  arguments and user specifies sequentially
	else if "`byvars'" != "" & "`byseq'" != "" {
	
		// Set up a counter macro
		loc boxcount = 0

		// Add subsection header
		file write doc "\subsection{Lattice Box Plots}" _n

		// Loop over all the categorical variables
		foreach ct of var `cat' {

			file write doc `"\subsubsection{Distributions by `ct'}"' _n
			
			// Get variable label for categorical variable
			loc catlab : var label `ct'

			// Loop over the bygroup variables
			foreach b of var `byvars' {
		
				// Get name of the by variable
				texclean `"`b'"', r
				
				// Store by variable name in bref
				loc bref `r(clntex)'
				
				// Get by variable label
				texclean `"`: var l `b''"'
				
				// Store label
				loc blab `r(clntex)'
				
				// Loop over all of the continuous variables
				foreach cnt of var `cont' { 
				
					qui: levelsof `ct', loc(categoryvalues)
					loc obexclude 
					foreach v of loc categoryvalues {
						qui: su `cnt' if `ct' == `v'
						if `r(N)' == 0 loc obexclude `obexclude' `v'
					}
					if length("`obexclude'") != 0 {
						loc obexclude & !inlist(`ct', `: subinstr loc obexclude " " ", ", all')
					}

					// Define a macro used to set legend parameters
					loc leg legend(rows(`:char `ct'[lrows]') symy(1.85) symx(1.85))

					// Increment the boxplot counter
					loc boxcount = `boxcount' + 1
					
					// Generate Box plot
					cap gr box `cnt' if `touse' `obexclude', over(`ct') asyvars	`scheme' ///   
					yti("")	`leg' `missing'	by(`bref', 						 ///   
					ti(`: char `cnt'[title]' "vs" `: char `ct'[title]')		 ///  
					note("Created on: `c(current_date)' at: `c(current_time)'"))
					
					// Check for successful return code
					if _rc == 0 {
					
						// Export to pdf
						qui: gr export `"`root'/graphs/box`bref'`boxcount'.pdf"', as(pdf) replace
						
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
							qui: gr save `"`root'/graphs/box`bref'`boxcount'.gph"', replace
						
						} // End IF Block to remove .gph files
					
						// Include in the LaTeX document
						file write doc "\begin{figure}[h!]" _n
						file write doc `"\caption{Box Plot of `ycap' over `xcap' by `bref' \label{fig:box`bref'`boxcount'}}"' _n
						file write doc `"\includegraphics[width=\textwidth]{box`bref'`boxcount'.pdf}"' _n
						file write doc "\end{figure} \newpage\clearpage" _n
						
					} // End IF Block for successful return code	
					
				} // End loop over continuous variables for a given categorical variable
			
			} // End loop over by variables
			
		} // End Loop over categorical variables
		
	} // End ELSEIF Block for sequential by graphs
		
	// If the byvars parameter has  arguments and user specifies sequentially
	else if "`byvars'" != "" & "`byseq'" != "" {
	
		// Set up a counter macro
		loc boxcount = 0

		file write doc "\subsection{Lattice Box Plots}" _n

		// Loop over all the categorical variables
		foreach ct of var `cat' {

			file write doc `"\subsubsection{Distributions by `ct'}"' _n
			
			// Get variable label for categorical variable
			loc catlab : var label `ct'

			// Loop over the bygroup variables
			foreach b of var `byvars' {
		
				qui: levelsof `ct', loc(categoryvalues)
				loc obexclude 
				foreach v of loc categoryvalues {
					qui: su `cnt' if `ct' == `v'
					if `r(N)' == 0 loc obexclude `obexclude' `v'
				}
				if length("`obexclude'") != 0 {
					loc obexclude & !inlist(`ct', `: subinstr loc obexclude " " ", ", all')
				}

				// Get name of the by variable
				texclean `"`b'"', r
				
				// Store by variable name in bref
				loc bref `r(clntex)'
				
				// Comma separate the byvariables
				loc blab `: subinstr loc bref `" "' `", "', all'
				
				// Loop over all of the continuous variables
				foreach cnt of var `cont' { 
				
					// Define a macro used to set legend parameters
					loc leg legend(rows(`:char `ct'[lrows]') symy(1.85) symx(1.85))

					// Increment the boxplot counter
					loc boxcount = `boxcount' + 1
					
					// Generate Box plot
					cap gr box `cnt' if `touse' `obexclude', over(`ct') asyvars	`scheme' ///   
					yti("")	`leg' `missing'	by(`bref', 						 ///   
					ti(`: char `cnt'[title]' "vs" `: char `ct'[title]')		 ///  
					note("Created on: `c(current_date)' at: `c(current_time)'"))
								
					// Check return code
					if _rc == 0 {
								
						// Export to pdf
						qui: gr export `"`root'/graphs/boxByGraph`boxcount'.pdf"', as(pdf) replace
						
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
							qui: gr save `"`root'/graphs/boxByGraph`boxcount'.gph"', replace
						
						} // End IF Block to remove .gph files
					
						// Include in the LaTeX document
						file write doc "\begin{figure}[h!]" _n
						file write doc `"\caption{Box Plot of `ycap' over `xcap' by `blab' \label{fig:boxByGraph`boxcount'}}"' _n
						file write doc `"\includegraphics[width=\textwidth]{boxByGraph`boxcount'.pdf}"' _n
						file write doc "\end{figure} \newpage\clearpage" _n
						
					} // End IF Block to check return code
						
				} // End loop over continuous variables for a given categorical variable
			
			} // End loop over by variables
			
		} // End Loop over categorical variables
		
	} // End ELSEIF Block for nonsequential by graphs		
	
// End of program definition
end	

