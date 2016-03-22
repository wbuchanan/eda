********************************************************************************
* Description of the Program -												   *
* Utility to build a LaTeX compilation script.								   *
*                                                                              *
* Program Output -                                                             *
*     Bash/Batch script calling pdflatex on a given LaTeX source code file     *
*                                                                              *
* Lines -                                                                      *
*     111                                                                      *
*                                                                              *
********************************************************************************
		
*! maketexcomp
*! v 0.0.0
*! 27OCT2015

// Drop program from memory if it is already loaded
cap prog drop maketexcomp

// Define program
prog def maketexcomp, rclass

	// Version Stata should use to interpret the code
	version 14 
	
	// Define syntax structure for subroutine
	syntax anything(name=filenm id="Name of LaTeX Source Code File"),		 ///   
	SCRiptname(string) [ PDFlatex(string asis) ]
	
	// Check for null PDFLaTeX argument
	if `"`pdflatex'"' == "" {
	
		// If null use the binary name
		loc pdflatex pdflatex
		
	} // End IF Block for null pdflatex binary reference
		
	// Check if user is running on Windoze
	if `"`c(os)'"' == "Windows" {
	
		loc compile `scriptname'.bat
	
		// Write a Windoze batch script to compile a given LaTeX document
		file open comp using `"`scriptname'.bat"', w replace
		file write comp "::Batch file to compile LaTeX source" _n
		file write comp `"`pdflatex'.exe `filenm'.tex"' _n
		file write comp `"`pdflatex'.exe `filenm'.tex"' _n
		file write comp `"`pdflatex'.exe `filenm'.tex"' _n

		// Loop over ancillary file extensions
		foreach v in aux lof log lot out toc {

			// Delete ancillary files
			file write comp `"DEL "`filenm'.`v'""' _n

		} // End Loop over ancillary file extensions
		
		file write comp "" _n
		file write comp "" _n
		file close comp
			
	} // End IF Block for Windoze-based systems
	
	// For all other computer systems on the planet
	else {
	
		loc compile `scriptname'.sh

		// Write a bash script to compile the LaTeX document 
		file open comp using `"`scriptname'.sh"', w replace
		file write comp "#!/bin/bash" _n
		file write comp `"`pdflatex' `filenm'.tex"' _n
		file write comp `"`pdflatex' `filenm'.tex"' _n
		file write comp `"`pdflatex' `filenm'.tex"' _n

		// Loop over ancillary file extensions
		foreach v in aux lof log lot out toc {

			// Delete ancillary files
			file write comp `"sudo rm "`filenm'.`v'""' _n

		} // End Loop over ancillary file extensions
		
		file write comp "" _n
		file close comp

		// Make the bash script executable
		! sudo chmod a+x "`scriptname'.sh"

	} // End of ELSE Block for non Windoze based systems
	
	// Check for OSX
	if `"`c(os)'"' == "MacOSX" {
	
		// Return a version of the shell out for OSX
		ret loc comp ! open -a Terminal.app `scriptname'.sh
		
	} // End IF Block for OSX	

	// For other OS
	else {
	
		// Return the name of the script to execute
		ret loc comp ! `compile'
		
	} // End ELSE Block for other OS
		
// End of subroutine definition	
end
	
