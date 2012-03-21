 NOLIST
;
; Sony (SIRC) remote control decoder subroutine
;
 NOLIST
if(XTAL == 3)
 LIST
HEADER@LOW = 178
HEADER@HIGH = 241
BIT@LENGTH = 80
 NOLIST	
endif
 NOLIST
if(XTAL == 4)
 LIST
HEADER@LOW = 200
HEADER@HIGH = 270
BIT@LENGTH = 90
 NOLIST	
endif
 NOLIST
if(XTAL == 8)
 LIST
HEADER@LOW = 400
HEADER@HIGH = 539
BIT@LENGTH = 179
 NOLIST	
endif
 NOLIST
if(XTAL == 10)
 LIST
HEADER@LOW = 499
HEADER@HIGH = 675
BIT@LENGTH = 224
 NOLIST	
endif
 NOLIST
if(XTAL == 12)
 LIST
HEADER@LOW = 600
HEADER@HIGH = 810
BIT@LENGTH = 270
 NOLIST	
endif
 NOLIST
if(XTAL == 14)
 LIST
HEADER@LOW = 715
HEADER@HIGH = 966
BIT@LENGTH = 322
 NOLIST	
endif
 NOLIST
if(XTAL == 16)
 LIST
HEADER@LOW = 800
HEADER@HIGH = 1079
BIT@LENGTH = 360
 NOLIST	
endif
 NOLIST
if(XTAL == 20)
 LIST
HEADER@LOW = 1000
HEADER@HIGH = 1350 
BIT@LENGTH = 450
 NOLIST	
endif
 NOLIST
if(XTAL == 24)
 LIST
HEADER@LOW = 1200
HEADER@HIGH = 1620
BIT@LENGTH = 539
 NOLIST	
endif
 NOLIST
if(XTAL == 32)
 LIST
HEADER@LOW = 1600
HEADER@HIGH = 2160
BIT@LENGTH = 719
 NOLIST	
endif
 NOLIST
if(XTAL == 40)
 LIST
HEADER@LOW = 2000
HEADER@HIGH = 2699
BIT@LENGTH = 899
 NOLIST	
endif
 NOLIST
if(XTAL == 48)
 LIST
HEADER@LOW = 2400
HEADER@HIGH = 3240
BIT@LENGTH = 1078
 NOLIST	
endif
 LIST
SNY@IN:
	Clrf 	PP0	
	Movlw 	SONYIN#PORT
	Movwf 	GEN
	Movlw 	(1 << SONYIN#PIN)
	Movwf 	GENH
	Call 	p@in						; Call the PULSIN subroutine   
	Movlw 	HEADER@LOW & 255
	Subwf 	PP0,W
	Movlw 	(HEADER@LOW >> 8) & 255
	Subwfb 	PP0H,W
	Bnc 	snyin@LL7
	Movlw 	HEADER@HIGH & 255
	Subwf 	PP0,W
	Movlw 	(HEADER@HIGH >> 8) & 255
	Subwfb 	PP0H,W
	Bnc 	snyin@LL6
snyin@LL7
	Setf 	PP0H
	Setf 	PP0  
	Bra 	ext@snyin    
snyin@LL6
; Implement a loop for the 12 bits
	Movlw 	11
	Movwf 	GPR
snyin@rpt
;  Default to a clear bit (zero-bit)
	Bcf 	PP2H,3
	Clrf 	PP0
	Call 	p@in						; Call the PULSIN subroutine
	Movlw 	BIT@LENGTH & 255
	Subwf 	PP0,W
	Movlw 	(BIT@LENGTH >> 8) & 255
	Subwfb 	PP0H,W
	Btfsc	STATUS,C
	Bsf 	PP2H,3
	Bcf		STATUS,C					; Shift the bits right 1 place
	Rrcf 	PP2H,F
	Rrcf 	PP2,F	
	Decfsz 	GPR,F						; Close the loop after 12 bits
	Bra 	snyin@rpt	
	Movlw 	127							; Mask the BUTTON bits
	Andwf 	PP2,W
	Movwf 	PP0
	Bcf		STATUS,C					; Move bit 7 into bit 8
	Rlcf 	PP2,F
	Rlcf 	PP2H,W
	Andlw	31							; PP0H = PP2H & %00011111
	Movwf 	PP0H	
ext@snyin
	Movf 	PP0,W						; Transfer PP0 into WREG before returning
	Return
 LIST