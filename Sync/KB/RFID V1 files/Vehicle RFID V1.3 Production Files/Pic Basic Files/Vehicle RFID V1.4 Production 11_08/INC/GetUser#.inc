'=============Subroutine to get Employee #=================================			
'Used to get a new Employee# from keypad
GetEmployee#: 	CLS
		 		Print AT 2,1, "Enter User #"
		 		Print AT 1,17, "(6 Digits)"
		 		Print AT 2,17, "CLEAR to Exit"
		 		Print $FE, 2 	'Jump to first line for input		 
		 		For Index = 0 to 5		 'Set up array for Employee # digits
GetEmpLoop1:		Gosub GetKey  		 'Get User keypress
		  	 		SELECT Key			 'Check to see if it is 0-9
		  				CASE 0 TO 9
		 		 			EmpIN[Index] = Key	 'Place digit into EmpIn array
				 			Print DEC Key		 'Echo Key to LCD
						Case "C"  
							 Goto MainMenu					
						CASE ELSE
							Goto GetEmpLoop1	  'Key is not digit (0-9)
					ENDSELECT
				Next 'Index    Next Digit
				
				 Gosub GoodSound
				CLS
		   	   'Print entered Employee ID back for verification
			   Print $FE, 2 
		   	   Print DEC EmpIN[0]
		   	   Print DEC EmpIN[1]
		   	   Print DEC EmpIN[2]
		   	   Print DEC EmpIN[3]
		   	   Print DEC EmpIN[4]
		   	   Print DEC EmpIN[5]
		   	   Print AT 2,1, "Is this correct?"
		   	   Print AT 1,17, "ENTER = Correct"
		   	   Print AT 2,17, "CLEAR = Redo"

GetEmpLoop2:	Gosub GetKey	  		 
				Select Key
		   		Case "C"
					 GoTo GetEmployee# 'Redo Employee #
				Case "E"  'Employee number was correct
				
				'We wish to consolidate the 6 digit employee number into 3 digits to save space
				'We cannot just add them together as we did for the Tag numbers because
				'We need to re-split them later to read them out on the LCD display	
					B2 = EmpIN[0]
					B1 = EmpIN[1] 'B1 now contains Employee Digit(1)in lower bits of B1
					B1.4 = B2.0	  ' Here we are adding employee digit(0)
					B1.5 = B2.1	  ' to the upper bits
					B1.6 = B2.2	  ' of B1
					B1.7 = B2.3
					CE[0] = B1 	  
					
					B2 = EmpIN[2] 'Same as above except for Digit(2) and Digit(3)
					B1 = EmpIN[3]
					B1.4 = B2.0
					B1.5 = B2.1
					B1.6 = B2.2
					B1.7 = B2.3
					CE[1] = B1 
					
					B2 = EmpIN[4] 'Same as above except for Digit(4) and Digit(5)
					B1 = EmpIN[5]
					B1.4 = B2.0
					B1.5 = B2.1
					B1.6 = B2.2
					B1.7 = B2.3
					CE[2] = B1 
					'Now we are ready to write the 6 digit employee number using only 3 bytes..CE(0) to CE(2)
					 
					 Return			 'Employee# is OK.. Return 
				Case Else
					 Goto GetEmpLoop2
				EndSelect		
		    
'..................End of GetEmployee# routine.............................
