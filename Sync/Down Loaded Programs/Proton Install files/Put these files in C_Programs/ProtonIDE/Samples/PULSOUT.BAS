' PULSOUT Command demonstration
' Variable Pulse Generator. 
' Two buttons adjust from off to 10mSec in 10 uSec steps.
' This will be displayed as LED 1 increasing and decreasing brightness

        Include "PROTON_4.INC"

		Dim W0	as	Word

		Symbol PO = PORTD.0                     ' Define pulse output pin

        OPTION_REG.7 = 0        					' Enable PORTB pull-ups
        PORTB = 0       							' PORTB lines low to read buttons
        TRISB = $F0     							' Enable all buttons

        Low PORTD      								' All LEDs off        
        W0 = 0
        Low PO                                  	' Initialize output polarity
Incr:   If PORTB.4 = 0 Or W0 = 1000 Then Decr  		' Increment frequency on switch 2 
		Inc W0
Decr:   If PORTB.5 = 0 Or W0 = 0 Then Pulse    		' Decrement frequency on switch 1
		Dec W0
Pulse:  Pulsout PO,W0                            	' Generate pulse
        Delayms 10                                	
        Goto Incr                                	' Do it forever
