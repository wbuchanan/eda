********************************************************************************
* Description of the Program -												   *
* EDA subroutine used to create bar graphs						 			   *
*                                                                              *
* Program Output -                                                             *
*     Creates bar graph GPH and PDF as well as entries in the LaTeX document   *
*                                                                              *
* Lines -                                                                      *
*     230                                                                      *
*                                                                              *
********************************************************************************
		
*! edabar
*! v 0.0.2
*! 22sep2019

// Drop program from memory if already loaded
cap prog drop edabar

// Define program
prog def edabar

	// Version used to interpret code
	version 14
	
	// Syntax structure for edabar subroutine
	syntax varlist(min=1) [if] [in], 	BARType(string asis)				 /// 
										root(string asis)					 ///   
										[BARGRAphopts(string asis)			 ///   
										scheme(passthru) byseq				 ///   
										keepgph	MISSing byvars(varlist) DEBug ]
										
	// Mark only the observations to use
	marksample touse, strok novarlist

	// If the byvars parameter has no arguments
	if "`byvars'" == "" {
	
		// Add subsubsection header for categorical data
		file write doc "\subsubsection{Bar Graphs} \newpage\clearpage" _n
		
		// Create bar graphs for the categorical variables
		foreach v of var `varlist' { 

			// Define a macro used to set legend parameters
			loc leg legend(rows(`:char `v'[lrows]') symy(1.85) symx(1.85))

			// Create the histogram
			gr bar (`bartype') if `touse', over(`v') asyvars `bargraphopts'  ///   
			`scheme' ti(`: char `v'[title]') `leg' `missing'				 ///   
			note("Created on: `c(current_date)' at: `c(current_time)'") 	
			
			// Export to .pdf file
			qui: gr export `"`root'/graphs/bar`v'.pdf"', as(pdf) replace
			
			// Get prepped version of the variable name
			texclean `"`v'"', r
			
			// Store variable name in local macro ref
			loc ref `r(clntex)'
			
			// Get the cleaned variable label
			texclean `"`: var l `v''"'
			
			// Store the cleaned variable label
			loc cap `r(clntex)'
					
			// Add the graph to the LaTeX file
			file write doc "\begin{figure}[h!]" _n
			file write doc `"\caption{`cap' \label{fig:bar`v'}}"' _n
			file write doc `"\includegraphics[width=\textwidth]{bar`v'.pdf}"' _n
			file write doc "\end{figure}" _n
			file write doc "\hyperlink{tof}{Back to List of Figures}" _n
			file write doc "\hyperlink{toc}{Back to Table of Contents}\newpage\clearpage" _n

			// Check if user wants to keep the GPH files
			if "`keepgph'" != "" {
			
				// Define local macro with syntax to remove file
				qui: gr save `"`root'/graphs/bar`v'.gph"', replace
				
			} // End IF Block to remove .gph files
			
		} // End loop over categorical variables
		
	} // End IF Block for single variable

	// If the byvars parameter has  arguments and user specifies sequentially
	else if "`byvars'" != "" & "`byseq'" != "" {
	
		// Create bar graphs for the categorical variables
		foreach v of var `varlist' { 

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
				
				// Get the name of the bar variable
				texclean `"`v'"', r
				
				// Store bar variable name
				loc ref `r(clntex)'
				
				// Combined Label for Captions
				texclean `"`: var l `v'' by `blab'"'

				// Store the caption string
				loc cap `r(clntex)'
				
				// Double check that all internal quotation marks are removed
				loc cap : subinstr loc cap `"""' "", all
								
				// Add subsubsection header for categorical data
				file write doc "\subsubsection{Bar Graphs by `blab'} \newpage\clearpage" _n
		
				// Define a macro used to set legend parameters
				loc leg legend(rows(`:char `v'[lrows]') symy(1.85) symx(1.85))

				// Create the histogram
				cap gr bar (`bartype') if `touse', over(`v') asyvars 		 ///   
				`bargraphopts' `scheme' `missing' by(`b', `leg'				 ///   
				ti(`: char `v'[title]') 									 ///   
				note("Created on: `c(current_date)' at: `c(current_time)'"))
				
				// Check return code
				if _rc == 0 {
				
					// Export to .pdf file
					qui: gr export `"`root'/graphs/bar`v'By`bref'.pdf"', as(pdf) replace
				
					// Add the graph to the LaTeX file
					file write doc "\begin{figure}[h!]" _n
					file write doc `"\caption{`cap' \label{fig:bar`v'By`bref'}}"' _n
					file write doc `"\includegraphics[width=\textwidth]{bar`v'By`bref'.pdf}"' _n
					file write doc "\end{figure}" _n
					file write doc "\hyperlink{tof}{Back to List of Figures}" _n
					file write doc "\hyperlink{toc}{Back to Table of Contents}\newpage\clearpage" _n

					// Check if user wants to keep the GPH files
					if "`keepgph'" != "" {
					
						// Define local macro with syntax to remove file
						qui: gr save `"`root'/graphs/bar`v'By`bref'.gph"', replace
						
					} // End IF Block to remove .gph files
					
				} // End IF Block for return code check
			
			} // End Loop over by variables
		
		} // End loop over categorical variables
		
	} // End ELSEIF Block for sequential by graphs

	// If the byvars parameter has  arguments and user specifies sequentially
	else if "`byvars'" != "" & "`byseq'" == "" {
	
		// Create bar graphs for the categorical variables
		foreach v of var `varlist' { 

			// Get the name of the bar variable
			texclean `"`v'"', r
			
			// Store bar variable name
			loc ref `r(clntex)'
			
			// Comma separate the byvars
			loc blab `: subinstr loc byvars `" "' `", "', all'
			
			// Combined Label for Captions
			texclean `"`: var l `v'' by `blab'"'

			// Store the caption string
			loc cap `r(clntex)'
			
			// Double check that all internal quotation marks are removed
			loc cap : subinstr loc cap `"""' "", all
							
			// Add subsubsection header for categorical data
			file write doc "\subsubsection{Bar Graphs by `blab'} \newpage\clearpage" _n
	
			// Define a macro used to set legend parameters
			loc leg legend(rows(`:char `v'[lrows]') symy(1.85) symx(1.85))

			// Create the histogram
			cap gr bar (`bartype') if `touse', over(`v') asyvars `missing' 	 ///   
			`bargraphopts' `scheme' by(`byvars', ti(`: char `v'[title]') 	 ///   
			note("Created on: `c(current_date)' at: `c(current_time)'") `leg') 	
			
			// Check return code
			if _rc == 0 {
			
				// Export to .pdf file
				qui: gr export `"`root'/graphs/bar`v'ByGraph.pdf"', as(pdf) replace
			
				// Add the graph to the LaTeX file
				file write doc "\begin{figure}[h!]" _n
				file write doc `"\caption{`cap' \label{fig:bar`v'ByGraph}}"' _n
				file write doc `"\includegraphics[width=\textwidth]{bar`v'ByGraph.pdf}"' _n
				file write doc "\end{figure}" _n
				file write doc "\hyperlink{tof}{Back to List of Figures}" _n
				file write doc "\hyperlink{toc}{Back to Table of Contents}\newpage\clearpage" _n

				// Check if user wants to keep the GPH files
				if "`keepgph'" != "" {
				
					// Define local macro with syntax to remove file
					qui: gr save `"`root'/graphs/bar`v'ByGraph.gph"', replace
					
				} // End IF Block to remove .gph files

			} // End IF Block for successful return code
			
		} // End loop over categorical variables
		
	} // End ELSE Block for by graphs

// End Subroutine definition
end

