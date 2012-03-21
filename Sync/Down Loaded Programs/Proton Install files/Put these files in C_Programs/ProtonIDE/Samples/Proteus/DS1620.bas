' Display the temperature from a Dallas DS1302 sensor
'
' For use with the ISIS 16F628 Virtual Evaluation Board.

		Device = 16F628A
        XTAL = 4
             
        LCD_DTPIN = PORTB.4	
		LCD_RSPIN = PORTB.3
		LCD_ENPIN = PORTB.0
		LCD_INTERFACE = 4					' 4-bit Interface
		LCD_LINES = 2 						' 2-Line LCD
		LCD_TYPE = 0						' Alphanumeric LCD type
        
'Define DS1620 Pins 

		Symbol CLK 		= PORTA.0      		' CLK = Clock pin 
		Symbol DQ		= PORTA.1       	' DQ = Data pin
		Symbol RST		= PORTB.7  			' RST = Reset pin

' Define Variables 
		Dim DSdata  as Word  				' Word variable to hold 9-bit data.

' Define Constants for DS1620 configuration
		Symbol Rconf	= $AC   			' Read Configuration
		Symbol Wconf	= $0C   			' Write Configuration
		Symbol CPUon	= %10   			' Operate with Microcontroller mode
		Symbol Cont		= %00   			' Continuous conversions on start
		Symbol StartC	= $EE   			' Start Conversion
		Symbol Rdtemp	= $AA   			' Read Temperature

' Define Thermostat functions
		Symbol RhiT	= $A1   				' Read High-Temperature Setting
		Symbol WhiT	= $01   				' Write High-Temperature Setting
		Symbol RloT	= $A2   				' Read Low-Temperature Setting.'
		Symbol WloT	= $02   				' Write Low-Temperature Setting.'
		Symbol HighVal = $32   				' High Temperature Setting 25C for Thigh
		Symbol LowVal  = $31   				' High Temperature Setting 24C for Tlow
'-------------------------------------------------------------------------
' Start of main Program
		ALL_DIGITAL = ON
        Cls									' Clear the LCD
        Output RST							' Make the RST pin an output
        Output CLK							' Make the CLK pin an output
        
		Print "TEMPERATURE IS"
    	Clear RST 							' Shutdown the DS1620
		'Delayms 50 							' Time for reset to occur
		Set RST 							' Get ready to write data
	
		Shout DQ,CLK,LSBFIRST,[Wconf\8,CPUon|Cont\8] ' Set configuration
		Clear RST 							' Reset teh DS1620
		Delayms 50 	
		Set RST 	
		Shout DQ,CLK,LSBFIRST,[StartC\8] 	' Start a conversion
		Clear RST 							' Reset the DS1620
	
' Writes the config byte for THigh, set for 25C
' With a LED connected THigh pin 7, at 25C or higher the LED will light. 
		Delayms 50
		Set RST
		Shout DQ,CLK,LSBFIRST,[Whit\8,HighVal\9]
		Clear RST
	
' Writes the config byte for the TLow, set for 24C
' With a LED connected TLow pin 6, at 24C or below the LED will light.  
		Delayms 50
		Set RST
		Shout DQ,CLK,LSBFIRST,[Wlot\8,LowVal\9]
		Clear RST

' Start loop, reads temperature. Loop forever
		While 1 = 1
			Delayms 1000 						' Wait 1 second between readings
			Clear CLK
			Set RST   							' Start the DS1620
			Shout DQ,CLK,LSBFIRST,[Rdtemp\8] 	' Request temperature
			Shin DQ,CLK,LSBPRE,[DSdata\9]  		' Get temperature
			Clear RST

			DSdata = DSdata >> 1				' Shift the sign bit into the correct position   
' Display signed temperature in Celsius.
			Print at 2,1,SDec DSdata.lowbyte," DEGREES C "
	Wend
