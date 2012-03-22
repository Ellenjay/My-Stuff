' Serial Keypad

		Device 16F84					' We are using a PIC16F84
		
		XTAL = 4					' And a 4MHz crystal
        RSOUT_PIN	= PortA.0		' Serial out at PORTA bit-0
        SERIAL_BAUD	= 9600			' 9600 Baud
        RSOUT_MODE	= Inverted    	' Inverted
        RSOUT_PACE	= 100			' 100ms between characters sent    
		Keypad_Port = PortB			' Connect the Keypad to PortB

		Dim Key as	Byte				' Holds the key pressed
            
' ** THE MAIN PROGRAM LOOP STARTS HERE **
Again:	Key = Inkey						' Read the Keypad
        Delayms 50						' Delayms for 50ms to debounce
        Rsout at 1,1,Key				' Output the value of KEY		
		Goto Again						' Do it forever        