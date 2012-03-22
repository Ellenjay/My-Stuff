;*******************************************************
;*                 Code Produced by the                *
;*             PROTON+ Compiler. Version 2.1.3         *
;* Copyright Rosetta Technologies/Crownhill Associates *
;*              Written by Les Johnson. 2003           *
;*******************************************************
	NOLIST

	#include "C:\MYVEHI~1\PICBAS~1\USARTC~1\OUT_US~1.PBP" 

	LIST
VAR1 Equ 39
F1_SOF equ $ ; OUT_US~1.BAS
F1_000006 equ $ ; in [OUT_US~1.BAS] CONFIG XT_OSC , WDT_OFF , PWRTE_ON , BODEN_OFF , LVP_OFF , CP_OFF , DEBUG_OFF
LOOP
F1_000029 equ $ ; in [OUT_US~1.BAS] HSEROUT ["XYZ"]
	Movlw 'X'
	F@Call HRsout
	Movlw 'Y'
	F@Call HRsout
	Movlw 'Z'
	F@Call HRsout
F1_000030 equ $ ; in [OUT_US~1.BAS] HSEROUT ["Hello there     "]
	Movlw 'H'
	F@Call HRsout
	Movlw 'e'
	F@Call HRsout
	Movlw 'l'
	F@Call HRsout
	F@Call HRsout
	Movlw 'o'
	F@Call HRsout
	Movlw ' '
	F@Call HRsout
	Movlw 't'
	F@Call HRsout
	Movlw 'h'
	F@Call HRsout
	Movlw 'e'
	F@Call HRsout
	Movlw 'r'
	F@Call HRsout
	Movlw 'e'
	F@Call HRsout
	Movlw ' '
	F@Call HRsout
	F@Call HRsout
	F@Call HRsout
	F@Call HRsout
	F@Call HRsout
F1_000033 equ $ ; in [OUT_US~1.BAS] Pause 500
	Movlw 1
	Movwf PP1H
	Movlw 244
	F@Call dly@w
F1_000034 equ $ ; in [OUT_US~1.BAS] Goto Loop
	F@Jump LOOP
	END

