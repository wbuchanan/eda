********************************************************************************
* Description of the Program -												   *
* EDA subroutine used to create mosaic/spine plots					 		   *
*                                                                              *
* Program Output -                                                             *
*     Creates series of mosaic/spine plots GPHs and PDFs as well as entries in *
*	  the LaTeX document  													   *
*                                                                              *
* Lines -                                                                      *
*     93                                                                       *
*                                                                              *
********************************************************************************
		
*! edamosaic
*! v 0.0.0
*! 28OCT2015

// Drop program from memory if already loaded
cap prog drop edamosaic

// Define program
prog def edamosaic

	// Version used to interpret code
	version 14
	
	// Syntax structure for edabar subroutine
	syntax varlist(min=2) [if] [in], root(string asis)						 ///   
			[ scheme(passthru) keepgph PERCent MISSing byvars(varlist) byseq ]
			
	// Mark only the observations to use
	marksample touse
	
	// If no by vars are passed to the command
	if `"`byvars'"' == "" {

		// Add section header to LaTeX file
		file write doc "\subsubsection{Mosaic Plots}" _n

		// Generate list of all pairwise combination of continuous variables
		tuples `varlist', asis min(2) max(2)		
				
		// Generate scatter plots for all pairwise combinations of continuous variables
		forv i = 1/`ntuples' {

			// Use the first element of the tuple for the x-axis
			loc x : word 1 of `tuple`i''
			
			// Use the second element of the tuple for the y-axis
			loc y : word 2 of `tuple`i''
			
			// Set legend rows 
			loc rs rows(`: char `y'[lrows]')
			
			// Macro storing legending options
			loc legend legend(`rs' pos(12) symy(1.85) symx(1.85))

			// Create mosaic plot
			spineplot `y' `x' if `touse', `percent' `missing' `legend'			 ///   
			xti(`: char `x'[title]', axis(2)) yti(`: char `y'[title]', axis(2))  ///   
			ti("Joint distribution of " `: char `y'[title]' " and "				 ///   
			`: char `x'[title]') `scheme'  
			
			// Export to pdf
			qui: gr export `"`root'/graphs/mosaic`i'.pdf"', as(pdf) replace
			
			// Get a LaTeX prepped version of the y var label
			texclean `"`: var l `y''"'

			// Store the prepped y var label in yax
			loc yax `r(clntex)'

			// Get a LaTeX prepped version of the x var label
			texclean `"`: var l `x''"'

			// Store the prepped x var label in xax
			loc xax `r(clntex)'
		
			// Check if user wants to keep the GPH files
			if "`keepgph'" != "" {
			
				// Define local macro with syntax to remove file
				qui: gr save `"`root'/graphs/mosaic`i'.gph"', replace
				
			} // End IF Block to remove .gph files

			// Include in the LaTeX document
			file write doc "\begin{figure}[h!]" _n
			file write doc `"\caption{Mosaic Plots of `yax' by `xax' \label{fig:mosaic`i'}}"' _n
			file write doc `"\includegraphics[width=\textwidth]{mosaic`i'.pdf}"' _n
			file write doc "\end{figure} \newpage\clearpage" _n
						
		} // End loop over categorical by categorical tuples
		
	} // End IF Block for no byvars
			
	// sequential by graphs
	else if `"`byvars'"' != "" & "`byseq'" != "" {
	
	
	} // End ELSEIF Block for sequential by graphs
	
	// Lattice graphs
	else if `"`byvars'"' != "" & "`byseq'" == "" {
	
	
	} // End ELSE IF Block for Lattice style graphs
		
// End of program definition
end

