********************************************************************************
* Description of the Program -												   *
* Utility for handling LaTeX spcial characters.  The ref option is used when   *
* string will be used as part of a reference label in LaTeX (e.g., special 	   *
* characters are deleted); without this option the characters are escaped 	   *
* and/or their text macros used in their place.								   *
*                                                                              *
* Program Output -                                                             *
*     r(clntex) - A LaTeX sanitized string									   *
*                                                                              *
* Lines -                                                                      *
*     103                                                                      *
*                                                                              *
********************************************************************************
		
*! texclean
*! v 0.0.0
*! 27OCT2015

// Drop program from memory if previously loaded
cap prog drop texclean

// Define program
prog def texclean, rclass

	// Set version used to interpret code
	version 14
	
	// Set program syntax
	syntax anything(name=text id="LaTeX String to Escape" everything), [ Ref ] 
	
	// Check for LaTeX special characters
	if 	regexm(`"`text'"', "([#\$%&~_\^\\\{\}<>\|¡¿£])") == 1 {
	
		// Store argument in new local macro
		loc cln `"`text'"'
		
		// For use with reference labels
		if "`ref'" != "" {

			// Loop over the LaTeX special characters
			foreach c in "£" "|" "¡" "¿" "{" "}" "<" ">" "\" "^" "_" "~" "&" ///   
						 "%" "$" "#" {
						 
				// Remove the special characters		 
				loc cln `: subinstr loc cln `"`c'"' "", all'	
				
			} // End Loop over LaTeX special characters
			
		} // End IF Block for reference strings
		
		// Otherwise
		else {

			// Handle # character
			loc cln `: subinstr loc cln "#" "\#", all'

			// Handle $ character
			loc cln `: subinstr loc cln "$" "\$", all'
			
			// Handle % character
			loc cln `: subinstr loc cln "%" "\%", all'
			
			// Handle & character
			loc cln `: subinstr loc cln "&" "\&", all'
			
			// Handle ~ character
			loc cln `: subinstr loc cln "~" "\textasciitilde{}", all'
			
			// Handle _ character
			loc cln `: subinstr loc cln "_" "\_", all'
			
			// Handle ^ character
			loc cln `: subinstr loc cln "^" "\textasciicircum{}", all'
			
			// Handle \ character
			loc cln `: subinstr loc cln "\" "\textbackslash{}", all'
			
			// Handle { character
			loc cln `: subinstr loc cln `"{"' `"\{"', all'

			// Handle } character
			loc cln `: subinstr loc cln `"}"' `"\}"', all'
		
		} // End ELSE Block for non reference label cases

		// Return the cleaned string
		ret loc clntex `cln'
		
	} // End IF Block for cases w/LaTeX special characters
	
	// If no special characters are in the string
	else {
	
		// Return string that does not include special characters
		ret loc clntex `text'
		
	} // End ELSE Block for text w/o special characters
	
// End Program definition
end

