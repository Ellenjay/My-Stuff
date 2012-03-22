;*******************************************************
;*                 Code Produced by the                *
;*             PROTON+ Compiler. Version 2.1.3         *
;* Copyright Rosetta Technologies/Crownhill Associates *
;*              Written by Les Johnson. 2003           *
;*******************************************************
	NOLIST

	#include "C:\MYVEHI~1\PICBAS~1\USARTC~1\USARTV~1.PBP" 

	LIST
F1_SOF equ $ ; USARTV~1.BAS
F1_000006 equ $ ; in [USARTV~1.BAS] CONFIG XT_OSC , WDT_OFF , PWRTE_ON , BODEN_OFF , LVP_OFF , CP_OFF , DEBUG_OFF
F1_000022 equ $ ; in [USARTV~1.BAS] Print At 2,1,"Hello"
	Movlw 128
	Movwf BPFH
	Movlw 192
	F@Call LCD@crs
	Movlw 'H'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'l'
	F@Call Print
	F@Call Print
	Movlw 'o'
	F@Call Print
	DE "This is a Test"
F1_000027 equ $ ; in [USARTV~1.BAS] TXSTA.4 = 0
	Bsf STATUS,5
ram_bank = 1
	Bcf TXSTA,4
F1_000029 equ $ ; in [USARTV~1.BAS] Print at 1,1, isbin TXSTA
	Movlw 128
	Bcf STATUS,5
ram_bank = 0
	Movwf BPFH
	Movlw 128
	F@Call LCD@crs
	Movlw 37
	F@Call ch@snd
	Bsf STATUS,5
ram_bank = 1
	Movfw TXSTA
	Bcf STATUS,5
ram_bank = 0
	F@Call out@sbinb
	END

