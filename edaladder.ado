********************************************************************************
* Description of the Program -												   *
* EDA subroutine used to create ladders of powers graphs		 			   *
*                                                                              *
* Program Output -                                                             *
*     Creates series of ladder of powers graph GPHs and PDFs as well as 	   *
* 	  entries in the LaTeX document  										   *
*                                                                              *
* Lines -                                                                      *
*     93                                                                       *
*                                                                              *
********************************************************************************
		
*! edaladder
*! v 0.0.0
*! 28OCT2015

// Drop program from memory if already loaded
cap prog drop edaladder

// Define program
prog def edaladder

	// Version used to interpret code
	version 14
	
	// Syntax structure for edabar subroutine
	syntax varlist(min=1) [if] [in], 	root(string asis)					 ///   
										[HISTOGRamopts(string asis)			 ///   
										scheme(passthru)					 ///   
										keepgph	]
										
	// Mark only the observations to use
	marksample touse, strok novarlist

	// Add subheading to the LaTeX file
	file write doc "\subsubsection{Ladder of Powers Transformation Graphs} \newpage\clearpage" _n

	// Loop over continuous variables
	foreach v of var `varlist' {
	
		// Create the gladder graph
		gladder `v' if `touse', `scheme' `histogramopts'					 ///   
		ti("Ladder of Powers Histograms for " `: char `v'[title]')
	
		// Export to pdf
		qui: gr export `"`root'/graphs/gladder`v'.pdf"', as(pdf) replace
	
		// Create the gladder graph
		qladder `v' if `touse', `scheme' `histogramopts'					 ///   
		ti("Ladder of Powers Quantile Normal Plots for " `:char `v'[title]')
	
		// Export to pdf
		qui: gr export `"`root'/graphs/qladder`v'.pdf"', as(pdf) replace
		
		// Get LaTeX formatted variable name
		texclean "`v'", r
		
		// Store the variable name in the local macro vref
		loc vref `r(clntex)'
		
		// Get a LaTeX cleaned title string
		texclean `"`: var l `v''"'
		
		// Store the string in the local macro vlab
		loc vlab `r(clntex)'
		
		// Remove unneeded quotation marks from the label string
		loc vlab : subinstr loc vlab `"""' "", all
				
		// Add the graph to the LaTeX file
		file write doc "\begin{figure}[h!]" _n
		file write doc `"\caption{`vlab' Ladder of Powers Histograms \label{fig:gladder`vref'}}"' _n
		file write doc `"\includegraphics[width=\textwidth]{gladder`v'.pdf}"' _n
		file write doc "\end{figure} \newpage\clearpage" _n
		file write doc "\begin{figure}[h!]" _n
		file write doc `"\caption{`vlab' Ladder of Powers Quantile Normal Plots \label{fig:qladder`vref'}}"' _n
		file write doc `"\includegraphics[width=\textwidth]{qladder`v'.pdf}"' _n
		file write doc "\end{figure} \newpage\clearpage" _n
		
		// Check if user wants to keep the GPH files
		if "`keepgph'" != "" {

			// Erase the GPH Files
			qui: gr save `"`root'/graphs/gladder`v'.gph"', replace
			qui: gr save `"`root'/graphs/qladder`v'.gph"', replace
		
		} // End of Keep Stata graph files option
		
	} // End Loop over continuous variables

// End program definition
end	

