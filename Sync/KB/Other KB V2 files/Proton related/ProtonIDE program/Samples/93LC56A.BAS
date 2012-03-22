' PROTON+ program to read and write to a Microwire SEEPROM 93LC56A
'
' Write to the first 16 locations of an external serial EEPROM
' Read first 16 locations back and send to LCD repeatedly
' Note: for serial eeproms with byte-sized address

       	Device = 16F877
		XTAL = 4

                
' LCD pin Assignments         
        LCD_DTPIN = PORTD.4
        LCD_RSPIN = PORTE.0
        LCD_ENPIN = PORTE.1
        LCD_LINES = 2
        LCD_INTERFACE = 4

		Symbol CS  	= PORTA.5                		' Chip select pin
		Symbol CLK 	= PORTC.3                		' Clock pin
		Symbol DI	= PORTC.4                		' Data in pin
		Symbol DO	= PORTC.5                		' Data out pin

		Dim Addr as Byte                    		' Address
		DIm B0   as Byte                    		' Data

        Delayms 500									' Wait for PICmicro to stabilise
        ALL_DIGITAL = TRUE                     		' Set PORTA and PORTE to digital
        Low CS                          			' Chip select inactive        
        Low PORTE.2                     			' LCD R/W line low (W)
        Delayms 100                       			' Wait for LCD to start up

        Gosub eewriteen                 			' Enable SEEPROM writes
        
        For addr = 0 To 15              			' Loop 16 times
        	B0 = addr + 100         				' B0 is data for SEEPROM
        	Gosub eewrite           				' Write to SEEPROM
       		Delayms 10               				' Delay 10ms after each write
        Next

loop:   Cls
		For addr = 0 To 15              			' Loop 16 times
        	Gosub eeread            				' Read from SEEPROM
        	Print at 1,1,#addr,": ",#B0     		' Display
        	Delayms 1000
        Next

        Goto loop

' Subroutine to read data from addr in serial EEPROM
eeread: CS = 1                          			' Enable serial EEPROM
        Shout DI, CLK, MSBFIRST, [%1100\4, addr]    ' Send read command and address
        Shin DO, CLK, MSBPOST, [B0]  				' Read data
        CS = 0                          			' Disable
        Return

' Subroutine to write data at addr in serial EEPROM
eewrite: 
		CS = 1                         				' Enable serial EEPROM
        Shout DI, CLK, MSBFIRST, [%1010\4, addr, B0] ' Send write command, address and data
        CS = 0                          			' Disable
        Return

' Subroutine to enable writes to serial EEPROM
eewriteen: 
		CS = 1                       				' Enable serial EEPROM
        Shout DI, CLK, MSBFIRST, [%10011\5, 0\7]    ' Send write enable command and dummy clocks
        CS = 0                          			' Disable
        Return
     