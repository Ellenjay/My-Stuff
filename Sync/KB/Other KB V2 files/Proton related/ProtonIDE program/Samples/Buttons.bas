' Show button press on LED

		'Include "PROTON_4.INC"
        Device = 16F877
        
        ALL_DIGITAL = TRUE
        PORTB_PULLUPS = ON      ' Enable PORTB pull-ups
        TRISD = 0       		' Set PORTD (LEDs) to all output
        
Loop:
        PORTB = 0       		' PORTB lines low to read buttons
        TRISB = $F0     		' Enable all buttons

        PORTD = 0       		' All LEDs off
' Check any button pressed to turn on LED
        If PORTB.7 = 0 Then     ' If 4th button pressed...
        	PORTD.4 = 1     	' 4th LED on
        Endif
        If PORTB.6 = 0 Then     ' If 3rd button pressed...
        	PORTD.5 = 1     	' 3rd LED on
        Endif
        If PORTB.5 = 0 Then     ' If 2nd button pressed...
        	PORTD.6 = 1     	' 2nd LED on
        Endif
        If PORTB.4 = 0 Then     ' If 1st button pressed...
        	PORTD.7 = 1     	' 1st LED on
        Endif
        Goto Loop       		' Do it forever