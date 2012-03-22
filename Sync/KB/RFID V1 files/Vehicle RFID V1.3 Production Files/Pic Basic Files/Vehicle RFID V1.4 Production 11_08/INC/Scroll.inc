'========This INCLUDE file contains the 3 parts of the SCROLL routine============

'=======================Scroll Users list========================================

ScrollUsers: 

CurrentLine = 0		 'Setup to print on first line of LCD
EndLine = NUA 		 'Set Endline to first empty spot


StartScrollAgain:			
			CLS
			Print AT 1,1, "Use Arrow Keys"
			Print AT 2,1, "to Scroll."
			Print AT 1,17, "'Clear' to Exit"
			Pause 4000
			StartLine = 5   			 'Set first user here if new scroll request

Scroll:		CurrentLine = StartLine 	 'Set Currentline to scroll demand
			CLS
			Gosub PrintUser
				  GoSub GetKey
				  		Select Key
						Case "U"
							 If StartLine > 5 then 
							 	StartLine = StartLine - 8
							 	Goto Scroll
							ELSE
								CLS
								Print AT 1,1, "Start of List"
								Pause 1000
								Goto Scroll
							ENDIF
						Case "D"
							 If StartLine + 24 < EndLine then 
							 	StartLine = StartLine + 8
							 	Goto Scroll
							Else 							
								 Goto Scroll
							ENDIF
						Case "C"
							 Goto MainMenu
						Case Else 
						Goto StartScrollAgain
						EndSelect	 

'....................END of ScrollUsers........................................


'====================PrintUser==============================================
'Used by Scroll to print out 4 or less lines of users from table
PrintUser: Gosub Get#
		   GoSub Split
		   PRINT AT 1,1, DEC EmpIN[0], DEC EmpIN[1], DEC EmpIN[2], DEC EmpIN[3], DEC EmpIN[4], DEC EmpIN[5]
		   CurrentLine = CurrentLine + 8
		   If CurrentLine = EndLine then
		   	  Print AT 2,1, "END OF LIST"
			  RETURN
		   ENDIF
		   
		   GoSUB Get#
		   GoSub Split
		  PRINT AT 2,1, DEC EmpIN[0], DEC EmpIN[1], DEC EmpIN[2], DEC EmpIN[3], DEC EmpIN[4], DEC EmpIN[5]
			 CurrentLine = CurrentLine + 8
			 If CurrentLine = EndLine then
		   	  Print AT 1,17, "END OF LIST"
			  RETURN
		   ENDIF 
		   
		     GoSUB Get#
		  	 GoSub Split
		  PRINT AT 1,17, DEC EmpIN[0], DEC EmpIN[1], DEC EmpIN[2], DEC EmpIN[3], DEC EmpIN[4], DEC EmpIN[5]
			 CurrentLine = CurrentLine + 8
			 If CurrentLine = EndLine then
		   	  Print AT 2,17, "END OF LIST"
			  RETURN
		   ENDIF 
		  
		    GoSUB Get#
		  	GoSub Split
		  PRINT AT 2,17, DEC EmpIN[0], DEC EmpIN[1], DEC EmpIN[2], DEC EmpIN[3], DEC EmpIN[4], DEC EmpIN[5]
		  RETURN  
   
'....................End PrintUser..........................................


'===================Get#==================================================
'Used by 'Scroll' to get each employee# from table			
Get#:		Index = 0 				
				 REPEAT   			 				'Get each employee
				  B1 = EREAD CurrentLine + Index  'in the 8 byte key spots
				  CE[Index] = B1 	'Get first digit of employee #  	 
				  	 INC Index 		   'Get Next Digit
				 UNTIL Index > 2
				 B1 = "C"	   
				 Return
'.......................END GetUser#..........................................
		
