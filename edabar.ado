********************************************************************************
* Description of the Program -												   *
* EDA subroutine used to create bar graphs						 			   *
*                                                                              *
* Program Output -                                                             *
*     Creates bar graph GPH and PDF as well as entries in the LaTeX document   *
*                                                                              *
* Lines -                                                                      *
*     75                                                                       *
*                                                                              *
********************************************************************************
		
*! edabar
*! v 0.0.0
*! 27OCT2015

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
										scheme(passthru)					 ///   
										keepgph	MISSing ]
										
	// Mark only the observations to use
	marksample touse

	// Add subsubsection header for categorical data
	file write doc "\subsubsection{Bar Graphs} \newpage\clearpage" _n
	
	// Create bar graphs for the categorical variables
	foreach v of var `varlist' { 

		// Define a macro used to set legend parameters
		loc leg legend(rows(`:char `v'[lrows]') symy(1.85) symx(1.85))

		// Create the histogram
		gr bar (`bartype') if `touse', over(`v') asyvars `bargraphopts' 	 ///   
		`scheme' ti(`: char `v'[title]') `leg' `missing'					 ///   
		note("Created on: `c(current_date)' at: `c(current_time)'") 	
		
		// Export to .pdf file
		qui: gr export `"`root'/graphs/bar`v'.pdf"', as(pdf) replace
		
		texclean "`v'", r
		loc ref `r(clntex)'
		texclean `"`: char `v'[title]'"'
		loc cap `r(clntex)'
		
		loc cap : subinstr loc cap `"""' "", all
				
		// Add the graph to the LaTeX file
		file write doc "\begin{figure}[h!]" _n
		file write doc `"\caption{`cap' \label{fig:bar`v'}}"' _n
		file write doc `"\includegraphics[width=\textwidth]{bar`v'.pdf}"' _n
		file write doc "\end{figure} \newpage\clearpage" _n

		// Check if user wants to keep the GPH files
		if "`keepgph'" != "" {
		
			// Define local macro with syntax to remove file
			qui: gr save `"`root'/graphs/bar`v'.gph"', replace
			
		} // End IF Block to remove .gph files
		
			
	} // End loop over categorical variables

// End Subroutine definition
end

