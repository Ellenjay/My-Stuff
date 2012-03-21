' Program to measure voltage (0-5VDC)
' and display on LCD with 2 decimal places. A
' 60 segment bargraph is also displayed using
' custom LCD characters.
'
' This program uses the */ operator to scale the
' ADC result from 0-1023 to 0-500.  The */ performs
' a divide by 256 automatically, allowing math which
' would normally exceed the limit of a word variable.
'
' Connect analog input to channel-0 (RA0)

		DEVICE = 16F877
        XTAL = 4


		LCD_DTPIN = PORTD.4	
		LCD_RSPIN = PORTE.0
		LCD_ENPIN = PORTE.1
		LCD_INTERFACE = 4	' 4-bit Interface
		LCD_LINES = 2
		LCD_TYPE = 0        

' Define ADC parameters
		ADIN_RES = 10 				' 10-bit result required 
		ADIN_TAD = FRC 				' RC OSC chosen 
		ADIN_STIME = 50 			' Allow 50us sample time

' Declare variables
		Dim Adval 		as Word				' Create adval to store result
		Dim Fullbars 	as Byte				' Number of full bars at left of graph
		Dim Barval 		as Byte				' Value passed to bargraph routine
		Dim Partbar 	as Byte				' ASCII code for partial bar character
		Dim Pad 		as Byte				' Number of spaces to pad to the right of graph


		TRISA = %11111111					' Set PORTA to all input
        ADCON1 = %10000010					' Set PORTA analog and right justify result

        Delayms 500       					' Wait .5 second
        
' Load the custom characters to LCD CGRAM. The blank at $0 makes the graphing math work faster.
        
	    Print $FE,64,Rep $0\8				' Load blank character (ASCII 0)
	    Print $0,Rep $10\6,$0				' Load | character (ASCII 1)
    	Print $0,Rep $14\6,$0				' Load || character (ASCII 2)
	    Print $0,Rep $15\6,$0				' Load ||| character (ASCII 3)
	    
	    Cls									' Clear the display


Loop: 	Adcin 0, Adval						' Read channel 0 to adval (0-1023)

		Adval = (Adval */ 500) >> 2			' equates to: (adval * 500)/1024

        Print at 1,1,"DC Volts= ",Dec (Adval/100),".", Dec2 Adval	' Display the decimal value
        
        Barval = (Adval / 9) + 1			' Scale 0-500 to 60 segment bargraph (1-56)
        
        Gosub Bargraph						' Update bargraph with new barval

        Goto Loop       					' Do it forever


Bargraph:

  		Fullbars = (Barval Min 60) / 3		' Calculate number of full bars (|||). 
  	
' Partbar holds the ASCII code for the partial bar character: $0=" ", $1="|", or $2="||"

  		Partbar = (Barval Min 60) // 3		' Calculate ascii code for partial bar character		 
  	
  		Pad = 19 - Fullbars					' Number of spaces to fill display width.
  	
		Print at 2,1, Rep $03\Fullbars, Partbar, Rep " "\Pad	' Display the bar on second line
	
		Return


