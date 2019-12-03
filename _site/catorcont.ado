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
*     357                                                                      *
*                                                                              *
********************************************************************************
		
*! catorcont
*! v 0.0.3
*! 22sep2019

// Drop program from memory if already defined
cap prog drop catorcont

// Define program as an rclass that returns varlists of categorical/continuous
// variables
prog def catorcont, rclass

	// Set versioning
	version 14

	// Define syntax structure for subroutine
	syntax varlist, [ MINNsize(int 5)  MINCat(int 2) MAXCat(int 9)	 		 ///   
					CATVars(varlist) CONTVars(varlist) MISSing 				 ///   
					GRLABLength(passthru) ]

	// Create the macros that will store the names of the variables
	loc continuous
	loc categorical
	
	// If user provides minimum and maximum distinct values
	if `"`catvars'"' == "" & `"`contvars'"' == "" {
		
		// Separate the variables into categorical vs continuous based on the number of 
		// unique values the variable has.  

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
					
					// Get the number of rows for values in graph legends
					getlegendrows `v', `grlablength' `missing' values(`uniqval')
					
					// Add number of rows as characteristic
					char `v'[lrow] `r(nrows)'
					
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
			
			// Get the number of rows for values in graph legends
			getlegendrows `v', `grlablength' `missing' values(`uniqval')
			
			// Add number of rows as characteristic
			char `v'[lrow] `r(nrows)'
			
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
	
	// If only categorical variable list is provided
	else if `"`catvars'"' != "" & `"`contvars'"' == "" {
	
		// Loop over categorical variables to add metadata
		foreach v of loc catvars {

			// Get number of unique values for variable
			qui: levelsof `v', loc(values) `missing'
		
			// Store number of unique values
			loc uniqval `: word count `values''
			
			// Add number of values to variable as characteristic
			char `v'[nvals] `uniqval'
			
			// Get the n non-missing values 
			qui: count if !mi(`v')

			// Get the number of rows for values in graph legends
			getlegendrows `v', `grlablength' `missing' values(`uniqval')
			
			// Add number of rows as characteristic
			char `v'[lrow] `r(nrows)'
			
			// If variable has sufficient observations
			if r(N) >= `minnsize' {
			
				// Add variable to categorical variable list
				loc categorical `categorical' `v'
				
			} // End IF Block to add variable to categorical variable list
		
		} // End Loop over categorical variables

		// Remove user identified categorical variables from variable list
		loc possible : list varlist - catvars
		
		// Iterate over each variable and add it to the continuous variable list
		foreach v of loc possible {
		
			// Get total number of unique values
			qui: levelsof `v', loc(values) `missing'
			
			// Count number of non-missing cases
			qui: count if !mi(`v')
			
			// If sufficient observations and more than max cat
			if r(N) >= `minnsize' & `: word count `values'' >= `maxcat' {
		
				// Add to continuous variable list
				loc continuous `continuous' `v'

			} // End IF Block to add variable to continuous variable list	
				
		} // End Loop over remaining variables to be treated as continuous
	
	} // End ELSEIF Block for non-missing categorical variables and missing cont
	
	// If only categorical variable list is provided
	else {
	
		// Loop over continuous variables to add to return macro
		foreach v of loc contvars {

			// Get the n of non-missing values 
			qui: count if !mi(`v')

			// If variable has sufficient observations
			if r(N) >= `minnsize' {
			
				// Add variable to continuous variable list
				loc continuous `continuous' `v'
				
			} // End IF Block to add variable to continuous variable list
		
		} // End Loop over continuous variables

		// Remove user identified continuous variables from variable list
		loc possible : list varlist - contvars
		
		// Iterate over each variable and add it to the categorical variable list
		foreach v of loc possible {
		
			// Get total number of unique values
			qui: levelsof `v', loc(values) `missing'
			
			// Count number of non-missing cases
			qui: count if !mi(`v')
			
			// Get the number of rows for values in graph legends
			getlegendrows `v', `grlablength' `missing' values(`uniqval')
			
			// Add number of rows as characteristic
			char `v'[lrow] `r(nrows)'
			
			// If sufficient observations and w/in tolerances for categorical
			if r(N) >= `minnsize' &											 ///   
			inrange(`: word count `values'', `mincat', `maxcat') {
		
				// Add to categorical variable list
				loc categorical `categorical' `v'

			} // End IF Block to add variable to categorical variable list	
				
		} // End Loop over remaining variables to be treated as categorical
	
	} // End ELSEIF Block for non-missing categorical variables and missing cont
	
	// Get a list of any potential time/timeseries variables
	qui: ds, has(format %t*)
	
	// Store the variables in a new macro
	loc tsvars `r(varlist)'
	
	// Remove the tsvars from the categorical variable list
	loc categorical : list categorical - tsvars
	
	// Remove the tsvars from the continuous variable list
	loc continuous : list continuous - tsvars
	
	// Return the categorical variable list
	ret loc cat `categorical'
	
	// Return the continuous variable list
	ret loc cont `continuous'
	
	// Return the time variables in a separate macro
	ret loc timevars `tsvars'
	
// End of program
end
	
// Subroutine used to define the number of rows in EDA graph legends	
prog def getlegendrows, rclass

	// Syntax used to call subroutine
	syntax varlist(min=1 max=1), values(int) [ missing grlablength(int 50) ]
		
	// Get value label for variable
	loc vallab : value label `varlist'
	
	// If there is a value label associated with the variable
	if `"`vallab'"' != "" {
	
		// Get the labels for each of the variables
		forv i = 1/`values' {
		
			// Local macro that holds the string with all labels
			loc labstr `labstr' `: label `vallab' `i''
		
		} // End Loop over unique values
		
		// Get the length of all of the value labels
		loc lablen : strlen loc labstr
		
		// 10 fewer than grlabl and use ceiling to ensure always 
		// have at least 1 row
		loc lrows `= ceil(`lablen' / (`grlablength' - 10))'
	
	} // End IF Block for categorical variables with labels

	// If there is no value labels associated with variable
	else {
	
		// If number of unique values is divisible by 5
		if mod(`values', 5) == 0 {
			
			// Get number of rows
			loc lrows `= ceil(`values' / 5)'
			
		} // End IF Block for unique values / 5
		
		// If the unique values are divisible by 4
		else if mod(`values', 4) == 0 {
		
			// Get the number of rows
			loc lrows `= ceil(`values' / 4)'
			
		} // End ELSEIF Block for unqiue values divisible by 4
		
		// If the unique values are divisible by 3
		else if mod(`values', 3) == 0 {
		
			// Get the number of rows
			loc lrows `= ceil(`values' / 3)'
			
		} // End ELSEIF Block for cases that are divisible by 3
		
		// For all other cases ~ 4 values per line
		else {

			// Force Rounding up after division by four
			loc lrows `= ceil(`values' / 4)'
		
		} // End ELSE Block for other divisors
	
	} // End IF Block for 5 or more values
	
	// Set to single row if smaller number
	ret loc nrows `lrows'
				
// End of sub routine definition
end	

