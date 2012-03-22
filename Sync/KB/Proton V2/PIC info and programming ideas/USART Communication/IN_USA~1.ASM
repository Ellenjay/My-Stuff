;*******************************************************
;*                 Code Produced by the                *
;*             PROTON+ Compiler. Version 2.1.3         *
;* Copyright Rosetta Technologies/Crownhill Associates *
;*              Written by Les Johnson. 2003           *
;*******************************************************
	NOLIST

	#include "C:\MYVEHI~1\PICBAS~1\USARTC~1\IN_USA~1.PBP" 

	LIST
VAR1 Equ 52
SERSTRING Equ 53
 Variable SERSTRING#0=53,SERSTRING#1=54,SERSTRING#2=55,SERSTRING#3=56,SERSTRING#4=57,SERSTRING#5=58
 Variable SERSTRING#6=59,SERSTRING#7=60,SERSTRING#8=61,SERSTRING#9=62,SERSTRING#10=63,SERSTRING#11=64
 Variable SERSTRING#12=65,SERSTRING#13=66,SERSTRING#14=67,SERSTRING#15=68
F1_SOF equ $ ; IN_USA~1.BAS
F1_000006 equ $ ; in [IN_USA~1.BAS] CONFIG XT_OSC , WDT_OFF , PWRTE_ON , BODEN_OFF , LVP_OFF , CP_OFF , DEBUG_OFF
LOOP
F1_000030 equ $ ; in [IN_USA~1.BAS] HSERIN  4000 , Timeout , [WAIT( "XYZ" ) , STR SERSTRING]
	Movlw 15
	Movwf GENH
	Movlw 160
	Movwf GEN
Pb@lb2
	F@Call Hrsin2
	set@page TIMEOUT
	Btfss STATUS,0
	Goto TIMEOUT
	Sublw 'X'
	set@page Pb@lb2
	Btfss STATUS,2
	Goto Pb@lb2
	F@Call Hrsin2
	set@page TIMEOUT
	Btfss STATUS,0
	Goto TIMEOUT
	Sublw 'Y'
	set@page Pb@lb2
	Btfss STATUS,2
	Goto Pb@lb2
	F@Call Hrsin2
	set@page TIMEOUT
	Btfss STATUS,0
	Goto TIMEOUT
	Sublw 'Z'
	set@page Pb@lb2
	Btfss STATUS,2
	Goto Pb@lb2
	Clrf PBP#VAR0
Pb@lb5
	Setc
	F@Call Hrsin2
	set@page TIMEOUT
	Btfss STATUS,0
	Goto TIMEOUT
	Movfw PBP#VAR0
	Addlw SERSTRING
	Movwf FSR
	Movfw RCREG
	Movwf INDF
	Incf PBP#VAR0,F
	Movfw PBP#VAR0
	Sublw 16
	set@page Pb@lb5
	Btfss STATUS,2
	Goto Pb@lb5
F1_000034 equ $ ; in [IN_USA~1.BAS] CLS
	F@Call Lcd@Cls
F1_000035 equ $ ; in [IN_USA~1.BAS] PRINT at 1,1, STR SerString      ' Display the string.
	Movlw 128
	Movwf BPFH
	Movlw 128
	F@Call LCD@crs
	Movlw 16
	Movwf GEN4
	Clrf PP2H
	Movlw 53
	F@Call sb@strout
F1_000038 equ $ ; in [IN_USA~1.BAS] GOTO Loop ' Loop forever
	F@Jump LOOP
TIMEOUT
F1_000040 equ $ ; in [IN_USA~1.BAS] CLS
	F@Call Lcd@Cls
F1_000041 equ $ ; in [IN_USA~1.BAS] PRINT "TIMED OUT" ' Display an error if HSERIN timed out
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
F1_000042 equ $ ; in [IN_USA~1.BAS] Pause 2000
	Movlw 7
	Movwf PP1H
	Movlw 208
	F@Call dly@w
F1_000043 equ $ ; in [IN_USA~1.BAS] Goto Loop
	F@Jump LOOP
	END

