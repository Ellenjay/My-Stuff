 NOLIST 
; RC5 infrared decoder
; Input		: None
; Output	: WREG or PP0 hold the BUTTON code
;			: PP0H holds the SYSTEM code
;			: PP1 holds the TOGGLE code. 1 or 0
;			: PP1 is optional and can be brought out to the main code if required
; Notes		: The CARRY flag (STATUS.0) is set upon return from the subroutine if any errors
;			: were detected in the bitstream
 LIST
rc5@in
	Bsf		(RC5IN#PORT + 12h),RC5IN#PIN ; Make IR sensor pin an input
	Clrf 	PP3H
	Clrf 	PP3
	Lfsr 	0,PP2						; Reset the indirect pointer back to the start of the buffer space
	Movlw 	1								
	Movwf 	PP0H
	Movlw 	186
	Call 	dlus@w						; Delayus 442
	Btfsc 	RC5IN#PORT,RC5IN#PIN		; Check RC5_DATA_IN signal, If it's high (logic 0), exit
	Bra 	rc5@extfalse				; And exit prematurely
rc5@LL7									; Create a loop for all the bits
	Movlw 	3
	Movwf 	PP0H
	Movlw 	118
	Call 	dlus@w						; Delayus 886
	Incf 	PP3H,F						; Increment the bit counter
	Movlw 	32							; See if we've done all 32 bits
	Cpfsgt 	PP3H
	Bra 	rc5@LL10
    Bra 	rc5@prse					; Jump to the parser
rc5@LL10
	Bsf 	STATUS,C					; Preset the carry bit
	Btfsc 	RC5IN#PORT,RC5IN#PIN		; Test RC5_DATA_IN
	Bcf 	STATUS,C
	Rlcf 	INDF0,F						; Rotate carry into the buffer
	Incf 	PP3,F
	Btfss 	PP3,3						; See if all 8 bits are filled
	Bra 	rc5@LL14
	Movf 	POSTINC0,F					; If Yes, use next buffer byte
	Clrf 	PP3
rc5@LL14
	Bra 	rc5@LL7						; Loop back & do the rest of the bits
   
rc5@prse    
    Lfsr 	0,PP2						; Put buffer start address into the FSR register
	Clrf 	GEN							; Initialise variables
	Clrf 	PP3
	Clrf 	PP1
	Clrf 	PP0H
	Clrf 	PP0
	Rlcf 	INDF0,F						; First bit into carry
	Rlcf 	GEN,F						; Put it into GEN for decoding
	Rlcf 	INDF0,F						; Second bit into carry
	Rlcf 	GEN,F						; Put it into GEN for decoding
	Incf 	PP3,F						; Start keeping track of INDF bit position
	RCall 	rc5@dcde
	Btfsc 	GPR,2						; Illegal pattern found ?
	Bra 	rc5@extfalse
	Clrf 	GEN							; Next one is the TOGGLE bit
	Rlcf 	INDF0,F						; First bit into carry
	Rlcf 	GEN,F						; Put it into GEN for decoding
	Rlcf 	INDF0,F						; Second bit into carry
	Rlcf 	GEN,F						; Put it into GEN for decoding
	Incf 	PP3,F						; keep track of INDF bit position
	RCall 	rc5@dcde
	Btfsc 	GPR,2						; Illegal pattern found ?
	Bra 	rc5@extfalse
	Rrcf 	GPR,F						; Put toggle bit into Carry
	Rlcf 	PP1,F						; Move it into PP1
	Movlw 	5
	Movwf 	GENH
rc5@sysrpt
	Clrf 	GEN
	Rlcf 	INDF0,F						; First bit into carry
	Rlcf 	GEN,F						; Put it into GEN for decoding
	Rlcf 	INDF0,F						; Second bit into carry
	Rlcf 	GEN,F						; Put it into GEN for decoding
	Incf 	PP3,F						; keep track of INDF bit position
	Btfss 	PP3,2						; (there are two rotates per count)
	Bra 	rc5@LL20
	Movf 	POSTINC0,F					; Go to next buffer byte when count=4
	Clrf 	PP3
rc5@LL20
	RCall 	rc5@dcde
	Btfsc 	GPR,2						; Illegal pattern found ?
	Bra 	rc5@extfalse
	Rrcf 	GPR,F						; Put bit into Carry
	Rlcf 	PP0H,F
	Decfsz 	GENH,F						; Have we done all 5 bits?
	Bra 	rc5@sysrpt
	Movlw 	6
	Movwf 	GENH
rc5@cmdrpt
	Clrf 	GEN
	Rlcf 	INDF0,F						; First bit into carry
	Rlcf 	GEN,F						; Put it into GEN for decoding
	Rlcf 	INDF0,F						; Second bit into carry
	Rlcf 	GEN,F						; Put it into GEN for decoding
	Incf 	PP3,F						; keep track of INDF bit position (there are two rotates per count)
	Btfss 	PP3,2
	Bra 	rc5@LL24
	Movf 	POSTINC0,F					; Go to next buffer byte when count = 4
	Clrf 	PP3
rc5@LL24
	RCall 	rc5@dcde
	Btfsc 	GPR,2						; Illegal pattern found ?
	Bra 	rc5@extfalse
	Rrcf 	GPR,F						; Put bit into Carry
	Rlcf 	PP0,F						; Move it into PP0
	Decfsz 	GENH,F						; Have we done all 6 bits?
	Bra 	rc5@cmdrpt
rc5@LL28
	Movf	PP0,W
    Bcf 	STATUS,C					; Clear the CARRY to indicate a good capture
	Return								; Finish here if Philips format
rc5@extfalse
	Setf	PP0
	Setf	PP0H
	Bsf 	STATUS,C					; Set the carry flag to show error
	Return								; And exit prematurely
 NOLIST
;------------------------------------------------
; DECODE .. Enter with two-bit data in GEN
;           return with result code in GPR.
;           GPR.0 = valid data, one or zero
;           GPR.1 = unused
;           GPR.2 = set if data is invalid
 LIST
rc5@dcde
	Clrf 	GPR							; Clear PARSE FLAGS before we start
	Decfsz 	GEN,W						; Compare to bit pattern '01'
	Bra 	rc5@LL2
	Bsf 	GPR,0						; Return with valid data in LSB
	Return
rc5@LL2
	Movlw 	2							; Compare to bit pattern '10'
	Cpfseq 	GEN
	Bra 	rc5@LL4
	Return
rc5@LL4
	Bsf 	GPR,2						; Bit pattern neither 01 nor 10
	Return
 LIST