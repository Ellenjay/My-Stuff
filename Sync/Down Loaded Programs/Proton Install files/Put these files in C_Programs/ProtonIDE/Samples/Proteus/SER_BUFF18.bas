' Interrupt-driven input buffer for hardware USART receive 
' using Assembly language interrupt. 

' Pin definitions compatible with PROTON Development board and PIC18F452


		Include "PROTON18_4.INC"

		Dim F_SAVE	as WORD SYSTEM				' Saves FSR0

		Symbol BUFFER_SIZE	=	64				' Sets size of ring buffer (max 255)
		Dim BUFFER[BUFFER_SIZE]	as	BYTE		' Array variable for holding received characters
		Dim INDEX_IN	as	BYTE 				' Pointer - next empty location in buffer
		Dim INDEX_OUT	as	BYTE 				' Pointer - location of oldest character in buffer
		Dim ERRFLAG		as	BYTE  				' Error flag

		Dim BUFCHAR		as	BYTE				' Stores the character retrieved from the buffer
		Dim COL			as	BYTE				' Stores location on LCD for text wrapping
		Dim I			as	BYTE				' Loop counter
		
        Symbol LED		=	PORTD.0				' Alias LED to PORTD.0
		Symbol CREN		= 	RCSTA.4				' Alias CREN (Serial receive enable)

		' Point to interrupt handler
		ON_INTERRUPT INT_UART

' Configure internal registers
		Delayms 500               				' Wait for PICmicro to stabilise
		Clear									' Clear all RAM before we start
		RCSTA = $90								' Enable USART receive
		TXSTA = $24								' Set USART parameters
		SPBRG = 25								' Set baud rate to 9600 (4MHz clock)
		Goto START								' Skip around interrupt handler
'-------------------------------------------------------------------------------
' Assembly  INTERRUPT handler

INT_UART:
' Save the state of FSR0 register
		Movff	FSR0L,F_SAVE			' Save FSR0 lowbyte
        Movff	FSR0H,F_SAVEH			' Save FSR0 highbyte
			
' Check for hardware overrun error
		Btfsc	RCSTA,OERR				' Check for usart overrun
		Bra 	USART_ERR				' Jump to assembly error routine
	
' Test for buffer overrun		
		Incf	INDEX_IN,W				' Increment index_in to WREG
		Subwf	INDEX_OUT,W				' Subtract indexes to test for buffer overrun
		Bz		BUFFER_ERR				' Check for zero (index_in = index_out) jump to error routine if zero

' Increment the index_in pointer and reset it if it's outside the ring buffer
		Incf	INDEX_IN, F				' Increment index_in to index_in
		Movlw 	BUFFER_SIZE
        Cpfslt	INDEX_IN				' If index_in => buffer_size
		Clrf	INDEX_IN				' Clear index_in

' Set FSR0 with the location of the next empty element in buffer
		Lfsr 	0,BUFFER				' Move buffer address to FSR0

' Read and store the character from the USART		
		Movfw	INDEX_IN				' WREG must hold the offset value for the next empty location
		Movff	RCREG, PLUSW0			' Move the character in RCREG to address (FSR0+W)
		
' Restore FSR0
FINISHED:
		Movff	F_SAVE,FSR0L			' Restore FSR0L
        Movff	F_SAVEH,FSR0H			' Restore FSR0H
		Retfie	Fast					' Return from the interrupt

' Error routines	
BUFFER_ERR:								' Jump here on buffer error
		Bsf		ERRFLAG,1				' Set the buffer flag
USART_ERR:								' Jump here on USART error
		Bsf		ERRFLAG,0				' Set the USART flag
		Movfw	RCREG					' Discard the received character
		Bra		FINISHED				' Restore state and return to program

'------------------------------------------------------------------------------
' Get a character from the buffer
GETBUF:										' Move the next character in buffer to bufchar
		INTCON = 0							' Disable interrupts while reading buffer
		Inc INDEX_OUT						' Increment index_out pointer (0 to 63)
		If INDEX_OUT >= BUFFER_SIZE Then INDEX_OUT = 0	' Reset pointer if outside buffer
		BUFCHAR = BUFFER[INDEX_OUT]			' Read buffer location(index_out)
		INTCON = %11000000					' Enable interrupts
		Return
'------------------------------------------------------------------------------
' Display an error
ERROR_DISP:									' Display error message
		INTCON = 0							' Disable interrupts while in the error routine
		If ERRFLAG.1 = 1 Then				' Determine the error
			Print at 2,1,"Buffer Overrun"	' Display buffer error on line-2
		Else
			Print at 2,1,"USART Overrun"	' Display usart error on line_2
		Endif
	
		Cursor 1,1							' Send the LCD cursor back to line-1 home
		For I = 2 To COL					' Loop for each column beyond 1
			Print $FE,$14					' Put the cursor back where it was
		Next
	
		ERRFLAG = 0							' Reset the error flag
		CREN = 0							' Disable continuous receive to clear hardware error
		CREN = 1							' Enable continuous receive
		INTCON = %11000000					' Enable interrupts

		Goto DISPLAY						' Carry on
'--------------------------------------------------------------------------------
' Main program loop starts here
Start:
		Cls									' Clear the LCD
' Initialise variables
		INDEX_IN = 0
		INDEX_OUT = 0
		COL = 1
		ERRFLAG = 0

		INTCON = %11000000					' Enable interrupts
		PIE1.5 = 1							' Enable interrupt on USART

LOOP:   
		High LED        					' Turn on LED connected to PORTD.0
		Delayms 500   						' Wait 500mS
		Low LED     						' Turn off LED connected to PORTD.0
		Delayms 500							' Wait another 500mS

DISPLAY:									' Send the buffer to the LCD
		If ERRFLAG = 1 Then ERROR_DISP		' Goto error routine if needed
		If INDEX_IN = INDEX_OUT Then LOOP	' Loop if nothing in buffer
		
		Gosub GETBUF						' Get a character from buffer	
		Print at 1,COL , BUFCHAR,at 2,1,Dec INDEX_OUT," : ",Dec INDEX_IN,"   " 	' Send the character to LCD
	
	
		Inc COL								' Increment LCD location
		If COL > 16 Then					' Check for end of line
			COL = 1							' Reset LCD location
			Print at 2,1,Rep " "\16,at 1,1	' Clear any error on line-2 of LCD, and return home
		EndIF

		GoTo DISPLAY						' Check for more characters in buffer




