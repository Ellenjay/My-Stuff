' Flash all the LEDs sequentially connected to PORTD
		
        INCLUDE "PROTON_4.INC"	' Add the setup for the PROTON board

		DIM SCAN AS BYTE    	' Declare SCAN variable
		Symbol LED = PORTD   	' Alias PORTD to LEDS
		
		LOW LED					' Make PORTD output LOW
LOOP:   LED = 1        			' First LED on
        DELAYMS 300       		' Delay for .3 seconds
        FOR SCAN = 1 TO 7  		' Go through For..Next loop 7 times
        	LED = LED << 1    	' Shift on LED, one to left
        	DELAYMS 300       	' Delay for .3 seconds
        NEXT					' Close the SCAN loop
        GOTO LOOP       		' Go back to loop and blink LED forever
