' Program to measure voltage (0-5VDC)
' and display on LCD with 2 decimal places
' This program uses the */ operator to scale the
' ADC result from 0-1023 to 0-500.  The */ performs
' a divide by 256 automatically, allowing math which
' would normally exceed the limit of a word variable.

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
	
		Dim ADVAL AS WORD			' Create ADVAL to store result

		TRISA = %11111111			' Set PORTA to all input
        ADCON1 = %10000010			' Set PORTA analog and right justify result
        Delayms 500       			' Wait .5 second
		Cls  						' Clear LCD 
		      
	 	While 1 = 1					' Create an infinite loop
			ADVAL = Adcin 0				' Read channel 0 to adval (0-1023)
			ADVAL = (ADVAL */ 500) >> 2	' equates to: (adval * 500)/1024    
        	Print at 1,1,"DC Volts= ",Dec (ADVAL/100),".", Dec2 ADVAL,"  "	' Display the decimal value  
       	 	Delayms 100       			' Wait .1 second
        Wend       			' Do it forever

