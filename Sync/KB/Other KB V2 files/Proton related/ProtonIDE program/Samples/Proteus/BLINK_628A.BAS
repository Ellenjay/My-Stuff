' Strobe all the LEDs connected to PORTB
'
' For use with the ISIS 16F628 Virtual Evaluation Board.
		
        Device = 16F628A
        XTAL = 4
		
        Dim I as byte    		' Define loop variable

		Symbol LED = PORTB   	' Alias PORTB to LEDS

		Delayms 500				' Wait for PICmicro to stabilise
		TRISB = %00000000       ' Set PORTB to all output

		While 1 = 1
			LED = 1        		' First LED on
        	Delayms 500       	' Delay for .5 seconds

        	For I = 1 To 7  	' Go through For..Next loop 7 times
        		LED = LED << 1  ' Shift on LED, one to left
        		Delayms 500     ' Delay for .5 seconds
        	Next

        Wend       				' Go back to loop and blink LED forever
        
