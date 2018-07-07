********************************************************************************
* Description of the Program -												   *
* Utility to build a LaTeX compilation script.								   *
*                                                                              *
* Program Output -                                                             *
*     Bash/Batch script calling pdflatex on a given LaTeX source code file     *
*                                                                              *
* Lines -                                                                      *
*     125                                                                      *
*                                                                              *
********************************************************************************
		
*! maketexcomp
*! v 0.0.2
*! 07JUL2018

// Drop program from memory if it is already loaded
cap prog drop maketexcomp

// Define program
prog def maketexcomp, rclass

	// Version Stata should use to interpret the code
	version 14 
	
	// Define syntax structure for subroutine
	syntax anything(name=filenm id="Name of LaTeX Source Code File"),		 ///   
	SCRiptname(string) root(string) [ PDFlatex(string asis) ]
	
	// If path to pdfLaTeX not specified use *nix binary reference
	if `"`pdflatex'"' == "" loc pdflatex pdflatex
	
	// Clean the filename macro to remove any quotation marks from the path
	loc filenm `: subinstr loc filenm `"""' "", all'
	
	// Check if user is running on Windows
	if `"`c(os)'"' == "Windows" {
	
		// Creates file extension for Windows terminal executables
		loc extension .bat
		
		// Adds a comment header for Windows batch files
		loc header "::Batch file to compile LaTeX source"
		
		// Contructs the reference to the pdf LaTeX binary
		loc bin `pdflatex'.exe
		
		// Contructs the reference to the terminal command to delete/remove files
		loc remove DEL
		
		// Only used for parallel construction across OS
		loc scriptexec 
		
	} // End of IF Block for Windows systems
	
	// For *nix based systems
	else {
	
		// Create extension reference for a shell script
		loc extension .sh
		
		// Add the header for the Bourne Again SHell
		loc header "#!/bin/bash"
		
		// Add reference to the binary for pdf LaTeX
		loc bin `pdflatex'
		
		// Add reference for the terminal command to delete/remove files
		loc remove "rm"
		
		// Constructs shell command to make the script executable
		loc scriptexec ! chmod +x "`scriptname'.`extension'"
		
	} // End of ELSE Block for *nix based systems
	
	// Opens a file connection to construct the compilation script
	file open comp using `"`scriptname'.`extension'"', w replace
	
	// Writes the appropriate OS header for a terminal script
	file write comp "`header'" _n
	
	// Calls pdfLaTeX to do the first pass
	file write comp `"`bin' "`filenm'.tex""' _n
	
	// Calls pdfLaTeX to do the second pass; this should finalize hyperrefs to 
	// individual graphs and TOC references as well as doing the initial insert
	// and build of the TOC
	file write comp `"`bin' "`filenm'.tex""' _n
	
	// Calls pdfLaTeX to do the last pass; this should finalize the TOC/TOF and
	// any other references like that
	file write comp `"`bin' "`filenm'.tex""' _n

	// Loop over ancillary file extensions
	foreach v in aux lof log lot out toc {

		// If Windows these file name references need to have a Windows path
		// delimiter
		if `"`c(os)'"' == "Windows" loc filenm `: subinstr loc filenm "/" "\", all'
	
		// Delete ancillary files
		file write comp `"`remove' "`filenm'.`v'""' _n

	} // End Loop over ancillary file extensions
		
	// Adds empty line	
	file write comp "" _n
		
	// Adds empty line	
	file write comp "" _n
		
	// Closes the open file connection
	file close comp
	
	// Need to make the file executable on *nix systems
	`scriptexec'

	// Return shell command to execute compilation script on OSX
	if `"`c(os)'"' == "MacOSX" ret loc comp ! open -a Terminal.app `scriptname'.sh
		
	// For other OS
	else ret loc comp ! `compile'
		
// End of subroutine definition	
end
	
