' Program to send and receive from the hardware serial port
' LEDs count characters and flash error if none received for 10 seconds

		Include "PROTON_4.INC"

		Dim Char as Byte				' Storage for serial character

		Delayms 500
        
		TRISB = %11111000				' Set PORTB.0-2 to outputs
		PORTB = 0						' Turn off LEDs

Loop:   Hrsin {10000 , All_On} , Char	' Get a char from serial port

		Inc PORTB						' Increment LED count

        Hrsout Char						' Send char out serial port
		Goto Loop						' Do it all over again

All_On:	PORTB = 7						' Error - no character received
		Delayms 500						' Blink all LEDs
		PORTB = 0
		Delayms 500
		Goto All_On

