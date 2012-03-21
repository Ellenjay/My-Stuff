' Assembler autobaud routine for 14-bit core devices
' To use it, simply call the subroutine AUTOBAUD
' and send a value $55, or $CC. 
' Register SPBRG will automatically be configured for
' the baud rate received.

' For use with the Hardware USART only.

' Notice the use of Assembler mnemonics without
' wrapping in ASM, ENDASM

		Include "PROTON_4.INC"
               
        Dim AB#TIME as Byte SYSTEM		' Use an obscure variable name
        
        Delayms 500						' Wait for PICmicro to stabilise
        Cls								' Clear the LCD
		Goto OVER_SUBROUTINES			' Jump over the Autobaud subroutine
        
'----------------------------------------------------------------------------
'
' ___	 ______            ________
'    \__/	   \__________/
'       |                  |
'       |-------- p -------|
'
' p = The number of instructions between the first and last
' rising edge of the RS232 control sequence 0x0F. 
' Other possible control sequences are 0x01, 0x03, 0x07, 0x1F, 0x3F (ASCII code for character '?'), 0x7F.
'
'	SPBRG = (p / 32) - 1  	BRGH = 1
										
AUTOBAUD:
		Bcf		STATUS,RP1									
		Bsf		STATUS,RP0		' Point to BANK 1					
		Movlw	%00000011							
		Movwf	OPTION_REG		' 1:16 Prescale
        Bsf		TRISC,7			' RX pin to input							
		Bcf		STATUS,RP0		' Back to BANK 0						
		Bcf		RCSTA,CREN							
						
 		Btfsc	PORTC,7			' Wait for a falling edge		
		#ifdef WATCHDOG_REQ		' Do we need the WATCHDOG reset?
        	Clrwdt
            Jump	$ - 2
        #else      
        	Jump	$ - 1								
		#endif
        Btfss	PORTC,7			' Wait for starting edge		
		#ifdef WATCHDOG_REQ
        	Clrwdt
            Jump	$ - 2
        #else      
        	Jump	$ - 1								
		#endif
    
		Clrf	TMR0			' Start counting			

 		Btfsc	PORTC,7			' Wait for a falling edge		
		#ifdef WATCHDOG_REQ		' Do we need the WATCHDOG reset ?
        	Clrwdt
            Jump	$ - 2
        #else      
        	Jump	$ - 1								
		#endif							
		Btfss	PORTC,7			' Wait for starting edge		
		#ifdef WATCHDOG_REQ		' Do we need the WATCHDOG reset ?
        	Clrwdt
            Jump	$ - 2
        #else      
        	Jump	$ - 1								
		#endif						

		Movfw	TMR0			' Read the timer			
		Movwf	AB#TIME			' Save the value					
		Clrc
		Rrf		AB#TIME,W							
		Skpc					' Rounding				
		Addlw	255								

		Bsf		STATUS,RP0		' Point ot BANK 1						
		Movwf	SPBRG			' Set the BAUD					
		Bcf		STATUS,RP0		' Back to BANK 0						
		Bsf		RCSTA,CREN		' Enable receive			
		Movfw	RCREG							
		Movfw	RCREG			' Clear the USART buffer							
		Bsf		STATUS,RP0		' Point to BANK 1													
		Clrf	OPTION_REG		' Back to normal
        Bcf		STATUS,RP0		' Back to BANK 0	
        Return
        
'-----------------------------------------------------------------------
OVER_SUBROUTINES:
		
		Gosub AUTOBAUD					' Adjust the baud rate
        HSERIN [DEC2 AB#TIME]			' Receive 2 decimal characters
        Print at 1,1,DEC AB#TIME , "  "	' Display the characters received
        Stop							
