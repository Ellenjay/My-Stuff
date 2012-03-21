'==================Check for Existing Tag Sub==============================

 
Check_Tag:	   Response = 0  	 		  'Process will set Response to 1 if Tag is found
			   If User_Pointer = BUA Then 	  'there are no User entries in the table
			   Cls
			   Print "No Users"
			   Pause 2000
				 Return
			   EndIf			  
			   Word_Var = BUA 		' Start search in first user memory spot			 
NextTag:		Index = 0 
				Response = 0  			'Process will set Flag to 1 if Tag is found
				 Repeat   			'Repeat until all Tag digits are checked
				  TV1 = CRead TagOffset + Word_Var + Index   'TagOffset jumps over User #
                  If TV1 = TagIn[Index] Then 
				  	 Response = 1 		   'Digits Match
				  	 Inc Index 		   'Check Next Digit
				  Else
				  	  Response = 0		   'Digit does not match, therefore
					  Index = 10		'we are finished with this Tag  
				 EndIf
				 Until Index > 9
				 If Response = 1 Then      'Write User of Tag into UserIn variable array
                        For Index = 0 To 3
                            UserIn[Index] = CRead Word_Var + Index
                        Next
                    Return
			     EndIf
			     
			  Word_Var = Word_Var + 16
			  If Word_Var = User_Pointer Then Return
			
			  GoTo NextTag
			  
		
'.....................End of Check for existing Tag.......................
