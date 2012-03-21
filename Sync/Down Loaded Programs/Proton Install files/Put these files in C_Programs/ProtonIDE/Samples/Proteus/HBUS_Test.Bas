' Using the Master Synchronous Serial Port (MSSP). Configured as an I2C master.

		Include "PROTON_4.INC"			
		
' ** Declare some USER Variables **        
        Dim ADDRS	as	Word
        Dim E_BYTE	as	Byte								' Byte read/written to eeprom
        
' ** MAIN PROGRAM STARTS HERE **
                  
		Cls													' Clear the LCD
' Write to the first 11 address's of the Eeprom
        For ADDRS = 0 To 10                					' Create a loop of 11
			E_BYTE = ADDRS								' Place the byte to be transmitted into E_Byteout		
			HBUSOUT %10100000 , ADDRS , [E_BYTE]			' Write the byte to the Eeprom
            Print at 1,1,"Data Written ",Dec E_BYTE,"  "
			Delayms 200
        Next												' Close the Loop
		Delayms 500

' Read the first 11 address's within the Eeprom,	
' and display them on the LCD
AGAIN:  Cls													' Clear the LCD
		For ADDRS = 0 To 10        							' Create a loop of 11		
			HBUSIN %10100000 , ADDRS , [E_BYTE]  			' Receive the byte from the eeprom
            Print at 1,1,"Address   ",Dec ADDRS,"   ",at 2,1,"Data Read ",Dec E_BYTE,"  "  	' Print the value read in from the eeprom
			Delayms 400										' Delayms between displays, for drama
        Next												' Close the loop
        Goto AGAIN											' Do it forever		
