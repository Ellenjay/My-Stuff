;*******************************************************
;*                 Code Produced by the                *
;*             PROTON+ Compiler. Version 2.1.3         *
;* Copyright Rosetta Technologies/Crownhill Associates *
;*              Written by Les Johnson. 2003           *
;*******************************************************
	NOLIST

	#include "C:\MYVEHI~1\PICBAS~1\1WIREK~1\1WIREK~1.PBP" 

	LIST
F1_SOF equ $ ; 1WIREK~1.BAS
F1_000011 equ $ ; in [1WIREK~1.BAS] CONFIG XT_OSC , WDT_OFF , PWRTE_ON , BODEN_OFF , LVP_OFF , CP_OFF , DEBUG_OFF
F1_000027 equ $ ; in [1WIREK~1.BAS] CLS
	F@Call Lcd@Cls
F1_000028 equ $ ; in [1WIREK~1.BAS] Print at 1,1, "Hello"
	Movlw 128
	Movwf BPFH
	Movlw 128
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
	END

