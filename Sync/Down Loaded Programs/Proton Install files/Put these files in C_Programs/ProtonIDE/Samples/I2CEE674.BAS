' BUSIN and BUSOUT Commands
'
' Write to the first 16 locations of internal I2C eeprom
' Read first 16 locations back and send to serial out repeatedly
' Note: for PIC12CE67x PICmicros

        Device = 12C672
        Include "MODEDEFS.BAS"          			' Include serial modes

		INTERNAL_BUS = ON							' Use an internal I2C bus

' SDA and SCL automatically default to internal
' port.bit when this device is targetted
' But the two lines shown below can also be used
        'SDA_PIN = GPIO.6          					' Data line to internal EEPROM
        'SCL_PIN = GPIO.7          					' Clock line to internal EEPROM	
        	
        Dim B0 as Byte
		Dim B1 as Byte
		Dim B2 as Byte
        				
		Symbol SO = GPIO.1               			' Define serial output pin

'------------------------------------------------------------------------------------
 
 		Delayms 200									' Wait for PICmicro to stabilise       
        ALL_DIGITAL = True							' Set ADC pins to digital operation
	
        For B0 = 0 To 15                			' Loop 16 times
       		Busout $A0,B0,[B0]  					' Write each location's address to itself
       		Delayms 10                				' Delay 10ms after each write
        Next B0

        While 1 = 1									' Create an infinite loop
   			For B0 = 0 To 15 Step 2         		' Loop 8 times
        		Busin $A0,B0,[B1,B2]        		' Read 2 locations in a row
        		Serout SO,T2400,[#B1," ",#B2," "]   ' Display 2 locations
        	Next B0

        	Serout SO,T2400,[13]            		' Display linefeed

        Wend

