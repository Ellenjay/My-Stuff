			   		 
CheckMaster:	Index = 0 
				Flag = 0  			'Process will set Flag to 1 if Master Tag is found
				 REPEAT   			'Repeat until all Master Tag digits are checked
				  B1 = EREAD Index   				 
				  If B1 = CT[Index] then 
				  	 Flag = 1 		   'Digits Match
				  	 INC Index 		   'Check Next Digit
				  Else
				  	  Flag = 0		   'Digit does not match, therefore
					  Index = 5		   	'we are finished with this Tag  
				 ENDIF
				 UNTIL Index > 4
				 B1 = "C"
				Return		
				
				 
				 
			