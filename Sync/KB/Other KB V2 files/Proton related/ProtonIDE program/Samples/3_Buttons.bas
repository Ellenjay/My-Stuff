' BUTTON Command for the PROTON board
' Demonstrates multiple BUTTON commands. Each of 3 buttons toggles an LED.
' Hold a button for 1 second and the LED will flicker (auto-repeat).

        Include "PROTON_20.INC"			' Configure ports for PROTON board
                 		
        Dim BUF1 As Byte				' Working buffer 1 for button command
		Dim BUF2 As Byte				' Working buffer 2 for button command
		Dim BUF3 As Byte				' Working buffer 3 for button command        
		Symbol SW1	= PORTB.4
		Symbol SW2	= PORTB.5
		Symbol SW3	= PORTB.6
		Symbol LED1 = PORTD.5
		Symbol LED2 = PORTD.6
		Symbol LED3 = PORTD.7

		DelayMS 500						' Wait for PICmicro to stabilise
        Clear							' Clear buffers
        Low PORTD						' ALL LEDs off
		TRISB = %11110000				' Set PORTB 0-3 outputs, 4-7 inputs
		PORTB_PULLUPS = On				' Enable PORTB pull-ups
Chk1:	DelayMS 25
		Button SW1,0,40,5,BUF1,0,Chk2	' Check Button 1 (Skip to 2 if Not Pressed)
		Toggle LED1						' Toggle LED if pressed		
Chk2:	Button SW2,0,40,5,BUF2,0,Chk3	' Check Button 2 (Skip to 3 if Not Pressed)
		Toggle LED2						' Toggle LED if pressed		
Chk3:	Button SW3,0,40,5,BUF3,0,Chk1	' Check Button 3 (Skip to 1 if Not Pressed)
		Toggle LED3						' Toggle LED if pressed
        GoTo Chk1						' Do it forever
