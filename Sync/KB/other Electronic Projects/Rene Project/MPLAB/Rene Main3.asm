;------------------------------------------------------------------- 
; 
; Binary-to-BCD.  Written by John Payson. 
; 
; Enter with 16-bit binary number in NumH:NumL. 
; Exits with BCD equivalent in TenK:Thou:Hund:Tens:Ones. 
; 
	LIST P=16F628, R=DEC   ; Use the PIC16F628 and Hexidecimal system 
	#include "P16F628.INC"  ; Include header file 
	__config  _INTRC_OSC_NOCLKOUT & _LVP_OFF & _WDT_OFF & _PWRTE_ON & _BODEN_ON 	
	
	
	CBLOCK 0x20   
		NumH,NumL
		counter:2	
		TenK,Thou,Hund,Tens,Ones
		DiC,BiC,BitCount,DigitCount
		Scaler
        Counter1
        Counter2	
		CountA
		CountB
		CountC
	endc
  
; 
; ----------- 
; INITIALIZE 
; ----------- 
; 
        ORG    0x000           	; Program starts at 0x000 
		Call LDelay				; a delay to allow chips to stabalize
        CLRF   PORTA           	; Initialize port A 
        CLRF   PORTB           	; Initialize port B 
		BSF    STATUS,RP0      	; RAM bank 1 
        MOVLW	0X05			;set pins RA0 and Ra2 to inputs 
        MOVWF	TRISA			;all other PortA pins to output
        CLRF   TRISB           	; All pins port B output 
		BSF		TRISB,2
		BCF    STATUS,RP0      	; RAM bank 0 
		       
        
; 
; ----------- 
; Main Program 
; ----------- 
;        
               
Start  	CLRF	NumH
		CLRF	NumL 
		Call 	InitDeltaSigA2D
        Call	DeltaSigA2D
        Call 	Convert
        
        movlw	0x25	;set Indirect Address to
        movwf	FSR		;Thou Place
        movlw	4		;set counter to number 
		movwf	DiC		;of digits of converted number
		movlw	0					;Set top of digits
		movwf	DigitCount			;to be displayed (0 =0 to 3 and 4 = 4 to 7)
		Call	Display
		
		CLRF	NumH
		CLRF	NumL 
		Call	GetTemp
		Call	Convert
		movlw	0x25	;set Indirect Address to
        movwf	FSR		;Thou Place
        movlw	4		;set counter to number 
		movwf	DiC		;of digits of converted number
		movlw	4					;Set top of digits
		movwf	DigitCount			;to be displayed (0 =0 to 3 and 4 = 4 to 7)
		Call	Display	
		Goto	Start


;--- END Main Program -------


;----------------
;GET TEMP Routine
;----------------
GetTemp	
			Call Flash
			; Here we would normally read first bit and it should be zero
			
			Call GetNextBit
			BTFSC	PORTB,2
			BSF		NumH,3
			Call GetNextBit
			BTFSC	PORTB,2
			BSF		NumH,2
			Call GetNextBit
			BTFSC	PORTB,2
			BSF		NumH,1
			Call GetNextBit
			BTFSC	PORTB,2
			BSF		NumH,0
			Call GetNextBit
			BTFSC	PORTB,2
			BSF		NumL,7
			Call GetNextBit
			BTFSC	PORTB,2
			BSF		NumL,6
			Call GetNextBit
			BTFSC	PORTB,2
			BSF		NumL,5
			Call GetNextBit
			BTFSC	PORTB,2
			BSF		NumL,4
			Call GetNextBit
			BTFSC	PORTB,2
			BSF		NumL,3
			Call GetNextBit
			BTFSC	PORTB,2
			BSF		NumL,2
			Call GetNextBit
			BTFSC	PORTB,2
			BSF		NumL,1
			Call GetNextBit
			BTFSC	PORTB,2
			BSF		NumL,0	
			; here we would read the next bit for an open thermocouple
		
			BCF		STATUS,0	;divide the Low and
			RRF		NumH,1		;high parts of
			RRF		NumL,1		;4 (Shift both twice)
			BCF		STATUS,0	
			RRF		NumH,1		
			RRF		NumL,1
			Return					
			
			
			
										
