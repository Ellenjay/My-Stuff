'=================Read Tag Subroutine========================================
ReadTag:		CLS
				Print AT 1,1, "To Scan Tag"
				Print AT 2,1, "press ENTER when"
				Print AT 1,17, "ready"
				Print AT 2,17, "CLEAR to Cancel"
				
		Gosub GetKey	  		 
		Select Key
		Case "C"
			GoTo Mainmenu   'User chose to cancel
		Case "E" 			'User is ready to have tag read
			CLS
			Print AT 1,1, "Attempting to"
			Print AT 2,1, "read Tag...."

ReadAgain:	Flag = 0 	  			'Used to indicate a good read
			LOW RFIDEnable		   	  ' Turn on RFID Reader
			Pause 10				'Time for Reader to settle
			HSERIN 30000, Timeout, [WAIT( 0x0A ) , STR TagIN] 'timeout in 30 sec
			HSERIN [Footer]' Receive a byte serially into Footer
		  	 		   				 'Read is finished	(TEMPORARY) 
		If Footer = 0x0D then		 'The footer (last byte) should always be 0X0D
		   	High RFIDEnable		' Turn off RFID Reader
		  	Flag = 1			'Tag was read OK
				   	B1 = TagIN[0] + TagIN[1]   		'We combine each pair of digits into 1... we can do this
					CT[0] = B1	  			 		' because each digit is always less than 128 bits so
					B1 = TagIN[2] + TagIN[3] 		' by adding 2 together we never exceed the 256 bit maximum
					CT[1] = B1	  			 		' This saves space for data storage when we write the tags numbers
					B1 = TagIN[4] + TagIN[5] 		' to the flash memeory
					CT[2] = B1
					B1 = TagIN[6] + TagIN[7]
					CT[3] = B1
					B1 = TagIN[8] + TagIN[9]
					CT[4] = B1
			Return					
		Else  		   				'Footer not right
		  	High RFIDEnable	 		' Turn off RFID Reader
			Goto ReadAgain			'Read was not good..Try again
		End if
		

Timeout:	High RFIDEnable		   	 ' Turn off RFID Reader ..No Tag detected for 10 sec
			 Gosub BadSound
			CLS
			Print at 1,1, "No Tag Detected"
			Pause 3000
			Goto GoSleep
Case ELSE
	 	 Goto ReadTag			'wrong key pressed on keypad
ENDSELECT
'................End of Read Tag Sub.......................................
