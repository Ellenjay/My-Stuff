;----------------------------------------------------------
; Code Produced by the PROTON+ Compiler. Version 3.2.5.5
; Copyright Rosetta Technologies/Crownhill Associates
; Written by Les Johnson. February 2007
;----------------------------------------------------------
 NOLIST
 #include "C:\PROGRAM FILES\PROTONIDE\SAMPLES\3_BUTTONS.PBP"
 LIST

 BUF1 = 44
 BUF2 = 45
 BUF3 = 46
	#Define __LCD_DTPORT PORTD
	#Define __LCD_RSPORT PORTE
	#Define __LCD_ENPORT PORTE
	#Define __SCL_PORT PORTC
	#Define __SDA_PORT PORTC
	#Define __RSOUT_PORT PORTC
	#Define __RSIN_PORT PORTC
	#Define __KEYPAD_PORT PORTB
	#Define __CCP1_PIN PORTC,2
	#Define __CCP2_PIN PORTC,1
	#Define SW1 PORTB,4
	#Define SW2 PORTB,5
	#Define SW3 PORTB,6
	#Define LED1 PORTD,5
	#Define LED2 PORTD,6
	#Define LED3 PORTD,7
F2_SOF equ $ ; 3_BUTTONS.PRP
F2_EOF equ $ ; 3_BUTTONS.PRP
F1_SOF equ $ ; 3_BUTTONS.BAS
F3_SOF equ $ ; PROTON_20.INC
F3_000067 equ $ ; in [PROTON_20.INC] ALL_DIGITAL = TRUE ' Set PORTA and PORTE to all digital
	Movlw 7
	Bsf STATUS,5
ram_bank = 1
	Movwf ADCON1
F3_EOF equ $ ; PROTON_20.INC
F1_000017 equ $ ; in [3_BUTTONS.BAS] DelayMS 500      ' Wait for PICmicro to stabilise
	Movlw 1
	Bcf STATUS,5
ram_bank = 0
	Movwf PP1H
	Movlw 244
	F@Call dly@w
F1_000018 equ $ ; in [3_BUTTONS.BAS] Clear       ' Clear buffers
	Movlw 32
	Movwf FSR
	Movlw 96
	F@Call cl@r
	Movlw 160
	Movwf FSR
	Movlw 80
	F@Call cl@r
	Movlw 16
	Movwf FSR
	Movlw 96
	F@Call cl@rh
	Movlw 144
	Movwf FSR
	Movlw 96
	F@Call cl@rh
F1_000019 equ $ ; in [3_BUTTONS.BAS] Low PORTD      ' ALL LEDs off
	Bsf STATUS,5
ram_bank = 1
	Clrf TRISD
	Bcf STATUS,5
ram_bank = 0
	Clrf PORTD
F1_000020 equ $ ; in [3_BUTTONS.BAS] TRISB = %11110000    ' Set PORTB 0-3 outputs, 4-7 inputs
	Movlw 240
	Bsf STATUS,5
ram_bank = 1
	Movwf TRISB
F1_000021 equ $ ; in [3_BUTTONS.BAS] PORTB_PULLUPS = On    ' Enable PORTB pull-ups
	Bcf OPTION_REG,7
CHK1
	Bcf STATUS,5
ram_bank = 0
F1_000022 equ $ ; in [3_BUTTONS.BAS] Chk1: DelayMS 25
	Movlw 25
	F@Call dl@ms
F1_000023 equ $ ; in [3_BUTTONS.BAS] Button SW1,0,40,5,BUF1,0,Chk2 ' Check Button 1 (Skip to 2 if Not Pressed)
	Movlw PORTB
	Movwf GEN
	Movlw 16
	Movwf GENH
	Clrf PP6
	Movlw 40
	Movwf PP5
	Movlw 5
	Movwf PP5H
	Clrf PP6H
	Movf BUF1,W
	F@Call but@n
	Movwf BUF1
	set@page CHK2
	Btfsc STATUS,0
	Goto CHK2
F1_000024 equ $ ; in [3_BUTTONS.BAS] Toggle LED1      ' Toggle LED if pressed
	Movlw 32
	Xorwf PORTD,F
	Bsf STATUS,5
ram_bank = 1
	Bcf TRISD,5
CHK2
	Bcf STATUS,5
ram_bank = 0
F1_000025 equ $ ; in [3_BUTTONS.BAS] Chk2: Button SW2,0,40,5,BUF2,0,Chk3 ' Check Button 2 (Skip to 3 if Not Pressed)
	Movlw PORTB
	Movwf GEN
	Movlw 32
	Movwf GENH
	Clrf PP6
	Movlw 40
	Movwf PP5
	Movlw 5
	Movwf PP5H
	Clrf PP6H
	Movf BUF2,W
	F@Call but@n
	Movwf BUF2
	set@page CHK3
	Btfsc STATUS,0
	Goto CHK3
F1_000026 equ $ ; in [3_BUTTONS.BAS] Toggle LED2      ' Toggle LED if pressed
	Movlw 64
	Xorwf PORTD,F
	Bsf STATUS,5
ram_bank = 1
	Bcf TRISD,6
CHK3
	Bcf STATUS,5
ram_bank = 0
F1_000027 equ $ ; in [3_BUTTONS.BAS] Chk3: Button SW3,0,40,5,BUF3,0,Chk1 ' Check Button 3 (Skip to 1 if Not Pressed)
	Movlw PORTB
	Movwf GEN
	Movlw 64
	Movwf GENH
	Clrf PP6
	Movlw 40
	Movwf PP5
	Movlw 5
	Movwf PP5H
	Clrf PP6H
	Movf BUF3,W
	F@Call but@n
	Movwf BUF3
	set@page CHK1
	Btfsc STATUS,0
	Goto CHK1
F1_000028 equ $ ; in [3_BUTTONS.BAS] Toggle LED3      ' Toggle LED if pressed
	Movlw 128
	Xorwf PORTD,F
	Bsf STATUS,5
ram_bank = 1
	Bcf TRISD,7
F1_000029 equ $ ; in [3_BUTTONS.BAS] GoTo Chk1      ' Do it forever
	Bcf STATUS,5
ram_bank = 0
	F@Jump CHK1
F1_EOF equ $ ; 3_BUTTONS.BAS
 LIST
	END

