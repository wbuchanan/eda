********************************************************************************
* Description of the Program -												   *
* EDA subroutine used to create scatter plots					 			   *
*                                                                              *
* Program Output -                                                             *
*     Creates series of scatterplots GPHs and PDFs as well as entries in the   * 
*	  LaTeX document  														   *
*                                                                              *
* Lines -                                                                      *
*     289                                                                      *
*                                                                              *
********************************************************************************
		
*! edascat
*! v 0.0.2
*! 22sep2019

// Drop program from memory if already loaded
cap prog drop edascat

// Define program
prog def edascat

	// Version used to interpret code
	version 14
	
	// Syntax structure for edabar subroutine
	syntax varlist(min=1) [if] [in], 	root(string asis)					 ///   
										[ LFIT LFIT2(string asis) 			 ///   
										QFIT QFIT2(string asis)			 	 ///   
										LOWess LOWess2(string asis) 		 ///   
										FPFIT FPFIT2(string asis)			 ///   
										LFITCi LFITCi2(string asis) 		 ///   
										QFITCi QFITCi2(string asis)			 ///   
										FPFITCi FPFITCi2(string asis)		 ///  
										scheme(passthru) keepgph 			 ///   
										byvars(varlist) byseq DEBug ]
										
	// Mark only the observations to use
	marksample touse, strok novarlist
	
	// If byvars weren't passed
	if `"`byvars'"' == "" {

		// Add section header to LaTeX file
		file write doc "\subsubsection{Scatterplots}" _n

		// Generate list of all pairwise combination of continuous variables
		tuples `varlist', asis min(2) max(2) cvp	
				
		// Generate scatter plots for all pairwise combinations of continuous variables
		forv i = 1/`ntuples' {
		
			// Use the first element of the tuple for the x-axis
			loc x : word 1 of `tuple`i''
			
			// Use the second element of the tuple for the y-axis
			loc y : word 2 of `tuple`i''
			
			// Check for linear fit
			if "`lfit'" != "" {
			
				// Check for lfit overlay options
				if "`lfit2'" != "" {
				
					// Add comma before options
					loc lfit2 , `lfit2' 
			
				} // End If Block for linear fit options
				
				// Local with lfit option syntax
				loc grlfit lfit `y' `x'  if `touse'`lfit2' || 
				
				// Legend label
				loc lfitlab "Linear"
				
			} // End of IF Block for linear fit overlay
			
			// Check for lowess smoothed fit 
			if "`lowess'" != "" {
			
				// Check for lowess overlay options
				if "`lowess2'" != "" {
				
					// Add comma before options
					loc lowess2 , `lowess2'
			
				} // End If Block for linear fit options
				
				// Local with lowess option syntax
				loc grlowess lowess `y' `x'  if `touse'`lowess2' || 
				
				// Legend label
				loc lowesslab "Loess Smoother"
				
			} // End of IF Block for lowess smoothed fit 
			
			// Check for quadratic fit
			if "`qfit'" != "" {
			
				// Check for qfit overlay options
				if "`qfit2'" != "" {
				
					// Add comma before options
					loc qfit2 , `qfit2'
			
				} // End If Block for linear fit options
				
				// Local with qfit option syntax
				loc grqfit qfit `y' `x'  if `touse'`qfit2' || 
				
				// Legend label
				loc qfitlab "Quadratic"
				
			} // End of IF Block for quadratic fit overlay
			
			// Check for fractional polynomial fit 
			if "`fpfit'" != "" {
			
				// Check for fpfit overlay options
				if "`fpfit2'" != "" {
				
					// Add comma before options
					loc fpfit2 , `fpfit2'
			
				} // End If Block for linear fit options
				
				// Local with fpfit option syntax
				loc grfpfit fpfit `y' `x'  if `touse'`fpfit2' || 
				
				// Legend label
				loc fpfitlab "Fractional Polynomial"
				
			} // End of IF Block for fractional polynomial fit 
			
			// Check for linear fit with confidence intervals
			if "`lfitci'" != "" {
			
				// Check for lfitci overlay options
				if "`lfitci2'" != "" {
				
					// Add comma before options
					loc lfitci2 , `lfitci2'
			
				} // End If Block for linear fit options
				
				// Local with lfitci option syntax
				loc grlfitci lfitci `y' `x'  if `touse'`lfitci2' || 
				
				// Label for linear ci overlay
				loc lfitcilab "Linear Fit w/CIs"
				
			} // End of IF Block for linear fit with confidence intervals overlay
			
			// Check for quadratic fit with confidence intervals
			if "`qfitci'" != "" {
			
				// Check for qfitci overlay options
				if "`qfitci2'" != "" {
				
					// Add comma before options
					loc qfitci2 , `qfitci2'
			
				} // End If Block for linear fit options
				
				// Local with qfitci option syntax
				loc grqfitci qfitci `y' `x'  if `touse'`qfitci2' || 
				
				// Label for linear ci overlay
				loc lfitcilab "Quadratic Fit w/CIs"
				
			} // End of IF Block for quadratic fit with confidence intervals overlay
			
			// Check for fractional polynomial fit with confidence intervals
			if "`fpfitci'" != "" {
								
				// Check for qfitci overlay options
				if "`fpfitci2'" != "" {
				
					// Add comma before options
					loc fpfitci2 , `fpfitci2'
			
				} // End If Block for linear fit options
				
				// Local with qfitci option syntax
				loc grfpfitci fpfitci `y' `x'  if `touse' `fpfitci2' || 
				
				// Label for linear ci overlay
				loc fpfitcilab "Fractional Polynomial w/CIs"
				
			} // End of IF Block for fractional polynomial fit with confidence intervals

			// Local macro to use for indexing legending graphs
			loc scattercounter = 1
			
			// Loop over the overlay options
			foreach ov in lfit lowess qfit fpfit lfitci qfitci fpfitci { 
			
				// End IF Block to check for legend labels
				if `"``ov'lab'"' != "" {
				
					// Increment the counter id
					loc scattercounter = `scattercounter' + 1
					
					// Append the labels for the legend
					loc legendlabels `legendlabels' label(`scattercounter' ``ov'lab')
					
				} // End IF Block
				
			} // End Loop over overlay options
			
			// Add scatter points as the last element of the legend labels
			loc legendlabels label(`= `scattercounter' + 1' "Scatter Points")

			// Append the labels for the legend
			loc legendlabels `legendlabels' label(`scattercounter' ``ov'lab')
					
			// If there are 4 or less total legend entries use a single row
			if `scattercounter' <= 4 {
			
				// Syntax to enforce single row of legend keys
				loc leg legend(rows(1) symy(1.85) symx(1.85) `legendlabels')
				
			} // End IF Block for <= 4 graph elements

			// If there are more elements to place in the legend
			else {
			
				// Reduce the size of the labels
				loc leg legend(rows(2) symy(1.85) symx(1.85) `legendlabels' size(small))
				
			} // End ELSE Block for many legend entries
			
			// Generate the scatterplot
			tw `grlfitci' `grqfitci' `grfpfitci' `grlfit' `grlowess' `grqfit' 	 ///   
			`grfpfit' scatter `y' `x' if `touse', `scheme' 	`leg'				 ///   
			xti(`: char `x'[title]') yti(`: char `y'[title]')					 ///   
			ti("Joint Distribution of `y' and `x'")								 ///   
			note("Created on: `c(current_date)' at: `c(current_time)'") 
			
			// Export the scatterplot as a .png file
			qui: gr export `"`root'/graphs/scatter-`y'-`x'.pdf"', as(pdf) replace
			
			// Check if user wants to keep the GPH files
			if "`keepgph'" != "" {
			
				// Define local macro with syntax to remove file
				qui: gr save `"`root'/graphs/scatter-`y'-`x'.gph"', replace
				
			} // End IF Block to remove .gph files

			// Get LaTeX cleaned y variable label
			texclean `"`: var l `y''"'

			// Store the y variable label in yti
			loc yti `r(clntex)'

			// Get LaTeX cleaned x variable label
			texclean `"`: var l `x''"'

			// Store the x variable label in xti
			loc xti `r(clntex)'

			// Add the scatterplot to the LaTeX document
			file write doc "\begin{figure}[h!]" _n
			file write doc `"\caption{Scatterplot of `yti' \& `xti' \label{fig:scatter`i'}}"' _n
			file write doc `"\includegraphics[width=\textwidth]{scatter-`y'-`x'.pdf}"' _n
			file write doc "\end{figure}" _n
			file write doc "\hyperlink{tof}{Back to List of Figures}" _n
			file write doc "\hyperlink{toc}{Back to Table of Contents}\newpage\clearpage" _n
			
		} // End Loop over scatter plot permutations
	
	} // End IF Block for no byvars argument
	
	// sequential by graphs
	else if `"`byvars'"' != "" & "`byseq'" != "" {
	
	
	} // End ELSEIF Block for sequential by graphs
	
	// Lattice graphs
	else if `"`byvars'"' != "" & "`byseq'" == "" {
	
	
	} // End ELSE IF Block for Lattice style graphs
		
// End Program definition
end

