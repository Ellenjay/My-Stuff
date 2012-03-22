' This module is to write the Employee # into the history table
'Assumes that Employee # or "(JUMP # 000000 )" is in CE[]

WriteH:	 
		StartLine = 202	'Starting address of history table
		EndLine = 250	'End Address of history Table

CurrentLine = ERead 254		'Get last User History address 
ShiftAgain: If CurrentLine = 202 then Goto WriteHNow 'Empty spot is first spot
  			  	

		'We are now ready to shift table down
			For Index = 0 to 2
				B1 = EREAD CurrentLine - 3 + Index
				EWRITE CurrentLine + Index, [B1]
			Next 'Index = 0 to 2
			CurrentLine = CurrentLine - 3
			Goto ShiftAgain			 
		 						
WriteHNow:			'Ready to write new user history
 			For Index = 0 to 2	 		  	   		   'Write User # to History
				B1 = CE[Index]
				EWRITE CurrentLine + Index, [B1]
 			Next 'Index  

CurrentLine = EREAD 254
If CurrentLine < 244 then CurrentLine = CurrentLine + 3
Ewrite 254, [CurrentLine]		'We now set the address pointer to next empty history record spot
Return