;--------------
;GetNextBit Routine
;--------------

GetNextBit	
			Call SDelay
			BSF		PORTB,1 ; Clock High
			Call	SDelay
			BCF		PORTB,1	; Clock low again and ready to read TEMP bit
			Return
				
;* InitDeltaSigA2D sets up the voltage reference and comparator
;* in the "idle" state.

InitDeltaSigA2D
		bsf 	STATUS,RP0
		movlw 	0xEC 		;set voltage reference on with 
		movwf 	VRCON		; Voltage reference output on RA2 pin (Low Range)
		bcf 	PORTA,3 	;set comparator pin to output
		bcf 	STATUS,RP0
		movlw 	0x06 		;set up for 2 analog comparators with 
		movwf 	CMCON		;common reference
		return
;---END InitDeltaSigA2D------------


; Delta Sigma A2D
; The code below contains a lot of nops and goto next instruction. These
; are necessary to ensure that each pass through the loop takes the same
; amount of time, no matter the path through the code.
;
DeltaSigA2D
	clrf 	counter
	clrf 	counter+1
	clrf 	NumL
	clrf 	NumH
	movlw 	0x03 			; set up for 2 analog comparators with common reference
	movwf 	CMCON
loop
	btfsc 	CMCON,C1OUT 	; Is comparator high or low?
	goto 	complow 		; Go the low route
comphigh
	nop 					; necessary to keep timing even
	bcf 	PORTA,3 		; PORTA.3 = 0
	incfsz 	NumL,f 		; bump counter
	goto 	eat2cycles 
	incf 	NumH,f 
	goto 	endloop 
complow
	bsf 	PORTA,3 		; Comparator is low
	nop 					; necessary to keep timing even
	goto eat2cycles 			; same here
eat2cycles
	goto 	endloop 		; eat 2 more cycles
endloop
	incfsz 	counter,f 		; Count this lap through the loop.
	goto 	eat5cycles 
	incf 	counter+1,f 
	movf 	counter+1,w 
	andlw 	0x04 			; Are we done? (We're done when bit2 of
	btfsc 	STATUS,Z 		; the high order byte overflows to 1).
	goto 	loop 
	goto 	exit
eat5cycles
	goto 	$+1 			; more wasted time to keep the loops even
	nop ;
	goto loop 
exit
	movlw 	0x06 			; set up for 2 analog comparators with common reference
	movwf 	CMCON

	return
;---END Delta Sigma A2D-------------

;---Display Routine------
Display		movf	INDF,0 		;Get Current digit fron Indirect Address
			movwf	BiC			; and place it in variable BiC		
			Call	Shift		
			BSF		PORTB,6		;Set B-enable Bit
			Call 	LDelay
			BCF		PORTB,6		;Clear the B-enable BIT
			Call	LDelay		
			BCF		DigitCount,3		;Clear hold bit for digit Display		
			Call	SetDigit		
			BSF		DigitCount,3		;Set hold bit for digit display		
			Call	SetDigit			
			incf	DigitCount,1
			incf	FSR,1				;Get next Digit
			decfsz	DiC,1	;are we finished?
			goto	Display			; if not, then do another digit
        	Return
;---END of Display-----------


;-----Set Digit Routine---

SetDigit		movf	DigitCount,0 		;Get digit to be displayed
				movwf	BiC			; and place it in variable BiC
				Call 	Shift
				BCF		PORTB,7		;Clear D-enable Bit
				Call 	LDelay
				BSF		PORTB,7		;Set the D-enable BIT
				Call	LDelay
				Return

;----END Set Digit Routine---


;---Shift Routine---        
		
Shift	
		swapf	BiC,1		; Move Lower bits to HIGH position
		MOVLW	4			;Place the count of 4 into
		MOVWF	BitCount	;variable BitCount
