'===================Start of User Menu=======================================
UserMenu:	
			CLS
			Print AT 1,1,  "(1) Add New User"
			Print AT 2,1,  "(2) Delete User"
			Print AT 1,17, "(3) Delete ALL"
			Print AT 2,17, "(4) View Users"
			
		GoSub GetKey   'Get response from keypad	
		SELECT Key
	    CASE 1			' Is Key equal to 1 ?
			 GoTo AddNewUser
			 
		
	    CASE 2			' Is KEY equal to 2 ?
			GoSub GetEmployee#
			GoSub CheckUser
				CLS
				If Flag = 1 then						
					 Gosub GoodSound
					Print AT 1,1,"User deleted"
					Pause 4000
					Goto MainMenu
				Else
					 Gosub BadSound
					Print AT 1,1,"User is not"
					Print AT 2,1,"in the database!"
					Pause 4000
					Goto MainMenu
				ENDIF
		Case 3		 'Delete all users
				 Gosub GoodSound
				CLS
				Print AT 1,1, "Warning!"
				Print AT 2,1, "Delete ALL?"
				Print AT 1,17, "(1) = YES"
				Print AT 2,17, "(2) = NO"
				Gosub GetKey   		  	   'Get response from keypad
				Select Key
					   Case 1
					   		Gosub GoodSound
							CLS
							Print AT 1,1, "ALL Users"
							Print AT 2,1, "will be deleted!"					
							Pause 4000
							NUA = 5 			'set # users to zero
							EWRITE 255, [NUA]
							Goto MainMenu
						Case 2
							 Goto MainMenu
				EndSelect
		CASE 4			'Key is equal to 4 'Scroll'
				If NUA = 5 then 
			 	   Gosub BadSound
				   CLS
			 	   Print AT 1,1, "There are no"
			 	   Print AT 2,1, "Users in the"
			 	   Print AT 1,17, "Database"
			 	   Pause 4000
			 	   Goto MainMenu
				ENDIF 'If NUA = 5

				GoTo ScrollUsers
		
		CASE ELSE			' Otherwise...
			 Goto MainMenu
ENDSELECT	 'End of User Menu

'.......................End of User Menu.....................................





