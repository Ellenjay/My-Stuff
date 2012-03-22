
'====================Sub to add new user===================================
AddNewUser:		  
CLS			

NUA = EREAD 255	 'Get Next user empty spot address
If NUA > 189 then	  'Address 197 is then END of the last spot for Users and Tag

ANULoop2:	 Gosub BadSound
			CLS
			Print AT 1,1, "Memory is full!"
			Print At 2,1, "You must delete"
			Print AT 1,17, "a User."
			Print AT 2,17, "Press Enter"
			Gosub Getkey
			
			If Key = "E" then
	   		   Goto MainMenu
			Else
				Goto ANUloop2 'Wrong Key
			ENDIF 'Key = E
ENDIF 'NUA > 189


	  	    GoSub GetEmployee#  		  'Get EmployeeID form KeyPad
			Gosub CheckUser 			  'Check that user does not already exist.
	
			GoSub ReadTag	'User will scan Tag  			
			If Flag = 0 then goto MainMenu
			GoSub CheckMaster  'Check that we are not trying to use the Master Key for a user	
				 If Flag = 1 then
				  	  Gosub BadSound
					 CLS
					 Print AT 1,1, "Master Key"
					 Print AT 2,1, "detected!!"
					 Print AT 1,17, "Please use"
					 Print AT 2,17, "another Key!"
					 Pause 4000
					 Goto MainMenu
				ENDIF 'Flag = 1 (for Master)
			GoSub CheckTag	'Make sure another User is not already using this Tag
			If Flag = 1 then 	   	    'Tag does exist
TagExists:				Currentline = Index2
						Gosub Get#
						Gosub Split
						 Gosub BadSound
						CLS
						Print AT 1,1, "Tag belongs to"
						Print AT 2,1, "User# ", DEC EmpIN[0], DEC EmpIN[1], DEC EmpIN[2], DEC EmpIN[3], DEC EmpIN[4], DEC EmpIN[5]
						Print AT 1,17, "(1) Delete User"
						Print At 2,17, "(2) Start Over"
						B1 = "C"
						GOSUB GetKey
					Select Key
						Case 2 'Choice was not to delete Tag
						   		GoTo MainMenu  'Exit adding Tag
						Case 1 'Yes, delete this Tag and OLD user and use it for this NEW user.
							   	CLS
								Print AT 1,1, "Tag will be"
								Print AT 2,1, "assigned to new"
								Print AT 1,17, "User "
								Print DEC EmpIN[0]
		   	   					Print DEC EmpIN[1]
		   	   					Print DEC EmpIN[2]
		   	   					Print DEC EmpIN[3]
		   	   					Print DEC EmpIN[4]
		   	   					Print DEC EmpIN[5]
								Pause 4000
								GoTo DeleteTag
						Case Else 'Key was not 1 or 2"
							 	Goto TagExists
					EndSelect		

DeleteTag:					If Index2  = EndLine - 8  then 'If the Employee# is the last one in the table then
							   NUA = NUA - 8   'remove last entry
							   EWRITE 255, [NUA]
							Else
								GoSub MoveSpot 'Located in 'Check User' module
							ENDIF 'Index2 = EndLine - 8
					  	  		  
			ENDIF 'Flag = 1 (for Tag)
				  GoSub WriteTag	'Write Tag into memory
				   Gosub GoodSound
				  CLS
				  Print AT 1,1, "Tag & User#"
				  Print AT 2,1, "Inserted"
				  Pause 4000
				  Goto MainMenu
		
		  
'.....................End of AddNewUser sub...................................

