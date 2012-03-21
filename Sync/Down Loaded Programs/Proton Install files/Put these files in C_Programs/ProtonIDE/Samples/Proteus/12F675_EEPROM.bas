' Read and write to an I2C Serial Eeprom using an 8-pin 12F675 PICmicro device
'
' Write to the first 16 locations of an external Serial Eeprom
' Read first 16 locations back and send to LCD repeatedly
' Note: for serial eeproms with WORD-sized address

		Device = 12F675
'
' Setup for internal MCLR pin, and internal Oscillator
'		
		REMINDERS = OFF
		CONFIG CPD_OFF,CP_OFF,BODEN_OFF,MCLRE_OFF,PWRTE_OFF,WDT_OFF	,INTRC_OSC_NOCLKOUT	
		REMINDERS = ON
		
        XTAL = 4
        
        SERIAL_BAUD = 9600	
		RSOUT_PIN = GPIO.1
		RSOUT_MODE = TRUE
		RSOUT_PACE = 10

		SDA_PIN = GPIO.5 							' Assign the eeprom's SDA pin to GPIO.5
		SCL_PIN = GPIO.4                			' Assign the eeprom's SCL pin to GPIO.4

        Dim W0	as	Word                    		' Address
		Dim B1	as	Byte                    		' Data 1
		Dim B2	as	Byte                    		' Data 2
		
		
        Delayms 100									' Wait for the PICmicro to stabilise
        ALL_DIGITAL = TRUE  						' Set the GPIO pins to all digital mode
   
'-------[MAIN PROGRAM LOOP STARTS HERE]----------------------------------

' Write to the eeprom       
        For W0 = 0 To 15                			' Loop 16 times
        	B1 = W0 + 10           					' B1 is data for SEEPROM
        	Busout $A0,W0,[B1]    					' Write each location
        	Delayms 10                				' Delay 5ms after each write
        Next
' Read from the eeprom
		While 1 = 1  
			For W0 = 0 To 15 Step 2         		' Loop 8 times
        		Busin $A1,W0,[B1,B2]  				' Read 2 locations in a row
        		Rsout at 1,1,Dec W0,": ",Dec B1," ",Dec B2," "  ' Display 2 locations
        		Delayms 500
        	Next

        Wend										' Do another conversion
	
        
