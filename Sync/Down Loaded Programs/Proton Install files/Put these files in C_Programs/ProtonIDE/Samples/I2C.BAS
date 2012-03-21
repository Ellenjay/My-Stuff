' PROTON+ program to read and write to I2C Serial Eeproms
'
' Write to the first 16 locations of an external Serial Eeprom
' Read first 16 locations back and send to LCD repeatedly
' Note: for serial eeproms with WORD-sized address

       	Include "PROTON_4.INC"

		Dim W0	as	Word                    		' Address
		Dim B1	as	Byte                    		' Data 1
		Dim B2	as	Byte                    		' Data 2

       
        For W0 = 0 To 15                			' Loop 16 times
        	B1 = W0 + 10           					' B1 is data for SEEPROM
        	Busout $A0,W0,[B1]    					' Write each location
        	Delayms 5                				' Delay 5ms after each write
        Next

loop:   Cls
		For W0 = 0 To 15 Step 2         			' Loop 8 times
        	Busin $A1,W0,[B1,B2]  					' Read 2 locations in a row
        	Print at 1,1,Dec W0,": ",Dec B1," ",Dec B2," "  	' Display 2 locations
        	Delayms 1000
        Next

        Goto loop

