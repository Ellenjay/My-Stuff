' This program demonstrates basic functionality of the USART.
' PORTD is connected to 8 LEDs. 
' When the PIC18F452 receives a byte of data from
' the USART, the value is displayed on the LEDs and
' is retransmitted to the host computer.
'
' Set serial terminal program to 9600 baud, 1 stop bit, no parity

		Device = 18F452
    	XTAL = 4

		Symbol TXEN = TXSTA.5
		Symbol BRGH = TXSTA.2
	
		Symbol SPEN = RCSTA.7
		Symbol CREN = RCSTA.4

		Symbol RCIF = PIR1.5
		Symbol RCIE = PIE1.5
		Symbol PEIE = INTCON.6
		Symbol GIE = INTCON.7
        
' DECLARE INTERRUPT VECTOR
		ON_INTERRUPT GOTO INTVECTOR		' Point to the HIGH priority interrupt subroutine

		Goto OVER_INTERRUPTS			' Jump over the interrupt subroutine
'---------------------------------------------------------------------------
' Interrupt Service Routine
INTVECTOR:
		Btfss 	RCIF			' Did USART cause interrupt?
		Bra		OTHERINT		' No, some other interrupt
		Movlw	6				' Mask out unwanted bits
		Andwf	RCSTA,W			' Check for errors
		Bnz		RCVERROR		' Was either error status bit set?
		Movfw	RCREG			' Get input data
		Movwf	PORTD			' Display on LEDs
		Movwf	TXREG			' Echo character back
		Retfie	Fast			' Exit interrupt. Restoring WREG, STATUS and BSR registers	
RCVERROR:
		Bcf		CREN			' Clear receiver status
		Bsf		CREN			
		PORTD = 255				' Light all LEDs
		Retfie	Fast			' Exit interrupt. Restoring WREG, STATUS and BSR registers
OTHERINT:
		Bra	$					' Find cause of interrupt and service it before returning from
								' interrupt. If not, the same interrupt will re-occur as soon
								' as execution returns to interrupted program.
'---------------------------------------------------------------------------
' MAIN PROGRAM BEGINS HERE
OVER_INTERRUPTS:
		Clear LATD				' Clear PORTD output latches
		Output PORTD 			' Config PORTD as all outputs
		Output PORTC.6			' Make RC6 an output

		SPBRG = $19 			' 9600 baud at 4MHz
	
		Set TXEN				' Enable transmit
		Set BRGH				' Select high baud rate	
		Set SPEN				' Enable Serial Port
		Set CREN				' Enable continuous reception
		Clear RCIF				' Clear RCIF Interrupt Flag
		Set RCIE				' Set RCIE Interrupt Enable
		Set PEIE				' Enable peripheral interrupts
		Set GIE					' Enable global interrupts

INF: 	Goto 	INF				' Loop to self doing nothing




