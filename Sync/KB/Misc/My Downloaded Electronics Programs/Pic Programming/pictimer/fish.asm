	list p=16f628
	#include <p16f628.inc>

	__CONFIG	_BODEN_OFF & _CP_OFF & _DATA_CP_OFF &_PWRTE_OFF & _WDT_OFF & _LVP_OFF & _MCLRE_OFF & _XT_OSC

; Frequency 4MHz

;--------------------------------------------------------------------------
	;Macro - used for saving data to shift register
MOVE_BIT MACRO	
    BSF   MEM_PORTA, 01h
    MOVF  MEM_PORTA, W
    MOVWF PORTA			; set bit
    IORLW 01h			; set raising edge
    MOVWF PORTA
	ANDLW 0feh			; set failing edge
    MOVWF PORTA
	BCF   MEM_PORTA, 01h; clear data bit
	MOVF  MEM_PORTA, W
    MOVWF PORTA
	ENDM

;--------------------------------------------------------------------------
;IO bits
PIN_LED_CLOCK	EQU		01h	;	RA0 (pin 17)  - clock for CD4015
PIN_LED_DATA	EQU		02h	; 	RA1 (pin 18)  - data for CD4015

PIN_RX			EQU  	02h ;	RB1 (pin 7)   - RS232 RX
PIN_TX			EQU		03h ;   RB2 (pin 8)   - RS232 TX

PIN_INPUT_KEY	EQU 	04h	;	RA4 (pin 3)   - Input line from 4 keys

PIN_LED1		EQU		07h	;	RB7 (pin 13)  - high-lewel switch for 1st digit, used for keyboard too - increment hours
PIN_LED2		EQU		06h	;	RB6 (pin 12)  - high-lewel switch for 2nd digit, used for keyboard too - increment minutes
PIN_LED3		EQU 	05h	;	RB5 (pin 11)  - high-lewel switch for 3rd digit, used for keyboard too - sets ON time for output switch 
PIN_LED4		EQU		04h	;	RB4 (pin 10)  - high-lewel switch for 4th digit, used for keyboard too - sets OFF time for output switch 

PIN_INPUT		EQU		04h ;   keyboard pin
PIN_HOUR		EQU		07h ;	pin to increment hours
PIN_MIN			EQU		06h	;	pin to increment minutes
PIN_PROG_ON		EQU		05h ;	pin to program ON time
PIN_PROG_OFF	EQU		04h ;	pin to program OFF time

PIN_SWITCH		EQU		03h	;	RB3 (pin 9)   - output pin - to relay on/off
;--------------------------------------------------------------------------

MODE_CLOCK		EQU		07h
MODE_CLOCK_PROG EQU		06h
MODE_PROG_ON	EQU		05h
MODE_PROG_OFF	EQU		04h

MS_DELAY		EQU		06h
;--------------------------------------------------------------------------
;Memory data allocation
MEM_LABEL_ERR	EQU 020h		; 4 bytes with values to indicate 'Eror'
MEM_LABEL_STOP  EQU 024h		; 4 bytes with values to indicate 'Stop'
MEM_LABEL_CLOCK EQU 028h		; 4 bytes with values to indicate 'Cloc'
MEM_LABEL_CLOCK_PROG EQU 02ch   ; 4 bytes with values to indicate 'PrOg'
MEM_LABEL_PROG_ON EQU 030h		; 4 bytes with values to indicate 'PrOn'
MEM_LABEL_PROG_OFF EQU 034h		; 4 bytes with values to indicate 'PrOF'

MEM_LAST_KB		EQU	038h
MEM_MODE_COUNT	EQU 039h
MEM_MODE		EQU	03Ah

MEM_TIME_ON		EQU 060h		; this is time when turn output switch ON - occupies 4 consecutive registers 
								; format: tens of hours, ones of hours, tens of minutes, ones of minutes
MEM_TIME_OFF	EQU 064h		; this is time when turn output switch OFF - occupies 4 consecutive registers 
								; format: tens of hours, ones of hours, tens of minutes, ones of minutes
MEM_CLOCK		EQU 068h		; this is current clock time - occupies 6 (not 4!) consecutive registers
								; format: tens of hours, ones of hours, tens of minutes, ones of minutes,
								; tens of seconds, ones of seconds
MEM_MS			EQU 06Eh		; number of 4ms interrupts passed - when 250 interrupts passed clock is incremented and action
								; is taken if set for the time
MEM_CYCLE		EQU 06Fh		; current cycle - 1 bit rolls through in 4 higher bits (04..07 bits) every interrupt (4 ms),
								; which is used for dynamical LED switching and for keyboard input (4 keys)

