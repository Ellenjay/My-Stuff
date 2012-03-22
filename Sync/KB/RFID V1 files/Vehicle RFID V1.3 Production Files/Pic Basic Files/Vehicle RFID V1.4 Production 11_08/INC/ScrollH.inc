'========This INCLUDE file contains the 3 parts of the SCROLLH routine============

'=======================ScrollH Users History========================================

StartScrollH: StartLine = 202	'Starting address of history table
		 	  EndLine = 250	'End Address of history Table

ScrollHAgain:			
			CLS
			Print AT 1,1, "Use Arrow Keys"
			Print AT 2,1, "to Scroll."
			Print AT 1,17, "'Clear' to Exit"
			Pause 4000
			LastUser = EREAD 254 	 'Get next empty User history record address
			
ScrollH:	CurrentLine = StartLine  'Set Currentline first User history record
			CLS
			Gosub PrintHistory
				  GoSub GetKey
				  		Select Key
						Case "U"
							 If StartLine > 202 then 
							 	StartLine = StartLine - 3
							 	Goto ScrollH
							ELSE
								CLS
								Print AT 1,1, "Start of List"
								Pause 1000
								Goto ScrollH
							ENDIF
						Case "D"
							 If StartLine + 9 < LastUser then 
							 	StartLine = StartLine + 3
							 	Goto ScrollH
							Else 							
								 Goto ScrollH
							ENDIF
						Case "C"
							 Goto MainMenu
						Case Else 
						Goto ScrollHAgain
						EndSelect	 

'....................END of ScrollUsers........................................


'====================PrintUser==============================================
'Used by ScrollH to print out 4 or less lines of users from table
PrintHistory: Gosub GetUser#
		   GoSub Split
		   PRINT AT 1,1, DEC EmpIN[0], DEC EmpIN[1], DEC EmpIN[2], DEC EmpIN[3], DEC EmpIN[4], DEC EmpIN[5]
		   CurrentLine = CurrentLine + 3   'Get next User from history records
		  
		   IF CurrentLine = LastUser then	  
			  Print AT 2,1, "END OF LIST"
			  RETURN
		   ENDIF
		   
		  GoSUB GetUser#
		  GoSub Split
		  PRINT AT 2,1, DEC EmpIN[0], DEC EmpIN[1], DEC EmpIN[2], DEC EmpIN[3], DEC EmpIN[4], DEC EmpIN[5]
		  CurrentLine = CurrentLine + 3   'Get next User from history records
		   IF CurrentLine = LastUser then	
		   	  Print AT 1,17, "END OF LIST"
			  RETURN
		   ENDIF 
		   
		     GoSUB GetUser#
		  GoSub Split
		  PRINT AT 1,17, DEC EmpIN[0], DEC EmpIN[1], DEC EmpIN[2], DEC EmpIN[3], DEC EmpIN[4], DEC EmpIN[5]
			CurrentLine = CurrentLine + 3   'Get next User from history records	      
		   IF CurrentLine = LastUser then	
		   	  Print AT 2,17, "END OF LIST"
			  RETURN
		   ENDIF   
		    GoSUB GetUser#
		  GoSub Split
		  PRINT AT 2,17, DEC EmpIN[0], DEC EmpIN[1], DEC EmpIN[2], DEC EmpIN[3], DEC EmpIN[4], DEC EmpIN[5] 
		  RETURN  
   
'....................End PrintUser..........................................


'===================Get#==================================================
'Used by 'ScrollH' to get each employee# from table			
GetUser#:		Index = 0 				
				 REPEAT   			 				'Get each employee
				  B1 = EREAD CurrentLine + Index  'in the 3 byte history spots
				  CE[Index] = B1 	'Get first digit of employee #  	 
				  	 INC Index 		   'Get Next Digit
				 UNTIL Index > 2
				 B1 = "C"	   
				 Return
'.......................END GetUser#..........................................
		
