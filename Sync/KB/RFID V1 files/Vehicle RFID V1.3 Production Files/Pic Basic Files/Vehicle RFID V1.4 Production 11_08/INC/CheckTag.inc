'==================Check for Existing Tag Sub==============================

 
CheckTag:	   Flag = 0  	 		  'Process will set Flag to 1 if Tag is found
			   If NUA = 5 then 	  'there are no User entries in the table
				 Return
			   EndIf
			   ENDline = NUA		 'Set Endline to first empty spot			  
			   Index2 = 5 		' Start search in first user memory spot			 
NextTag:		Index = 0 
				Flag = 0  			'Process will set Flag to 1 if Tag is found
				 REPEAT   			'Repeat until all Tag digits are checked
				  B1 = EREAD TagOffset + Index2 + Index   'TagOffset jumps over User #
				  If B1 = CT[Index] then 
				  	 Flag = 1 		   'Digits Match
				  	 INC Index 		   'Check Next Digit
				  Else
				  	  Flag = 0		   'Digit does not match, therefore
					  Index = 5		'we are finished with this Tag  
				 ENDIF
				 UNTIL Index > 4
				 If Flag = 1 then Return
				 B1 = "C" 
			  Index2 = Index2 + 8
			  If Index2 = Endline then Return
			  B1 = "C"
			  Goto NextTag
			  
		
'.....................End of Check for existing Tag.......................
