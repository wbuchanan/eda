********************************************************************************
* Description of the Program -												   *
* EDA subroutine used to create pie charts						 			   *
*                                                                              *
* Program Output -                                                             *
*     Creates pie chart GPH and PDF as well as entries in the LaTeX document   *
*                                                                              *
* Lines -                                                                      *
*     180                                                                      *
*                                                                              *
********************************************************************************
		
*! edahist
*! v 0.0.0
*! 27OCT2015

// Drop program from memory if already loaded
cap prog drop edahist

// Define program
prog def edahist

	// Version used to interpret code
	version 14
	
	// Syntax structure for edabar subroutine
	syntax varlist(min=1) [if] [in], 	root(string asis)					 ///   
										[ HISTOGramopts(string asis)		 ///   
										KDENSity 							 ///  
										KDENSOpts(string asis)				 ///  
										FIVENUMsum 							 ///  
										FNSOpts(string asis)				 ///
										scheme(passthru)					 ///   
										keepgph	]
										
	// Mark only the observations to use
	marksample touse

	// Graphs for individual continuous variables
	foreach v of var `varlist' {

		// Get some basic info about the variable
		qui: su `v' if `touse', de
		
		// Store sample size
		loc n = r(N)
		
		// Observed minimum value of variable
		loc vmin = r(min)
		
		// Observed 25th percentile of variable
		loc vpct25 = r(p25)
		
		// Observed 50th percentile of variable
		loc vmedian = r(p50)
		
		// Observed 75th percentile of variable
		loc vpct75 = r(p75)
		
		// Observed maximum value of variable
		loc vmax = r(max)
		
		// Observed mean of variable
		loc mu = r(mean)
		
		// Observed standard deviation of variable
		loc sigma = r(sd)
		
		// Check for 5 num summary option
		if "`fivenumsum'" != "" {
		
			// Check for fivenum opts
			if `"`fnsopts'"' != "" {
			
				// Loop over "word" segments
				forv fnsnum = 1/`: word count `fnsopts'' {
				
					// Create individual macros for the options
					loc fns`fnsnum' , `: word `fnsnum' of `fnsopts''
				
				} // End Loop over the word segments in the option
			
			} // End IF Block for five number summary options
			
			// Syntax to add vertical line for minimum value
			loc xlinemin xline(`vmin' `fns1')
			
			// Syntax to add vertical line for 25th %ile value
			loc xlinep25 xline(`vpct25' `fns2')
			
			// Syntax to add vertical line for 50th %ile value
			loc xlinemed xline(`vmedian' `fns3')
			
			// Syntax to add vertical line for 75th %ile value
			loc xlinep75 xline(`vpct75' `fns4')
			
			// Syntax to add vertical line for maximum value
			loc xlinemax xline(`vmax' `fns5')
			
			// Builds caption text
			loc cap1 "Vertical lines show locations of Tukey's Five Number Summary "
			
			// Text to display min/25th %ile values
			loc cap2a "Min = `: di %5.2f `vmin'' 25th %ile = `: di %5.2f `vpct25'' " 

			// Text to display median values
			loc cap2b "Median = `: di %5.2f `vmedian'' "

			// Text to display 75th/Maximum %ile values
			loc cap2c "75th %ile = `: di %5.2f `vpct75'' Max = `: di %5.2f `vmax''"

			// Build second line of caption string
			loc cap2 "`cap2a'`cap2b'`cap2c'"
					
			// Build last line of caption string
			loc cap3 "{&mu} = `: di %5.2f `mu'' {&sigma} = `: di %5.2f `sigma''"
			
			// Local macro used to add caption to graph
			loc caption caption("`cap1'" "`cap2'" "`cap3'", size(vsmall) span)
		
		} // End IF Block for Tukey's Five Number Summary

		// If no five number summary is requested
		else {

			// Create text with mu = formatted mean of the variable
			loc cap1 "{&mu} = `: di %5.2f `mu'' "

			// Create text with sigma = formatted SD of the variable
			loc cap2 "{&sigma} = `: di %5.2f `sigma''"
		
			// Local macro used to add caption to graph
			loc caption caption("`cap1'`cap2'", size(vsmall) span)
		
		} // End ELSE Block for no five number summary
		
		// Create graph
		histogram `v' if `touse', `kdensity' `xlinemin' `xlinep25' 			 ///   
		`xlinemed' `xlinep75' `xlinemax' `caption' `kdensopts'				 ///
		`histogramopts' ti(`: char `v'[title]') `scheme'					 ///   
		note("Created on: `c(current_date)' at: `c(current_time)'") 
		
		// Get LaTeX formatted variable name
		texclean "`v'", r
		
		// Store the name in vref
		loc vref `r(clntex)'
		
		// Get a LaTeX cleaned title string
		texclean "`: char `v'[title]'"
		
		// Store the string in the local macro vlab
		loc vlab `r(clntex)'
		
		// Remove unneeded quotation marks from the label string
		loc vlab : subinstr loc vlab `"""' "", all
		
		// Export graph to pdf
		qui: gr export `"`root'/graphs/histo`v'.pdf"', as(pdf) replace
		
		// Check if user wants to keep the GPH files
		if "`keepgph'" != "" {
		
			// Define local macro with syntax to remove file
			qui: gr save `"`root'/graphs/histo`v'.gph"', replace
			
		} // End IF Block to remove .gph files

		// Add the graph to the LaTeX file
		file write doc "\begin{figure}" _n
		file write doc `"\caption{`vlab' \label{fig:histo`vref'}}"' _n
		file write doc `"\includegraphics{histo`v'.pdf}"' _n
		file write doc "\end{figure} \newpage\clearpage" _n
		
	} // End loop over continuous variables

// End of Program definition	
end

	
