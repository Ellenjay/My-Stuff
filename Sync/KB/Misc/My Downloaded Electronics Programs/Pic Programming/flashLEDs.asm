;**********************************************************************
;
;    Filename:	    flashLEDs.asm
;    Date:          $Date: 2003/03/05 01:33:04 $
;    File Version:  $Id: flashLEDs.asm,v 1.1 2003/03/05 01:33:04 jerry Exp $
;                   $Source: /home/cvsroot/projectsTop/picProjectBoard/examples/mplab_example/flashLEDs.asm,v $
;    Author:        Jerry Dunmire
;
;**********************************************************************
;
;    Notes:
;
;    This program will flash the 4 discrete LEDs on the ECPE5 PIC
;    project board. The pattern will be 0x5, 0xA at 5 Hz rate.
;
;    See the ATTENTION and WARNING notes embedded below!
;
;**********************************************************************


	list      p=16f877            ; list directive to define processor
	#include <p16f877.inc>        ; processor specific variable definitions
	
         ; '__CONFIG' directive is used to embed configuration data within
         ; .asm file.  The labels following the directive are from the
         ; p16f877.inc file.
         ;
         ; ATTENTION! This config setting is ignored when the file is
         ;            loaded with WLoader.  
         ;
         ;       BUT! XWisp crashes when it attempts to set the config
         ;            register. Apparently WLoader does not return a
         ;            response that XWisp understands. The program is
         ;            successfully loaded, but the 16F877 is still in
         ;            program mode (WLoader running) until you remove
         ;            the serial cable and press the reset button.
         ;            You will have to completely exit XWisp and
         ;            restart.
         ;
         ; WARNING!   So since this program is intended for use with
         ;            the ECEP5 PIC Project board using WLoader, the
         ;            config setting below is commented out. If you
         ;            try to use this program with another PIC programmer
         ;            you will almost certainly have to un-comment this
         ;            line (unless your programmer allows a manual
         ;            config setting).
         ;
         ; WARNING!   The config value below is the default value
         ;            from the template file Microchip provided with
         ;            v6.10 of the PIC IDE. I have not checked the
         ;            values to see if they are correct for this
         ;            program.

;	__CONFIG _CP_OFF & _WDT_ON & _BODEN_ON & _PWRTE_ON & _RC_OSC & _WRT_ENABLE_ON & _LVP_ON & _DEBUG_OFF & _CPD_OFF 


;***** VARIABLE DEFINITIONS
w_temp        EQU     0x70        ; variable used for context saving 
status_temp   EQU     0x71        ; variable used for context saving

;**********************************************************************
;
; Start vector
;
; ATTENTION!
;   For use with WLoader, it is important that the first
;   instruction at 0x000 be a goto statement. WLoader will relocate that
;   goto statement and use it to start the program. The actual goto
;   statement at 0x000 is a jump to the WLoader program.
;
;   The template file (f877temp.asm) provided by Microchip starts
;   with the 'clrf PCLATH' command (which is commented out below).
;   My reading of the 16F877 data sheet indicates the PCLATH register
;   is cleared on power-on or software reset,so I'm not sure why
;   the template includes the clrf PCLATH command. Anyway, a 'clrf
;   PCLATH command is incompatible with WLoader.
;

	ORG     0x000             ; processor reset vector
  	goto    main              ; go to beginning of program


;**********************************************************************
;
; Interrupt handler
;
; Simply invert the value in port C and clear the interrupt flag.
; The W register doesn't really need saved for this code, but
; it probably would for most ISRs- so leave the save/restore W
; code in place as starting point for other ISRs
;
	ORG     0x004             ; interrupt vector location
	movwf   w_temp            ; save off current W register contents
	movf	STATUS,w          ; move status register into W register
	movwf	status_temp       ; save off contents of STATUS register

        comf    PORTC, f
        bcf     PIR1, 0           ; clear the TIMER0 interrupt flag

	movf    status_temp,w     ; retrieve copy of STATUS register
	movwf	STATUS            ; restore pre-isr STATUS register contents
	swapf   w_temp,f
	swapf   w_temp,w          ; restore pre-isr W register contents
	retfie                    ; return from interrupt


;**********************************************************************
; Main code section
;
; An initial value is written to the port C (the low 4 bits control the
; LEDs). Then each time Timer 0 overflows an interrupt will be generated.
; The interrupt service routine will inverte the value in port C causing
; LEDs that were on to turn off and visa versa.
;
; By using the largest prescaler setting for Timer 1 (1:8) the period
; between interrupts will be:
;     Fosc   = 20MHz
;     Fosc/4 = 5MHz  = prescaler_clock
;     prescaler_clock/8 = 625000 Hz = clock
;
;     period = 1 / (clock/(2^16)) = 1 / (625000 / 65536) = ~104.9 ms
;
main
        ; Setup port C output lines and set and intial output value
        bcf	STATUS, RP0
	bsf     STATUS, RP0     ; select bank 1 to get at the TRISC register
	clrf	TRISC
	bcf     STATUS, RP0     ; PORTC and T1CON (below) are in bank 0
	movlw   0x05
	movwf	PORTC

        ; setup timer 0
        movlw   B'00110001'
                ; |||||||+--  1 = start timer
                ; ||||||+---  0 = internal clock (Fosc/4) = 5MHz for our board
                ; |||||+----  x = ignored for internal clock
                ; ||||+-----  0 = Timer1 external OSC disabled
                ; ||++------ 11 = 1:8 Prescaler (clock = 5MHz / 8)
                ; ++-------- xx = unimplemented
        movwf   T1CON

        ; Enable Timer1 overflow interrupt
	bsf     STATUS, RP0     ; PIE1 is in bank 1
        movlw   B'00000001'
                ; |||||||+--  1 = Timer1 overflow interrupt enabled (TMR1F)
                ; ||||||+---  0 = TMR2 to PR2 match interrupt disabled
                ; |||||+----  0 = CCP1 interrupt disabled
                ; ||||+-----  0 = SSP interrupt disabled
                ; |||+------  0 = USART xmit interrupt disabled
                ; ||+-------  0 = USART recv interrupt disabled
                ; |+--------  0 = A/D Converter interrupt disabled
                ; +---------  0 = Parallel port r/w interrupt disabled
        movwf   PIE1
	bcf     STATUS, RP0     ; return to bank 0 to set INTCON

        ; INTCON setup
        movlw   B'11000000'
                ; |||||||+--  0 = Port B change interrupt flag clear
                ; ||||||+---  0 = RB0/INT flag clear
                ; |||||+----  0 = Timer0 overflow interrupt flag clear
                ; ||||+-----  0 = Port B change interrupt disabled
                ; |||+------  0 = RB0/INT interrupt disabled
                ; ||+-------  0 = Timer0 overflow interrupt disabled 
                ; |+--------  1 = Peripheral Interrupts enabled
                ; +---------  1 = All (global) interrupts enabled
        movwf   INTCON

        ; sleep - can't use the sleep command because it
        ; will turn off the main oscillator that we are using
        ; for the timer!
        ;
        ; Instead we'll just waste time (and power) doing nothing.
wait    nop
        goto wait

	END                       ; directive 'end of program'
