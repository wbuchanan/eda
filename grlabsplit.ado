********************************************************************************
* Description of the Program -												   *
* Utility to split variable labels for multiline titles/axis titles			   *
*                                                                              *
* Program Output -                                                             *
*     char varname[ti1] - First half of graph titles/labels for this variable  *
*     char varname[ti2] - Second half of graph titles/labels for this variable *
*	  char varname[title] - A string that can be used for titles in graphs	   *
*                                                                              *
* Lines -                                                                      *
*     80                                                                       *
*                                                                              *
********************************************************************************
		
*! grlabsplit
*! v 0.0.0
*! 20OCT2015

// Drop program from memory if loaded
cap prog drop grlabsplit

// EDA subroutine that writes split graph titles to dataset characteristics
prog def grlabsplit

	// Requires a variable list
	syntax varlist [, GRLABLength(int 50)]

	// Loop over variable list
	foreach v in `varlist' {
	
		// Get variable label
		loc graphlab : var l `v'
		
		// Remove apostrophes
		loc graphlab : subinstr loc graphlab "'" "", all 
		
		// Get the length of the x-axis variable lable
		loc lablength : length loc graphlab
		
		// Get the number of chunks needed to split the label
		loc chunks = ceil(`lablength' / `grlablength')
		
		// Make sure to allocate enough chunks in cases where the label length 
		// is less than the grlablength parameter
		if `lablength' > `grlablength' & `chunks' < 2 {
		
			// Add one to the chunk macro
			loc chunks = 2
			
		} // End IF Block for shorter variable labels than split length

		// Holder for title string
		loc title `""'
			
		// If the variable label is longer than `grlablength' characters split it
		forv i = 1/`chunks' {
			
			// Extracts a chunk from the variable label
			loc tmplab : piece `i' `grlablength' of `"`: var label `v''"', nobreak
			
			// Stores the label chunk in a characteristic
			char `v'[ti_chunk_`i'] "`tmplab'"

			// Add chunk to title string
			loc title `"`title'"`tmplab'" "'
			
		} // End IF Block for splitting variable labels

		// Store the title string in a characteristic
		char `v'[title] "`title'"
		
		// Store the length of the original label
		char `v'[lablen] `lablength'
		
	} // End Loop over variable list
	
// End of subroutine for splitting variable labels for titles	
end

