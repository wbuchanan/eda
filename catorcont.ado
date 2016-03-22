********************************************************************************
* Description of the Program -												   *
* Utility for defining categorical or continuous variables for automated EDA   *
* program.																	   *
*                                                                              *
* Program Output -                                                             *
*     r(cat) - list of categorical variables								   *
*     r(cont) - list of continuous variables								   *
*                                                                              *
* Lines -                                                                      *
*     151                                                                      *
*                                                                              *
********************************************************************************
		
*! catorcont
*! v 0.0.0
*! 20OCT2015

// Drop program from memory if already defined
cap prog drop catorcont

// Define program as an rclass that returns varlists of categorical/continuous
// variables
prog def catorcont, rclass

	// Set versioning
	version 14

	// Define syntax structure for subroutine
	syntax varlist, [ MINNsize(int 5)  MINCat(int 2) MAXCat(int 10) 		 ///   
					CATVars(varlist) CONTVars(varlist) MISSing ]

	// If user provides minimum and maximum distinct values
	if `"`catvars'"' == "" & `"`contvars'"' == "" {
		
		// Separate the variables into categorical vs continuous based on the number of 
		// unique values the variable has.  

		// Create the macros that will store the names of the variables
		loc continuous
		loc categorical

		// Loop over the numeric variables and sort into continuous/categorical
		foreach v of loc varlist {

			// Get all the values the variable can take
			qui: levelsof `v', loc(values) `missing'
			
			// Store number of unique values
			loc uniqval `: word count `values''
			
			// Add number of values to variable as characteristic
			char `v'[nvals] `uniqval'
			
			// Get the n non-missing values 
			qui: count if !mi(`v')

			// If >= `minnsize' values include in the lists
			if r(N) >= `minnsize' {
			
				// If there are fewer than 10 unique values put the variable in the 
				// categorical list variables with only 1 value will be excluded
				if inrange(`uniqval', `mincat', `maxcat') {

					// Add the variable to the categorical local macro
					loc categorical `categorical' `v'
					
					// If 5 or more unique values
					if `uniqval' > 4 {
					
						// If number of unique values is divisible by 5
						if mod(`uniqval', 5) == 0 {
							
							// Get number of rows
							loc lrows `= `uniqval' / 5'
							
							// Store the number of rows in the characteristics
							char `v'[lrows] `lrows'
						
						} // End IF Block for unique values / 5
						
						// If the unique values are divisible by 4
						else if mod(`uniqval', 4) == 0 {
						
							// Get the number of rows
							loc lrows `= `uniqval' / 4'
							
							// Store the number of rows in the characteristics
							char `v'[lrows] `lrows'
						
						} // End ELSEIF Block for unqiue values divisible by 4
						
						// If the unique values are divisible by 3
						else if mod(`uniqval', 3) == 0 {
						
							// Get the number of rows
							loc lrows `= `uniqval' / 3'
							
							// Store the number of rows in the characteristics
							char `v'[lrows] `lrows'
						
						} // End ELSEIF Block for cases that are divisible by 3
						
						// For all other cases ~ 4 values per line
						else {

							// Force Rounding up after division by four
							loc lrows `= ceil(`uniqval' / 4)'
						
							// Store the number of rows in the characteristics
							char `v'[lrows] `lrows'
						
						} // End ELSE Block for other divisors
					
					} // End IF Block for 5 or more values
					
					// If 4 or fewer unique values
					else {
					
						// Set to single row if smaller number
						char `v'[lrows] 1
					
					} // End ELSE Block for number of legend rows
					
				} // End IF Block for Categorical variables
			
				// Otherwise treat it as continuous
				else if `: word count `values'' > `maxcat' &				 ///   
					!mi(`: word count `values'') {
				
					// Add the variable to the continuous local macro
					loc continuous `continuous' `v'
					
				} // End ELSE IF Block for continuous variables
				
				// If 1 or fewer values do not include
				else {
					
					// Move to next iteration/condition
					continue
					
				} // End ELSE Block for <=1 unique value

			} // End IF Block for # non-missing values
			
			// For variables with < `minnsize' observations
			else {
			
				// Skip over them and move on to the next variable
				continue
				
			} // End ELSE Block for extremely sparse variables
			
		} // End loop over all numeric variables in the dataset

	} // End IF Block for no cat/cont varlists passed
	
	// If user specifies categorical and continuous variable lists
	else if `"`catvars'"' != "" & `"`contvars'"' != "" {
	
		loc categorical
		loc continuous 
	
		// Loop over the numeric variables and sort into continuous/categorical
		foreach v of loc catvars {

			// Get all the values the variable can take
			qui: levelsof `v', loc(values)
			
			// Get the n non-missing values 
			qui: count if !mi(`v')

			// If >= `minnsize' values include in the lists
			if r(N) >= `minnsize' {
			
				loc categorical `categorical' `v'
			
			} // End IF Block for categorical variable with sufficient observations
			
		} // End Loop over categorical variable list
		
		// Loop over the numeric variables and sort into continuous/categorical
		foreach v of loc contvars {

			// Get all the values the variable can take
			qui: levelsof `v', loc(values)
			
			// Get the n non-missing values 
			qui: count if !mi(`v')

			// If >= `minnsize' values include in the lists
			if r(N) >= `minnsize' {
			
				loc continuous `continuous' `v'
			
			} // End IF Block for categorical variable with sufficient observations
			
		} // End Loop over categorical variable list
			
	} // End ELSEIF Block for user supplied categorical/continuous varlists
	
	// Return the categorical variable list
	ret loc cat `categorical'
	
	// Return the continuous variable list
	ret loc cont `continuous'
	
// End of program
end
	
	
