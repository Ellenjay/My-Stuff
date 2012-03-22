' Program to read and write to SPI SEEPROMs
'
' Write to the first 16 locations of an external serial EEPROM
' Read first 16 locations back and send to LCD repeatedly
' Note: for SEEPROMs with word-sized address

		Include "PROTON_4.INC"


		Symbol CS = PORTC.4				' SPI eeprom CS line
        Symbol SCK = PORTC.3			' Clock pin
        Symbol SI = PORTC.5				' Data in pin
        Symbol SO = PORTC.5				' Data out pin

		Dim Addr  as   Word             ' Address
		Dim B0    as   Byte             ' Data

        Output CS                     	' Set CS to output

        Delayms 100                     ' Wait for LCD to start up


        For Addr = 0 To 15              ' Loop 16 times
        	B0 = Addr + 10         ' B0 is data for SEEPROM
        	Gosub Eewrite           ' Write to SEEPROM
       		Delayms 10                ' Delay 10ms after each write
        Next B0

Loop:   For Addr = 0 To 15              ' Loop 16 times
        	Gosub Eeread            ' Read from SEEPROM
        	Print $FE,1,#Addr,": ",#B0     ' Display
        	Delayms 1000
        Next B0

        Goto Loop

' Subroutine to read data from addr in serial EEPROM
Eeread: CS = 0                          ' Enable serial EEPROM
        Shout SI, SCK, MSBFIRST, [$03, Addr\16]       ' Send read command and address
        Shin SO, SCK, MSBPRE, [B0]   ' Read data
        CS = 1                          ' Disable
        Return

' Subroutine to write data at addr in serial EEPROM
Eewrite: CS = 0                         ' Enable serial EEPROM
        Shout SI, SCK, MSBFIRST, [$06]       ' Send write enable command
        CS = 1                          ' Disable to execute command
        CS = 0                          ' Enable
        Shout SI, SCK, MSBFIRST, [$02, Addr\16, B0]   ' Send address and data
        CS = 1                          ' Disable
        Return

        End
