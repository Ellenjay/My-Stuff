' Display text from two LDATA tables
' Based on their address located in a seperate table
		
        Include "PROTON_4.INC"				' Use a 14-bit core device
        
        Dim ADDRESS as Word
        Dim LOOP as Word
        Dim DATA_BYTE as Byte
        
        Delayms 200							' Wait for PICmicro to stabilise
        Cls									' Clear the LCD
        ADDRESS = LREAD ADDR_TABLE			' Locate the address of the first string
       	While 1 = 1							' Create an infinite loop
        	DATA_BYTE = LREAD ADDRESS		' Read each character from the LDATA string
            If DATA_BYTE = 0 Then Break		' Exit if NULL found
        	Print DATA_BYTE					' Display the character
            Inc ADDRESS						' Next character
        Wend								' Close the loop
EXIT_LOOP:
		
        Cursor 2,1							' Point to line 2 of the LCD
		ADDRESS = LREAD ADDR_TABLE + 2		' Locate the address of the second string
       	While 1 = 1							' Create an infinite loop
        	DATA_BYTE = LREAD ADDRESS		' Read each character from the LDATA string
            If DATA_BYTE = 0 Then Break 	' Exit if NULL found
        	Print DATA_BYTE					' Display the character
            Inc ADDRESS						' Next character
        Wend								' Close the loop
EXIT_LOOP2:
        Stop
        
        
ADDR_TABLE:									' Table of address's
		LDATA as WORD STRING1, STRING2
STRING1: 
		LDATA "HELLO",0
STRING2: 
		LDATA "WORLD",0
      	
        
      	

        
                