LP1		BCF		PORTB,4		;Clear PortB, pin 4
		RLF		BiC,1		;Rotate Bic through Carry
		BTFSC	STATUS,C	;check the carry for a '1'
		BSF		PORTB,4		; and set the PortB, pin 4 if the carry is a 1
		BSF		PORTB,5		;Set shift Bit
		Call 	LDelay
		BCF		PORTB,5		;Clear the shift BIT
		Call	LDelay
		DECFSZ	BitCount,1	;dec the bit count	
		GoTo	LP1			; get next bit if count is not zero
		Return
	
;---END of Shift Routine---		
	

;--- 1 Millisec Delay----

SDelay     		MOVLW 0F9h          ;put 249 into W          
             	NOP
SDL   			ADDLW 0FFh          ;This is effectively subtracting 1 from W
             	BTFSS 03,2            ;Look at the zero bit of the Status register. Skip when Zero bit is SET.
             	GOTO SDL
             	RETURN 
;--- END 1 MilliSec Delay---	

	
;----- 250 Millisec Delay--- 

LDelay  	MOVLW 003H          ;put 249 into W          
        	NOP
LDL  		ADDLW 0FFh          ;This is effectively subtracting 1 from W
        	BTFSS 03,2            ;Look at the zero bit of the Status register. Skip when Zero bit is SET.
        	GOTO LDL
        	RETURN 	

;---END 250 Millisec Delay-----
    		
;--- Flash Delay----------   		
    		
SLDelay    	MOVLW 1h        ;Set Number for deley  
            MOVWF CountC  
Delay1      DECFSZ CountA,1  
            GOTO Delay1  
            DECFSZ CountB,1  
            GOTO Delay1  
            DECFSZ CountC,1  
            GOTO Delay1  
            RETURN 
;-----END 2 Sec Delay-----------

;----Led Flash Routine------
Flash    BSF    PORTA,6       ; Turn on LED 
        CALL    SLDelay 
        BCF     PORTA,6       ; Turn off LED  
        CALL    SLDelay 
        Return

;-----Convert Routine-----
 
Convert                      
        swapf   NumH,w 				;Takes number in NumH:NumL 
 		andlw   0x0F  				; Returns decimal in 
 		addlw   0xF0				; TenK:Thou:Hund:Tens:Ones             
        movwf   Thou 
        addwf   Thou,f 
        addlw   0xE2 
        movwf   Hund 
        addlw   0x32 
        movwf   Ones 

        movf    NumH,w 
        andlw   0x0F 
        addwf   Hund,f 
        addwf   Hund,f 
        addwf   Ones,f 
        addlw   0xE9 
        movwf   Tens 
        addwf   Tens,f 
        addwf   Tens,f 

        swapf   NumL,w 
        andlw   0x0F 
        addwf   Tens,f 
        addwf   Ones,f 

        rlf     Tens,f 
        rlf     Ones,f 
        comf    Ones,f 
        rlf     Ones,f 

        movf    NumL,w 
        andlw   0x0F 
        addwf   Ones,f 
        rlf     Thou,f 

        movlw   0x07 
        movwf   TenK 

                        ; At this point, the original number is 
                        ; equal to TenK*10000+Thou*1000+Hund*100+Tens*10+Ones 
                        ; if those entities are regarded as two's compliment 
                        ; binary.  To be precise, all of them are negative 
                        ; except TenK.  Now the number needs to be normal- 
                        ; ized, but this can all be done with simple byte 
                        ; arithmetic. 

        movlw   0x0A     ; Ten 
Lb1 
        addwf   Ones,f 
        decf    Tens,f 
        btfss   3,0 
         goto   Lb1 
Lb2 
        addwf   Tens,f 
        decf    Hund,f 
        btfss   3,0 
         goto   Lb2 
Lb3 
        addwf   Hund,f 
        decf    Thou,f 
        btfss   3,0 
         goto   Lb3 
Lb4 
        addwf   Thou,f 
        decf    TenK,f 
        btfss   3,0 
         goto   Lb4 

        retlw   0
		END
;-----------------------
;End of Convert Routine
;-----------------------
