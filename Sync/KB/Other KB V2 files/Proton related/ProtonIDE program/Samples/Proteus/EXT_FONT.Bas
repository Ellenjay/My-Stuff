' Pre-load the I2C eeprom with the graphic LCD's font table
' And display 3 fonts
' As each font area is filled within the eeprom
' the display will slowly show the characters

		'Include "PROTON18_G10.EXT"				' Unremark for use with 16-bit core device
        Include "PROTON_G10.EXT"
' Set up some Variables
        Dim FBYTE	as	Byte
        Dim ADDR	as	Word
        
        Delayms 500								' Wait for PICmicro to stabilise
        Hrsout "Clearing Eeprom of any font data. Please wait...",13
		Cls										' Clear the LCD
' Clear some of the eeprom before we start
' So we can see each font being created
		Low PORTD
        Clear ADDR
        Repeat
        	Busout $A0,ADDR,[0]					' Write to EEPROM	 		
            Delayms 10							' Wait for the byte to be placed	
       		Inc ADDR
            PORTD.0 = ADDR.5					' Flash LED to signify 'WORKING' 
        Until ADDR > 2303						' Erase up to address 2304
        
' Read the font table and load it into a 24C128 I2C eeprom
                       
' Load memory area for FONT 0 (0 - 767)
        Hrsout "Loading Eeprom with font 0 data. Watch the LCD and Please wait...",13
		Clear ADDR
        Repeat									' Create a loop       	
            FBYTE = CRead FONT + ADDR			' Read the font data
        	Busout $A0,ADDR,[FBYTE]				' Write to EEPROM	 		
            Delayms 10							' Wait for the byte to be placed           
            Print at 1,0,FONT 0 , "LOADING EEPROM " , DEC ADDR
            Inc ADDR
        Until ADDR > 767						' 128 characters = 6 * 128
        Print at 0,0,FONT 0 , "FONT 0"

' Load memory area for FONT 1 (768 - 1535)        	
        Hrsout "Loading Eeprom with font 1 data. Watch the LCD and Please wait...",13
		Clear ADDR
        Repeat									' Create a loop       	         
            FBYTE = CRead FONT + ADDR			' Read the font data
            Busout $A0,ADDR + 768,[FBYTE]		' Write to EEPROM	 		
            Delayms 10							' Wait for the byte to be placed           
            Print at 3,0,FONT 1 , "LOADING EEPROM " , DEC ADDR + 768
            Inc ADDR
        Until ADDR > 767						' 128 characters = 6 * 128
        Print at 2,0,FONT 1 , "FONT 1"
 
' Load memory area for FONT 2 (1536 - 2303)              
        Hrsout "Loading Eeprom with font 2 data. Watch the LCD and Please wait...",13
		Clear ADDR
        Repeat									' Create a loop       	
            FBYTE = CRead FONT + ADDR			' Read the font data
            Busout $A0,ADDR + 1536,[FBYTE]		' Write to EEPROM	 		
            Delayms 10							' Wait for the byte to be placed           
            Print at 5,0,FONT 2 , "LOADING EEPROM " , DEC ADDR + 1536 
            Inc ADDR
        Until ADDR > 767						' 128 characters = 6 * 128
        Print at 4,0,FONT 2 , "FONT 2"        
        
       	Hrsout "Eeprom Loaded",13
  		Print at 7,0, FONT 0 , "EEPROM LOADED"
        Stop

' Include the FONT table to be placed into eeprom memory
		Include "FONT.INC"						' Load the font data into memory
        
                  
