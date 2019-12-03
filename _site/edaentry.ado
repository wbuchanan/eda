/*******************************************************************************

	This is completely experimental and not intended for distribution with 
	eda at this time.  It is an attempt at refactoring some of the functionality
	of the internals in eda to maintain LaTeX entries for specific captions, 
	titling, and reference entries outside of individual sub routines and/or 
	the main program.

*******************************************************************************/

*! edaentry
*! v 0.0.0
*! 07JUL2018

cap prog drop edaentry

prog def edaentry

	version 14
	
	syntax , id(string asis) XVar(varname) Type(string asis) 				 ///   
			 [ YVar(varname) AUXvar(varname) ]

	// Remove LaTeX Special Characters from variable name
	texclean "`xvar'", r
	
	// Store in local macro
	loc xref `r(clntex)'
	
	// Get label info 
	texclean "`: var l `xvar''"
	
	// Set title/caption info
	loc xlab `r(clntex)'
	
	// If yvar is passed 
	if "`yvar'" != "" {
	
		// Remove LaTeX Special Characters from variable name
		texclean "`yvar'", r
		
		// Store variable name for use in references
		loc yref `r(clntex)'
		
		// Get label info 
		texclean "`: var l `xvar''"
		
		// Set title/caption info
		loc xlab `r(clntex)'
		
	} // End IF Block for yvars
	
	// If auxvar passed create macros
	if "`auxvar'" != "" {
		
		// Remove LaTeX Special Characters from variable name
		texclean "`auxvar'", r
		
		// Store variable name for use in references
		loc auxref `r(clntex)'

		// Get label info 
		texclean "`: var l `auxvar''"
		
		// Set title/caption info
		loc auxlab `r(clntex)'
	
	} // End IF Block for auxvars
	
	// Check the type of the entry to add
	if "`type'" == "bar" {

		// Add the graph to the LaTeX file
		file write doc "\begin{figure}" _n
		file write doc `"\caption{`xlab' \label{fig:`type'`xref'}}"' _n // Add Identifier
		file write doc `"\includegraphics{`type'`xvar'.pdf}"' _n // Add Identifier
		file write doc "\end{figure} \newpage\clearpage" _n
	
	} // End IF Block for bar graphs
	
	// If the type is 
	else if "`type'" == "pie" {

		// Add the graph to the LaTeX file
		file write doc "\begin{figure}" _n
		file write doc `"\caption{`: char `v'[title]' \label{fig:`type'}}"' _n // Add Identifier
		file write doc `"\includegraphics{`type'`xvar'.pdf}"' _n // Add Identifier
		file write doc "\end{figure} \newpage\clearpage" _n
	
	} // End ELSEIF Block for 
	
	// If the type is 
	else if "`type'" == "" {

		// Add the graph to the LaTeX file
		file write doc "\begin{figure}" _n
		file write doc `"\caption{`: char `v'[title]' \label{fig:`type'}}"' _n // Add Identifier
		file write doc `"\includegraphics{`type'.pdf}"' _n // Add Identifier
		file write doc "\end{figure} \newpage\clearpage" _n
	
	} // End ELSEIF Block for 
	
	// If the type is 
	else if "`type'" == "" {

		// Add the graph to the LaTeX file
		file write doc "\begin{figure}" _n
		file write doc `"\caption{`: char `v'[title]' \label{fig:`type'}}"' _n // Add Identifier
		file write doc `"\includegraphics{`type'.pdf}"' _n // Add Identifier
		file write doc "\end{figure} \newpage\clearpage" _n
	
	} // End ELSEIF Block for 
	
	// If the type is 
	else if "`type'" == "" {

		// Add the graph to the LaTeX file
		file write doc "\begin{figure}" _n
		file write doc `"\caption{`: char `v'[title]' \label{fig:`type'}}"' _n // Add Identifier
		file write doc `"\includegraphics{`type'.pdf}"' _n // Add Identifier
		file write doc "\end{figure} \newpage\clearpage" _n
	
	} // End ELSEIF Block for 
	
	// If the type is 
	else if "`type'" == "" {

		// Add the graph to the LaTeX file
		file write doc "\begin{figure}" _n
		file write doc `"\caption{`: char `v'[title]' \label{fig:`type'}}"' _n // Add Identifier
		file write doc `"\includegraphics{`type'.pdf}"' _n // Add Identifier
		file write doc "\end{figure} \newpage\clearpage" _n
	
	} // End ELSEIF Block for 
	
	// If the type is 
	else if "`type'" == "" {

		// Add the graph to the LaTeX file
		file write doc "\begin{figure}" _n
		file write doc `"\caption{`: char `v'[title]' \label{fig:`type'}}"' _n // Add Identifier
		file write doc `"\includegraphics{`type'.pdf}"' _n // Add Identifier
		file write doc "\end{figure} \newpage\clearpage" _n
	
	} // End ELSEIF Block for 
	
	// If the type is 
	else if "`type'" == "" {

		// Add the graph to the LaTeX file
		file write doc "\begin{figure}" _n
		file write doc `"\caption{`: char `v'[title]' \label{fig:`type'}}"' _n // Add Identifier
		file write doc `"\includegraphics{`type'.pdf}"' _n // Add Identifier
		file write doc "\end{figure} \newpage\clearpage" _n
	
	} // End ELSEIF Block for 
	
	// If the type is 
	else if "`type'" == "" {

		// Add the graph to the LaTeX file
		file write doc "\begin{figure}" _n
		file write doc `"\caption{`: char `v'[title]' \label{fig:`type'}}"' _n // Add Identifier
		file write doc `"\includegraphics{`type'.pdf}"' _n // Add Identifier
		file write doc "\end{figure} \newpage\clearpage" _n
	
	} // End ELSEIF Block for 
	
	// If the type is 
	else if "`type'" == "" {

		// Add the graph to the LaTeX file
		file write doc "\begin{figure}" _n
		file write doc `"\caption{`: char `v'[title]' \label{fig:`type'}}"' _n // Add Identifier
		file write doc `"\includegraphics{`type'.pdf}"' _n // Add Identifier
		file write doc "\end{figure} \newpage\clearpage" _n
	
	} // End ELSEIF Block for 
	
	// If the type is 
	else if "`type'" == "" {

		// Add the graph to the LaTeX file
		file write doc "\begin{figure}" _n
		file write doc `"\caption{`: char `v'[title]' \label{fig:`type'}}"' _n // Add Identifier
		file write doc `"\includegraphics{`type'.pdf}"' _n // Add Identifier
		file write doc "\end{figure} \newpage\clearpage" _n
	
	} // End ELSEIF Block for 
	
	// For any other case
	else {
	
	
	} // End ELSE Block for other cases
	
	
end