MEM_LED1		EQU 070h		; copy of the 7-segment LED's segments including dot. 'a' segments corresponds to most significant bit
MEM_LED2		EQU 071h		; copy of the 7-segment LED's segments including dot. 'a' segments corresponds to most significant bit
MEM_LED3		EQU 072h		; copy of the 7-segment LED's segments including dot. 'a' segments corresponds to most significant bit
MEM_LED4		EQU 073h		; copy of the 7-segment LED's segments including dot. 'a' segments corresponds to most significant bit

MEM_LED			EQU 074h		; segments of current LED to be displayed

MEM_KB			EQU 075h		; last state of the keyboard 
MEM_DELAY		EQU	076h		; keyboard delay
MEM_TEMP		EQU 077h		; temporary register

MEM_PORTA		EQU 07Ch		; copy of the PORTA to be written out
MEM_PORTB		EQU 07Dh		; copy of the PORTB to be written out
MEM_STATUS		EQU 07Eh		; register to save copy of STATUS register on interrupt
MEM_W			EQU 07Fh		; register to save copy of W register on interrupt


;--------------------------------------------------------------------------
;Constants - used to light up LED's segments
_0 				EQU 0fch  ; 0
_1				EQU 060h  ; 1
_2				EQU 0dah  ; 2
_3				EQU 0f2h  ; 3
_4				EQU 066h  ; 4
_5				EQU 0b6h  ; 5
_6				EQU 0beh  ; 6
_7				EQU 0e0h  ; 7
_8				EQU 0feh  ; 8
_9				EQU 0f6h  ; 9
_A				EQU 0eeh  ; A
_B				EQU 027h  ; b
_C				EQU 09ch  ; C
_D				EQU 07Ah  ; d
_E				EQU 09eh  ; E
_F				EQU	08eh  ; F
_r				EQU 00ah  ; r
_o				EQU 03ah  ; o
_P				EQU 0Ceh  ; P
_n 				EQU 02ah  ; n
_t				EQU 01ch  ; t
_g				EQU 0F6h  ; g
_l				EQU 006h  ; l
;--------------------------------------------------------------------------


	org 00h
;--------------------------------------------------------------------------
;Reset vector
;--------------------------------------------------------------------------
	GOTO	START

	org 04h
;--------------------------------------------------------------------------
;Interrupt vector
;--------------------------------------------------------------------------
	GOTO	GOT_INT


	org	010h	
;--------------------------------------------------------------------------
;SUBROTINES
;--------------------------------------------------------------------------

