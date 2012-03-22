LIST P=16F628, R=Hex    ; Use the PIC16F628 and Hexidecimal system 
#include "P16F628.INC"  ; Include header file 
__config  _INTRC_OSC_NOCLKOUT & _LVP_OFF & _WDT_OFF & _PWRTE_ON & _BODEN_ON 

CBLOCK 0x20             ; Declare variable addresses starting at 0x20 
        Var_Input
        Temp1
        Temp2
        Offset
        OutPut
        ENDC 
; 
; ----------- 
; INITIALIZE 
; ----------- 
; 
        ORG    0x000           ; Program starts at 0x000 

Start			movlw 2h
				movwf	Var_Input
				movlw	T_Units
				movwf	Temp1
				movwf	FSR
				movlw	LOW INDF
				clrf	Temp1
				movwf	Temp1
SetupLookupTable
				movf Var_Input,W	; variable for Lookup Table
				movwf Offset		; Move it into offset variable
				movlw LOW T_Units	; Get low 8 bits of table address
				movwf	Temp2
				addwf Offset, F		; Add to offset variable
				movlw HIGH T_Units	; Get high 5 bits table address
				btfsc STATUS, C		; Did we cross a page?
				addlw 1				; If Yes - add one to high address
				movwf PCLATH		; Store value in PCLATH
				movf Offset,0      	; store offset in W
				call Table
				movwf OutPut		; Put returned value into 'OutPut'
				GoTo 	Start
Table
		movwf	PCL

T_Units						;data table for bit pattern
		retlw	b'10000000'
        retlw   b'01000000'
        retlw   b'00100000'
        retlw   b'00010000'
        retlw   b'00001000'
        retlw   b'00000100'
        retlw   b'00000010'
        retlw   b'00000001'
        retlw   b'00000010'
        retlw   b'00000100'
        retlw   b'00001000'
        retlw   b'00010000'
        retlw   b'00100000'
        retlw   b'01000000'

T_Tens				;data table for bit pattern
		retlw	b'11000000'
        retlw   b'01100000'
        retlw   b'00110000'
        retlw   b'00011000'
        retlw   b'00001100'
        retlw   b'00000110'
        retlw   b'00000011'
        retlw   b'00000011'
        retlw   b'00000110'
        retlw   b'00001100'
        retlw   b'00011000'
        retlw   b'00110000'
        retlw   b'01100000'
        retlw   b'11000000'

T_Hun			;data table for bit pattern
		retlw	b'01111111'
        retlw   b'10111111'
        retlw   b'11011111'
        retlw   b'11101111'
        retlw   b'11110111'
        retlw   b'11111011'
        retlw   b'11111101'
        retlw   b'11111110'
        retlw   b'11111101'
        retlw   b'11111011'
        retlw   b'11110111'
        retlw   b'11101111'
        retlw   b'11011111'
        retlw   b'10111111'

T_Tho				;data table for bit pattern
		retlw	b'00111111'
        retlw   b'10011111'
        retlw   b'11001111'
        retlw   b'11100111'
        retlw   b'11110011'
        retlw   b'11111001'
        retlw   b'11111100'
        retlw   b'11111100'
        retlw   b'11111001'
        retlw   b'11110011'
        retlw   b'11100111'
        retlw   b'11001111'
        retlw   b'10011111'
        retlw   b'00111111'
...
END
