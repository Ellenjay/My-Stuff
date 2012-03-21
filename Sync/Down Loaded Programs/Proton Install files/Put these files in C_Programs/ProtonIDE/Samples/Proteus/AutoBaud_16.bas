' Assembler autobaud routine for 16-bit core devices
' To use it, simply call the subroutine AUTOBAUD
' and send a value $55, or $CC. 
' Register SPBRG will automatically be configured for
' the baud rate received.

' For use with the Hardware USART only.

' Notice the use of Assembler mnemonics without
' wrapping in ASM, ENDASM

		Include "PROTON18_4.INC"
               
        Dim AB#TIME as Byte SYSTEM		' Use an obscure variable name

        Delayms 500						' Wait for PICmicro to stabilise
        Cls								' Clear the LCD
		Goto OVER_SUBROUTINES			' Jump over the Autobaud subroutine
        
' -------------------------------------------------------------------------
AUTOBAUD:
'
' ___	 ______            ________
'    \__/	   \__________/
'       |                  |
'       |-------- p -------|
'
' p = The number of instructions between the first and last
' rising edge of the RS232 control sequence 0x0F. 
' Other possible control sequences are 0x01, 0x03, 0x07, 0x1F, 0x3F, 0x7F.
'
'	SPBRG = (p / 32) - 1  	BRGH = 1
										
		Bcf		RCSTA,CREN			' Disable receiving
		Movlw	%00000011			' 1:16 Prescale
		Movwf	T0CON
		Clrf	TMR0H				' Reset timer
		Clrf	TMR0L
		Btfsc	PORTC,7				' Wait for a falling edge
		#ifdef WATCHDOG_REQ
        	Clrwdt
            Bra	$ - 4
        #else      
        	Bra	$ - 2								
		#endif
		Btfss	PORTC,7				' Wait for starting edge
		#ifdef WATCHDOG_REQ			' Do we need the WATCHDOG reset ?
        	Clrwdt
            Bra	$ - 4
        #else      
        	Bra	$ - 2								
		#endif
		Bsf		T0CON, TMR0ON		' Start counting
		Btfsc	PORTC,7				' Wait for a falling edge
		#ifdef WATCHDOG_REQ			' Do we need the WATCHDOG reset ?
        	Clrwdt
            Bra	$ - 4
        #else      
        	bra	$ - 2								
		#endif
		Btfss	PORTC,7				' Wait for starting edge
		#ifdef WATCHDOG_REQ			' Do we need the WATCHDOG reset ?
        	Clrwdt
            Bra	$ - 4
        #else      
        	Bra	$ - 2								
		#endif
		Bcf		T0CON,TMR0ON		' Stop counting
		Movff	TMR0L,AB#TIME		' Read the timer	
		Rrcf	TMR0H,f				' divide by 2
		Rrcf	AB#TIME,f
		Skpc						' Rounding
		Decf	AB#TIME,f
		Movff	AB#TIME,SPBRG		' Set the BAUD
		Bsf		RCSTA,CREN			' Enable receiving
		Movfw	RCREG				' Empty the USART buffer
		Movfw	RCREG	
        Clrf	T0CON				' Back to normal						
		Return
        
'-----------------------------------------------------------------------
OVER_SUBROUTINES:
		
        Gosub AUTOBAUD					' Adjust the baud rate
        HSERIN [DEC2 AB#TIME]			' Receive 2 decimal characters
        Print at 1,1,DEC AB#TIME , "  "	' Display the characters received
        Stop        
        
