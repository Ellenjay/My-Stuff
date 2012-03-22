' Program to demonstrate an interrupt-driven input buffer for HRSIN using On Interrupt.


		Include "PROTON_4.INC"

		Symbol Buffer_size = 16				' Sets the size of the ring buffer
		Dim Buffer[Buffer_Size] as Byte		' Array variable for holding received characters
		Dim Index_in	as	Byte			' Pointer - next empty location in buffer
		Dim Index_out	as	Byte			' Pointer - location of oldest character in buffer
		Dim Bufchar		as	Byte			' Stores the character retrieved from the buffer
		Dim I			as	Byte			' loop counter 
		Dim Col			as	Byte			' Stores location on LCD for text wrapping
		Dim Errflag		as	Byte			' Holds error flags

        Symbol RCIF	= PIR1.5				' Alias RCIF (USART Receive Interrupt Flag)
		Symbol OERR	= RCSTA.1				' Alias OERR (USART Overrun Error Flag)
		Symbol CREN	= RCSTA.4				' Alias CREN (USART Continuous Receive Enable)
		Symbol LED = PORTD.0 				' Alias LED to PORTD.0

'----------------------------------------------------------------------------------------        
' Initialise variables
		Delayms 200							' Wait for the power supply to stabilise
        Errflag = 0
        Index_in = 0
		Index_out = 0
		I = 0
		Col = 1

		Cls								' Clear LCD
		INTCON = %11000000				' Enable interrupts
		On Interrupt Goto SerialIn		' Declare software interrupt handler routine
		PIE1.5 = 1						' Enable interrupt on USART

' MAIN PROGRAM STARTS HERE - Blink an LED at 1Hz

Loop:   High LED        				' Turn on LED connected to PORTD.0
        For I = 0 to 250				' Delay for .5 seconds (250*2mS)
	    	Delayms 2   				' Use a short Delayms within a loop
		Next							' Instead of one long delay
        Low LED     					' Turn off LED connected to PORTD.0
        For I = 0 to 250				' Delay for .5 seconds (250*2mS)
	        Delayms 2   				' Use a short Delayms within a loop
		Next							' Instead of one long delay

Display:								' Dump the buffer to the LCD
		If Errflag  > 0 Then Error1		' Handle error if needed
		If Index_in = Index_out Then Loop	' loop if nothing in buffer

		Gosub Getbuf					' Get a character from buffer	
		Print Bufchar					' Send the character to LCD
		
		Inc Col							' Increment LCD location
		If Col > 20 Then				' Check for end of line
			Col = 1						' Reset LCD location
			Print at 2,1,Rep " "\20 , $FE,2	' Clear line-2 of LCD and Tell LCD to return home
		Endif

		Goto Display					' Check for more characters in buffer
        
'----------------------------------------------------------------------------------------
' Subroutines

		Disable							' Don't check for interrupts in this section

Getbuf:									' Move the next character in buffer to bufchar
		Index_out = (Index_out + 1)			' Increment index_out pointer (0 to 63)
		If Index_out > (Buffer_size - 1) Then Index_out = 0	' Reset pointer if outside of buffer
		Bufchar = Buffer[Index_out]			' Read buffer location
		Return

'----------------------------------------------------------------------------------------
Error1:										' Display error message if buffer has overrun
		If Errflag.1  = 1 Then				' Determine the error
			Print at 2,1,"BUFFER OVERRUN"	' Display buffer error on line-2
		Else
			Print at 2,1,"USART OVERRUN"	' Display usart error on line-2
		Endif	
		Print $FE,2							' Send the LCD cursor back to line-1 home
		For I = 2 to Col					' Loop for each column beyond 1
			Print $FE,$14					' Move the cursor right to the right column
		Next
	
		Errflag = 0							' Reset the error flag
		CREN = 0							' Disable continuous receive to clear overrun flag
		CREN = 1							' Enable continuous receive
		Goto Display						' Carry on
	
'----------------------------------------------------------------------------------------	
' Interrupt handler
SerialIn:											' Buffer the character received
		If OERR  = 1 Then Usart_Error				' Check for USART errors
		Index_in = (Index_in + 1)					' Increment index_in pointer (0 to 63)
		If Index_in > (Buffer_size - 1) Then Index_in = 0	'Reset pointer if outside of buffer
		If Index_in = Index_out Then Buffer_Error	' Check for buffer overrun
		Hrsin Buffer[Index_in]						' Read USART and store character to next empty location
		If RCIF = 1 Then SerialIn					' Check for another character while we're here

		Resume										' Return to program

Buffer_Error:
		Errflag.1 = 1								' Set the error flag for software
' Move pointer back to avoid corrupting the buffer. MIN insures that it ends up within the buffer.	
		Index_in = (Index_in - 1) Min (Buffer_size - 1)	
		Hrsin Buffer[Index_in]						' Overwrite the last character stored (resets the interrupt flag)
Usart_Error:
		Errflag.0 = 1								' Set the error flag for hardware	

		Resume										' Return to program
				
