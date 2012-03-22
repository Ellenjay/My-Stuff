' Read and Write to a NEXFLASH NX26M080A card or NX26F160 chip.

' Clock pin is attached to PORTB.0
' Data pin is attached to PORTB.1
' A0 to A3 dictate the device address (0 in this case, so strap them to ground)

		Include "PROTON_4.INC"

' Designate the Clock and Data pins
		Symbol SCL = PORTC.0         		' Serial clock
		Symbol SIO = PORTC.1         		' Serial data I/O

' Declare some variables
		Dim I       	as	Word            ' Loop variable
		Dim Sector    	as	Word            ' Sector address
		Dim Stat    	as	Word            ' Busy / ready status
		Dim Dev_Addr	as	Byte			' The physical address of the card (A0 to A3)
		Dim Data_Byte	as	Byte			' Holds the data sent and received from the memory

' Declare some constants
		Symbol tRESET = 5					' tRESET time (in microseconds)
		Symbol tWP = 6						' tWP time (in milliseconds)
		Symbol tRP = 30						' tRP time (in microseconds)
		Symbol Tag_Sync = $C9				' Tag/Sync value
		Symbol Status_Valid = $9999			' Indicates Write complete
		Symbol Status_Invalid = $6666		' Indicates Write incomplete

		Symbol Main_Sector = 0				' Access the standard sectors
		Symbol Info_Sector = 5				' Access the information sector

        ADCON1 = 7              			' Set PORTA, E to digital
        Cls									' Clear the LCD	
        Goto Mainloop        				' Skip the subroutines

' *** SUBROUTINES START HERE ***

'------------------------------------------------------------------------------------
' OPEN the card for writing to the sector
' Format:- 
' write command (4-bits) .. Send value TWO for READ command
' sector address (12-bits)...Held in Variable 'SECTOR'
' device address (4-bits)....Held in Constant 'DEV_ADDR'
' aux sector address (4-bits)..Send 0 for normal sectors
' reserved (32-bits)...Send 32-bits, should be zeros
Open_Write:
        Shout SIO, SCL, MSBFIRST_H, [2\4, Sector\12, Dev_Addr\4, 0\4, 0, 0, 0, 0]
		Return

'------------------------------------------------------------------------------------
' CLOSE the card after writing the full or partial 535 byte sector
Close_Write:
        Shout SIO, SCL, MSBFIRST_H, [0,0]    		' Send 16 bits (data is don't care)
        Return
        
'------------------------------------------------------------------------------------
' Write the TAG/SYNC byte
' This should be placed in byte 0 of every sector
Write_Tag:
        Shout SIO, SCL, MSBFIRST_H, [Tag_Sync]     	' Write sector tag first ($C9)
        Return
'------------------------------------------------------------------------------------
' OPEN the card for reading from a sector
' Format:- 
' Read command (4-bits).. Send value ONE for READ command 
' Sector address (12-bits)...Held in Variable 'SECTOR'
' Device address (4-bits)....Held in Constant 'DEV_ADDR'
' Aux sector address (4-bits)..'MAIN_SECTOR' for normal sectors, 'INFO_SECTOR' to access information sector
' Reserved (32-bits)...Send 32-bits, should be zeros
' Input status (16-bits).. Read the 16-bit STATUS value. Returned in variable 'STAT'
Open_Read:
        Shout SIO, SCL, MSBFIRST_H, [1\4, Sector\12, Dev_Addr\4, Main_Sector\4, 0, 0, 0, 0]

' The line below is used to read the DEVICE INFORMATION sector instead of the MAIN sectors
' Shout SIO, SCL, MSBFIRST_H, [1\4, Sector\12, Dev_Addr\4, Info_Sector\4, 0, 0, 0, 0]

' READ the STATUS byte. 
' This will return $9999 (39321) if OK to write and $6666 (26214) if the card is busy writing/erasing

        Shin SIO, SCL, MSBPOST_H, [Stat.HighByte]    	' Read the first byte of status
        Delayus tRP              						' Delay between reading second half (tRP)
        Shin SIO, SCL, MSBPOST_H, [Stat.LowByte]  		' Read the second byte of status
		Return

'------------------------------------------------------------------------------------
' Subroutine to read data from the floppy card
' The byte received is returned in variable 'DATA_BYTE'
' Note: The card is held in READ mode by keeping the Clock line high after the byte is received.
FREAD:
		Shin SIO, SCL, MSBPOST_H, [Data_Byte]			' Read the data from the card
        Return

'------------------------------------------------------------------------------------
' Subroutine to write data to the card
' The byte to send is held in variable 'DATA_BYTE'
' Note: The card is held in WRITE mode by keeping the Clock line high after the byte is sent.
FWRITE:
		Shout SIO, SCL, MSBFIRST_H, [Data_Byte]     	' Write the data to the card
        Return

'------------------------------------------------------------------------------------
' *** THE MAIN PROGRAM LOOP STARTS HERE ***
' Write the TAG/SYNC byte to the first byte of the sector
' Then output 535 bytes of data to the card, at a given sector
' 
' Read the TAG/SYNC byte and reports an error if appropriate
' Then read 535 bytes from the card at the specified sector
MAINLOOP:

		Dev_Addr = 0						' We are addressing card with address 0 (A0-A3 all gnd)
        Low SCL                 		
		High SCL							' Wake the card from standby
        Delayus tRESET                		' Wait more than 5us (tRESET)

' Write to the card
		Print at 1,1,"Writing!"
        Sector = 2                			' Pick a sector to write to
		Gosub OPEN_WRITE					' Open the card for writing				
		Gosub Write_Tag						' Write the TAG/SYNC byte to 1st byte of the sector
		For I = 1 to 535					' Create a loop to cover the rest of the sector bytes
			Data_Byte = I					' Load the data to send
        	Data_Byte = Data_Byte & 255		' Extract the low byte of I (0 to 255)
			Gosub FWRITE            		' Write to the sector
		Next I
        Gosub Close_Write    				' Send 16 more clocks to close the card
        Low SCL                 			' Reset the card
        Delayms tWP                 		' Wait for more than 5ms (tWP)


' Read from the card
        Cls									' Clear the LCD
        Sector = 2                			' Pick a sector to read from
        Print at 1,1,"Sector: ",@Sector,"  "' Display the sector from which we are reading
		Gosub OPEN_READ						' Open the card for reading
        Gosub FREAD            				' Read the first byte from the sector (TAG/SYNC)
		If Data_Byte <> Tag_Sync then Err	' Reports an error if not $C9
		For I = 1 to 535					' Create a loop to cover the rest of the sector bytes
        	Gosub FREAD            			' Read it
        	Delayms 300      				' Delayms for drama
        	Rsout at 2,1,"Data: ",@Data_Byte,"  " 	' Display data on the LCD
		Next I

        Low SCL                 			' Reset the card (back into standby)

       	Stop
'-----------------------------------
' Come here if an error was found in the TAG/SYNC STATUS
Err:
        Cls									' Clear the LCD
        Print at 1,1,"ERROR in Sector"
        Print at 2,1,@Sector
        Low SCL								' Switch off the card
Inf:	Goto Inf							' Loop forever