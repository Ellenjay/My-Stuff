
'====================Start of MainMenu=====================================

MainMenu: 
		  CLS
		  Print AT 1,1, "(1)User Tag Menu"
		  Print AT 2,1, "(2)View last 14"
		  PRINT AT 1,17, "Vehicle users"
		  Gosub GetKey
		  Select Key
		  	Case 1
				 Goto UserMenu
			Case 2
				LastUser = EREAD 254
				If LastUser = 202 then 
			 	    Gosub BadSound
				   CLS
			 	   Print AT 1,1, "There is no"
			 	   Print AT 2,1, "User History"
			 	   Print AT 1,17, "in the Database"
			 	   Pause 4000
			 	   Goto MainMenu
				ENDIF 'If LastUser = 202

				GoTo StartScrollH
		
		 Case Else
		 	  Goto MainMenu
		 EndSelect	 
'....................End of MainMenu