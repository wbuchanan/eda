********************************************************************************
* Description of the Program -												   *
* Utility for checking/handling directory construction/management related to   *
* brewscheme.																   *
*                                                                              *
* Data Requirements -														   *
*     none                                                                     *
*																			   *
* System Requirements -														   *
*     Active Internet Connection											   *
*                                                                              *
* Program Output -                                                             *
*     void																	   *
*                                                                              *
* Lines -                                                                      *
*     121                                                                      *
*                                                                              *
********************************************************************************
		
*! dirfile
*! v 0.0.3
*! 04NOV2015

// Drop the program from memory if loaded
cap prog drop dirfile

// Define the file
prog def dirfile

	// Interpret under Stata version 13
	version 13
	
	// Syntax for calling the program
	syntax , Path(string) [ REBuild ]
	
	// Check for file path existence
	cap confirm new file `"`path'"'
	
	// Doesn't exist create it
	if _rc == 0 {
	
		// Make the directory
		mkdir `"`path'"'
		
		// Print message to the console (mostly for debugging)
		di as res `"The directory `path' was successfully created."'
	
	} // End IF Block for non-existent file path
	
	// Does exist and user wants to rebuild the directory
	else if _rc == 602 & "`rebuild'" != "" {
	
		// Get all the files in the directory
		loc dirfiles : dir `"`path'"' files "*", respectcase
		
		// Loop over the files in the directory
		forv i = 1/`: word count `dirfiles'' {
		
			// Print message to screen and get user input
			di as res `"Delete the file `: word `i' of `dirfiles'' from `path' ? (Y/n)"' _request(_del)
			
			// If user enters nothing, y, or Y delete the file
			if inlist(`"`del'"', "y", "Y", "") {
			
				// Erase the file from the disk
				erase `"`path'/`: word `i' of `dirfiles''"'
				
				// Success message to console
				di as res `"Erased the file : `path'/`: word `i' of `dirfiles''"'
				
			} // End IF Block for user selected file deletion
			
		} // End Loop over files in directory
		
		// Check for files in directory again
		loc dirfiles : dir `"`path'"' files "*", respectcase
		
		// Check for files in directory again
		loc subdirs : dir `"`path'"' dirs "*", respectcase
		
		// If the directory is empty 
		if `"`dirfiles'`subdirs'"' == "" {
		
			// Ask user if they want to delete the directory
			di as res `"`path' is empty.  Delete the directory too? (Y/n)"'  ///   
			_request(_del)
		
			// If y, Y, or null delete the directory
			if inlist(`"`del'"', "y", "Y") {
			
				// Remove the directory
				qui: rmdir `"`path'"'
				
			} // End IF Block for directory removal
			
		} // End IF Block for directory removal
		
	} // End ELSE Block for existing directory with rebuild option
		
	// If directory exists but user does not want to rebuild	
	else if _rc == 602 & "`rebuild'" == "" {
	
		// Print message to console
		di as res "Directory exists and rebuild option not specified.  No further action"
	
	} // End ELSEIF Block for continuance action
	
	// Work around for stupid Windoze bug
	else if _rc == 603 & `"`c(os)'"' == "Windows" {
	} // End ELSE IF Block for stupid Windows bug
	
	// Some other error with the file path	
	else {
	
		// Error out with the returned error code
		err _rc
		 
	} // End ELSE Block for other error code handling
		
// End of program definition		
end 

