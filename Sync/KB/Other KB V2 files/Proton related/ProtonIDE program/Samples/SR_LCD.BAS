' Serial LCD

		Device 16F84					' We are using a PIC16F84
		XTAL = 4						' And a 4MHz crystal
        
        RSIN_PIN	= PORTA.0		' Serial in at PORTA bit-0
        SERIAL_BAUD	= 9600			' 9600 Baud
        RSOUT_MODE  = Inverted    	' Inverted    

		Dim Byte_In	As Byte 
		           
' ** THE MAIN PROGRAM LOOP STARTS HERE **
Again:	Byte_In = RSIn					' Read the serial data
        Print Byte_In					' Display the serial data		
		GoTo Again						' Do it forever        
