********************************************************************************
* Description of the Program -												   *
* Utility to check for missing dependencies and prompt end user to install     *
* the dependencies if they are missing.										   *
*                                                                              *
* Lines -                                                                      *
*     204                                                                      *
*                                                                              *
********************************************************************************
		
*! progcheck
*! v 0.0.1
*! 17jul2018

// Drop the program from memory if it is already loaded in memory
cap prog drop progcheck

// Define the program progcheck
prog def progcheck

	// Define the version under which the code should be interpreted
	version 14

	// Define syntax of program
	syntax anything(name=progs id="Program Names"), WHere(string asis) 		 ///   
													[ Pattern(numlist) ]
													
	// Get number of installation locations
	loc instlocs `: word count `where''
	
	// Get number of programs
	loc nprogs `: word count `progs''
	
	// If no programs entered
	if mi(`nprogs') | `nprogs' == 0 {
	
		// Print error message for end user
		di as err "Must specify one or more programs to check"
	
		// Return error code
		err 198
		
	} // End IF Block for null program argument
	
	// Get number of pattern values
	loc npat `: word count `pattern''
	
	// Check number of programs/locations to install from
	if `nprogs' >= 2 {
	
		// If a single installation location is passed 
		if `instlocs' == 1 {
			
			// Move to the program body
			
		} // End IF Block for a single installation location
		
		/* Multiple installation locations, but insufficient number of values 
		passed to the pattern parameter to determine how to recycle the 
		locations.  Pattern should have a value like 1 1 2 1 3 for the case 
		where there are 5 programs to check, only three locations are passed, 
		and the programs' installation locations correspond to the pattern of 
		values specified in the pattern argument. */
		else if `instlocs' != `nprogs' & `npat' != `nprogs' & !mi(`npat') {
		
		   // Print message to console for end user
		   di as err "The number of values passed to the pattern argument "	 ///   
		   "does not match the number of programs to be checked."
		   
		   // Return an error code
		   err 198
		
		} // End ELSEIF Block for insufficient values of pattern parameter
		
		/* Multiple installation locations but no pattern provided.  In this 
		case the values passed to where need be the same length as the number 
		of programs being checked.  For example, the call:
		progcheck estout spikeplot ivreg2
		Would require either where(`""ssc" "ssc" "ssc""') as in this case, or 
		where("ssc"), or where("ssc") pattern(1 1 1). */
		else if `instlocs' != `nprogs' & mi(`npat') {
		
		   // Print message to console for end user
		   di as err "The number of installation locations does not match "	 ///   
		   "the number of programs to check and no pattern argument was "	 ///  
		   "provided."
		   
		   // Return an error code
		   err 198
				
		} // End ELSEIF Block for nonmatching number of locations
		
		// Other wise continue into the body of the program
		else {
		
			// Move to body of program
			
		} // End ELSE Block
	   	
	} // End IF Block for invalid argument combinations
		
	// Check for required programs
	forv i = 1/`: word count `progs'' {
	
		// Store program name
		loc program `: word `i' of `progs''
		
		// Check for a pattern value
		if `"`pattern'"' != "" {
		
			// Get location id using the numeric pattern specified in pattern
			loc wherenum `: word `i' of `pattern''
			
			// Get location text
			loc location `: word `wherenum' of `where''
			
		} // End IF Block for non missing pattern values
		
		// If null pattern value
		else {
		
			// Check number of locations
			if `instlocs' == 1 {
			
				// Check for SSC
				if lower(`"`where'"') == "ssc" {
				
					// Build installation string
					loc inst ssc inst `program', replace
					
				} // End IF Block for SSC-based programs
				
				// For other cases
				else {
								
					// Build installation syntax
					loc inst net inst `program', from(`"`where'"')
					
				} // End ELSE Block for non-SSC based programs
				
			} // End IF Block for single install location
		
			// If more than a single installation location
			else {
			
				// Get location text
				loc location `: word `i' of `where''

				// Check for SSC
				if lower(`"`location'"') == "ssc" {
				
					// Build installation string
					loc inst ssc inst `program', replace
					
				} // End IF Block for SSC-based programs
				
				// For other cases
				else {
								
					// Build installation syntax
					loc inst net inst `program', from(`"`location'"')
					
				} // End ELSE Block for non-SSC based programs
							
			} // End ELSE Block for multiple installation locations
		
		} // End ELSE Block for null pattern argument
		
		// See if program is installed
		cap which `program'
		
		// If not installed
		if _rc != 0 {
		
			// Print message to screen and ask user if they want to install it
			di as res "The program `program' is not installed and is a "	 ///   
			"dependency of this program.  Would you like to install it "	 ///   
			"now? (Y/n)" _request(_inst)
			
			// If user enters y, Y, or nothing the program will be installed
			if inlist(`"`inst'"', "Y", "y", "") {
			
				// Install program 
				`inst'
				
			} // End IF Block to install program
			
			// If user doesn't want to install program
			else {
			
				// Print different message to screen
				di as err "Please install the program `v' before running eda."
				
				// Display error code
				err 601
				
			} // End ELSE Block for user selecting not to install program
			
		} // End IF Block for not installed program
		
	} // End Loop over programs
	
// End of subroutine
end

	