;--------------------------------------------------------------------------
	; Subroutine to resolv hex digits to LED segments
    ; Segment A of LED is the most significant bit moving down to least significant (LED's dot)

GET_LEDS:
   	ADDWF PCL, f
   	RETLW _0
	RETLW _1
	RETLW _2
	RETLW _3
	RETLW _4
	RETLW _5
	RETLW _6
	RETLW _7
	RETLW _8
	RETLW _9
	RETLW _A
	RETLW _B
	RETLW _C
	RETLW _D
	RETLW _E
	RETLW _F

;--------------------------------------------------------------------------
		
;--------------------------------------------------------------------------
	; Subroutine to display LEDS
	; This subroutine is called every 4 ms 
    ; Every call the subrotine displays next LED digit
    ; MEM_CYCLE contains bit whicorresponding to the LED to be displayed
    ; the LED segments to be displayed - in FSR //MEM_LED1 ... MEM_LED4
    ; To display LED additional chip CD4015 is used
    ; To move digit to CD4015 RA0 used as CLOCK (normal level LOW) and RA1 as DATA
    ; Segment A of LED is the most significant bit moving down to least significant (LED's dot)
 
DISPLAY:
								; roll MEM_CYCLE
	RLF		MEM_CYCLE, F
	BCF		MEM_CYCLE, 00h
	MOVLW	00h
	ADDWF	MEM_CYCLE, F
	BTFSS	STATUS, Z
	GOTO	CYCLE_OK
	MOVLW	010h
	MOVWF	MEM_CYCLE
CYCLE_OK:
									; turn off current digit
	MOVF 	MEM_PORTB, W
	ANDLW 	0Fh 
	MOVWF 	PORTB
									; load new digit
	BTFSC 	MEM_CYCLE, PIN_LED1
	GOTO 	LOAD_LED
	INCF	FSR, F
	BTFSC 	MEM_CYCLE, PIN_LED2
	GOTO 	LOAD_LED
	INCF	FSR, F
	BTFSC 	MEM_CYCLE, PIN_LED3
	GOTO 	LOAD_LED
	INCF	FSR, F
LOAD_LED:
	MOVF	INDF, W
;DISPLAY_LED:				; W contains segments which are to be displayed
    MOVWF 	MEM_LED		
	MOVF 	MEM_PORTA, W
	ANDLW 	0FCh
    MOVWF 	MEM_PORTA
    MOVWF 	PORTA
							; write it out to shift register through RA0, RA1
    BTFSC 	MEM_LED, 00h
	MOVE_BIT
    BTFSC MEM_LED,   01h
	MOVE_BIT
    BTFSC MEM_LED,   02h
	MOVE_BIT
    BTFSC MEM_LED,   03h
	MOVE_BIT
    BTFSC MEM_LED,   04h
	MOVE_BIT
    BTFSC MEM_LED,   05h
	MOVE_BIT
    BTFSC MEM_LED,   06h
	MOVE_BIT
    BTFSC MEM_LED,   07h
	MOVE_BIT
						; turn on the LED
	MOVLW 0fh
	ANDWF MEM_PORTB, W
	IORWF MEM_CYCLE, W
    MOVWF MEM_PORTB
	MOVWF PORTB
						; return
	RETLW 0

;--------------------------------------------------------------------------
	; subroutine to increment secounds/minutes - rolls to 0 after 59
    ; input - FSR register points to pair of memory registers where tens/ones of seconds/minutes are stored
    ; output - 0 if no updates for minutes/hours needed
    ;        - 1 if minutes/hours need to be incremented (counter rolled from 59 to 00)
    
INC_60:
    INCF  FSR, f			; point to ones
    INCF  INDF, f 		
    MOVLW 0ah			; see, if ones equal 10
    SUBWF INDF, W		
    BTFSS STATUS, Z 
    GOTO  RET0_60
	CLRF  INDF 			
    DECF  FSR, f		; move to previous cell - tens 
    INCF  INDF, f		; increment tens
    MOVLW 6				; see if tens equal 6
    SUBWF INDF, W		
    BTFSS STATUS, Z 
    GOTO  RET_60_0
	CLRF  INDF			
    RETLW 1
RET0_60:
    DECF FSR, f
RET_60_0:
    RETLW 0
;--------------------------------------------------------------------------

;--------------------------------------------------------------------------
	; subroutine to increment hours - rolls to 0 after 23
    ; input - FSR register points to pair of memory registers where tens/ones of hours are stored
    ; output - 0 always

INC_HOURS:
	MOVLW 2
    SUBWF INDF, W		; see if tens equal 2
    BTFSS STATUS, Z
    GOTO  INC_HOUR		; not yet - increment ones
    MOVLW 3             ; yes, tens were equal 2 - see if ones equal 3, so we'll roll to 00
    INCF  FSR, f
    SUBWF INDF, W
    BTFSS STATUS, Z
    GOTO  INC_HOUR_1	; no, not 3 yet - increment ones
	CLRF  INDF			; roll to 00
	DECF  FSR, f
    CLRF  INDF
    RETLW 0
INC_HOUR:
    INCF  FSR, f
INC_HOUR_1:
	INCF  INDF, f
    MOVLW 0ah
    SUBWF INDF, W		; if ones equal 10 - roll to 0 and increment tens 
    BTFSS STATUS, Z
    GOTO  HOUR_RET0
    CLRF  INDF
    DECF  FSR, f
    INCF  INDF, f
    GOTO  HOUR_RET0
INC_HOUR_0:
	DECF  FSR, f
HOUR_RET0:
    RETLW 0
;--------------------------------------------------------------------------

;--------------------------------------------------------------------------
	; this subrotine compares current time (hour and minutes) 
	; to hour/minutes 4 registers pointed by FSR
	; Input : FSR points to hours-tens (4 register) to be compared with 
	; 		  current time
	; Output :
	;		0 - current time is less then one pointed by FSR
	;		1 - current time is equal to one passed in FSR
	;		2 - current time is more then one pointed by FSR
CMP_TIME:
	MOVF	INDF, w
	SUBWF	MEM_CLOCK, W
	BTFSS   STATUS, C
	RETLW   0	; current time is less
	BTFSS   STATUS, Z
	RETLW   2	; current time is bigger
				; equal - move on to the next

	INCF	FSR, f
	MOVF	INDF, w
	SUBWF	MEM_CLOCK + 1, W
	BTFSS   STATUS, C
	RETLW   0	; current time is less
	BTFSS   STATUS, Z
	RETLW   2	; current time is bigger

				; equal - move on to the next
	INCF	FSR, f
	MOVF	INDF, w
	SUBWF	MEM_CLOCK + 2, W
	BTFSS   STATUS, C
	RETLW   0	; current time is less
	BTFSS   STATUS, Z
	RETLW   2	; current time is bigger

				; equal - move on to the next
	INCF	FSR, f
	MOVF	INDF, w
	SUBWF	MEM_CLOCK + 3, W
	BTFSS   STATUS, C
	RETLW   0	; current time is less 
	BTFSS   STATUS, Z
	RETLW   2	; current time is bigger
				; equal
	RETLW	1

;--------------------------------------------------------------------------
	; this subroutine returns 1 if at the current time output switch should be ON
	; and 0 if output switch should be OFF
	; uses CMP_TIME subroutine
	; feature - if ON and OFF time are the same the subroutine returns 0

GET_SWITCH:
	MOVF	MEM_TIME_ON, W
	SUBWF   MEM_TIME_OFF, W
	BTFSS   STATUS, C
	GOTO    OFF_LESS
	BTFSS   STATUS, Z
	GOTO 	ON_LESS

				; equal - move on to the next
	MOVF	MEM_TIME_ON+1, W
	SUBWF   MEM_TIME_OFF+1, W
	BTFSS   STATUS, C
	GOTO    OFF_LESS
	BTFSS   STATUS, Z
	GOTO 	ON_LESS

				; equal - move on to the next
	MOVF	MEM_TIME_ON+2, W
	SUBWF   MEM_TIME_OFF+2, W
	BTFSS   STATUS, C
	GOTO    OFF_LESS
	BTFSS   STATUS, Z
	GOTO 	ON_LESS

				; equal - move on to the next
	MOVF	MEM_TIME_ON+3, W
	SUBWF   MEM_TIME_OFF+3, W
	BTFSS   STATUS, C
	GOTO    OFF_LESS
	BTFSS   STATUS, Z
	GOTO 	ON_LESS

				; equal - return 0
	RETLW	0

ON_LESS:
				; so, the time switch should be turned on is less 
				; then the time when switch should be turned off, 
				; which means if current time bigger or equal time ON
				; and less then time OFF - we return 1, otherwise - 0
	MOVLW	MEM_TIME_ON
	MOVWF	FSR
	CALL	CMP_TIME ; we'll have 0 in W if ON time is bigger then current time, 1 if equl, 2 - otherwise  
	SUBLW	01h
	BTFSC	STATUS, Z
	RETLW	01h		; surprise! - no need for additional checks - we know time ON and time OFF is not equal
					; at that point and ON less then OF, so if ON equals current time - turn switch ON
	BTFSC   STATUS, C
	RETLW   00h		; CMP_TIME returned 0 - means ON time have not come yet
					; now check to see if it is less then OFF
	MOVLW	MEM_TIME_OFF
	MOVWF	FSR
	CALL	CMP_TIME
					; W have 0, if OFF time is bigger - return 1 in this case, 0 otherwise
	SUBLW   01h
	BTFSC	STATUS, Z
	RETLW	00h
	BTFSS	STATUS, C
	RETLW	00h 
	RETLW	01h

OFF_LESS:
				; so, the time switch should be turned on is bigger 
				; then the time when switch should be turned off, 
				; which means if current time bigger or equal time OFF
				; and less then time ON - we return 0, otherwise - 1
	MOVLW	MEM_TIME_OFF
	MOVWF	FSR
	CALL	CMP_TIME ; we'll have 0 in W if OFF time is bigger then current time, 1 if equl, 2 - otherwise  
	SUBLW	01h
	BTFSC	STATUS, Z
	RETLW	00h		; surprise! - no need for additional checks - we know time ON and time OFF is not equal
					; at that point and OFF less then ON, so if OFF bigger then current time - turn switch ON
	BTFSC   STATUS, C
	RETLW   01h		; means current time less then OFF time
	MOVLW	MEM_TIME_ON
	MOVWF	FSR
	CALL	CMP_TIME
					; W have 0, if ON time is bigger - return 1 in this case, 0 otherwise
	SUBLW	01h
	BTFSC	STATUS, Z
	RETLW	01h
	BTFSS	STATUS, C
	RETLW	01h
	RETLW	00h

;--------------------------------------------------------------------------
	; this routine returns set bit in W if the state of the corresponding key
	; has changed its state. If Key was released, bit 0 is set, if pressed -
	; bit 0 is cleared

CHECK_KB:
	BTFSS	PORTA, PIN_INPUT	;04h
	GOTO	NON_PRESSED

			; some key was pressed - detect the state
	MOVF	MEM_CYCLE, W
	ANDWF	MEM_KB, W
	BTFSS	STATUS, Z
	GOTO	RET_MEM_KB	; this key was pressed already before
						; non-pressed before key

	MOVF	MEM_DELAY, W

	BTFSS	MEM_CYCLE, 07h
	GOTO	CHECK_KB_2
						; check for passed delay for 07h bit
	ADDLW	040h
	MOVWF	MEM_DELAY
	ANDLW	0c0h
	BTFSS	STATUS, Z	; if 0 - delay passed (2 bits length)
	RETLW	00h			; no changes
	BSF		MEM_KB, 07h	; new key pressed 
	RETLW	080h
	
CHECK_KB_2:
	BTFSS	MEM_CYCLE, 06h
	GOTO	CHECK_KB_3
						; check for passed delay for 07h bit
	ADDLW	010h
	ANDLW	030h
	BCF		MEM_DELAY, 04h
	BCF		MEM_DELAY, 05h
	IORWF	MEM_DELAY, f
	ANDLW	030h
	BTFSS	STATUS, Z	; if 0 - delay passed (2 bits length)
	RETLW	00h
	BSF		MEM_KB, 06h	; new key pressed
	RETLW	040h

CHECK_KB_3:
	BTFSS	MEM_CYCLE, 05h
	GOTO	CHECK_KB_4
						; check for passed delay for 07h bit
	ADDLW	04h
	ANDLW	0ch
	BCF		MEM_DELAY, 	03h
	BCF		MEM_DELAY, 	02h
	IORWF	MEM_DELAY,  f
	ANDLW	0ch
	BTFSS	STATUS, Z	; if 0 - delay passed (2 bits length)
	RETLW	00h
	BSF		MEM_KB, 05h
	RETLW	020h

CHECK_KB_4:
	ADDLW	01h
	ANDLW	03h
	BCF		MEM_DELAY, 00h
	BCF		MEM_DELAY, 01h
	IORWF	MEM_DELAY, f
	ANDLW	03h
	BTFSS	STATUS, Z	; if 0 - delay passed (2 bits length)
	RETLW	00h
	BSF		MEM_KB, 04h
	RETLW	010h
	
RET_MEM_KB:
				; clear MEM_DELAY for this cycle
	BTFSS	MEM_CYCLE, 07h
	GOTO	CHECK_KB_5
	BCF		MEM_DELAY, 07h
	BCF		MEM_DELAY, 06h
	RETLW	00h	; no changes in the keys pressed
CHECK_KB_5:
	BTFSS	MEM_CYCLE, 06h
	GOTO	CHECK_KB_6
	BCF		MEM_DELAY, 05h
	BCF		MEM_DELAY, 04h
	RETLW	00h	; no changes in the keys pressed
CHECK_KB_6:
	BTFSS	MEM_CYCLE, 05h
	GOTO	CHECK_KB_7
	BCF		MEM_DELAY, 03h
	BCF		MEM_DELAY, 02h
	RETLW	00h	; no changes in the keys pressed
CHECK_KB_7:
	BCF		MEM_DELAY, 01h
	BCF		MEM_DELAY, 00h
	RETLW	00h	; no changes in the keys pressed

NON_PRESSED:
				; non-pressed key in this cycle
	MOVF	MEM_CYCLE, W
	ANDWF	MEM_KB, W
	BTFSS	STATUS, Z
	GOTO	RET_MEM_KB_PRESSD	; this key was pressed already before
						; key was not pressed

	BTFSS	MEM_CYCLE, 07h
	GOTO	CHECK_KB_10
						; check for passed delay for 07h bit
	MOVLW	03fh
	GOTO	CHECK_KB_15
CHECK_KB_10:
	BTFSS	MEM_CYCLE, 06h
	GOTO	CHECK_KB_11
	MOVLW	0cfh
	GOTO	CHECK_KB_15
CHECK_KB_11:
	BTFSS	MEM_CYCLE, 05h
	GOTO	CHECK_KB_12
	MOVLW	0f3h
	GOTO	CHECK_KB_15
CHECK_KB_12:
	MOVLW	0fch
CHECK_KB_15:
	ANDWF	MEM_DELAY, f
	RETLW	00h			; nothing changed

RET_MEM_KB_PRESSD:
	MOVF	MEM_DELAY, W

	BTFSS	MEM_CYCLE, 07h
	GOTO	CHECK_KB_22
						; check for passed delay for 07h bit
	ADDLW	040h
	MOVWF	MEM_DELAY
	ANDLW	0c0h
	BTFSS	STATUS, Z	; if 0 - delay passed (2 bits length)
	RETLW	00h			; no changes yet
	BCF		MEM_KB, 07h	; the key released 
	RETLW	081h
	
CHECK_KB_22:
	BTFSS	MEM_CYCLE, 06h
	GOTO	CHECK_KB_23
						; check for passed delay for 07h bit
	ADDLW	010h
	ANDLW	030h
	BCF		MEM_DELAY, 04h
	BCF		MEM_DELAY, 05h
	IORWF	MEM_DELAY, f
	ANDLW	030h
	BTFSS	STATUS, Z	; if 0 - delay passed (2 bits length)
	RETLW	00h
	BCF		MEM_KB, 06h	; the key was released
	RETLW	041h

CHECK_KB_23:
	BTFSS	MEM_CYCLE, 05h
	GOTO	CHECK_KB_24
						; check for passed delay for 07h bit
	ADDLW	04h
	ANDLW	0ch
	BCF		MEM_DELAY, 02h
	BCF		MEM_DELAY, 03h
	IORWF	MEM_DELAY, f
	ANDLW	0ch
	BTFSS	STATUS, Z	; if 0 - delay passed (2 bits length)
	RETLW	00h
	BCF		MEM_KB, 05h	; the key was released
	RETLW	021h
CHECK_KB_24:
	ADDLW	01h
	ANDLW	03h
	BCF		MEM_DELAY, 00h
	BCF		MEM_DELAY, 01h
	IORWF	MEM_DELAY, f
	ANDLW	03h
	BTFSS	STATUS, Z	; if 0 - delay passed (2 bits length)
	RETLW	00h
	BCF		MEM_KB, 04h	; the key was released
	RETLW	011h
;--------------------------------------------------------------------------
CLOCK_INC:
	MOVLW	MEM_CLOCK+4
	MOVWF	FSR
	CALL	INC_60
	ADDLW	00h
	BTFSC	STATUS, Z
	GOTO	CLOCK_CHECK_SWITCH
					; increment minutes
	MOVLW	MEM_CLOCK+2
	MOVWF	FSR
	CALL	INC_60
	ADDLW	00h
	BTFSC	STATUS, Z
	GOTO	CLOCK_CHECK_SWITCH
	MOVLW	MEM_CLOCK
	MOVWF	FSR
	CALL	INC_HOURS
CLOCK_CHECK_SWITCH:
	CALL	GET_SWITCH
	ADDLW	00h
	BTFSS	STATUS, Z
	GOTO	SWITCH_IS_ON
	BCF		MEM_PORTB, PIN_SWITCH
	RETLW	00h
SWITCH_IS_ON:
	BSF		MEM_PORTB, PIN_SWITCH
	RETLW	00h	

;--------------------------------------------------------------------------


CLOCK:

	MOVLW	02h
	MOVWF	MEM_TEMP
CLOCK_DELAY:
	DECF	MEM_TEMP, F
	BTFSS	STATUS, Z
	GOTO	CLOCK_DELAY
	NOP
	NOP
	BANKSEL TMR0
	MOVLW 8			; 250 mks delay * 1:16 prescaler - 4 ms cycle
	MOVWF TMR0
	
	CALL	CHECK_KB
			; act depending on MODE
	MOVWF	MEM_LAST_KB
	MOVLW	0c0h
	ANDWF	MEM_KB, W
	SUBLW	0c0h
	BTFSC	STATUS, Z
	GOTO	MODE_ERR	; oooppss... RB6, RB7 pressed alltogether
	MOVLW	030h
	ANDWF	MEM_KB, W
	SUBLW	030h
	BTFSS	STATUS, Z
	GOTO	MODE_OK
						; stop MODE (RB4, RB5 pressed altogether)- in this mode 
						; clock doesnot increment and displays 'StOP'
	CLRF	MEM_CLOCK + 4
	CLRF	MEM_CLOCK + 5
	MOVLW 	6
    MOVWF 	MEM_MS
	MOVLW	MEM_LABEL_STOP	
	MOVWF	FSR
	CALL	DISPLAY
	RETLW	00h
MODE_ERR:

    INCFSZ 	MEM_MS, f		; if no 250 cycles passed (1 sec - goto dislay LEDS) 
    GOTO  	DISPLAY_ERR 
	MOVLW 	6
    MOVWF 	MEM_MS
	CALL	CLOCK_INC
DISPLAY_ERR:
	MOVLW	MEM_LABEL_ERR
	MOVWF	FSR
	CALL	DISPLAY
	RETLW	00h

MODE_OK:
							; first - increment clock
    INCFSZ 	MEM_MS, f		; if no 250 cycles passed (1 sec - goto dislay LEDS) 
    GOTO  	DISPLAY_MODE 
	MOVLW 	MS_DELAY
    MOVWF 	MEM_MS
	CALL	CLOCK_INC

DISPLAY_MODE:	
	MOVF	MEM_LAST_KB, W
	ANDLW	0ffh
	BTFSC	STATUS, Z
	GOTO	MODE_SAME
							; mode changing
	CLRF	MEM_MODE_COUNT
	INCF	MEM_MODE_COUNT, f
							; update mode
MODE_SAME:	
	CLRF	MEM_MODE
	MOVF	MEM_KB, W
	ANDLW	030h
	SUBLW	010h			; only one bit - RB4 or RB5 might have been set
							; so, if the resul negative (C is 0) - clock mode
							; positive - Programming ON time, equal - Programming OFF time
	BTFSC	STATUS, Z
	GOTO	MODE_2
							; clock mode - should check programming mode
	BTFSS	STATUS, C
	GOTO	MODE_1
	MOVLW	0c0h
	ANDWF	MEM_KB, W
	BTFSC	STATUS, Z
	GOTO	MODE_CLOCK_1
	BSF		MEM_MODE, MODE_CLOCK_PROG
	GOTO	UPDATE_MODE
MODE_CLOCK_1:
	
	BSF		MEM_MODE, MODE_CLOCK
	GOTO	UPDATE_MODE
MODE_2:
	BSF		MEM_MODE, MODE_PROG_OFF
	GOTO	UPDATE_MODE
MODE_1:
	BSF		MEM_MODE, MODE_PROG_ON
UPDATE_MODE:

							; act depending on current mode
	MOVF	MEM_MODE_COUNT, W
	ANDLW	0ffh
	BTFSC	STATUS, Z
	GOTO	DIRECT_MODE		; act as mode, not label
							; show label for the mode
	INCF	MEM_MODE_COUNT, F
							; show label
	BTFSS	MEM_MODE, MODE_CLOCK
	GOTO	MODE_3
	MOVLW	MEM_LABEL_CLOCK
	MOVWF	FSR
	CALL	DISPLAY
	RETLW	00h

MODE_3:
	BTFSS	MEM_MODE, MODE_PROG_ON
	GOTO	MODE_4
	MOVLW	MEM_LABEL_PROG_ON
	MOVWF	FSR
	CALL	DISPLAY
	RETLW	00h
MODE_4:
	BTFSS	MEM_MODE, MODE_PROG_OFF
	GOTO	MODE_5
	MOVLW	MEM_LABEL_PROG_OFF
	MOVWF	FSR
	CALL	DISPLAY
	RETLW	00h
MODE_5:
	MOVLW	MEM_LABEL_CLOCK_PROG
	MOVWF	FSR
	CALL	DISPLAY
	RETLW	00h

DIRECT_MODE:
	BTFSS	MEM_MODE, MODE_CLOCK
	GOTO	MODE_11
	MOVLW	MEM_CLOCK
	MOVWF	FSR
	GOTO	UPDATE_DISPLAY
MODE_11:
	BTFSS	MEM_MODE, MODE_CLOCK_PROG
	GOTO	MODE_12	
								; programming CLOCK mode
								; clear seconds
	CLRF	MEM_CLOCK+4
	CLRF	MEM_CLOCK+5
	MOVLW	MEM_CLOCK+2			; load pointer to minutes
	GOTO	INC_DISPLAYED
MODE_12:
	BTFSS	MEM_MODE, MODE_PROG_ON
	GOTO	MODE_13
	MOVLW	MEM_TIME_ON+2
	GOTO	INC_DISPLAYED	
MODE_13:
	MOVLW	MEM_TIME_OFF+2
INC_DISPLAYED:
								; if MEM_MS is not 0 - do not increment
	MOVWF	MEM_TEMP
	MOVF	MEM_MS, W
	SUBLW	MS_DELAY
	BTFSC	STATUS, Z
	GOTO	DO_INC
	MOVF	MEM_TEMP, W
	MOVWF	FSR
	GOTO	BEFORE_UPDATE_DISPLAY
DO_INC:
				; depending on what was pressed - increment hours or minutes
	MOVF	MEM_TEMP, W				
	MOVWF	FSR
	BTFSC	MEM_KB, 06h
	GOTO	MODE_INC_MINUTES
	BTFSS	MEM_KB, 07h
	GOTO	BEFORE_UPDATE_DISPLAY
	GOTO	MODE_INC_HOURS
				; update hours
		
	
MODE_INC_MINUTES:
	CALL	INC_60
	GOTO	BEFORE_UPDATE_DISPLAY

								; increment minutes
MODE_INC_HOURS:
	DECF	FSR, F
	DECF	FSR, F
	CALL	INC_HOURS
	GOTO	UPDATE_DISPLAY

BEFORE_UPDATE_DISPLAY:
	DECF	FSR, F
	DECF	FSR, F
UPDATE_DISPLAY:
    MOVF 	INDF, W
    CALL 	GET_LEDS
    MOVWF 	MEM_LED1

	INCF	FSR, f
    MOVF 	INDF, W
    CALL 	GET_LEDS
    MOVWF 	MEM_LED2

	INCF	FSR, f
    MOVF 	INDF, W
    CALL 	GET_LEDS
    MOVWF 	MEM_LED3

	INCF	FSR, f
    MOVF 	INDF, W
    CALL 	GET_LEDS
    MOVWF 	MEM_LED4
    

	
								;special treatment for MODE_CLOCK update DOT
	BTFSS	MEM_MODE, MODE_CLOCK
	GOTO	CALL_DISPLAY    
	BTFSC 	MEM_MS, 07h
    BSF   	MEM_LED2, 00h
CALL_DISPLAY:
	MOVLW	MEM_LED1
	MOVWF	FSR
    CALL DISPLAY
    RETLW 0


GOT_INT_EXT:
    RETLW 0


	org 	400h
START:			; initialization
				; clear all the memory
	MOVLW	020h
	MOVWF	FSR
START_2:
	CLRF	INDF
	INCF	FSR, F
	BTFSS	FSR, 07h
	GOTO	START_2
				; load labels
	MOVLW	_E
	MOVWF	MEM_LABEL_ERR
	MOVLW	_r
	MOVWF	MEM_LABEL_ERR+1
	MOVLW	_0
	MOVWF	MEM_LABEL_ERR+2
	MOVLW	_r
	MOVWF	MEM_LABEL_ERR+3

	MOVLW	_5
	MOVWF	MEM_LABEL_STOP
	MOVLW	_t
	MOVWF	MEM_LABEL_STOP+1
	MOVLW	_0
	MOVWF	MEM_LABEL_STOP+2
	MOVLW	_P
	MOVWF	MEM_LABEL_STOP+3


	MOVLW	_C
	MOVWF	MEM_LABEL_CLOCK
	MOVLW	_l
	MOVWF	MEM_LABEL_CLOCK+1
	MOVLW	_0
	MOVWF	MEM_LABEL_CLOCK+2
	MOVLW	_C
	MOVWF	MEM_LABEL_CLOCK+3

	MOVLW	_P
	MOVWF	MEM_LABEL_CLOCK_PROG
	MOVLW	_r
	MOVWF	MEM_LABEL_CLOCK_PROG+1
	MOVLW	_0
	MOVWF	MEM_LABEL_CLOCK_PROG+2
	MOVLW	_g
	MOVWF	MEM_LABEL_CLOCK_PROG+3

	MOVLW	_P
	MOVWF	MEM_LABEL_PROG_ON
	MOVLW	_r
	MOVWF	MEM_LABEL_PROG_ON+1
	MOVLW	_0
	MOVWF	MEM_LABEL_PROG_ON+2
	MOVLW	_n
	MOVWF	MEM_LABEL_PROG_ON+3

	MOVLW	_P
	MOVWF	MEM_LABEL_PROG_OFF
	MOVLW	_r
	MOVWF	MEM_LABEL_PROG_OFF+1
	MOVLW	_0
	MOVWF	MEM_LABEL_PROG_OFF+2
	MOVLW	_F
	MOVWF	MEM_LABEL_PROG_OFF+3

	BSF		MEM_MODE, MODE_CLOCK
	MOVLW 10h
    MOVWF MEM_CYCLE
    MOVLW 07h
    MOVWF CMCON

    BANKSEL PIR1
	CLRW
    MOVWF PIR1

	MOVWF MEM_PORTB

    MOVWF RCSTA

    MOVLW 0F0h			; enable GIE (global interrupt), PEIE (peripherial interrupt), TOIE (TMR 0), INTE (RB0 interrupt)
    MOVWF INTCON

	MOVLW 6
    MOVWF MEM_MS

	BANKSEL OPTION_REG
    MOVLW 03h	; 1:16 prescaler for TMR0
	MOVWF OPTION_REG
	
	BANKSEL TMR0
	MOVLW 4			; 250 mks delay * 1:16 prescaler - 4 ms cycle
	MOVWF TMR0

	BANKSEL PIE1
	MOVLW 020h			; RCIE enabled (USART receive interrupt flag)
    MOVWF PIE1

	MOVLW 0fch			; enable PORTA output
	MOVWF TRISA

	MOVLW 07h
	MOVWF TRISB

	MOVLW 026h
    MOVWF TXSTA

	MOVLW 25 
    MOVWF SPBRG

    BANKSEL PORTA
LOOP:
    NOP
    NOP
    GOTO LOOP

GOT_INT:		; INT may be: 1) keyboard 2) from "real-time clock" (timer2) - 4 every ms	 
			; there is 2 mode of working - usual clock and while in programming - the clock
			; stopped at that time and dot segment is rolling around 

			; save the registers
	MOVWF MEM_W					; save W register
	MOVF  STATUS, W
	MOVWF MEM_STATUS			; save STATUS register
	
	BANKSEL PORTA
	BTFSC INTCON, INTF			; RB0 interrupt?
	CALL GOT_INT_EXT
	BANKSEL PORTA				; select again - may be it was changed
	BTFSC INTCON, T0IF
	CALL CLOCK
	BCF   	INTCON, T0IF

			; other interrupts routine goes here

    BANKSEL PORTA
	MOVF MEM_STATUS, W
    MOVWF STATUS
    MOVF MEM_W, W
    RETFIE

	END



