********************************************************************************
* Description of the Program -												   *
* EDA subroutine used to create mosaic/spine plots					 		   *
*                                                                              *
* Program Output -                                                             *
*     Creates series of mosaic/spine plots GPHs and PDFs as well as entries in *
*	  the LaTeX document  													   *
*                                                                              *
* Lines -                                                                      *
*     87                                                                       *
*                                                                              *
********************************************************************************
		
*! edamosaic
*! v 0.0.0
*! 27OCT2015

// Drop program from memory if already loaded
cap prog drop edamosaic

// Define program
prog def edamosaic

	// Version used to interpret code
	version 14
	
	// Syntax structure for edabar subroutine
	syntax varlist(min=2) [if] [in], root(string asis)						 ///   
									 [ scheme(passthru) keepgph PERCent MISSing ]
			
	// Mark only the observations to use
	marksample touse

	// Add section header to LaTeX file
	file write doc "\subsubsection{Bivariate Distributions and Lines of Best Fit}" _n

	// Generate list of all pairwise combination of continuous variables
	tuples `varlist', asis min(2) max(2)		
			
	// Generate scatter plots for all pairwise combinations of continuous variables
	forv i = 1/`ntuples' {

		// Use the first element of the tuple for the x-axis
		loc x : word 1 of `tuple`i''
		
		// Use the second element of the tuple for the y-axis
		loc y : word 2 of `tuple`i''
		
		// Set legend rows 
		loc rs `= round((`: char `y'[nvals]' / 3), 1)'
		
		// Macro storing legending options
		loc legend legend(rows(`rs') pos(12) span symy(1.85) symx(1.85))

		// Create mosaic plot
		spineplot `y' `x' if `touse', `percent' `missing' `legend'			 ///   
		xti(`: char `x'[title]') yti(`: char `y'[title]') 					 ///   
		ti("Joint distribution of `y' and `x'")	`scheme'  
		
		// Export to pdf
		qui: gr export `"`root'/graphs/mosaic`i'.pdf"', as(pdf) replace
		
		texclean "`: char `y'[title]'"
		loc yax `r(clntex)'
		texclean "`: char `x'[title]'"
		loc xax `r(clntex)'
	
		// Check if user wants to keep the GPH files
		if "`keepgph'" != "" {
		
			// Define local macro with syntax to remove file
			qui: gr save `"`root'/graphs/mosaic`i'.gph"', replace
			
		} // End IF Block to remove .gph files

		// Include in the LaTeX document
		file write doc "\begin{figure}" _n
		file write doc `"\caption{`yax' by `xax' \label{fig:mosaic`i'}}"' _n
		file write doc `"\includegraphics[angle=90,width=\textwidth]{mosaic`i'.pdf}"' _n
		file write doc "\end{figure} \newpage\clearpage" _n
					
	} // End loop over categorical by categorical tuples
			
// End of program definition
end

