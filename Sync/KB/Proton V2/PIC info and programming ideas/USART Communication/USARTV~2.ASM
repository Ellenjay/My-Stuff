;*******************************************************
;*                 Code Produced by the                *
;*             PROTON+ Compiler. Version 2.1.3         *
;* Copyright Rosetta Technologies/Crownhill Associates *
;*              Written by Les Johnson. 2003           *
;*******************************************************
	NOLIST

	#include "C:\MYVEHI~1\PICBAS~1\USARTC~1\USARTV~2.PBP" 

	LIST
VAR1 Equ 47
F1_SOF equ $ ; USARTV~2.BAS
F1_000006 equ $ ; in [USARTV~2.BAS] CONFIG XT_OSC , WDT_OFF , PWRTE_ON , BODEN_OFF , LVP_OFF , CP_OFF , DEBUG_OFF
LOOP
F1_000029 equ $ ; in [USARTV~2.BAS] HSERIN  1000 , Timeout , [VAR1] ' Receive a byte serially into VAR1
	Movlw 3
	Movwf GENH
	Movlw 232
	Movwf GEN
	F@Call Hrsin2
	set@page TIMEOUT
	Btfss STATUS,0
	Goto TIMEOUT
	Movwf VAR1
F1_000030 equ $ ; in [USARTV~2.BAS] PRINT DEC VAR1 , " " ' Display the byte received
	Movlw 128
	Movwf BPFH
	Movfw VAR1
	F@Call out@decb
	Movlw ' '
	F@Call Print
F1_000031 equ $ ; in [USARTV~2.BAS] GOTO Loop ' Loop forever
	F@Jump LOOP
TIMEOUT
F1_000033 equ $ ; in [USARTV~2.BAS] CLS
	F@Call Lcd@Cls
F1_000034 equ $ ; in [USARTV~2.BAS] PRINT "TIMED OUT" ' Display an error if HSERIN timed out
	Movlw 'T'
	F@Call Print
	Movlw 'I'
	F@Call Print
	Movlw 'M'
	F@Call Print
	Movlw 'E'
	F@Call Print
	Movlw 'D'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'O'
	F@Call Print
	Movlw 'U'
	F@Call Print
	Movlw 'T'
	F@Call Print
F1_000035 equ $ ; in [USARTV~2.BAS] Pause 2000
	Movlw 7
	Movwf PP1H
	Movlw 208
	F@Call dly@w
F1_000036 equ $ ; in [USARTV~2.BAS] Goto Loop
	F@Jump LOOP
	END

