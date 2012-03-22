;*******************************************************
;*                 Code Produced by the                *
;*             PROTON+ Compiler. Version 2.1.3         *
;* Copyright Rosetta Technologies/Crownhill Associates *
;*              Written by Les Johnson. 2003           *
;*******************************************************
	NOLIST

	#include "C:\MYVEHI~2\PICBAS~1\VEHICL~3\RFIDSY~2.PBP" 

	LIST
INDEX Equ 58
INDEX2 Equ 59
TAGOFFSET Equ 60
B1 Equ 61
B2 Equ 62
_B#VR1 Equ 63
CURRENTLINE Equ 64
STARTLINE Equ 65
ENDLINE Equ 66
LASTUSER Equ 67
EMPIN Equ 68
 Variable EMPIN#0=68,EMPIN#1=69,EMPIN#2=70,EMPIN#3=71,EMPIN#4=72,EMPIN#5=73
CE Equ 74
 Variable CE#0=74,CE#1=75,CE#2=76
TAGIN Equ 77
 Variable TAGIN#0=77,TAGIN#1=78,TAGIN#2=79,TAGIN#3=80,TAGIN#4=81,TAGIN#5=82
 Variable TAGIN#6=83,TAGIN#7=84,TAGIN#8=85,TAGIN#9=86
CT Equ 87
 Variable CT#0=87,CT#1=88,CT#2=89,CT#3=90,CT#4=91
FOOTER Equ 92
NUA Equ 93
STIME Equ 94
COL Equ 95
ROW Equ 96
KEY Equ 97
	#Define FLAG _B#VR1,0
	#Define GIE INTCON,7
	#Define STARTENABLE PORTC,0
	#Define GREEN PORTC,1
	#Define RED PORTC,2
	#Define SPIN PORTC,4
	#Define RFIDENABLE PORTD,4
	#Define HHDETECT PORTC,3
F1_SOF equ $ ; RFIDSY~2.BAS
F1_000010 equ $ ; in [RFIDSY~2.BAS] CONFIG XT_OSC , WDT_OFF , PWRTE_ON , BODEN_ON , LVP_OFF , CP_OFF , DEBUG_OFF
F1_000059 equ $ ; in [RFIDSY~2.BAS] Option_Reg.6 = 0   'Set to allow PortB.0 to detect a high to low pulse
	Bsf STATUS,5
ram_bank = 1
	Bcf OPTION_REG,6
F1_000061 equ $ ; in [RFIDSY~2.BAS] PORTB_PULLUPS = TRUE           ' Enable PORTB pullups
	Bcf OPTION_REG,7
F1_000062 equ $ ; in [RFIDSY~2.BAS] ALL_DIGITAL = TRUE     'Sets all Ports to digital inputs and outputs
	Movlw 7
	Movwf ADCON1
F1_000063 equ $ ; in [RFIDSY~2.BAS] INPUT HHDetect      'Set HHDetect as input
	Bsf TRISC,3
F1_000064 equ $ ; in [RFIDSY~2.BAS] OUTPUT StartEnable     'Set PORTC.0 as OutPut
	Bcf TRISC,0
START
	Bcf STATUS,5
ram_bank = 0
F1_000068 equ $ ; in [RFIDSY~2.BAS] Pause 1000
	Movlw 3
	Movwf PP1H
	Movlw 232
	F@Call dly@w
F1_000071 equ $ ; in [RFIDSY~2.BAS] B1 = "C"   'Set B1 to 'Clear' so that it is not confused when checking Employee Numbers
	Movlw 67
	Movwf B1
F1_000072 equ $ ; in [RFIDSY~2.BAS] Low Red          'Set Bi-Polar Led Off
	Bcf PORTC,2
	Bsf STATUS,5
ram_bank = 1
	Bcf TRISC,2
F1_000073 equ $ ; in [RFIDSY~2.BAS] Low Green     'Set Bi-Polar Led Off
	Bcf STATUS,5
ram_bank = 0
	Bcf PORTC,1
	Bsf STATUS,5
ram_bank = 1
	Bcf TRISC,1
F1_000074 equ $ ; in [RFIDSY~2.BAS] High RFIDEnable            ' Turn off RFID Reader
	Bcf STATUS,5
ram_bank = 0
	Bsf PORTD,4
	Bsf STATUS,5
ram_bank = 1
	Bcf TRISD,4
F1_000075 equ $ ; in [RFIDSY~2.BAS] High StartEnable       'Shut off start relay
	Bcf STATUS,5
ram_bank = 0
	Bsf PORTC,0
	Bsf STATUS,5
ram_bank = 1
	Bcf TRISC,0
F1_000076 equ $ ; in [RFIDSY~2.BAS] High RFIDEnable       'Shut Off RFID Reader
	Bcf STATUS,5
ram_bank = 0
	Bsf PORTD,4
	Bsf STATUS,5
ram_bank = 1
	Bcf TRISD,4
F1_000077 equ $ ; in [RFIDSY~2.BAS] GIE = 0      ' Turn OFF global interrupts
	Bcf INTCON,7
F1_000078 equ $ ; in [RFIDSY~2.BAS] WHILE GIE = 1 : GIE = 0 : WEND  ' And make sure they are off
bc@ll1
	Bcf STATUS,5
ram_bank = 0
	set@page bc@ll2
	Btfss INTCON,7
	Goto bc@ll2

	Bcf INTCON,7
	F@Jump bc@ll1
bc@ll2
F1_000079 equ $ ; in [RFIDSY~2.BAS] INTCON.4 = 0             'Set wakeup on PortB.0 to off
	Bcf INTCON,4
F1_000087 equ $ ; in [RFIDSY~2.BAS] Print $FE, $0F       'Blinking Cursor ON
	Movlw 254
	F@Call Print
	Movlw 15
	F@Call Print
F1_000088 equ $ ; in [RFIDSY~2.BAS] CLS               'Clear LCD
	F@Call Lcd@Cls
F1_000089 equ $ ; in [RFIDSY~2.BAS] PRINT $FE , 2       'Move Cursor to HOME
	Movlw 254
	F@Call Print
	Movlw 2
	F@Call Print
F1_000091 equ $ ; in [RFIDSY~2.BAS] TagOffset = 3        'Unit key table OffSet
	Movlw 3
	Movwf TAGOFFSET
F1_000092 equ $ ; in [RFIDSY~2.BAS] NUA = EREAD 255        'Set 'NUA' to next empty user address in Table
	Movlw 255
	F@Call Ee_rd
	Movwf NUA
F1_000094 equ $ ; in [RFIDSY~2.BAS] If NUA = 0xFF then   'If User address spot = 0xFF then chip is new
	Incf NUA,W
	set@page bc@ll4
	Btfss STATUS,2
	Goto bc@ll4
F1_000095 equ $ ; in [RFIDSY~2.BAS] CLS
	F@Call Lcd@Cls
F1_000096 equ $ ; in [RFIDSY~2.BAS] Print AT 1,1, "Please get ready"
	Movlw 128
	Movwf BPFH
	Movlw 128
	F@Call LCD@crs
	Movlw 'P'
	F@Call Print
	Movlw 'l'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'g'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 'd'
	F@Call Print
	Movlw 'y'
	F@Call Print
F1_000097 equ $ ; in [RFIDSY~2.BAS] Print AT 2,1, "to insert new"
	Movlw 128
	Movwf BPFH
	Movlw 192
	F@Call LCD@crs
	Movlw 't'
	F@Call Print
	Movlw 'o'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'i'
	F@Call Print
	Movlw 'n'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'n'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'w'
	F@Call Print
F1_000098 equ $ ; in [RFIDSY~2.BAS] Print AT 1,17, "Master Key"
	Movlw 128
	Movwf BPFH
	Movlw 144
	F@Call LCD@crs
	Movlw 'M'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'K'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'y'
	F@Call Print
F1_000099 equ $ ; in [RFIDSY~2.BAS] Pause 3000
	Movlw 11
	Movwf PP1H
	Movlw 184
	F@Call dly@w
F1_000100 equ $ ; in [RFIDSY~2.BAS] Gosub ReadTag    'Read the Master Tag
	F@Call READTAG
F1_000101 equ $ ; in [RFIDSY~2.BAS] GoSub WriteMaster   'Write Master Tag to Memory Spot 0 (Zero)
	F@Call WRITEMASTER
F1_000102 equ $ ; in [RFIDSY~2.BAS] Gosub GoodSound
	F@Call GOODSOUND
F1_000103 equ $ ; in [RFIDSY~2.BAS] CLS
	F@Call Lcd@Cls
F1_000104 equ $ ; in [RFIDSY~2.BAS] Print AT 1,1, "Master Inserted!"
	Movlw 128
	Movwf BPFH
	Movlw 128
	F@Call LCD@crs
	Movlw 'M'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'I'
	F@Call Print
	Movlw 'n'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'd'
	F@Call Print
	Movlw '!'
	F@Call Print
F1_000105 equ $ ; in [RFIDSY~2.BAS] Pause 3000
	Movlw 11
	Movwf PP1H
	Movlw 184
	F@Call dly@w
F1_000106 equ $ ; in [RFIDSY~2.BAS] EWrite 255,[5]    'This is the first User address spot. (0-4 is used by 'Master Key')
	Bsf STATUS,6
ram_bank = 2
	Movlw 255
	Movwf EEADR
	Movlw 5
	Bcf STATUS,6
ram_bank = 0
	F@Call Ee_wr
F1_000107 equ $ ; in [RFIDSY~2.BAS] NUA = 5
	Movlw 5
	Movwf NUA
F1_000108 equ $ ; in [RFIDSY~2.BAS] EWRITE 254, [202]  'This is the first spot for User History records
	Movlw 254
	Bsf STATUS,6
ram_bank = 2
	Movwf EEADR
	Movlw 202
	Bcf STATUS,6
ram_bank = 0
	F@Call Ee_wr
F1_000109 equ $ ; in [RFIDSY~2.BAS] GoTo MainMenu
	F@Jump MAINMENU
F1_000110 equ $ ; in [RFIDSY~2.BAS] ENDIF
bc@ll4
F1_000111 equ $ ; in [RFIDSY~2.BAS] NUA = EREAD 255
	Movlw 255
	F@Call Ee_rd
	Movwf NUA
F1_000113 equ $ ; in [RFIDSY~2.BAS] If HHDetect = 1 then 'We have detected that the programming HandHeld is plugged in.
	set@page bc@ll6
	Btfss PORTC,3
	Goto bc@ll6
F1_000114 equ $ ; in [RFIDSY~2.BAS] CLS
	F@Call Lcd@Cls
F1_000115 equ $ ; in [RFIDSY~2.BAS] Print AT 1,1, "Welcome to"
	Movlw 128
	Movwf BPFH
	Movlw 128
	F@Call LCD@crs
	Movlw 'W'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'l'
	F@Call Print
	Movlw 'c'
	F@Call Print
	Movlw 'o'
	F@Call Print
	Movlw 'm'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'o'
	F@Call Print
F1_000116 equ $ ; in [RFIDSY~2.BAS] Print AT 2,1, "KeyBusters..."
	Movlw 128
	Movwf BPFH
	Movlw 192
	F@Call LCD@crs
	Movlw 'K'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'y'
	F@Call Print
	Movlw 'B'
	F@Call Print
	Movlw 'u'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw '.'
	F@Call Print
	F@Call Print
	F@Call Print
F1_000117 equ $ ; in [RFIDSY~2.BAS] Print At 1,17,"Please scan"
	Movlw 128
	Movwf BPFH
	Movlw 144
	F@Call LCD@crs
	Movlw 'P'
	F@Call Print
	Movlw 'l'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 'c'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 'n'
	F@Call Print
F1_000118 equ $ ; in [RFIDSY~2.BAS] Print at 2,17, "Master Key"
	Movlw 128
	Movwf BPFH
	Movlw 208
	F@Call LCD@crs
	Movlw 'M'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'K'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'y'
	F@Call Print
F1_000120 equ $ ; in [RFIDSY~2.BAS] GoSub ReadAgain          'Go read the key
	F@Call READAGAIN
F1_000122 equ $ ; in [RFIDSY~2.BAS] If Flag = 0 then  'Tag could not be read or wrong Tag
	set@page bc@ll8
	Btfsc _B#VR1,0
	Goto bc@ll8
F1_000123 equ $ ; in [RFIDSY~2.BAS] Gosub BadSound
	F@Call BADSOUND
F1_000124 equ $ ; in [RFIDSY~2.BAS] CLS
	F@Call Lcd@Cls
F1_000125 equ $ ; in [RFIDSY~2.BAS] Print AT 1,1,"Could not read"
	Movlw 128
	Movwf BPFH
	Movlw 128
	F@Call LCD@crs
	Movlw 'C'
	F@Call Print
	Movlw 'o'
	F@Call Print
	Movlw 'u'
	F@Call Print
	Movlw 'l'
	F@Call Print
	Movlw 'd'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'n'
	F@Call Print
	Movlw 'o'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 'd'
	F@Call Print
F1_000126 equ $ ; in [RFIDSY~2.BAS] Print AT 2,1,"Master Tag."
	Movlw 128
	Movwf BPFH
	Movlw 192
	F@Call LCD@crs
	Movlw 'M'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'T'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 'g'
	F@Call Print
	Movlw '.'
	F@Call Print
F1_000127 equ $ ; in [RFIDSY~2.BAS] Pause 3000
	Movlw 11
	Movwf PP1H
	Movlw 184
	F@Call dly@w
F1_000128 equ $ ; in [RFIDSY~2.BAS] Goto GoSleep
	F@Jump GOSLEEP
F1_000129 equ $ ; in [RFIDSY~2.BAS] ENDIF 'Flag = 0
bc@ll8
F1_000131 equ $ ; in [RFIDSY~2.BAS] GoSub CheckMaster     'Check for correct Master key
	F@Call CHECKMASTER
F1_000133 equ $ ; in [RFIDSY~2.BAS] If Flag = 0 then
	set@page bc@ll10
	Btfsc _B#VR1,0
	Goto bc@ll10
F1_000134 equ $ ; in [RFIDSY~2.BAS] Gosub BadSound
	F@Call BADSOUND
F1_000135 equ $ ; in [RFIDSY~2.BAS] CLS
	F@Call Lcd@Cls
F1_000136 equ $ ; in [RFIDSY~2.BAS] Print AT 1,1,"This key is"
	Movlw 128
	Movwf BPFH
	Movlw 128
	F@Call LCD@crs
	Movlw 'T'
	F@Call Print
	Movlw 'h'
	F@Call Print
	Movlw 'i'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'k'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'y'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'i'
	F@Call Print
	Movlw 's'
	F@Call Print
F1_000137 equ $ ; in [RFIDSY~2.BAS] Print AT 2,1,"not the Master"
	Movlw 128
	Movwf BPFH
	Movlw 192
	F@Call LCD@crs
	Movlw 'n'
	F@Call Print
	Movlw 'o'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'h'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'M'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'r'
	F@Call Print
F1_000138 equ $ ; in [RFIDSY~2.BAS] Print AT 1,17,"Key."
	Movlw 128
	Movwf BPFH
	Movlw 144
	F@Call LCD@crs
	Movlw 'K'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'y'
	F@Call Print
	Movlw '.'
	F@Call Print
F1_000139 equ $ ; in [RFIDSY~2.BAS] Pause 3000
	Movlw 11
	Movwf PP1H
	Movlw 184
	F@Call dly@w
F1_000140 equ $ ; in [RFIDSY~2.BAS] Goto GoSleep       'Master key was not correct so we go to sleep.
	F@Jump GOSLEEP
F1_000141 equ $ ; in [RFIDSY~2.BAS] ENDIF 'Flag = 0
bc@ll10
F1_000142 equ $ ; in [RFIDSY~2.BAS] Gosub GoodSound
	F@Call GOODSOUND
F1_000143 equ $ ; in [RFIDSY~2.BAS] CLS
	F@Call Lcd@Cls
F1_000144 equ $ ; in [RFIDSY~2.BAS] Print AT 1,1, "Master Key"  'Master Key was correct so we go to the Main Menu
	Movlw 128
	Movwf BPFH
	Movlw 128
	F@Call LCD@crs
	Movlw 'M'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'K'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'y'
	F@Call Print
F1_000145 equ $ ; in [RFIDSY~2.BAS] Print AT 2,1,"accepted!"
	Movlw 128
	Movwf BPFH
	Movlw 192
	F@Call LCD@crs
	Movlw 'a'
	F@Call Print
	Movlw 'c'
	F@Call Print
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'p'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'd'
	F@Call Print
	Movlw '!'
	F@Call Print
F1_000146 equ $ ; in [RFIDSY~2.BAS] Pause 2000
	Movlw 7
	Movwf PP1H
	Movlw 208
	F@Call dly@w
F1_000147 equ $ ; in [RFIDSY~2.BAS] GOTO MainMenu
	F@Jump MAINMENU
	F@Jump bc@ll11
bc@ll6
F1_000149 equ $ ; in [RFIDSY~2.BAS] ELSE 'HHDetect = 1         'Hand Held programmer was not detected so          '
F1_000150 equ $ ; in [RFIDSY~2.BAS] CLS
	F@Call Lcd@Cls
F1_000151 equ $ ; in [RFIDSY~2.BAS] Print AT 1,1, "Ready to"  'we will attempt to get a user key and
	Movlw 128
	Movwf BPFH
	Movlw 128
	F@Call LCD@crs
	Movlw 'R'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 'd'
	F@Call Print
	Movlw 'y'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'o'
	F@Call Print
F1_000152 equ $ ; in [RFIDSY~2.BAS] Print At 2,1, "Start Unit"  'start the unit.
	Movlw 128
	Movwf BPFH
	Movlw 192
	F@Call LCD@crs
	Movlw 'S'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'U'
	F@Call Print
	Movlw 'n'
	F@Call Print
	Movlw 'i'
	F@Call Print
	Movlw 't'
	F@Call Print
F1_000153 equ $ ; in [RFIDSY~2.BAS] Goto StartUnit
	F@Jump STARTUNIT
F1_000155 equ $ ; in [RFIDSY~2.BAS] ENDIF 'HHDetect = 1
bc@ll11
F2_SOF equ $ ; GETKEY.INC
GETKEY
F2_000004 equ $ ; in [GETKEY.INC] Delayms 50                    ' Debounce
	Movlw 50
	F@Call dl@ms
GETKEYU
F2_000008 equ $ ; in [GETKEY.INC] PORTB = 0                   ' All output pins low
	Clrf PORTB
F2_000009 equ $ ; in [GETKEY.INC] TRISB = $F0  '1111 binary            ' Bottom 4 pins out, top 4 pins in
	Movlw 240
	Bsf STATUS,5
ram_bank = 1
	Movwf TRISB
F2_000010 equ $ ; in [GETKEY.INC] If (PORTB >> 4) <> $0F Then Getkeyu    ' If any keys down, loop
	Bcf STATUS,5
ram_bank = 0
	Clrf PBP#VAR0H
	Swapf PORTB,W
	Andlw 15
	Movwf PBP#VAR0
	Movfw PBP#VAR0
	Xorlw 15
	Iorwf PBP#VAR0H,W
	set@page bc@ll13
	Btfsc STATUS,2
	Goto bc@ll13
	F@Jump GETKEYU
bc@ll13
F2_000011 equ $ ; in [GETKEY.INC] Delayms 50                    ' Debounce
	Movlw 50
	F@Call dl@ms
GETKEYP
F2_000015 equ $ ; in [GETKEY.INC] For Col = 0 to 3            ' 4 columns in keypad
	Clrf COL
fr@lb15
	Movlw 4
	Subwf COL,W
	set@page nx@lb16
	Btfsc STATUS,0
	Goto nx@lb16
F2_000016 equ $ ; in [GETKEY.INC] PORTB = 0            ' All output pins low
	Clrf PORTB
F2_000017 equ $ ; in [GETKEY.INC] TRISB = (Dcd Col) ^ $FF    ' Set one column pin to output
	Movfw COL
	F@Call Dc@d
	Movwf PBP#VAR0
	Movfw PP0H
	Movwf PBP#VAR0H
	Movlw 255
	Xorwf PBP#VAR0,W
	Bsf STATUS,5
ram_bank = 1
	Movwf TRISB
F2_000018 equ $ ; in [GETKEY.INC] Row = PORTB >> 4           ' Read row
	Bcf STATUS,5
ram_bank = 0
	Swapf PORTB,W
	Andlw 15
	Movwf ROW
F2_000019 equ $ ; in [GETKEY.INC] If Row <> $0F Then Gotkey         ' If any keydown, exit
	Movlw 15
	Subwf ROW,W
	set@page bc@ll17
	Btfsc STATUS,2
	Goto bc@ll17
	F@Jump GOTKEY
bc@ll17
F2_000020 equ $ ; in [GETKEY.INC] Next
	Incf COL,F
	set@page fr@lb15
	Btfss STATUS,2
	Goto fr@lb15
nx@lb16
F2_000021 equ $ ; in [GETKEY.INC] Goto Getkeyp                ' No keys down, go look again
	F@Jump GETKEYP
GOTKEY
F2_000024 equ $ ; in [GETKEY.INC] Key = (Col * 4) + (Ncd (Row ^ $0F))    ' Ncd is Priority encoder of a 16-bit value
	Movfw COL
	Movwf PP7
	Clrf PP7H
	Clrc
	Rlf PP7,F
	Rlf PP7H,F
	Rlf PP7,F
	Rlf PP7H,F
	Movlw 15
	Xorwf ROW,W
	Movwf PP0
	Movlw 0
	Movwf PP0H
	F@Call ncd@p
	Clrf PBP#VAR0H
	Movwf PBP#VAR0
	Movfw PP7
	Addwf PBP#VAR0,W
	Movwf KEY
F2_000025 equ $ ; in [GETKEY.INC] Select Key
F2_000026 equ $ ; in [GETKEY.INC] Case 4
	Movlw 4
	Subwf KEY,W
	set@page bc@ll19
	Btfss STATUS,2
	Goto bc@ll19
F2_000027 equ $ ; in [GETKEY.INC] Key = "U"  'Up
	Movlw 85
	Movwf KEY
	F@Jump bc@ll18
bc@ll19
F2_000028 equ $ ; in [GETKEY.INC] Case 5
	Movlw 5
	Subwf KEY,W
	set@page bc@ll22
	Btfss STATUS,2
	Goto bc@ll22
F2_000029 equ $ ; in [GETKEY.INC] Key = 4
	Movlw 4
	Movwf KEY
	F@Jump bc@ll18
bc@ll22
F2_000030 equ $ ; in [GETKEY.INC] Case 6
	Movlw 6
	Subwf KEY,W
	set@page bc@ll24
	Btfss STATUS,2
	Goto bc@ll24
F2_000031 equ $ ; in [GETKEY.INC] Key = 5
	Movlw 5
	Movwf KEY
	F@Jump bc@ll18
bc@ll24
F2_000032 equ $ ; in [GETKEY.INC] Case 7
	Movlw 7
	Subwf KEY,W
	set@page bc@ll26
	Btfss STATUS,2
	Goto bc@ll26
F2_000033 equ $ ; in [GETKEY.INC] Key = 6
	Movlw 6
	Movwf KEY
	F@Jump bc@ll18
bc@ll26
F2_000034 equ $ ; in [GETKEY.INC] Case 8
	Movlw 8
	Subwf KEY,W
	set@page bc@ll28
	Btfss STATUS,2
	Goto bc@ll28
F2_000035 equ $ ; in [GETKEY.INC] Key = "D" 'Down
	Movlw 68
	Movwf KEY
	F@Jump bc@ll18
bc@ll28
F2_000036 equ $ ; in [GETKEY.INC] Case 9
	Movlw 9
	Subwf KEY,W
	set@page bc@ll30
	Btfss STATUS,2
	Goto bc@ll30
F2_000037 equ $ ; in [GETKEY.INC] Key = 7
	Movlw 7
	Movwf KEY
	F@Jump bc@ll18
bc@ll30
F2_000038 equ $ ; in [GETKEY.INC] Case 10
	Movlw 10
	Subwf KEY,W
	set@page bc@ll32
	Btfss STATUS,2
	Goto bc@ll32
F2_000039 equ $ ; in [GETKEY.INC] Key = 8
	Movlw 8
	Movwf KEY
	F@Jump bc@ll18
bc@ll32
F2_000040 equ $ ; in [GETKEY.INC] Case 11
	Movlw 11
	Subwf KEY,W
	set@page bc@ll34
	Btfss STATUS,2
	Goto bc@ll34
F2_000041 equ $ ; in [GETKEY.INC] Key = 9
	Movlw 9
	Movwf KEY
	F@Jump bc@ll18
bc@ll34
F2_000042 equ $ ; in [GETKEY.INC] Case 12
	Movlw 12
	Subwf KEY,W
	set@page bc@ll36
	Btfss STATUS,2
	Goto bc@ll36
F2_000043 equ $ ; in [GETKEY.INC] Key = "N" '2nd
	Movlw 78
	Movwf KEY
	F@Jump bc@ll18
bc@ll36
F2_000044 equ $ ; in [GETKEY.INC] Case 13
	Movlw 13
	Subwf KEY,W
	set@page bc@ll38
	Btfss STATUS,2
	Goto bc@ll38
F2_000045 equ $ ; in [GETKEY.INC] Key = "C" 'Clear
	Movlw 67
	Movwf KEY
	F@Jump bc@ll18
bc@ll38
F2_000046 equ $ ; in [GETKEY.INC] Case 14
	Movlw 14
	Subwf KEY,W
	set@page bc@ll40
	Btfss STATUS,2
	Goto bc@ll40
F2_000047 equ $ ; in [GETKEY.INC] Key = 0
	Clrf KEY
	F@Jump bc@ll18
bc@ll40
F2_000048 equ $ ; in [GETKEY.INC] Case 15
	Movlw 15
	Subwf KEY,W
	set@page bc@ll42
	Btfss STATUS,2
	Goto bc@ll42
F2_000049 equ $ ; in [GETKEY.INC] Key = "H" 'Help
	Movlw 72
	Movwf KEY
	F@Jump bc@ll18
bc@ll42
F2_000050 equ $ ; in [GETKEY.INC] Case 16
	Movlw 16
	Subwf KEY,W
	set@page bc@ll44
	Btfss STATUS,2
	Goto bc@ll44
F2_000051 equ $ ; in [GETKEY.INC] Key = "E" 'Enter
	Movlw 69
	Movwf KEY
F2_000052 equ $ ; in [GETKEY.INC] EndSelect
bc@ll44
bc@ll18
F2_000053 equ $ ; in [GETKEY.INC] Return
	Return
F2_EOF equ $ ; GETKEY.INC
F3_SOF equ $ ; ADDNEWUSER.INC
ADDNEWUSER
F3_000004 equ $ ; in [ADDNEWUSER.INC] CLS
	F@Call Lcd@Cls
F3_000006 equ $ ; in [ADDNEWUSER.INC] NUA = EREAD 255  'Get Next user empty spot address
	Movlw 255
	F@Call Ee_rd
	Movwf NUA
F3_000007 equ $ ; in [ADDNEWUSER.INC] If NUA > 189 then   'Address 197 is then END of the last spot for Users and Tag
	Movlw 190
	Subwf NUA,W
	set@page bc@ll46
	Btfss STATUS,0
	Goto bc@ll46
ANULOOP2
F3_000009 equ $ ; in [ADDNEWUSER.INC] ANULoop2:  Gosub BadSound
	F@Call BADSOUND
F3_000010 equ $ ; in [ADDNEWUSER.INC] CLS
	F@Call Lcd@Cls
F3_000011 equ $ ; in [ADDNEWUSER.INC] Print AT 1,1, "Memory is full!"
	Movlw 128
	Movwf BPFH
	Movlw 128
	F@Call LCD@crs
	Movlw 'M'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'm'
	F@Call Print
	Movlw 'o'
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw 'y'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'i'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'f'
	F@Call Print
	Movlw 'u'
	F@Call Print
	Movlw 'l'
	F@Call Print
	F@Call Print
	Movlw '!'
	F@Call Print
F3_000012 equ $ ; in [ADDNEWUSER.INC] Print At 2,1, "You must delete"
	Movlw 128
	Movwf BPFH
	Movlw 192
	F@Call LCD@crs
	Movlw 'Y'
	F@Call Print
	Movlw 'o'
	F@Call Print
	Movlw 'u'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'm'
	F@Call Print
	Movlw 'u'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'd'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'l'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'e'
	F@Call Print
F3_000013 equ $ ; in [ADDNEWUSER.INC] Print AT 1,17, "a User."
	Movlw 128
	Movwf BPFH
	Movlw 144
	F@Call LCD@crs
	Movlw 'a'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'U'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw '.'
	F@Call Print
F3_000014 equ $ ; in [ADDNEWUSER.INC] Print AT 2,17, "Press Enter"
	Movlw 128
	Movwf BPFH
	Movlw 208
	F@Call LCD@crs
	Movlw 'P'
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 's'
	F@Call Print
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'E'
	F@Call Print
	Movlw 'n'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'r'
	F@Call Print
F3_000015 equ $ ; in [ADDNEWUSER.INC] Gosub Getkey
	F@Call GETKEY
F3_000017 equ $ ; in [ADDNEWUSER.INC] If Key = "E" then
	Movlw 69
	Subwf KEY,W
	set@page bc@ll48
	Btfss STATUS,2
	Goto bc@ll48
F3_000018 equ $ ; in [ADDNEWUSER.INC] Goto MainMenu
	F@Jump MAINMENU
	F@Jump bc@ll49
bc@ll48
F3_000019 equ $ ; in [ADDNEWUSER.INC] Else
F3_000020 equ $ ; in [ADDNEWUSER.INC] Goto ANUloop2 'Wrong Key
	F@Jump ANULOOP2
F3_000021 equ $ ; in [ADDNEWUSER.INC] ENDIF 'Key = E
bc@ll49
F3_000022 equ $ ; in [ADDNEWUSER.INC] ENDIF 'NUA > 189
bc@ll46
F3_000025 equ $ ; in [ADDNEWUSER.INC] GoSub GetEmployee#      'Get EmployeeID form KeyPad
	F@Call GETEMPLOYEE#
F3_000026 equ $ ; in [ADDNEWUSER.INC] Gosub CheckUser      'Check that user does not already exist.
	F@Call CHECKUSER
F3_000028 equ $ ; in [ADDNEWUSER.INC] GoSub ReadTag 'User will scan Tag
	F@Call READTAG
F3_000029 equ $ ; in [ADDNEWUSER.INC] If Flag = 0 then goto MainMenu
	set@page bc@ll51
	Btfsc _B#VR1,0
	Goto bc@ll51
	F@Jump MAINMENU
bc@ll51
F3_000030 equ $ ; in [ADDNEWUSER.INC] GoSub CheckMaster  'Check that we are not trying to use the Master Key for a user
	F@Call CHECKMASTER
F3_000031 equ $ ; in [ADDNEWUSER.INC] If Flag = 1 then
	set@page bc@ll53
	Btfss _B#VR1,0
	Goto bc@ll53
F3_000032 equ $ ; in [ADDNEWUSER.INC] Gosub BadSound
	F@Call BADSOUND
F3_000033 equ $ ; in [ADDNEWUSER.INC] CLS
	F@Call Lcd@Cls
F3_000034 equ $ ; in [ADDNEWUSER.INC] Print AT 1,1, "Master Key"
	Movlw 128
	Movwf BPFH
	Movlw 128
	F@Call LCD@crs
	Movlw 'M'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'K'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'y'
	F@Call Print
F3_000035 equ $ ; in [ADDNEWUSER.INC] Print AT 2,1, "detected!!"
	Movlw 128
	Movwf BPFH
	Movlw 192
	F@Call LCD@crs
	Movlw 'd'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'c'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'd'
	F@Call Print
	Movlw '!'
	F@Call Print
	F@Call Print
F3_000036 equ $ ; in [ADDNEWUSER.INC] Print AT 1,17, "Please use"
	Movlw 128
	Movwf BPFH
	Movlw 144
	F@Call LCD@crs
	Movlw 'P'
	F@Call Print
	Movlw 'l'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'u'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 'e'
	F@Call Print
F3_000037 equ $ ; in [ADDNEWUSER.INC] Print AT 2,17, "another Key!"
	Movlw 128
	Movwf BPFH
	Movlw 208
	F@Call LCD@crs
	Movlw 'a'
	F@Call Print
	Movlw 'n'
	F@Call Print
	Movlw 'o'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'h'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'K'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'y'
	F@Call Print
	Movlw '!'
	F@Call Print
F3_000038 equ $ ; in [ADDNEWUSER.INC] Pause 4000
	Movlw 15
	Movwf PP1H
	Movlw 160
	F@Call dly@w
F3_000039 equ $ ; in [ADDNEWUSER.INC] Goto MainMenu
	F@Jump MAINMENU
F3_000040 equ $ ; in [ADDNEWUSER.INC] ENDIF 'Flag = 1 (for Master)
bc@ll53
F3_000041 equ $ ; in [ADDNEWUSER.INC] GoSub CheckTag 'Make sure another User is not already using this Tag
	F@Call CHECKTAG
F3_000042 equ $ ; in [ADDNEWUSER.INC] If Flag = 1 then          'Tag does exist
	set@page bc@ll55
	Btfss _B#VR1,0
	Goto bc@ll55
TAGEXISTS
F3_000043 equ $ ; in [ADDNEWUSER.INC] TagExists:    Currentline = Index2
	Movfw INDEX2
	Movwf CURRENTLINE
F3_000044 equ $ ; in [ADDNEWUSER.INC] Gosub Get#
	F@Call GET#
F3_000045 equ $ ; in [ADDNEWUSER.INC] Gosub Split
	F@Call SPLIT
F3_000046 equ $ ; in [ADDNEWUSER.INC] Gosub BadSound
	F@Call BADSOUND
F3_000047 equ $ ; in [ADDNEWUSER.INC] CLS
	F@Call Lcd@Cls
F3_000048 equ $ ; in [ADDNEWUSER.INC] Print AT 1,1, "Tag belongs to"
	Movlw 128
	Movwf BPFH
	Movlw 128
	F@Call LCD@crs
	Movlw 'T'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 'g'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'b'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'l'
	F@Call Print
	Movlw 'o'
	F@Call Print
	Movlw 'n'
	F@Call Print
	Movlw 'g'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'o'
	F@Call Print
F3_000049 equ $ ; in [ADDNEWUSER.INC] Print AT 2,1, "User# ", DEC EmpIN[0], DEC EmpIN[1], DEC EmpIN[2], DEC EmpIN[3], DEC EmpIN[4], DEC EmpIN[5]
	Movlw 128
	Movwf BPFH
	Movlw 192
	F@Call LCD@crs
	Movlw 'U'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw '#'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movfw EMPIN#0
	F@Call out@decb
	Movfw EMPIN#1
	F@Call out@decb
	Movfw EMPIN#2
	F@Call out@decb
	Movfw EMPIN#3
	F@Call out@decb
	Movfw EMPIN#4
	F@Call out@decb
	Movfw EMPIN#5
	F@Call out@decb
F3_000050 equ $ ; in [ADDNEWUSER.INC] Print AT 1,17, "(1) Delete User"
	Movlw 128
	Movwf BPFH
	Movlw 144
	F@Call LCD@crs
	Movlw '('
	F@Call Print
	Movlw '1'
	F@Call Print
	Movlw ')'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'D'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'l'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'U'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'r'
	F@Call Print
F3_000051 equ $ ; in [ADDNEWUSER.INC] Print At 2,17, "(2) Start Over"
	Movlw 128
	Movwf BPFH
	Movlw 208
	F@Call LCD@crs
	Movlw '('
	F@Call Print
	Movlw '2'
	F@Call Print
	Movlw ')'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'S'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'O'
	F@Call Print
	Movlw 'v'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'r'
	F@Call Print
F3_000052 equ $ ; in [ADDNEWUSER.INC] B1 = "C"
	Movlw 67
	Movwf B1
F3_000053 equ $ ; in [ADDNEWUSER.INC] GOSUB GetKey
	F@Call GETKEY
F3_000054 equ $ ; in [ADDNEWUSER.INC] Select Key
F3_000055 equ $ ; in [ADDNEWUSER.INC] Case 2 'Choice was not to delete Tag
	Movlw 2
	Subwf KEY,W
	set@page bc@ll57
	Btfss STATUS,2
	Goto bc@ll57
F3_000056 equ $ ; in [ADDNEWUSER.INC] GoTo MainMenu  'Exit adding Tag
	F@Jump MAINMENU
	F@Jump bc@ll56
bc@ll57
F3_000057 equ $ ; in [ADDNEWUSER.INC] Case 1 'Yes, delete this Tag and OLD user and use it for this NEW user.
	Movlw 1
	Subwf KEY,W
	set@page bc@ll60
	Btfss STATUS,2
	Goto bc@ll60
F3_000058 equ $ ; in [ADDNEWUSER.INC] CLS
	F@Call Lcd@Cls
F3_000059 equ $ ; in [ADDNEWUSER.INC] Print AT 1,1, "Tag will be"
	Movlw 128
	Movwf BPFH
	Movlw 128
	F@Call LCD@crs
	Movlw 'T'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 'g'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'w'
	F@Call Print
	Movlw 'i'
	F@Call Print
	Movlw 'l'
	F@Call Print
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'b'
	F@Call Print
	Movlw 'e'
	F@Call Print
F3_000060 equ $ ; in [ADDNEWUSER.INC] Print AT 2,1, "assigned to new"
	Movlw 128
	Movwf BPFH
	Movlw 192
	F@Call LCD@crs
	Movlw 'a'
	F@Call Print
	Movlw 's'
	F@Call Print
	F@Call Print
	Movlw 'i'
	F@Call Print
	Movlw 'g'
	F@Call Print
	Movlw 'n'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'd'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'o'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'n'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'w'
	F@Call Print
F3_000061 equ $ ; in [ADDNEWUSER.INC] Print AT 1,17, "User "
	Movlw 128
	Movwf BPFH
	Movlw 144
	F@Call LCD@crs
	Movlw 'U'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw ' '
	F@Call Print
F3_000062 equ $ ; in [ADDNEWUSER.INC] Print DEC EmpIN[0]
	Movlw 128
	Movwf BPFH
	Movfw EMPIN#0
	F@Call out@decb
F3_000063 equ $ ; in [ADDNEWUSER.INC] Print DEC EmpIN[1]
	Movlw 128
	Movwf BPFH
	Movfw EMPIN#1
	F@Call out@decb
F3_000064 equ $ ; in [ADDNEWUSER.INC] Print DEC EmpIN[2]
	Movlw 128
	Movwf BPFH
	Movfw EMPIN#2
	F@Call out@decb
F3_000065 equ $ ; in [ADDNEWUSER.INC] Print DEC EmpIN[3]
	Movlw 128
	Movwf BPFH
	Movfw EMPIN#3
	F@Call out@decb
F3_000066 equ $ ; in [ADDNEWUSER.INC] Print DEC EmpIN[4]
	Movlw 128
	Movwf BPFH
	Movfw EMPIN#4
	F@Call out@decb
F3_000067 equ $ ; in [ADDNEWUSER.INC] Print DEC EmpIN[5]
	Movlw 128
	Movwf BPFH
	Movfw EMPIN#5
	F@Call out@decb
F3_000068 equ $ ; in [ADDNEWUSER.INC] Pause 4000
	Movlw 15
	Movwf PP1H
	Movlw 160
	F@Call dly@w
F3_000069 equ $ ; in [ADDNEWUSER.INC] GoTo DeleteTag
	F@Jump DELETETAG
F3_000070 equ $ ; in [ADDNEWUSER.INC] Case Else 'Key was not 1 or 2"
	F@Jump bc@ll62
bc@ll60
F3_000071 equ $ ; in [ADDNEWUSER.INC] Goto TagExists
	F@Jump TAGEXISTS
F3_000072 equ $ ; in [ADDNEWUSER.INC] EndSelect
bc@ll62
bc@ll56
DELETETAG
F3_000074 equ $ ; in [ADDNEWUSER.INC] DeleteTag:     If Index2  = EndLine - 8  then 'If the Employee# is the last one in the table then
	Movlw low (-8)
	Addwf ENDLINE,W
	Movwf PBP#VAR0
	Movlw low ((-8) >> 8)
	Skpnc
	Addlw 1
	Movwf PBP#VAR0H
	Movfw PBP#VAR0H
	set@page bc@ll64
	Btfss STATUS,2
	Goto bc@ll64
	Movfw PBP#VAR0
	Subwf INDEX2,W
	set@page bc@ll64
	Btfss STATUS,2
	Goto bc@ll64
F3_000075 equ $ ; in [ADDNEWUSER.INC] NUA = NUA - 8   'remove last entry
	Movlw 8
	Subwf NUA,F
F3_000076 equ $ ; in [ADDNEWUSER.INC] EWRITE 255, [NUA]
	Bsf STATUS,6
ram_bank = 2
	Movlw 255
	Movwf EEADR
	Bcf STATUS,6
ram_bank = 0
	Movfw NUA
	F@Call Ee_wr
	F@Jump bc@ll65
bc@ll64
F3_000077 equ $ ; in [ADDNEWUSER.INC] Else
F3_000078 equ $ ; in [ADDNEWUSER.INC] GoSub MoveSpot 'Located in 'Check User' module
	F@Call MOVESPOT
F3_000079 equ $ ; in [ADDNEWUSER.INC] ENDIF 'Index2 = EndLine - 8
bc@ll65
F3_000081 equ $ ; in [ADDNEWUSER.INC] ENDIF 'Flag = 1 (for Tag)
bc@ll55
F3_000082 equ $ ; in [ADDNEWUSER.INC] GoSub WriteTag 'Write Tag into memory
	F@Call WRITETAG
F3_000083 equ $ ; in [ADDNEWUSER.INC] Gosub GoodSound
	F@Call GOODSOUND
F3_000084 equ $ ; in [ADDNEWUSER.INC] CLS
	F@Call Lcd@Cls
F3_000085 equ $ ; in [ADDNEWUSER.INC] Print AT 1,1, "Tag & User#"
	Movlw 128
	Movwf BPFH
	Movlw 128
	F@Call LCD@crs
	Movlw 'T'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 'g'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw '&'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'U'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw '#'
	F@Call Print
F3_000086 equ $ ; in [ADDNEWUSER.INC] Print AT 2,1, "Inserted"
	Movlw 128
	Movwf BPFH
	Movlw 192
	F@Call LCD@crs
	Movlw 'I'
	F@Call Print
	Movlw 'n'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'd'
	F@Call Print
F3_000087 equ $ ; in [ADDNEWUSER.INC] Pause 4000
	Movlw 15
	Movwf PP1H
	Movlw 160
	F@Call dly@w
F3_000088 equ $ ; in [ADDNEWUSER.INC] Goto MainMenu
	F@Jump MAINMENU
F3_EOF equ $ ; ADDNEWUSER.INC
F4_SOF equ $ ; GETUSER#.INC
GETEMPLOYEE#
F4_000003 equ $ ; in [GETUSER#.INC] GetEmployee#:  CLS
	F@Call Lcd@Cls
F4_000004 equ $ ; in [GETUSER#.INC] Print AT 2,1, "Enter User #"
	Movlw 128
	Movwf BPFH
	Movlw 192
	F@Call LCD@crs
	Movlw 'E'
	F@Call Print
	Movlw 'n'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'U'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw '#'
	F@Call Print
F4_000005 equ $ ; in [GETUSER#.INC] Print AT 1,17, "(6 Digits)"
	Movlw 128
	Movwf BPFH
	Movlw 144
	F@Call LCD@crs
	Movlw '('
	F@Call Print
	Movlw '6'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'D'
	F@Call Print
	Movlw 'i'
	F@Call Print
	Movlw 'g'
	F@Call Print
	Movlw 'i'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw ')'
	F@Call Print
F4_000006 equ $ ; in [GETUSER#.INC] Print AT 2,17, "CLEAR to Exit"
	Movlw 128
	Movwf BPFH
	Movlw 208
	F@Call LCD@crs
	Movlw 'C'
	F@Call Print
	Movlw 'L'
	F@Call Print
	Movlw 'E'
	F@Call Print
	Movlw 'A'
	F@Call Print
	Movlw 'R'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'o'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'E'
	F@Call Print
	Movlw 'x'
	F@Call Print
	Movlw 'i'
	F@Call Print
	Movlw 't'
	F@Call Print
F4_000007 equ $ ; in [GETUSER#.INC] Print $FE, 2  'Jump to first line for input
	Movlw 254
	F@Call Print
	Movlw 2
	F@Call Print
F4_000008 equ $ ; in [GETUSER#.INC] For Index = 0 to 5   'Set up array for Employee # digits
	Clrf INDEX
fr@lb67
	Movlw 6
	Subwf INDEX,W
	set@page nx@lb68
	Btfsc STATUS,0
	Goto nx@lb68
GETEMPLOOP1
F4_000009 equ $ ; in [GETUSER#.INC] GetEmpLoop1:  Gosub GetKey     'Get User keypress
	F@Call GETKEY
F4_000010 equ $ ; in [GETUSER#.INC] SELECT Key    'Check to see if it is 0-9
F4_000011 equ $ ; in [GETUSER#.INC] CASE 0 TO 9
	Movlw 10
	Subwf KEY,W
	set@page bc@ll69
	Btfsc STATUS,0
	Goto bc@ll69
F4_000012 equ $ ; in [GETUSER#.INC] EmpIN[Index] = Key  'Place digit into EmpIn array
	Movfw INDEX
	Addlw EMPIN
	Movwf FSR
	Movfw KEY
	Movwf INDF
F4_000013 equ $ ; in [GETUSER#.INC] Print DEC Key   'Echo Key to LCD
	Movlw 128
	Movwf BPFH
	Movfw KEY
	F@Call out@decb
	F@Jump bc@ll68
bc@ll69
F4_000014 equ $ ; in [GETUSER#.INC] Case "C"
	Movlw 67
	Subwf KEY,W
	set@page bc@ll72
	Btfss STATUS,2
	Goto bc@ll72
F4_000015 equ $ ; in [GETUSER#.INC] Goto MainMenu
	F@Jump MAINMENU
F4_000016 equ $ ; in [GETUSER#.INC] CASE ELSE
	F@Jump bc@ll74
bc@ll72
F4_000017 equ $ ; in [GETUSER#.INC] Goto GetEmpLoop1   'Key is not digit (0-9)
	F@Jump GETEMPLOOP1
F4_000018 equ $ ; in [GETUSER#.INC] ENDSELECT
bc@ll74
bc@ll68
F4_000019 equ $ ; in [GETUSER#.INC] Next 'Index    Next Digit
	Incf INDEX,F
	set@page fr@lb67
	Btfss STATUS,2
	Goto fr@lb67
nx@lb68
F4_000021 equ $ ; in [GETUSER#.INC] Gosub GoodSound
	F@Call GOODSOUND
F4_000022 equ $ ; in [GETUSER#.INC] CLS
	F@Call Lcd@Cls
F4_000024 equ $ ; in [GETUSER#.INC] Print $FE, 2
	Movlw 254
	F@Call Print
	Movlw 2
	F@Call Print
F4_000025 equ $ ; in [GETUSER#.INC] Print DEC EmpIN[0]
	Movlw 128
	Movwf BPFH
	Movfw EMPIN#0
	F@Call out@decb
F4_000026 equ $ ; in [GETUSER#.INC] Print DEC EmpIN[1]
	Movlw 128
	Movwf BPFH
	Movfw EMPIN#1
	F@Call out@decb
F4_000027 equ $ ; in [GETUSER#.INC] Print DEC EmpIN[2]
	Movlw 128
	Movwf BPFH
	Movfw EMPIN#2
	F@Call out@decb
F4_000028 equ $ ; in [GETUSER#.INC] Print DEC EmpIN[3]
	Movlw 128
	Movwf BPFH
	Movfw EMPIN#3
	F@Call out@decb
F4_000029 equ $ ; in [GETUSER#.INC] Print DEC EmpIN[4]
	Movlw 128
	Movwf BPFH
	Movfw EMPIN#4
	F@Call out@decb
F4_000030 equ $ ; in [GETUSER#.INC] Print DEC EmpIN[5]
	Movlw 128
	Movwf BPFH
	Movfw EMPIN#5
	F@Call out@decb
F4_000031 equ $ ; in [GETUSER#.INC] Print AT 2,1, "Is this correct?"
	Movlw 128
	Movwf BPFH
	Movlw 192
	F@Call LCD@crs
	Movlw 'I'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'h'
	F@Call Print
	Movlw 'i'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'c'
	F@Call Print
	Movlw 'o'
	F@Call Print
	Movlw 'r'
	F@Call Print
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'c'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw '?'
	F@Call Print
F4_000032 equ $ ; in [GETUSER#.INC] Print AT 1,17, "ENTER = Correct"
	Movlw 128
	Movwf BPFH
	Movlw 144
	F@Call LCD@crs
	Movlw 'E'
	F@Call Print
	Movlw 'N'
	F@Call Print
	Movlw 'T'
	F@Call Print
	Movlw 'E'
	F@Call Print
	Movlw 'R'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw '='
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'C'
	F@Call Print
	Movlw 'o'
	F@Call Print
	Movlw 'r'
	F@Call Print
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'c'
	F@Call Print
	Movlw 't'
	F@Call Print
F4_000033 equ $ ; in [GETUSER#.INC] Print AT 2,17, "CLEAR = Redo"
	Movlw 128
	Movwf BPFH
	Movlw 208
	F@Call LCD@crs
	Movlw 'C'
	F@Call Print
	Movlw 'L'
	F@Call Print
	Movlw 'E'
	F@Call Print
	Movlw 'A'
	F@Call Print
	Movlw 'R'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw '='
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'R'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'd'
	F@Call Print
	Movlw 'o'
	F@Call Print
GETEMPLOOP2
F4_000035 equ $ ; in [GETUSER#.INC] GetEmpLoop2: Gosub GetKey
	F@Call GETKEY
F4_000036 equ $ ; in [GETUSER#.INC] Select Key
F4_000037 equ $ ; in [GETUSER#.INC] Case "C"
	Movlw 67
	Subwf KEY,W
	set@page bc@ll76
	Btfss STATUS,2
	Goto bc@ll76
F4_000038 equ $ ; in [GETUSER#.INC] GoTo GetEmployee# 'Redo Employee #
	F@Jump GETEMPLOYEE#
	F@Jump bc@ll75
bc@ll76
F4_000039 equ $ ; in [GETUSER#.INC] Case "E"  'Employee number was correct
	Movlw 69
	Subwf KEY,W
	set@page bc@ll79
	Btfss STATUS,2
	Goto bc@ll79
F4_000044 equ $ ; in [GETUSER#.INC] B2 = EmpIN[0]
	Movfw EMPIN#0
	Movwf B2
F4_000045 equ $ ; in [GETUSER#.INC] B1 = EmpIN[1] 'B1 now contains Employee Digit(1)in lower bits of B1
	Movfw EMPIN#1
	Movwf B1
F4_000046 equ $ ; in [GETUSER#.INC] B1.4 = B2.0   ' Here we are adding employee digit(0)
; Bit_Bit B2,0,B1,4
	Bsf B1,4
	Btfss B2,0
	Bcf B1,4
F4_000047 equ $ ; in [GETUSER#.INC] B1.5 = B2.1   ' to the upper bits
; Bit_Bit B2,1,B1,5
	Bsf B1,5
	Btfss B2,1
	Bcf B1,5
F4_000048 equ $ ; in [GETUSER#.INC] B1.6 = B2.2   ' of B1
; Bit_Bit B2,2,B1,6
	Bsf B1,6
	Btfss B2,2
	Bcf B1,6
F4_000049 equ $ ; in [GETUSER#.INC] B1.7 = B2.3
; Bit_Bit B2,3,B1,7
	Bsf B1,7
	Btfss B2,3
	Bcf B1,7
F4_000050 equ $ ; in [GETUSER#.INC] CE[0] = B1
	Movfw B1
	Movwf CE#0
F4_000052 equ $ ; in [GETUSER#.INC] B2 = EmpIN[2] 'Same as above except for Digit(2) and Digit(3)
	Movfw EMPIN#2
	Movwf B2
F4_000053 equ $ ; in [GETUSER#.INC] B1 = EmpIN[3]
	Movfw EMPIN#3
	Movwf B1
F4_000054 equ $ ; in [GETUSER#.INC] B1.4 = B2.0
; Bit_Bit B2,0,B1,4
	Bsf B1,4
	Btfss B2,0
	Bcf B1,4
F4_000055 equ $ ; in [GETUSER#.INC] B1.5 = B2.1
; Bit_Bit B2,1,B1,5
	Bsf B1,5
	Btfss B2,1
	Bcf B1,5
F4_000056 equ $ ; in [GETUSER#.INC] B1.6 = B2.2
; Bit_Bit B2,2,B1,6
	Bsf B1,6
	Btfss B2,2
	Bcf B1,6
F4_000057 equ $ ; in [GETUSER#.INC] B1.7 = B2.3
; Bit_Bit B2,3,B1,7
	Bsf B1,7
	Btfss B2,3
	Bcf B1,7
F4_000058 equ $ ; in [GETUSER#.INC] CE[1] = B1
	Movfw B1
	Movwf CE#1
F4_000060 equ $ ; in [GETUSER#.INC] B2 = EmpIN[4] 'Same as above except for Digit(4) and Digit(5)
	Movfw EMPIN#4
	Movwf B2
F4_000061 equ $ ; in [GETUSER#.INC] B1 = EmpIN[5]
	Movfw EMPIN#5
	Movwf B1
F4_000062 equ $ ; in [GETUSER#.INC] B1.4 = B2.0
; Bit_Bit B2,0,B1,4
	Bsf B1,4
	Btfss B2,0
	Bcf B1,4
F4_000063 equ $ ; in [GETUSER#.INC] B1.5 = B2.1
; Bit_Bit B2,1,B1,5
	Bsf B1,5
	Btfss B2,1
	Bcf B1,5
F4_000064 equ $ ; in [GETUSER#.INC] B1.6 = B2.2
; Bit_Bit B2,2,B1,6
	Bsf B1,6
	Btfss B2,2
	Bcf B1,6
F4_000065 equ $ ; in [GETUSER#.INC] B1.7 = B2.3
; Bit_Bit B2,3,B1,7
	Bsf B1,7
	Btfss B2,3
	Bcf B1,7
F4_000066 equ $ ; in [GETUSER#.INC] CE[2] = B1
	Movfw B1
	Movwf CE#2
F4_000069 equ $ ; in [GETUSER#.INC] Return    'Employee# is OK.. Return
	Return
F4_000070 equ $ ; in [GETUSER#.INC] Case Else
	F@Jump bc@ll81
bc@ll79
F4_000071 equ $ ; in [GETUSER#.INC] Goto GetEmpLoop2
	F@Jump GETEMPLOOP2
F4_000072 equ $ ; in [GETUSER#.INC] EndSelect
bc@ll81
bc@ll75
F4_EOF equ $ ; GETUSER#.INC
F5_SOF equ $ ; SCROLL.INC
SCROLLUSERS
F5_000007 equ $ ; in [SCROLL.INC] CurrentLine = 0   'Setup to print on first line of LCD
	Clrf CURRENTLINE
F5_000008 equ $ ; in [SCROLL.INC] EndLine = NUA    'Set Endline to first empty spot
	Movfw NUA
	Movwf ENDLINE
STARTSCROLLAGAIN
F5_000012 equ $ ; in [SCROLL.INC] CLS
	F@Call Lcd@Cls
F5_000013 equ $ ; in [SCROLL.INC] Print AT 1,1, "Use Arrow Keys"
	Movlw 128
	Movwf BPFH
	Movlw 128
	F@Call LCD@crs
	Movlw 'U'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'A'
	F@Call Print
	Movlw 'r'
	F@Call Print
	F@Call Print
	Movlw 'o'
	F@Call Print
	Movlw 'w'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'K'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'y'
	F@Call Print
	Movlw 's'
	F@Call Print
F5_000014 equ $ ; in [SCROLL.INC] Print AT 2,1, "to Scroll."
	Movlw 128
	Movwf BPFH
	Movlw 192
	F@Call LCD@crs
	Movlw 't'
	F@Call Print
	Movlw 'o'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'S'
	F@Call Print
	Movlw 'c'
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw 'o'
	F@Call Print
	Movlw 'l'
	F@Call Print
	F@Call Print
	Movlw '.'
	F@Call Print
F5_000015 equ $ ; in [SCROLL.INC] Print AT 1,17, "'Clear' to Exit"
	Movlw 128
	Movwf BPFH
	Movlw 144
	F@Call LCD@crs
	Movlw '\''
	F@Call Print
	Movlw 'C'
	F@Call Print
	Movlw 'l'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw '\''
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'o'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'E'
	F@Call Print
	Movlw 'x'
	F@Call Print
	Movlw 'i'
	F@Call Print
	Movlw 't'
	F@Call Print
F5_000016 equ $ ; in [SCROLL.INC] Pause 4000
	Movlw 15
	Movwf PP1H
	Movlw 160
	F@Call dly@w
F5_000017 equ $ ; in [SCROLL.INC] StartLine = 5       'Set first user here if new scroll request
	Movlw 5
	Movwf STARTLINE
SCROLL
F5_000019 equ $ ; in [SCROLL.INC] Scroll:  CurrentLine = StartLine   'Set Currentline to scroll demand
	Movfw STARTLINE
	Movwf CURRENTLINE
F5_000020 equ $ ; in [SCROLL.INC] CLS
	F@Call Lcd@Cls
F5_000021 equ $ ; in [SCROLL.INC] Gosub PrintUser
	F@Call PRINTUSER
F5_000022 equ $ ; in [SCROLL.INC] GoSub GetKey
	F@Call GETKEY
F5_000023 equ $ ; in [SCROLL.INC] Select Key
F5_000024 equ $ ; in [SCROLL.INC] Case "U"
	Movlw 85
	Subwf KEY,W
	set@page bc@ll83
	Btfss STATUS,2
	Goto bc@ll83
F5_000025 equ $ ; in [SCROLL.INC] If StartLine > 5 then
	Movlw 6
	Subwf STARTLINE,W
	set@page bc@ll86
	Btfss STATUS,0
	Goto bc@ll86
F5_000026 equ $ ; in [SCROLL.INC] StartLine = StartLine - 8
	Movlw 8
	Subwf STARTLINE,F
F5_000027 equ $ ; in [SCROLL.INC] Goto Scroll
	F@Jump SCROLL
	F@Jump bc@ll87
bc@ll86
F5_000028 equ $ ; in [SCROLL.INC] ELSE
F5_000029 equ $ ; in [SCROLL.INC] CLS
	F@Call Lcd@Cls
F5_000030 equ $ ; in [SCROLL.INC] Print AT 1,1, "Start of List"
	Movlw 128
	Movwf BPFH
	Movlw 128
	F@Call LCD@crs
	Movlw 'S'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'o'
	F@Call Print
	Movlw 'f'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'L'
	F@Call Print
	Movlw 'i'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 't'
	F@Call Print
F5_000031 equ $ ; in [SCROLL.INC] Pause 1000
	Movlw 3
	Movwf PP1H
	Movlw 232
	F@Call dly@w
F5_000032 equ $ ; in [SCROLL.INC] Goto Scroll
	F@Jump SCROLL
F5_000033 equ $ ; in [SCROLL.INC] ENDIF
bc@ll87
	F@Jump bc@ll82
bc@ll83
F5_000034 equ $ ; in [SCROLL.INC] Case "D"
	Movlw 68
	Subwf KEY,W
	set@page bc@ll89
	Btfss STATUS,2
	Goto bc@ll89
F5_000035 equ $ ; in [SCROLL.INC] If StartLine + 24 < EndLine then
	Movlw 24
	Addwf STARTLINE,W
	Movwf PBP#VAR0
	Clrf PBP#VAR0H
	Rlf PBP#VAR0H,F
	Movfw PBP#VAR0H
	set@page bc@ll91
	Btfss STATUS,2
	Goto bc@ll91
	Movfw ENDLINE
	Subwf PBP#VAR0,W
	set@page bc@ll91
	Btfsc STATUS,0
	Goto bc@ll91
F5_000036 equ $ ; in [SCROLL.INC] StartLine = StartLine + 8
	Movlw 8
	Addwf STARTLINE,F
F5_000037 equ $ ; in [SCROLL.INC] Goto Scroll
	F@Jump SCROLL
	F@Jump bc@ll92
bc@ll91
F5_000038 equ $ ; in [SCROLL.INC] Else
F5_000039 equ $ ; in [SCROLL.INC] Goto Scroll
	F@Jump SCROLL
F5_000040 equ $ ; in [SCROLL.INC] ENDIF
bc@ll92
	F@Jump bc@ll82
bc@ll89
F5_000041 equ $ ; in [SCROLL.INC] Case "C"
	Movlw 67
	Subwf KEY,W
	set@page bc@ll94
	Btfss STATUS,2
	Goto bc@ll94
F5_000042 equ $ ; in [SCROLL.INC] Goto MainMenu
	F@Jump MAINMENU
F5_000043 equ $ ; in [SCROLL.INC] Case Else
	F@Jump bc@ll96
bc@ll94
F5_000044 equ $ ; in [SCROLL.INC] Goto StartScrollAgain
	F@Jump STARTSCROLLAGAIN
F5_000045 equ $ ; in [SCROLL.INC] EndSelect
bc@ll96
bc@ll82
PRINTUSER
F5_000052 equ $ ; in [SCROLL.INC] PrintUser: Gosub Get#
	F@Call GET#
F5_000053 equ $ ; in [SCROLL.INC] GoSub Split
	F@Call SPLIT
F5_000054 equ $ ; in [SCROLL.INC] PRINT AT 1,1, DEC EmpIN[0], DEC EmpIN[1], DEC EmpIN[2], DEC EmpIN[3], DEC EmpIN[4], DEC EmpIN[5]
	Movlw 128
	Movwf BPFH
	Movlw 128
	F@Call LCD@crs
	Movfw EMPIN#0
	F@Call out@decb
	Movfw EMPIN#1
	F@Call out@decb
	Movfw EMPIN#2
	F@Call out@decb
	Movfw EMPIN#3
	F@Call out@decb
	Movfw EMPIN#4
	F@Call out@decb
	Movfw EMPIN#5
	F@Call out@decb
F5_000055 equ $ ; in [SCROLL.INC] CurrentLine = CurrentLine + 8
	Movlw 8
	Addwf CURRENTLINE,F
F5_000056 equ $ ; in [SCROLL.INC] If CurrentLine = EndLine then
	Movfw CURRENTLINE
	Subwf ENDLINE,W
	set@page bc@ll98
	Btfss STATUS,2
	Goto bc@ll98
F5_000057 equ $ ; in [SCROLL.INC] Print AT 2,1, "END OF LIST"
	Movlw 128
	Movwf BPFH
	Movlw 192
	F@Call LCD@crs
	Movlw 'E'
	F@Call Print
	Movlw 'N'
	F@Call Print
	Movlw 'D'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'O'
	F@Call Print
	Movlw 'F'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'L'
	F@Call Print
	Movlw 'I'
	F@Call Print
	Movlw 'S'
	F@Call Print
	Movlw 'T'
	F@Call Print
F5_000058 equ $ ; in [SCROLL.INC] RETURN
	Return
F5_000059 equ $ ; in [SCROLL.INC] ENDIF
bc@ll98
F5_000061 equ $ ; in [SCROLL.INC] GoSUB Get#
	F@Call GET#
F5_000062 equ $ ; in [SCROLL.INC] GoSub Split
	F@Call SPLIT
F5_000063 equ $ ; in [SCROLL.INC] PRINT AT 2,1, DEC EmpIN[0], DEC EmpIN[1], DEC EmpIN[2], DEC EmpIN[3], DEC EmpIN[4], DEC EmpIN[5]
	Movlw 128
	Movwf BPFH
	Movlw 192
	F@Call LCD@crs
	Movfw EMPIN#0
	F@Call out@decb
	Movfw EMPIN#1
	F@Call out@decb
	Movfw EMPIN#2
	F@Call out@decb
	Movfw EMPIN#3
	F@Call out@decb
	Movfw EMPIN#4
	F@Call out@decb
	Movfw EMPIN#5
	F@Call out@decb
F5_000064 equ $ ; in [SCROLL.INC] CurrentLine = CurrentLine + 8
	Movlw 8
	Addwf CURRENTLINE,F
F5_000065 equ $ ; in [SCROLL.INC] If CurrentLine = EndLine then
	Movfw CURRENTLINE
	Subwf ENDLINE,W
	set@page bc@ll100
	Btfss STATUS,2
	Goto bc@ll100
F5_000066 equ $ ; in [SCROLL.INC] Print AT 1,17, "END OF LIST"
	Movlw 128
	Movwf BPFH
	Movlw 144
	F@Call LCD@crs
	Movlw 'E'
	F@Call Print
	Movlw 'N'
	F@Call Print
	Movlw 'D'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'O'
	F@Call Print
	Movlw 'F'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'L'
	F@Call Print
	Movlw 'I'
	F@Call Print
	Movlw 'S'
	F@Call Print
	Movlw 'T'
	F@Call Print
F5_000067 equ $ ; in [SCROLL.INC] RETURN
	Return
F5_000068 equ $ ; in [SCROLL.INC] ENDIF
bc@ll100
F5_000070 equ $ ; in [SCROLL.INC] GoSUB Get#
	F@Call GET#
F5_000071 equ $ ; in [SCROLL.INC] GoSub Split
	F@Call SPLIT
F5_000072 equ $ ; in [SCROLL.INC] PRINT AT 1,17, DEC EmpIN[0], DEC EmpIN[1], DEC EmpIN[2], DEC EmpIN[3], DEC EmpIN[4], DEC EmpIN[5]
	Movlw 128
	Movwf BPFH
	Movlw 144
	F@Call LCD@crs
	Movfw EMPIN#0
	F@Call out@decb
	Movfw EMPIN#1
	F@Call out@decb
	Movfw EMPIN#2
	F@Call out@decb
	Movfw EMPIN#3
	F@Call out@decb
	Movfw EMPIN#4
	F@Call out@decb
	Movfw EMPIN#5
	F@Call out@decb
F5_000073 equ $ ; in [SCROLL.INC] CurrentLine = CurrentLine + 8
	Movlw 8
	Addwf CURRENTLINE,F
F5_000074 equ $ ; in [SCROLL.INC] If CurrentLine = EndLine then
	Movfw CURRENTLINE
	Subwf ENDLINE,W
	set@page bc@ll102
	Btfss STATUS,2
	Goto bc@ll102
F5_000075 equ $ ; in [SCROLL.INC] Print AT 2,17, "END OF LIST"
	Movlw 128
	Movwf BPFH
	Movlw 208
	F@Call LCD@crs
	Movlw 'E'
	F@Call Print
	Movlw 'N'
	F@Call Print
	Movlw 'D'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'O'
	F@Call Print
	Movlw 'F'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'L'
	F@Call Print
	Movlw 'I'
	F@Call Print
	Movlw 'S'
	F@Call Print
	Movlw 'T'
	F@Call Print
F5_000076 equ $ ; in [SCROLL.INC] RETURN
	Return
F5_000077 equ $ ; in [SCROLL.INC] ENDIF
bc@ll102
F5_000079 equ $ ; in [SCROLL.INC] GoSUB Get#
	F@Call GET#
F5_000080 equ $ ; in [SCROLL.INC] GoSub Split
	F@Call SPLIT
F5_000081 equ $ ; in [SCROLL.INC] PRINT AT 2,17, DEC EmpIN[0], DEC EmpIN[1], DEC EmpIN[2], DEC EmpIN[3], DEC EmpIN[4], DEC EmpIN[5]
	Movlw 128
	Movwf BPFH
	Movlw 208
	F@Call LCD@crs
	Movfw EMPIN#0
	F@Call out@decb
	Movfw EMPIN#1
	F@Call out@decb
	Movfw EMPIN#2
	F@Call out@decb
	Movfw EMPIN#3
	F@Call out@decb
	Movfw EMPIN#4
	F@Call out@decb
	Movfw EMPIN#5
	F@Call out@decb
F5_000082 equ $ ; in [SCROLL.INC] RETURN
	Return
GET#
F5_000089 equ $ ; in [SCROLL.INC] Get#:  Index = 0
	Clrf INDEX
F5_000090 equ $ ; in [SCROLL.INC] REPEAT           'Get each employee
bc@ll103
F5_000091 equ $ ; in [SCROLL.INC] B1 = EREAD CurrentLine + Index  'in the 8 byte key spots
	Movfw CURRENTLINE
	Addwf INDEX,W
	F@Call Ee_rd
	Movwf B1
F5_000092 equ $ ; in [SCROLL.INC] CE[Index] = B1  'Get first digit of employee #
	Movfw INDEX
	Addlw CE
	Movwf FSR
	Movfw B1
	Movwf INDF
F5_000093 equ $ ; in [SCROLL.INC] INC Index      'Get Next Digit
	Incf INDEX,F
F5_000094 equ $ ; in [SCROLL.INC] UNTIL Index > 2
	Movlw 3
	Subwf INDEX,W
	set@page bc@ll103
	Btfss STATUS,0
	Goto bc@ll103
bc@ll104
F5_000095 equ $ ; in [SCROLL.INC] B1 = "C"
	Movlw 67
	Movwf B1
F5_000096 equ $ ; in [SCROLL.INC] Return
	Return
F5_EOF equ $ ; SCROLL.INC
F6_SOF equ $ ; SCROLLH.INC
STARTSCROLLH
F6_000005 equ $ ; in [SCROLLH.INC] StartScrollH: StartLine = 202 'Starting address of history table
	Movlw 202
	Movwf STARTLINE
F6_000006 equ $ ; in [SCROLLH.INC] EndLine = 250 'End Address of history Table
	Movlw 250
	Movwf ENDLINE
SCROLLHAGAIN
F6_000009 equ $ ; in [SCROLLH.INC] CLS
	F@Call Lcd@Cls
F6_000010 equ $ ; in [SCROLLH.INC] Print AT 1,1, "Use Arrow Keys"
	Movlw 128
	Movwf BPFH
	Movlw 128
	F@Call LCD@crs
	Movlw 'U'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'A'
	F@Call Print
	Movlw 'r'
	F@Call Print
	F@Call Print
	Movlw 'o'
	F@Call Print
	Movlw 'w'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'K'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'y'
	F@Call Print
	Movlw 's'
	F@Call Print
F6_000011 equ $ ; in [SCROLLH.INC] Print AT 2,1, "to Scroll."
	Movlw 128
	Movwf BPFH
	Movlw 192
	F@Call LCD@crs
	Movlw 't'
	F@Call Print
	Movlw 'o'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'S'
	F@Call Print
	Movlw 'c'
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw 'o'
	F@Call Print
	Movlw 'l'
	F@Call Print
	F@Call Print
	Movlw '.'
	F@Call Print
F6_000012 equ $ ; in [SCROLLH.INC] Print AT 1,17, "'Clear' to Exit"
	Movlw 128
	Movwf BPFH
	Movlw 144
	F@Call LCD@crs
	Movlw '\''
	F@Call Print
	Movlw 'C'
	F@Call Print
	Movlw 'l'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw '\''
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'o'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'E'
	F@Call Print
	Movlw 'x'
	F@Call Print
	Movlw 'i'
	F@Call Print
	Movlw 't'
	F@Call Print
F6_000013 equ $ ; in [SCROLLH.INC] Pause 4000
	Movlw 15
	Movwf PP1H
	Movlw 160
	F@Call dly@w
F6_000014 equ $ ; in [SCROLLH.INC] LastUser = EREAD 254   'Get next empty User history record address
	Movlw 254
	F@Call Ee_rd
	Movwf LASTUSER
SCROLLH
F6_000016 equ $ ; in [SCROLLH.INC] ScrollH: CurrentLine = StartLine  'Set Currentline first User history record
	Movfw STARTLINE
	Movwf CURRENTLINE
F6_000017 equ $ ; in [SCROLLH.INC] CLS
	F@Call Lcd@Cls
F6_000018 equ $ ; in [SCROLLH.INC] Gosub PrintHistory
	F@Call PRINTHISTORY
F6_000019 equ $ ; in [SCROLLH.INC] GoSub GetKey
	F@Call GETKEY
F6_000020 equ $ ; in [SCROLLH.INC] Select Key
F6_000021 equ $ ; in [SCROLLH.INC] Case "U"
	Movlw 85
	Subwf KEY,W
	set@page bc@ll106
	Btfss STATUS,2
	Goto bc@ll106
F6_000022 equ $ ; in [SCROLLH.INC] If StartLine > 202 then
	Movlw 203
	Subwf STARTLINE,W
	set@page bc@ll109
	Btfss STATUS,0
	Goto bc@ll109
F6_000023 equ $ ; in [SCROLLH.INC] StartLine = StartLine - 3
	Movlw 3
	Subwf STARTLINE,F
F6_000024 equ $ ; in [SCROLLH.INC] Goto ScrollH
	F@Jump SCROLLH
	F@Jump bc@ll110
bc@ll109
F6_000025 equ $ ; in [SCROLLH.INC] ELSE
F6_000026 equ $ ; in [SCROLLH.INC] CLS
	F@Call Lcd@Cls
F6_000027 equ $ ; in [SCROLLH.INC] Print AT 1,1, "Start of List"
	Movlw 128
	Movwf BPFH
	Movlw 128
	F@Call LCD@crs
	Movlw 'S'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'o'
	F@Call Print
	Movlw 'f'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'L'
	F@Call Print
	Movlw 'i'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 't'
	F@Call Print
F6_000028 equ $ ; in [SCROLLH.INC] Pause 1000
	Movlw 3
	Movwf PP1H
	Movlw 232
	F@Call dly@w
F6_000029 equ $ ; in [SCROLLH.INC] Goto ScrollH
	F@Jump SCROLLH
F6_000030 equ $ ; in [SCROLLH.INC] ENDIF
bc@ll110
	F@Jump bc@ll105
bc@ll106
F6_000031 equ $ ; in [SCROLLH.INC] Case "D"
	Movlw 68
	Subwf KEY,W
	set@page bc@ll112
	Btfss STATUS,2
	Goto bc@ll112
F6_000032 equ $ ; in [SCROLLH.INC] If StartLine + 9 < LastUser then
	Movlw 9
	Addwf STARTLINE,W
	Movwf PBP#VAR0
	Clrf PBP#VAR0H
	Rlf PBP#VAR0H,F
	Movfw PBP#VAR0H
	set@page bc@ll114
	Btfss STATUS,2
	Goto bc@ll114
	Movfw LASTUSER
	Subwf PBP#VAR0,W
	set@page bc@ll114
	Btfsc STATUS,0
	Goto bc@ll114
F6_000033 equ $ ; in [SCROLLH.INC] StartLine = StartLine + 3
	Movlw 3
	Addwf STARTLINE,F
F6_000034 equ $ ; in [SCROLLH.INC] Goto ScrollH
	F@Jump SCROLLH
	F@Jump bc@ll115
bc@ll114
F6_000035 equ $ ; in [SCROLLH.INC] Else
F6_000036 equ $ ; in [SCROLLH.INC] Goto ScrollH
	F@Jump SCROLLH
F6_000037 equ $ ; in [SCROLLH.INC] ENDIF
bc@ll115
	F@Jump bc@ll105
bc@ll112
F6_000038 equ $ ; in [SCROLLH.INC] Case "C"
	Movlw 67
	Subwf KEY,W
	set@page bc@ll117
	Btfss STATUS,2
	Goto bc@ll117
F6_000039 equ $ ; in [SCROLLH.INC] Goto MainMenu
	F@Jump MAINMENU
F6_000040 equ $ ; in [SCROLLH.INC] Case Else
	F@Jump bc@ll119
bc@ll117
F6_000041 equ $ ; in [SCROLLH.INC] Goto ScrollHAgain
	F@Jump SCROLLHAGAIN
F6_000042 equ $ ; in [SCROLLH.INC] EndSelect
bc@ll119
bc@ll105
PRINTHISTORY
F6_000049 equ $ ; in [SCROLLH.INC] PrintHistory: Gosub GetUser#
	F@Call GETUSER#
F6_000050 equ $ ; in [SCROLLH.INC] GoSub Split
	F@Call SPLIT
F6_000051 equ $ ; in [SCROLLH.INC] PRINT AT 1,1, DEC EmpIN[0], DEC EmpIN[1], DEC EmpIN[2], DEC EmpIN[3], DEC EmpIN[4], DEC EmpIN[5]
	Movlw 128
	Movwf BPFH
	Movlw 128
	F@Call LCD@crs
	Movfw EMPIN#0
	F@Call out@decb
	Movfw EMPIN#1
	F@Call out@decb
	Movfw EMPIN#2
	F@Call out@decb
	Movfw EMPIN#3
	F@Call out@decb
	Movfw EMPIN#4
	F@Call out@decb
	Movfw EMPIN#5
	F@Call out@decb
F6_000052 equ $ ; in [SCROLLH.INC] CurrentLine = CurrentLine + 3   'Get next User from history records
	Movlw 3
	Addwf CURRENTLINE,F
F6_000054 equ $ ; in [SCROLLH.INC] IF CurrentLine = LastUser then
	Movfw CURRENTLINE
	Subwf LASTUSER,W
	set@page bc@ll121
	Btfss STATUS,2
	Goto bc@ll121
F6_000055 equ $ ; in [SCROLLH.INC] Print AT 2,1, "END OF LIST"
	Movlw 128
	Movwf BPFH
	Movlw 192
	F@Call LCD@crs
	Movlw 'E'
	F@Call Print
	Movlw 'N'
	F@Call Print
	Movlw 'D'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'O'
	F@Call Print
	Movlw 'F'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'L'
	F@Call Print
	Movlw 'I'
	F@Call Print
	Movlw 'S'
	F@Call Print
	Movlw 'T'
	F@Call Print
F6_000056 equ $ ; in [SCROLLH.INC] RETURN
	Return
F6_000057 equ $ ; in [SCROLLH.INC] ENDIF
bc@ll121
F6_000059 equ $ ; in [SCROLLH.INC] GoSUB GetUser#
	F@Call GETUSER#
F6_000060 equ $ ; in [SCROLLH.INC] GoSub Split
	F@Call SPLIT
F6_000061 equ $ ; in [SCROLLH.INC] PRINT AT 2,1, DEC EmpIN[0], DEC EmpIN[1], DEC EmpIN[2], DEC EmpIN[3], DEC EmpIN[4], DEC EmpIN[5]
	Movlw 128
	Movwf BPFH
	Movlw 192
	F@Call LCD@crs
	Movfw EMPIN#0
	F@Call out@decb
	Movfw EMPIN#1
	F@Call out@decb
	Movfw EMPIN#2
	F@Call out@decb
	Movfw EMPIN#3
	F@Call out@decb
	Movfw EMPIN#4
	F@Call out@decb
	Movfw EMPIN#5
	F@Call out@decb
F6_000062 equ $ ; in [SCROLLH.INC] CurrentLine = CurrentLine + 3   'Get next User from history records
	Movlw 3
	Addwf CURRENTLINE,F
F6_000063 equ $ ; in [SCROLLH.INC] IF CurrentLine = LastUser then
	Movfw CURRENTLINE
	Subwf LASTUSER,W
	set@page bc@ll123
	Btfss STATUS,2
	Goto bc@ll123
F6_000064 equ $ ; in [SCROLLH.INC] Print AT 1,17, "END OF LIST"
	Movlw 128
	Movwf BPFH
	Movlw 144
	F@Call LCD@crs
	Movlw 'E'
	F@Call Print
	Movlw 'N'
	F@Call Print
	Movlw 'D'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'O'
	F@Call Print
	Movlw 'F'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'L'
	F@Call Print
	Movlw 'I'
	F@Call Print
	Movlw 'S'
	F@Call Print
	Movlw 'T'
	F@Call Print
F6_000065 equ $ ; in [SCROLLH.INC] RETURN
	Return
F6_000066 equ $ ; in [SCROLLH.INC] ENDIF
bc@ll123
F6_000068 equ $ ; in [SCROLLH.INC] GoSUB GetUser#
	F@Call GETUSER#
F6_000069 equ $ ; in [SCROLLH.INC] GoSub Split
	F@Call SPLIT
F6_000070 equ $ ; in [SCROLLH.INC] PRINT AT 1,17, DEC EmpIN[0], DEC EmpIN[1], DEC EmpIN[2], DEC EmpIN[3], DEC EmpIN[4], DEC EmpIN[5]
	Movlw 128
	Movwf BPFH
	Movlw 144
	F@Call LCD@crs
	Movfw EMPIN#0
	F@Call out@decb
	Movfw EMPIN#1
	F@Call out@decb
	Movfw EMPIN#2
	F@Call out@decb
	Movfw EMPIN#3
	F@Call out@decb
	Movfw EMPIN#4
	F@Call out@decb
	Movfw EMPIN#5
	F@Call out@decb
F6_000071 equ $ ; in [SCROLLH.INC] CurrentLine = CurrentLine + 3   'Get next User from history records
	Movlw 3
	Addwf CURRENTLINE,F
F6_000072 equ $ ; in [SCROLLH.INC] IF CurrentLine = LastUser then
	Movfw CURRENTLINE
	Subwf LASTUSER,W
	set@page bc@ll125
	Btfss STATUS,2
	Goto bc@ll125
F6_000073 equ $ ; in [SCROLLH.INC] Print AT 2,17, "END OF LIST"
	Movlw 128
	Movwf BPFH
	Movlw 208
	F@Call LCD@crs
	Movlw 'E'
	F@Call Print
	Movlw 'N'
	F@Call Print
	Movlw 'D'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'O'
	F@Call Print
	Movlw 'F'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'L'
	F@Call Print
	Movlw 'I'
	F@Call Print
	Movlw 'S'
	F@Call Print
	Movlw 'T'
	F@Call Print
F6_000074 equ $ ; in [SCROLLH.INC] RETURN
	Return
F6_000075 equ $ ; in [SCROLLH.INC] ENDIF
bc@ll125
F6_000076 equ $ ; in [SCROLLH.INC] GoSUB GetUser#
	F@Call GETUSER#
F6_000077 equ $ ; in [SCROLLH.INC] GoSub Split
	F@Call SPLIT
F6_000078 equ $ ; in [SCROLLH.INC] PRINT AT 2,17, DEC EmpIN[0], DEC EmpIN[1], DEC EmpIN[2], DEC EmpIN[3], DEC EmpIN[4], DEC EmpIN[5]
	Movlw 128
	Movwf BPFH
	Movlw 208
	F@Call LCD@crs
	Movfw EMPIN#0
	F@Call out@decb
	Movfw EMPIN#1
	F@Call out@decb
	Movfw EMPIN#2
	F@Call out@decb
	Movfw EMPIN#3
	F@Call out@decb
	Movfw EMPIN#4
	F@Call out@decb
	Movfw EMPIN#5
	F@Call out@decb
F6_000079 equ $ ; in [SCROLLH.INC] RETURN
	Return
GETUSER#
F6_000086 equ $ ; in [SCROLLH.INC] GetUser#:  Index = 0
	Clrf INDEX
F6_000087 equ $ ; in [SCROLLH.INC] REPEAT           'Get each employee
bc@ll126
F6_000088 equ $ ; in [SCROLLH.INC] B1 = EREAD CurrentLine + Index  'in the 3 byte history spots
	Movfw CURRENTLINE
	Addwf INDEX,W
	F@Call Ee_rd
	Movwf B1
F6_000089 equ $ ; in [SCROLLH.INC] CE[Index] = B1  'Get first digit of employee #
	Movfw INDEX
	Addlw CE
	Movwf FSR
	Movfw B1
	Movwf INDF
F6_000090 equ $ ; in [SCROLLH.INC] INC Index      'Get Next Digit
	Incf INDEX,F
F6_000091 equ $ ; in [SCROLLH.INC] UNTIL Index > 2
	Movlw 3
	Subwf INDEX,W
	set@page bc@ll126
	Btfss STATUS,0
	Goto bc@ll126
bc@ll127
F6_000092 equ $ ; in [SCROLLH.INC] B1 = "C"
	Movlw 67
	Movwf B1
F6_000093 equ $ ; in [SCROLLH.INC] Return
	Return
F6_EOF equ $ ; SCROLLH.INC
F7_SOF equ $ ; CHECKUSER.INC
CHECKUSER
F7_000003 equ $ ; in [CHECKUSER.INC] CheckUser:    If NUA = 5 then 'there are no User entries in the table
	Movlw 5
	Subwf NUA,W
	set@page bc@ll129
	Btfss STATUS,2
	Goto bc@ll129
F7_000004 equ $ ; in [CHECKUSER.INC] Return
	Return
F7_000005 equ $ ; in [CHECKUSER.INC] EndIf
bc@ll129
F7_000007 equ $ ; in [CHECKUSER.INC] ENDline = NUA   'Set Endline to first empty spot
	Movfw NUA
	Movwf ENDLINE
F7_000009 equ $ ; in [CHECKUSER.INC] Index2 = 5   ' Start search in first memory spot
	Movlw 5
	Movwf INDEX2
NEXTUSER
F7_000010 equ $ ; in [CHECKUSER.INC] NextUser:      For Index = 0 to 2   'Cycle through employee #
	Clrf INDEX
fr@lb131
	Movlw 3
	Subwf INDEX,W
	set@page nx@lb132
	Btfsc STATUS,0
	Goto nx@lb132
F7_000011 equ $ ; in [CHECKUSER.INC] Flag = 0    'If the User exists then we will set the Flag to 1
	Bcf _B#VR1,0
F7_000012 equ $ ; in [CHECKUSER.INC] B1 = EREAD Index2 + Index
	Movfw INDEX2
	Addwf INDEX,W
	F@Call Ee_rd
	Movwf B1
F7_000013 equ $ ; in [CHECKUSER.INC] If NOT B1 = CE[Index]then 'If any digit does not match then
	Movfw INDEX
	Addlw CE
	Movwf FSR
	Movfw INDF
	Movwf PBP#VAR0
	Movfw B1
	Subwf PBP#VAR0,W
	Btfsc STATUS,2
	Movlw 1
	Btfss STATUS,2
	Clrw
	Sublw 0
	set@page bc@ll133
	Btfss STATUS,2
	Goto bc@ll133
F7_000014 equ $ ; in [CHECKUSER.INC] Break           'Break out of For/Next loop
	F@Jump nx@lb132
	F@Jump bc@ll134
bc@ll133
F7_000015 equ $ ; in [CHECKUSER.INC] Else
F7_000016 equ $ ; in [CHECKUSER.INC] Flag = 1 ' The digit Matches
	Bsf _B#VR1,0
F7_000017 equ $ ; in [CHECKUSER.INC] ENDIF
bc@ll134
F7_000018 equ $ ; in [CHECKUSER.INC] Next Index   'Look at the next digit
	Incf INDEX,F
	set@page fr@lb131
	Btfss STATUS,2
	Goto fr@lb131
nx@lb132
F7_000019 equ $ ; in [CHECKUSER.INC] If Flag = 1 then Goto EmployeeExists
	set@page bc@ll136
	Btfss _B#VR1,0
	Goto bc@ll136
	F@Jump EMPLOYEEEXISTS
bc@ll136
F7_000020 equ $ ; in [CHECKUSER.INC] Index2 = Index2 + 8
	Movlw 8
	Addwf INDEX2,F
F7_000021 equ $ ; in [CHECKUSER.INC] If Index2 = Endline then Return
	Movfw INDEX2
	Subwf ENDLINE,W
	set@page bc@ll138
	Btfss STATUS,2
	Goto bc@ll138
	Return
bc@ll138
F7_000022 equ $ ; in [CHECKUSER.INC] B1 = "C"
	Movlw 67
	Movwf B1
F7_000023 equ $ ; in [CHECKUSER.INC] Goto NextUser
	F@Jump NEXTUSER
EMPLOYEEEXISTS
F7_000025 equ $ ; in [CHECKUSER.INC] EmployeeExists:   Gosub BadSound
	F@Call BADSOUND
F7_000026 equ $ ; in [CHECKUSER.INC] CLS
	F@Call Lcd@Cls
F7_000027 equ $ ; in [CHECKUSER.INC] PRINT AT 1,1,"User Exists!"
	Movlw 128
	Movwf BPFH
	Movlw 128
	F@Call LCD@crs
	Movlw 'U'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'E'
	F@Call Print
	Movlw 'x'
	F@Call Print
	Movlw 'i'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw '!'
	F@Call Print
F7_000028 equ $ ; in [CHECKUSER.INC] PRINT AT 2,1, "Delete User?"
	Movlw 128
	Movwf BPFH
	Movlw 192
	F@Call LCD@crs
	Movlw 'D'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'l'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'U'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw '?'
	F@Call Print
F7_000029 equ $ ; in [CHECKUSER.INC] Print AT 1,17,"(1) = Yes"
	Movlw 128
	Movwf BPFH
	Movlw 144
	F@Call LCD@crs
	Movlw '('
	F@Call Print
	Movlw '1'
	F@Call Print
	Movlw ')'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw '='
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'Y'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 's'
	F@Call Print
F7_000030 equ $ ; in [CHECKUSER.INC] Print At 2,17,"(2) = No"
	Movlw 128
	Movwf BPFH
	Movlw 208
	F@Call LCD@crs
	Movlw '('
	F@Call Print
	Movlw '2'
	F@Call Print
	Movlw ')'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw '='
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'N'
	F@Call Print
	Movlw 'o'
	F@Call Print
F7_000031 equ $ ; in [CHECKUSER.INC] GOSUB GetKey
	F@Call GETKEY
F7_000032 equ $ ; in [CHECKUSER.INC] Select Key
F7_000033 equ $ ; in [CHECKUSER.INC] Case 2 'Choice was not to delete User
	Movlw 2
	Subwf KEY,W
	set@page bc@ll140
	Btfss STATUS,2
	Goto bc@ll140
F7_000034 equ $ ; in [CHECKUSER.INC] GoTo MainMenu  'Exit adding user
	F@Jump MAINMENU
	F@Jump bc@ll139
bc@ll140
F7_000035 equ $ ; in [CHECKUSER.INC] Case 1 'Yes, delete this user. We will add a new key for him
	Movlw 1
	Subwf KEY,W
	set@page bc@ll143
	Btfss STATUS,2
	Goto bc@ll143
F7_000036 equ $ ; in [CHECKUSER.INC] Goto DeleteUser
	F@Jump DELETEUSER
F7_000037 equ $ ; in [CHECKUSER.INC] Case Else 'Key was not 1 or 2"
	F@Jump bc@ll145
bc@ll143
F7_000038 equ $ ; in [CHECKUSER.INC] Goto EmployeeExists
	F@Jump EMPLOYEEEXISTS
F7_000039 equ $ ; in [CHECKUSER.INC] EndSelect
bc@ll145
bc@ll139
DELETEUSER
F7_000041 equ $ ; in [CHECKUSER.INC] DeleteUser:   If Index2  = EndLine - 8  then 'If the Employee# is the last one in the table then
	Movlw low (-8)
	Addwf ENDLINE,W
	Movwf PBP#VAR0
	Movlw low ((-8) >> 8)
	Skpnc
	Addlw 1
	Movwf PBP#VAR0H
	Movfw PBP#VAR0H
	set@page bc@ll147
	Btfss STATUS,2
	Goto bc@ll147
	Movfw PBP#VAR0
	Subwf INDEX2,W
	set@page bc@ll147
	Btfss STATUS,2
	Goto bc@ll147
F7_000042 equ $ ; in [CHECKUSER.INC] NUA = NUA - 8 'remove last entry
	Movlw 8
	Subwf NUA,F
F7_000043 equ $ ; in [CHECKUSER.INC] EWRITE 255, [NUA]    'Enter new next user address into pointer spot
	Bsf STATUS,6
ram_bank = 2
	Movlw 255
	Movwf EEADR
	Bcf STATUS,6
ram_bank = 0
	Movfw NUA
	F@Call Ee_wr
F7_000044 equ $ ; in [CHECKUSER.INC] Return
	Return
	F@Jump bc@ll148
bc@ll147
F7_000045 equ $ ; in [CHECKUSER.INC] Else
MOVESPOT
F7_000046 equ $ ; in [CHECKUSER.INC] MoveSpot:    NUA = NUA - 8
	Movlw 8
	Subwf NUA,F
F7_000047 equ $ ; in [CHECKUSER.INC] EWRITE 255, [NUA]   'Enter new next user address into pointer spot
	Bsf STATUS,6
ram_bank = 2
	Movlw 255
	Movwf EEADR
	Bcf STATUS,6
ram_bank = 0
	Movfw NUA
	F@Call Ee_wr
F7_000049 equ $ ; in [CHECKUSER.INC] For Index = 0 to 7
	Clrf INDEX
fr@lb150
	Movlw 8
	Subwf INDEX,W
	set@page nx@lb151
	Btfsc STATUS,0
	Goto nx@lb151
F7_000050 equ $ ; in [CHECKUSER.INC] B1 = EREAD NUA + Index
	Movfw NUA
	Addwf INDEX,W
	F@Call Ee_rd
	Movwf B1
F7_000051 equ $ ; in [CHECKUSER.INC] EWRITE Index2 + Index, [B1]
	Movfw INDEX2
	Addwf INDEX,W
	Bsf STATUS,6
ram_bank = 2
	Movwf EEADR
	Bcf STATUS,6
ram_bank = 0
	Movfw B1
	F@Call Ee_wr
F7_000052 equ $ ; in [CHECKUSER.INC] Next
	Incf INDEX,F
	set@page fr@lb150
	Btfss STATUS,2
	Goto fr@lb150
nx@lb151
F7_000053 equ $ ; in [CHECKUSER.INC] B1 = "C"
	Movlw 67
	Movwf B1
F7_000054 equ $ ; in [CHECKUSER.INC] Return
	Return
F7_000055 equ $ ; in [CHECKUSER.INC] ENDIF
bc@ll148
F7_EOF equ $ ; CHECKUSER.INC
F8_SOF equ $ ; CHECKTAG.INC
CHECKTAG
F8_000004 equ $ ; in [CHECKTAG.INC] CheckTag:    Flag = 0        'Process will set Flag to 1 if Tag is found
	Bcf _B#VR1,0
F8_000005 equ $ ; in [CHECKTAG.INC] If NUA = 5 then    'there are no User entries in the table
	Movlw 5
	Subwf NUA,W
	set@page bc@ll152
	Btfss STATUS,2
	Goto bc@ll152
F8_000006 equ $ ; in [CHECKTAG.INC] Return
	Return
F8_000007 equ $ ; in [CHECKTAG.INC] EndIf
bc@ll152
F8_000008 equ $ ; in [CHECKTAG.INC] ENDline = NUA   'Set Endline to first empty spot
	Movfw NUA
	Movwf ENDLINE
F8_000009 equ $ ; in [CHECKTAG.INC] Index2 = 5   ' Start search in first user memory spot
	Movlw 5
	Movwf INDEX2
NEXTTAG
F8_000010 equ $ ; in [CHECKTAG.INC] NextTag:  Index = 0
	Clrf INDEX
F8_000011 equ $ ; in [CHECKTAG.INC] Flag = 0     'Process will set Flag to 1 if Tag is found
	Bcf _B#VR1,0
F8_000012 equ $ ; in [CHECKTAG.INC] REPEAT      'Repeat until all Tag digits are checked
bc@ll153
F8_000013 equ $ ; in [CHECKTAG.INC] B1 = EREAD TagOffset + Index2 + Index   'TagOffset jumps over User #
	Movfw TAGOFFSET
	Addwf INDEX2,W
	Movwf PP7
	Clrf PP7H
	Rlf PP7H,F
	Movfw INDEX
	Addwf PP7,W
	F@Call Ee_rd
	Movwf B1
F8_000014 equ $ ; in [CHECKTAG.INC] If B1 = CT[Index] then
	Movfw INDEX
	Addlw CT
	Movwf FSR
	Movfw INDF
	Movwf PBP#VAR0
	Movfw B1
	Subwf PBP#VAR0,W
	set@page bc@ll156
	Btfss STATUS,2
	Goto bc@ll156
F8_000015 equ $ ; in [CHECKTAG.INC] Flag = 1      'Digits Match
	Bsf _B#VR1,0
F8_000016 equ $ ; in [CHECKTAG.INC] INC Index      'Check Next Digit
	Incf INDEX,F
	F@Jump bc@ll157
bc@ll156
F8_000017 equ $ ; in [CHECKTAG.INC] Else
F8_000018 equ $ ; in [CHECKTAG.INC] Flag = 0     'Digit does not match, therefore
	Bcf _B#VR1,0
F8_000019 equ $ ; in [CHECKTAG.INC] Index = 5  'we are finished with this Tag
	Movlw 5
	Movwf INDEX
F8_000020 equ $ ; in [CHECKTAG.INC] ENDIF
bc@ll157
F8_000021 equ $ ; in [CHECKTAG.INC] UNTIL Index > 4
	Movlw 5
	Subwf INDEX,W
	set@page bc@ll153
	Btfss STATUS,0
	Goto bc@ll153
bc@ll154
F8_000022 equ $ ; in [CHECKTAG.INC] If Flag = 1 then Return
	set@page bc@ll159
	Btfss _B#VR1,0
	Goto bc@ll159
	Return
bc@ll159
F8_000023 equ $ ; in [CHECKTAG.INC] B1 = "C"
	Movlw 67
	Movwf B1
F8_000024 equ $ ; in [CHECKTAG.INC] Index2 = Index2 + 8
	Movlw 8
	Addwf INDEX2,F
F8_000025 equ $ ; in [CHECKTAG.INC] If Index2 = Endline then Return
	Movfw INDEX2
	Subwf ENDLINE,W
	set@page bc@ll161
	Btfss STATUS,2
	Goto bc@ll161
	Return
bc@ll161
F8_000026 equ $ ; in [CHECKTAG.INC] B1 = "C"
	Movlw 67
	Movwf B1
F8_000027 equ $ ; in [CHECKTAG.INC] Goto NextTag
	F@Jump NEXTTAG
F8_EOF equ $ ; CHECKTAG.INC
F9_SOF equ $ ; READTAG.INC
READTAG
F9_000002 equ $ ; in [READTAG.INC] ReadTag:  CLS
	F@Call Lcd@Cls
F9_000003 equ $ ; in [READTAG.INC] Print AT 1,1, "To Scan Tag"
	Movlw 128
	Movwf BPFH
	Movlw 128
	F@Call LCD@crs
	Movlw 'T'
	F@Call Print
	Movlw 'o'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'S'
	F@Call Print
	Movlw 'c'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 'n'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'T'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 'g'
	F@Call Print
F9_000004 equ $ ; in [READTAG.INC] Print AT 2,1, "press ENTER when"
	Movlw 128
	Movwf BPFH
	Movlw 192
	F@Call LCD@crs
	Movlw 'p'
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 's'
	F@Call Print
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'E'
	F@Call Print
	Movlw 'N'
	F@Call Print
	Movlw 'T'
	F@Call Print
	Movlw 'E'
	F@Call Print
	Movlw 'R'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'w'
	F@Call Print
	Movlw 'h'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'n'
	F@Call Print
F9_000005 equ $ ; in [READTAG.INC] Print AT 1,17, "ready"
	Movlw 128
	Movwf BPFH
	Movlw 144
	F@Call LCD@crs
	Movlw 'r'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 'd'
	F@Call Print
	Movlw 'y'
	F@Call Print
F9_000006 equ $ ; in [READTAG.INC] Print AT 2,17, "CLEAR to Cancel"
	Movlw 128
	Movwf BPFH
	Movlw 208
	F@Call LCD@crs
	Movlw 'C'
	F@Call Print
	Movlw 'L'
	F@Call Print
	Movlw 'E'
	F@Call Print
	Movlw 'A'
	F@Call Print
	Movlw 'R'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'o'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'C'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 'n'
	F@Call Print
	Movlw 'c'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'l'
	F@Call Print
F9_000008 equ $ ; in [READTAG.INC] Gosub GetKey
	F@Call GETKEY
F9_000009 equ $ ; in [READTAG.INC] Select Key
F9_000010 equ $ ; in [READTAG.INC] Case "C"
	Movlw 67
	Subwf KEY,W
	set@page bc@ll163
	Btfss STATUS,2
	Goto bc@ll163
F9_000011 equ $ ; in [READTAG.INC] GoTo Mainmenu   'User chose to cancel
	F@Jump MAINMENU
	F@Jump bc@ll162
bc@ll163
F9_000012 equ $ ; in [READTAG.INC] Case "E"    'User is ready to have tag read
	Movlw 69
	Subwf KEY,W
	set@page bc@ll166
	Btfss STATUS,2
	Goto bc@ll166
F9_000013 equ $ ; in [READTAG.INC] CLS
	F@Call Lcd@Cls
F9_000014 equ $ ; in [READTAG.INC] Print AT 1,1, "Attempting to"
	Movlw 128
	Movwf BPFH
	Movlw 128
	F@Call LCD@crs
	Movlw 'A'
	F@Call Print
	Movlw 't'
	F@Call Print
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'm'
	F@Call Print
	Movlw 'p'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'i'
	F@Call Print
	Movlw 'n'
	F@Call Print
	Movlw 'g'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'o'
	F@Call Print
F9_000015 equ $ ; in [READTAG.INC] Print AT 2,1, "read Tag...."
	Movlw 128
	Movwf BPFH
	Movlw 192
	F@Call LCD@crs
	Movlw 'r'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 'd'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'T'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 'g'
	F@Call Print
	Movlw '.'
	F@Call Print
	F@Call Print
	F@Call Print
	F@Call Print
READAGAIN
F9_000017 equ $ ; in [READTAG.INC] ReadAgain: Flag = 0       'Used to indicate a good read
	Bcf _B#VR1,0
F9_000018 equ $ ; in [READTAG.INC] LOW RFIDEnable        ' Turn on RFID Reader
	Bcf PORTD,4
	Bsf STATUS,5
ram_bank = 1
	Bcf TRISD,4
F9_000019 equ $ ; in [READTAG.INC] Pause 10    'Time for Reader to settle
	Movlw 10
	Bcf STATUS,5
ram_bank = 0
	F@Call dl@ms
F9_000020 equ $ ; in [READTAG.INC] HSERIN 30000, Timeout, [WAIT( 0x0A ) , STR TagIN] 'timeout in 30 sec
	Movlw 117
	Movwf GENH
	Movlw 48
	Movwf GEN
Pb@lb168
	F@Call Hrsin2
	set@page TIMEOUT
	Btfss STATUS,0
	Goto TIMEOUT
	Sublw 10
	set@page Pb@lb168
	Btfss STATUS,2
	Goto Pb@lb168
	Clrf PBP#VAR0
Pb@lb171
	Setc
	F@Call Hrsin2
	set@page TIMEOUT
	Btfss STATUS,0
	Goto TIMEOUT
	Movfw PBP#VAR0
	Addlw TAGIN
	Movwf FSR
	Movfw RCREG
	Movwf INDF
	Incf PBP#VAR0,F
	Movfw PBP#VAR0
	Sublw 10
	set@page Pb@lb171
	Btfss STATUS,2
	Goto Pb@lb171
F9_000021 equ $ ; in [READTAG.INC] HSERIN [Footer]' Receive a byte serially into Footer
	F@Call Hrsin
	Movwf FOOTER
F9_000023 equ $ ; in [READTAG.INC] If Footer = 0x0D then   'The footer (last byte) should always be 0X0D
	Movlw 13
	Subwf FOOTER,W
	set@page bc@ll172
	Btfss STATUS,2
	Goto bc@ll172
F9_000024 equ $ ; in [READTAG.INC] High RFIDEnable  ' Turn off RFID Reader
	Bsf PORTD,4
	Bsf STATUS,5
ram_bank = 1
	Bcf TRISD,4
F9_000025 equ $ ; in [READTAG.INC] Flag = 1   'Tag was read OK
	Bcf STATUS,5
ram_bank = 0
	Bsf _B#VR1,0
F9_000026 equ $ ; in [READTAG.INC] B1 = TagIN[0] + TagIN[1]     'We combine each pair of digits into 1... we can do this
	Movfw TAGIN#0
	Movwf PBP#VAR0
	Movfw TAGIN#1
	Movwf PBP#VAR1
	Movfw PBP#VAR0
	Addwf PBP#VAR1,W
	Movwf B1
F9_000027 equ $ ; in [READTAG.INC] CT[0] = B1         ' because each digit is always less than 128 bits so
	Movfw B1
	Movwf CT#0
F9_000028 equ $ ; in [READTAG.INC] B1 = TagIN[2] + TagIN[3]   ' by adding 2 together we never exceed the 256 bit maximum
	Movfw TAGIN#2
	Movwf PBP#VAR0
	Movfw TAGIN#3
	Movwf PBP#VAR1
	Movfw PBP#VAR0
	Addwf PBP#VAR1,W
	Movwf B1
F9_000029 equ $ ; in [READTAG.INC] CT[1] = B1         ' This saves space for data storage when we write the tags numbers
	Movfw B1
	Movwf CT#1
F9_000030 equ $ ; in [READTAG.INC] B1 = TagIN[4] + TagIN[5]   ' to the flash memeory
	Movfw TAGIN#4
	Movwf PBP#VAR0
	Movfw TAGIN#5
	Movwf PBP#VAR1
	Movfw PBP#VAR0
	Addwf PBP#VAR1,W
	Movwf B1
F9_000031 equ $ ; in [READTAG.INC] CT[2] = B1
	Movfw B1
	Movwf CT#2
F9_000032 equ $ ; in [READTAG.INC] B1 = TagIN[6] + TagIN[7]
	Movfw TAGIN#6
	Movwf PBP#VAR0
	Movfw TAGIN#7
	Movwf PBP#VAR1
	Movfw PBP#VAR0
	Addwf PBP#VAR1,W
	Movwf B1
F9_000033 equ $ ; in [READTAG.INC] CT[3] = B1
	Movfw B1
	Movwf CT#3
F9_000034 equ $ ; in [READTAG.INC] B1 = TagIN[8] + TagIN[9]
	Movfw TAGIN#8
	Movwf PBP#VAR0
	Movfw TAGIN#9
	Movwf PBP#VAR1
	Movfw PBP#VAR0
	Addwf PBP#VAR1,W
	Movwf B1
F9_000035 equ $ ; in [READTAG.INC] CT[4] = B1
	Movfw B1
	Movwf CT#4
F9_000036 equ $ ; in [READTAG.INC] Return
	Return
	F@Jump bc@ll173
bc@ll172
F9_000037 equ $ ; in [READTAG.INC] Else           'Footer not right
F9_000038 equ $ ; in [READTAG.INC] High RFIDEnable    ' Turn off RFID Reader
	Bsf PORTD,4
	Bsf STATUS,5
ram_bank = 1
	Bcf TRISD,4
F9_000039 equ $ ; in [READTAG.INC] Goto ReadAgain   'Read was not good..Try again
	Bcf STATUS,5
ram_bank = 0
	F@Jump READAGAIN
F9_000040 equ $ ; in [READTAG.INC] End if
bc@ll173
TIMEOUT
F9_000043 equ $ ; in [READTAG.INC] Timeout: High RFIDEnable       ' Turn off RFID Reader ..No Tag detected for 10 sec
	Bsf PORTD,4
	Bsf STATUS,5
ram_bank = 1
	Bcf TRISD,4
F9_000044 equ $ ; in [READTAG.INC] Gosub BadSound
	Bcf STATUS,5
ram_bank = 0
	F@Call BADSOUND
F9_000045 equ $ ; in [READTAG.INC] CLS
	F@Call Lcd@Cls
F9_000046 equ $ ; in [READTAG.INC] Print at 1,1, "No Tag Detected"
	Movlw 128
	Movwf BPFH
	Movlw 128
	F@Call LCD@crs
	Movlw 'N'
	F@Call Print
	Movlw 'o'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'T'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 'g'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'D'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'c'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'd'
	F@Call Print
F9_000047 equ $ ; in [READTAG.INC] Pause 3000
	Movlw 11
	Movwf PP1H
	Movlw 184
	F@Call dly@w
F9_000048 equ $ ; in [READTAG.INC] Goto GoSleep
	F@Jump GOSLEEP
F9_000049 equ $ ; in [READTAG.INC] Case ELSE
	F@Jump bc@ll175
bc@ll166
F9_000050 equ $ ; in [READTAG.INC] Goto ReadTag   'wrong key pressed on keypad
	F@Jump READTAG
F9_000051 equ $ ; in [READTAG.INC] ENDSELECT
bc@ll175
bc@ll162
F9_EOF equ $ ; READTAG.INC
F10_SOF equ $ ; WRITE.INC
WRITETAG
F10_000003 equ $ ; in [WRITE.INC] WriteTag:     For Index = 0 to 2
	Clrf INDEX
fr@lb177
	Movlw 3
	Subwf INDEX,W
	set@page nx@lb178
	Btfsc STATUS,0
	Goto nx@lb178
F10_000004 equ $ ; in [WRITE.INC] B1 = CE[Index]
	Movfw INDEX
	Addlw CE
	Movwf FSR
	Movfw INDF
	Movwf B1
F10_000005 equ $ ; in [WRITE.INC] EWRITE NUA + Index, [B1]
	Movfw NUA
	Addwf INDEX,W
	Bsf STATUS,6
ram_bank = 2
	Movwf EEADR
	Bcf STATUS,6
ram_bank = 0
	Movfw B1
	F@Call Ee_wr
F10_000006 equ $ ; in [WRITE.INC] Next 'Index
	Incf INDEX,F
	set@page fr@lb177
	Btfss STATUS,2
	Goto fr@lb177
nx@lb178
F10_000008 equ $ ; in [WRITE.INC] For Index = 0 to 4
	Clrf INDEX
fr@lb179
	Movlw 5
	Subwf INDEX,W
	set@page nx@lb180
	Btfsc STATUS,0
	Goto nx@lb180
F10_000009 equ $ ; in [WRITE.INC] B1 = CT[Index]
	Movfw INDEX
	Addlw CT
	Movwf FSR
	Movfw INDF
	Movwf B1
F10_000010 equ $ ; in [WRITE.INC] EWRITE NUA + TagOffset + Index, [B1]
	Movfw NUA
	Addwf TAGOFFSET,W
	Movwf PP7
	Clrf PP7H
	Rlf PP7H,F
	Movfw INDEX
	Addwf PP7,W
	Bsf STATUS,6
ram_bank = 2
	Movwf EEADR
	Bcf STATUS,6
ram_bank = 0
	Movfw B1
	F@Call Ee_wr
F10_000011 equ $ ; in [WRITE.INC] Next 'Index
	Incf INDEX,F
	set@page fr@lb179
	Btfss STATUS,2
	Goto fr@lb179
nx@lb180
F10_000012 equ $ ; in [WRITE.INC] B1 = "C"
	Movlw 67
	Movwf B1
F10_000014 equ $ ; in [WRITE.INC] NUA = NUA + 8
	Movlw 8
	Addwf NUA,F
F10_000015 equ $ ; in [WRITE.INC] EWRITE 255, [NUA]
	Bsf STATUS,6
ram_bank = 2
	Movlw 255
	Movwf EEADR
	Bcf STATUS,6
ram_bank = 0
	Movfw NUA
	F@Call Ee_wr
F10_000016 equ $ ; in [WRITE.INC] Return
	Return
WRITEMASTER
F10_000019 equ $ ; in [WRITE.INC] For Index = 0 to 4
	Clrf INDEX
fr@lb181
	Movlw 5
	Subwf INDEX,W
	set@page nx@lb182
	Btfsc STATUS,0
	Goto nx@lb182
F10_000020 equ $ ; in [WRITE.INC] EWRITE Index, [CT[Index]]
	Movfw INDEX
	Bsf STATUS,6
ram_bank = 2
	Movwf EEADR
	Bcf STATUS,6
ram_bank = 0
	Movfw INDEX
	Addlw CT
	Movwf FSR
	Movfw INDF
	F@Call Ee_wr
F10_000021 equ $ ; in [WRITE.INC] Next
	Incf INDEX,F
	set@page fr@lb181
	Btfss STATUS,2
	Goto fr@lb181
nx@lb182
F10_000022 equ $ ; in [WRITE.INC] Return
	Return
F10_EOF equ $ ; WRITE.INC
F11_SOF equ $ ; WRITEH.INC
WRITEH
F11_000005 equ $ ; in [WRITEH.INC] StartLine = 202 'Starting address of history table
	Movlw 202
	Movwf STARTLINE
F11_000006 equ $ ; in [WRITEH.INC] EndLine = 250 'End Address of history Table
	Movlw 250
	Movwf ENDLINE
F11_000008 equ $ ; in [WRITEH.INC] CurrentLine = ERead 254  'Get last User History address
	Movlw 254
	F@Call Ee_rd
	Movwf CURRENTLINE
SHIFTAGAIN
F11_000009 equ $ ; in [WRITEH.INC] ShiftAgain: If CurrentLine = 202 then Goto WriteHNow 'Empty spot is first spot
	Movlw 202
	Subwf CURRENTLINE,W
	set@page bc@ll183
	Btfss STATUS,2
	Goto bc@ll183
	F@Jump WRITEHNOW
bc@ll183
F11_000013 equ $ ; in [WRITEH.INC] For Index = 0 to 2
	Clrf INDEX
fr@lb185
	Movlw 3
	Subwf INDEX,W
	set@page nx@lb186
	Btfsc STATUS,0
	Goto nx@lb186
F11_000014 equ $ ; in [WRITEH.INC] B1 = EREAD CurrentLine - 3 + Index
	Movlw low (-3)
	Addwf CURRENTLINE,W
	Movwf PP7
	Movlw low ((-3) >> 8)
	Skpnc
	Addlw 1
	Movwf PP7H
	Movfw INDEX
	Addwf PP7,W
	F@Call Ee_rd
	Movwf B1
F11_000015 equ $ ; in [WRITEH.INC] EWRITE CurrentLine + Index, [B1]
	Movfw CURRENTLINE
	Addwf INDEX,W
	Bsf STATUS,6
ram_bank = 2
	Movwf EEADR
	Bcf STATUS,6
ram_bank = 0
	Movfw B1
	F@Call Ee_wr
F11_000016 equ $ ; in [WRITEH.INC] Next 'Index = 0 to 2
	Incf INDEX,F
	set@page fr@lb185
	Btfss STATUS,2
	Goto fr@lb185
nx@lb186
F11_000017 equ $ ; in [WRITEH.INC] CurrentLine = CurrentLine - 3
	Movlw 3
	Subwf CURRENTLINE,F
F11_000018 equ $ ; in [WRITEH.INC] Goto ShiftAgain
	F@Jump SHIFTAGAIN
WRITEHNOW
F11_000021 equ $ ; in [WRITEH.INC] For Index = 0 to 2               'Write User # to History
	Clrf INDEX
fr@lb187
	Movlw 3
	Subwf INDEX,W
	set@page nx@lb188
	Btfsc STATUS,0
	Goto nx@lb188
F11_000022 equ $ ; in [WRITEH.INC] B1 = CE[Index]
	Movfw INDEX
	Addlw CE
	Movwf FSR
	Movfw INDF
	Movwf B1
F11_000023 equ $ ; in [WRITEH.INC] EWRITE CurrentLine + Index, [B1]
	Movfw CURRENTLINE
	Addwf INDEX,W
	Bsf STATUS,6
ram_bank = 2
	Movwf EEADR
	Bcf STATUS,6
ram_bank = 0
	Movfw B1
	F@Call Ee_wr
F11_000024 equ $ ; in [WRITEH.INC] Next 'Index
	Incf INDEX,F
	set@page fr@lb187
	Btfss STATUS,2
	Goto fr@lb187
nx@lb188
F11_000026 equ $ ; in [WRITEH.INC] CurrentLine = EREAD 254
	Movlw 254
	F@Call Ee_rd
	Movwf CURRENTLINE
F11_000027 equ $ ; in [WRITEH.INC] If CurrentLine < 244 then CurrentLine = CurrentLine + 3
	Movlw 244
	Subwf CURRENTLINE,W
	set@page bc@ll189
	Btfsc STATUS,0
	Goto bc@ll189
	Movlw 3
	Addwf CURRENTLINE,F
bc@ll189
F11_000028 equ $ ; in [WRITEH.INC] Ewrite 254, [CurrentLine]  'We now set the address pointer to next empty history record spot
	Movlw 254
	Bsf STATUS,6
ram_bank = 2
	Movwf EEADR
	Bcf STATUS,6
ram_bank = 0
	Movfw CURRENTLINE
	F@Call Ee_wr
F11_000029 equ $ ; in [WRITEH.INC] Return
	Return
F11_EOF equ $ ; WRITEH.INC
F12_SOF equ $ ; USERMENU.INC
USERMENU
F12_000003 equ $ ; in [USERMENU.INC] CLS
	F@Call Lcd@Cls
F12_000004 equ $ ; in [USERMENU.INC] Print AT 1,1,  "(1) Add New User"
	Movlw 128
	Movwf BPFH
	Movlw 128
	F@Call LCD@crs
	Movlw '('
	F@Call Print
	Movlw '1'
	F@Call Print
	Movlw ')'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'A'
	F@Call Print
	Movlw 'd'
	F@Call Print
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'N'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'w'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'U'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'r'
	F@Call Print
F12_000005 equ $ ; in [USERMENU.INC] Print AT 2,1,  "(2) Delete User"
	Movlw 128
	Movwf BPFH
	Movlw 192
	F@Call LCD@crs
	Movlw '('
	F@Call Print
	Movlw '2'
	F@Call Print
	Movlw ')'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'D'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'l'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'U'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'r'
	F@Call Print
F12_000006 equ $ ; in [USERMENU.INC] Print AT 1,17, "(3) Delete ALL"
	Movlw 128
	Movwf BPFH
	Movlw 144
	F@Call LCD@crs
	Movlw '('
	F@Call Print
	Movlw '3'
	F@Call Print
	Movlw ')'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'D'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'l'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'A'
	F@Call Print
	Movlw 'L'
	F@Call Print
	F@Call Print
F12_000007 equ $ ; in [USERMENU.INC] Print AT 2,17, "(4) View Users"
	Movlw 128
	Movwf BPFH
	Movlw 208
	F@Call LCD@crs
	Movlw '('
	F@Call Print
	Movlw '4'
	F@Call Print
	Movlw ')'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'V'
	F@Call Print
	Movlw 'i'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'w'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'U'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw 's'
	F@Call Print
F12_000009 equ $ ; in [USERMENU.INC] GoSub GetKey   'Get response from keypad
	F@Call GETKEY
F12_000010 equ $ ; in [USERMENU.INC] SELECT Key
F12_000011 equ $ ; in [USERMENU.INC] CASE 1   ' Is Key equal to 1 ?
	Movlw 1
	Subwf KEY,W
	set@page bc@ll191
	Btfss STATUS,2
	Goto bc@ll191
F12_000012 equ $ ; in [USERMENU.INC] GoTo AddNewUser
	F@Jump ADDNEWUSER
	F@Jump bc@ll190
bc@ll191
F12_000015 equ $ ; in [USERMENU.INC] CASE 2   ' Is KEY equal to 2 ?
	Movlw 2
	Subwf KEY,W
	set@page bc@ll194
	Btfss STATUS,2
	Goto bc@ll194
F12_000016 equ $ ; in [USERMENU.INC] GoSub GetEmployee#
	F@Call GETEMPLOYEE#
F12_000017 equ $ ; in [USERMENU.INC] GoSub CheckUser
	F@Call CHECKUSER
F12_000018 equ $ ; in [USERMENU.INC] CLS
	F@Call Lcd@Cls
F12_000019 equ $ ; in [USERMENU.INC] If Flag = 1 then
	set@page bc@ll196
	Btfss _B#VR1,0
	Goto bc@ll196
F12_000020 equ $ ; in [USERMENU.INC] Gosub GoodSound
	F@Call GOODSOUND
F12_000021 equ $ ; in [USERMENU.INC] Print AT 1,1,"User deleted"
	Movlw 128
	Movwf BPFH
	Movlw 128
	F@Call LCD@crs
	Movlw 'U'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'd'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'l'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'd'
	F@Call Print
F12_000022 equ $ ; in [USERMENU.INC] Pause 4000
	Movlw 15
	Movwf PP1H
	Movlw 160
	F@Call dly@w
F12_000023 equ $ ; in [USERMENU.INC] Goto MainMenu
	F@Jump MAINMENU
	F@Jump bc@ll197
bc@ll196
F12_000024 equ $ ; in [USERMENU.INC] Else
F12_000025 equ $ ; in [USERMENU.INC] Gosub BadSound
	F@Call BADSOUND
F12_000026 equ $ ; in [USERMENU.INC] Print AT 1,1,"User is not"
	Movlw 128
	Movwf BPFH
	Movlw 128
	F@Call LCD@crs
	Movlw 'U'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'i'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'n'
	F@Call Print
	Movlw 'o'
	F@Call Print
	Movlw 't'
	F@Call Print
F12_000027 equ $ ; in [USERMENU.INC] Print AT 2,1,"in the database!"
	Movlw 128
	Movwf BPFH
	Movlw 192
	F@Call LCD@crs
	Movlw 'i'
	F@Call Print
	Movlw 'n'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'h'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'd'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 'b'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw '!'
	F@Call Print
F12_000028 equ $ ; in [USERMENU.INC] Pause 4000
	Movlw 15
	Movwf PP1H
	Movlw 160
	F@Call dly@w
F12_000029 equ $ ; in [USERMENU.INC] Goto MainMenu
	F@Jump MAINMENU
F12_000030 equ $ ; in [USERMENU.INC] ENDIF
bc@ll197
	F@Jump bc@ll190
bc@ll194
F12_000031 equ $ ; in [USERMENU.INC] Case 3   'Delete all users
	Movlw 3
	Subwf KEY,W
	set@page bc@ll199
	Btfss STATUS,2
	Goto bc@ll199
F12_000032 equ $ ; in [USERMENU.INC] Gosub GoodSound
	F@Call GOODSOUND
F12_000033 equ $ ; in [USERMENU.INC] CLS
	F@Call Lcd@Cls
F12_000034 equ $ ; in [USERMENU.INC] Print AT 1,1, "Warning!"
	Movlw 128
	Movwf BPFH
	Movlw 128
	F@Call LCD@crs
	Movlw 'W'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw 'n'
	F@Call Print
	Movlw 'i'
	F@Call Print
	Movlw 'n'
	F@Call Print
	Movlw 'g'
	F@Call Print
	Movlw '!'
	F@Call Print
F12_000035 equ $ ; in [USERMENU.INC] Print AT 2,1, "Delete ALL?"
	Movlw 128
	Movwf BPFH
	Movlw 192
	F@Call LCD@crs
	Movlw 'D'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'l'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'A'
	F@Call Print
	Movlw 'L'
	F@Call Print
	F@Call Print
	Movlw '?'
	F@Call Print
F12_000036 equ $ ; in [USERMENU.INC] Print AT 1,17, "(1) = YES"
	Movlw 128
	Movwf BPFH
	Movlw 144
	F@Call LCD@crs
	Movlw '('
	F@Call Print
	Movlw '1'
	F@Call Print
	Movlw ')'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw '='
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'Y'
	F@Call Print
	Movlw 'E'
	F@Call Print
	Movlw 'S'
	F@Call Print
F12_000037 equ $ ; in [USERMENU.INC] Print AT 2,17, "(2) = NO"
	Movlw 128
	Movwf BPFH
	Movlw 208
	F@Call LCD@crs
	Movlw '('
	F@Call Print
	Movlw '2'
	F@Call Print
	Movlw ')'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw '='
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'N'
	F@Call Print
	Movlw 'O'
	F@Call Print
F12_000038 equ $ ; in [USERMENU.INC] Gosub GetKey           'Get response from keypad
	F@Call GETKEY
F12_000039 equ $ ; in [USERMENU.INC] Select Key
F12_000040 equ $ ; in [USERMENU.INC] Case 1
	Movlw 1
	Subwf KEY,W
	set@page bc@ll201
	Btfss STATUS,2
	Goto bc@ll201
F12_000041 equ $ ; in [USERMENU.INC] Gosub GoodSound
	F@Call GOODSOUND
F12_000042 equ $ ; in [USERMENU.INC] CLS
	F@Call Lcd@Cls
F12_000043 equ $ ; in [USERMENU.INC] Print AT 1,1, "ALL Users"
	Movlw 128
	Movwf BPFH
	Movlw 128
	F@Call LCD@crs
	Movlw 'A'
	F@Call Print
	Movlw 'L'
	F@Call Print
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'U'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw 's'
	F@Call Print
F12_000044 equ $ ; in [USERMENU.INC] Print AT 2,1, "will be deleted!"
	Movlw 128
	Movwf BPFH
	Movlw 192
	F@Call LCD@crs
	Movlw 'w'
	F@Call Print
	Movlw 'i'
	F@Call Print
	Movlw 'l'
	F@Call Print
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'b'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'd'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'l'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'd'
	F@Call Print
	Movlw '!'
	F@Call Print
F12_000045 equ $ ; in [USERMENU.INC] Pause 4000
	Movlw 15
	Movwf PP1H
	Movlw 160
	F@Call dly@w
F12_000046 equ $ ; in [USERMENU.INC] NUA = 5    'set # users to zero
	Movlw 5
	Movwf NUA
F12_000047 equ $ ; in [USERMENU.INC] EWRITE 255, [NUA]
	Bsf STATUS,6
ram_bank = 2
	Movlw 255
	Movwf EEADR
	Bcf STATUS,6
ram_bank = 0
	Movfw NUA
	F@Call Ee_wr
F12_000048 equ $ ; in [USERMENU.INC] Goto MainMenu
	F@Jump MAINMENU
	F@Jump bc@ll200
bc@ll201
F12_000049 equ $ ; in [USERMENU.INC] Case 2
	Movlw 2
	Subwf KEY,W
	set@page bc@ll204
	Btfss STATUS,2
	Goto bc@ll204
F12_000050 equ $ ; in [USERMENU.INC] Goto MainMenu
	F@Jump MAINMENU
F12_000051 equ $ ; in [USERMENU.INC] EndSelect
bc@ll204
bc@ll200
	F@Jump bc@ll190
bc@ll199
F12_000052 equ $ ; in [USERMENU.INC] CASE 4   'Key is equal to 4 'Scroll'
	Movlw 4
	Subwf KEY,W
	set@page bc@ll206
	Btfss STATUS,2
	Goto bc@ll206
F12_000053 equ $ ; in [USERMENU.INC] If NUA = 5 then
	Movlw 5
	Subwf NUA,W
	set@page bc@ll208
	Btfss STATUS,2
	Goto bc@ll208
F12_000054 equ $ ; in [USERMENU.INC] Gosub BadSound
	F@Call BADSOUND
F12_000055 equ $ ; in [USERMENU.INC] CLS
	F@Call Lcd@Cls
F12_000056 equ $ ; in [USERMENU.INC] Print AT 1,1, "There are no"
	Movlw 128
	Movwf BPFH
	Movlw 128
	F@Call LCD@crs
	Movlw 'T'
	F@Call Print
	Movlw 'h'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'n'
	F@Call Print
	Movlw 'o'
	F@Call Print
F12_000057 equ $ ; in [USERMENU.INC] Print AT 2,1, "Users in the"
	Movlw 128
	Movwf BPFH
	Movlw 192
	F@Call LCD@crs
	Movlw 'U'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'i'
	F@Call Print
	Movlw 'n'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'h'
	F@Call Print
	Movlw 'e'
	F@Call Print
F12_000058 equ $ ; in [USERMENU.INC] Print AT 1,17, "Database"
	Movlw 128
	Movwf BPFH
	Movlw 144
	F@Call LCD@crs
	Movlw 'D'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 'b'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 'e'
	F@Call Print
F12_000059 equ $ ; in [USERMENU.INC] Pause 4000
	Movlw 15
	Movwf PP1H
	Movlw 160
	F@Call dly@w
F12_000060 equ $ ; in [USERMENU.INC] Goto MainMenu
	F@Jump MAINMENU
F12_000061 equ $ ; in [USERMENU.INC] ENDIF 'If NUA = 5
bc@ll208
F12_000063 equ $ ; in [USERMENU.INC] GoTo ScrollUsers
	F@Jump SCROLLUSERS
F12_000065 equ $ ; in [USERMENU.INC] CASE ELSE   ' Otherwise...
	F@Jump bc@ll210
bc@ll206
F12_000066 equ $ ; in [USERMENU.INC] Goto MainMenu
	F@Jump MAINMENU
F12_000067 equ $ ; in [USERMENU.INC] ENDSELECT  'End of User Menu
bc@ll210
bc@ll190
F12_EOF equ $ ; USERMENU.INC
F13_SOF equ $ ; CHECKMASTER.INC
CHECKMASTER
F13_000002 equ $ ; in [CHECKMASTER.INC] CheckMaster: Index = 0
	Clrf INDEX
F13_000003 equ $ ; in [CHECKMASTER.INC] Flag = 0     'Process will set Flag to 1 if Master Tag is found
	Bcf _B#VR1,0
F13_000004 equ $ ; in [CHECKMASTER.INC] REPEAT      'Repeat until all Master Tag digits are checked
bc@ll211
F13_000005 equ $ ; in [CHECKMASTER.INC] B1 = EREAD Index
	Movfw INDEX
	F@Call Ee_rd
	Movwf B1
F13_000006 equ $ ; in [CHECKMASTER.INC] If B1 = CT[Index] then
	Movfw INDEX
	Addlw CT
	Movwf FSR
	Movfw INDF
	Movwf PBP#VAR0
	Movfw B1
	Subwf PBP#VAR0,W
	set@page bc@ll214
	Btfss STATUS,2
	Goto bc@ll214
F13_000007 equ $ ; in [CHECKMASTER.INC] Flag = 1      'Digits Match
	Bsf _B#VR1,0
F13_000008 equ $ ; in [CHECKMASTER.INC] INC Index      'Check Next Digit
	Incf INDEX,F
	F@Jump bc@ll215
bc@ll214
F13_000009 equ $ ; in [CHECKMASTER.INC] Else
F13_000010 equ $ ; in [CHECKMASTER.INC] Flag = 0     'Digit does not match, therefore
	Bcf _B#VR1,0
F13_000011 equ $ ; in [CHECKMASTER.INC] Index = 5      'we are finished with this Tag
	Movlw 5
	Movwf INDEX
F13_000012 equ $ ; in [CHECKMASTER.INC] ENDIF
bc@ll215
F13_000013 equ $ ; in [CHECKMASTER.INC] UNTIL Index > 4
	Movlw 5
	Subwf INDEX,W
	set@page bc@ll211
	Btfss STATUS,0
	Goto bc@ll211
bc@ll212
F13_000014 equ $ ; in [CHECKMASTER.INC] B1 = "C"
	Movlw 67
	Movwf B1
F13_000015 equ $ ; in [CHECKMASTER.INC] Return
	Return
F13_EOF equ $ ; CHECKMASTER.INC
F14_SOF equ $ ; MAINMENU.INC
MAINMENU
F14_000005 equ $ ; in [MAINMENU.INC] CLS
	F@Call Lcd@Cls
F14_000006 equ $ ; in [MAINMENU.INC] Print AT 1,1, "(1)User Tag Menu"
	Movlw 128
	Movwf BPFH
	Movlw 128
	F@Call LCD@crs
	Movlw '('
	F@Call Print
	Movlw '1'
	F@Call Print
	Movlw ')'
	F@Call Print
	Movlw 'U'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'T'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 'g'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'M'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'n'
	F@Call Print
	Movlw 'u'
	F@Call Print
F14_000007 equ $ ; in [MAINMENU.INC] Print AT 2,1, "(2)View last 14"
	Movlw 128
	Movwf BPFH
	Movlw 192
	F@Call LCD@crs
	Movlw '('
	F@Call Print
	Movlw '2'
	F@Call Print
	Movlw ')'
	F@Call Print
	Movlw 'V'
	F@Call Print
	Movlw 'i'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'w'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'l'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw '1'
	F@Call Print
	Movlw '4'
	F@Call Print
F14_000008 equ $ ; in [MAINMENU.INC] PRINT AT 1,17, "Vehicle users"
	Movlw 128
	Movwf BPFH
	Movlw 144
	F@Call LCD@crs
	Movlw 'V'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'h'
	F@Call Print
	Movlw 'i'
	F@Call Print
	Movlw 'c'
	F@Call Print
	Movlw 'l'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'u'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw 's'
	F@Call Print
F14_000009 equ $ ; in [MAINMENU.INC] Gosub GetKey
	F@Call GETKEY
F14_000010 equ $ ; in [MAINMENU.INC] Select Key
F14_000011 equ $ ; in [MAINMENU.INC] Case 1
	Movlw 1
	Subwf KEY,W
	set@page bc@ll217
	Btfss STATUS,2
	Goto bc@ll217
F14_000012 equ $ ; in [MAINMENU.INC] Goto UserMenu
	F@Jump USERMENU
	F@Jump bc@ll216
bc@ll217
F14_000013 equ $ ; in [MAINMENU.INC] Case 2
	Movlw 2
	Subwf KEY,W
	set@page bc@ll220
	Btfss STATUS,2
	Goto bc@ll220
F14_000014 equ $ ; in [MAINMENU.INC] LastUser = EREAD 254
	Movlw 254
	F@Call Ee_rd
	Movwf LASTUSER
F14_000015 equ $ ; in [MAINMENU.INC] If LastUser = 202 then
	Movlw 202
	Subwf LASTUSER,W
	set@page bc@ll222
	Btfss STATUS,2
	Goto bc@ll222
F14_000016 equ $ ; in [MAINMENU.INC] Gosub BadSound
	F@Call BADSOUND
F14_000017 equ $ ; in [MAINMENU.INC] CLS
	F@Call Lcd@Cls
F14_000018 equ $ ; in [MAINMENU.INC] Print AT 1,1, "There is no"
	Movlw 128
	Movwf BPFH
	Movlw 128
	F@Call LCD@crs
	Movlw 'T'
	F@Call Print
	Movlw 'h'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'i'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'n'
	F@Call Print
	Movlw 'o'
	F@Call Print
F14_000019 equ $ ; in [MAINMENU.INC] Print AT 2,1, "User History"
	Movlw 128
	Movwf BPFH
	Movlw 192
	F@Call LCD@crs
	Movlw 'U'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'H'
	F@Call Print
	Movlw 'i'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'o'
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw 'y'
	F@Call Print
F14_000020 equ $ ; in [MAINMENU.INC] Print AT 1,17, "in the Database"
	Movlw 128
	Movwf BPFH
	Movlw 144
	F@Call LCD@crs
	Movlw 'i'
	F@Call Print
	Movlw 'n'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'h'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'D'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 'b'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 'e'
	F@Call Print
F14_000021 equ $ ; in [MAINMENU.INC] Pause 4000
	Movlw 15
	Movwf PP1H
	Movlw 160
	F@Call dly@w
F14_000022 equ $ ; in [MAINMENU.INC] Goto MainMenu
	F@Jump MAINMENU
F14_000023 equ $ ; in [MAINMENU.INC] ENDIF 'If LastUser = 202
bc@ll222
F14_000025 equ $ ; in [MAINMENU.INC] GoTo StartScrollH
	F@Jump STARTSCROLLH
F14_000027 equ $ ; in [MAINMENU.INC] Case Else
	F@Jump bc@ll224
bc@ll220
F14_000028 equ $ ; in [MAINMENU.INC] Goto MainMenu
	F@Jump MAINMENU
F14_000029 equ $ ; in [MAINMENU.INC] EndSelect
bc@ll224
bc@ll216
F14_EOF equ $ ; MAINMENU.INC
F15_SOF equ $ ; STARTUNIT.INC
STARTUNIT
F15_000003 equ $ ; in [STARTUNIT.INC] High Green
	Bsf PORTC,1
	Bsf STATUS,5
ram_bank = 1
	Bcf TRISC,1
F15_000004 equ $ ; in [STARTUNIT.INC] High RED
	Bcf STATUS,5
ram_bank = 0
	Bsf PORTC,2
	Bsf STATUS,5
ram_bank = 1
	Bcf TRISC,2
F15_000006 equ $ ; in [STARTUNIT.INC] GoSub ReadAgain      ' Go Read Tag
	Bcf STATUS,5
ram_bank = 0
	F@Call READAGAIN
F15_000007 equ $ ; in [STARTUNIT.INC] GoSub CheckTag
	F@Call CHECKTAG
F15_000008 equ $ ; in [STARTUNIT.INC] IF Flag = 0 then    'Tag is not in table
	set@page bc@ll226
	Btfsc _B#VR1,0
	Goto bc@ll226
F15_000009 equ $ ; in [STARTUNIT.INC] Gosub BadSound
	F@Call BADSOUND
F15_000010 equ $ ; in [STARTUNIT.INC] CLS
	F@Call Lcd@Cls
F15_000011 equ $ ; in [STARTUNIT.INC] Print AT 1,1, "Tag not found"
	Movlw 128
	Movwf BPFH
	Movlw 128
	F@Call LCD@crs
	Movlw 'T'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 'g'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'n'
	F@Call Print
	Movlw 'o'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'f'
	F@Call Print
	Movlw 'o'
	F@Call Print
	Movlw 'u'
	F@Call Print
	Movlw 'n'
	F@Call Print
	Movlw 'd'
	F@Call Print
F15_000014 equ $ ; in [STARTUNIT.INC] Low Green
	Bcf PORTC,1
	Bsf STATUS,5
ram_bank = 1
	Bcf TRISC,1
F15_000015 equ $ ; in [STARTUNIT.INC] For Index = 0 to 10
	Bcf STATUS,5
ram_bank = 0
	Clrf INDEX
fr@lb228
	Movlw 11
	Subwf INDEX,W
	set@page nx@lb229
	Btfsc STATUS,0
	Goto nx@lb229
F15_000016 equ $ ; in [STARTUNIT.INC] Toggle Red
	Movlw 4
	Xorwf PORTC,F
	Bsf STATUS,5
ram_bank = 1
	Bcf TRISC,2
F15_000017 equ $ ; in [STARTUNIT.INC] DELAYMS 300
	Movlw 1
	Bcf STATUS,5
ram_bank = 0
	Movwf PP1H
	Movlw 44
	F@Call dly@w
F15_000018 equ $ ; in [STARTUNIT.INC] Next 'Index = 0 to 10
	Incf INDEX,F
	set@page fr@lb228
	Btfss STATUS,2
	Goto fr@lb228
nx@lb229
F15_000019 equ $ ; in [STARTUNIT.INC] Low Red
	Bcf PORTC,2
	Bsf STATUS,5
ram_bank = 1
	Bcf TRISC,2
F15_000020 equ $ ; in [STARTUNIT.INC] Goto GoSleep
	Bcf STATUS,5
ram_bank = 0
	F@Jump GOSLEEP
F15_000022 equ $ ; in [STARTUNIT.INC] ENDIF 'Flag = 0
bc@ll226
F15_000023 equ $ ; in [STARTUNIT.INC] Gosub GoodSound
	F@Call GOODSOUND
F15_000024 equ $ ; in [STARTUNIT.INC] CLS
	F@Call Lcd@Cls
F15_000025 equ $ ; in [STARTUNIT.INC] Print AT 1,1, "Unit can now"
	Movlw 128
	Movwf BPFH
	Movlw 128
	F@Call LCD@crs
	Movlw 'U'
	F@Call Print
	Movlw 'n'
	F@Call Print
	Movlw 'i'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'c'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 'n'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'n'
	F@Call Print
	Movlw 'o'
	F@Call Print
	Movlw 'w'
	F@Call Print
F15_000026 equ $ ; in [STARTUNIT.INC] Print AT 2,1, "be started!"
	Movlw 128
	Movwf BPFH
	Movlw 192
	F@Call LCD@crs
	Movlw 'b'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'a'
	F@Call Print
	Movlw 'r'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw 'd'
	F@Call Print
	Movlw '!'
	F@Call Print
F15_000027 equ $ ; in [STARTUNIT.INC] For Index = 0 to 2                'Get User # that is starting Unit
	Clrf INDEX
fr@lb230
	Movlw 3
	Subwf INDEX,W
	set@page nx@lb231
	Btfsc STATUS,0
	Goto nx@lb231
F15_000028 equ $ ; in [STARTUNIT.INC] CE[Index] = EREAD INDEX2 + INDEX
	Movfw INDEX2
	Addwf INDEX,W
	F@Call Ee_rd
	Movwf PBP#VAR0
	Movfw INDEX
	Addlw CE
	Movwf FSR
	Movfw PBP#VAR0
	Movwf INDF
F15_000029 equ $ ; in [STARTUNIT.INC] Next 'Index
	Incf INDEX,F
	set@page fr@lb230
	Btfss STATUS,2
	Goto fr@lb230
nx@lb231
F15_000031 equ $ ; in [STARTUNIT.INC] Gosub WriteH             'Go write the User into the history file
	F@Call WRITEH
F15_000032 equ $ ; in [STARTUNIT.INC] LOW StartEnable    'Turn On Start Relay
	Bcf PORTC,0
	Bsf STATUS,5
ram_bank = 1
	Bcf TRISC,0
F15_000035 equ $ ; in [STARTUNIT.INC] Low Red
	Bcf STATUS,5
ram_bank = 0
	Bcf PORTC,2
	Bsf STATUS,5
ram_bank = 1
	Bcf TRISC,2
F15_000036 equ $ ; in [STARTUNIT.INC] Low Green
	Bcf STATUS,5
ram_bank = 0
	Bcf PORTC,1
	Bsf STATUS,5
ram_bank = 1
	Bcf TRISC,1
F15_000037 equ $ ; in [STARTUNIT.INC] For Index = 0 to 5
	Bcf STATUS,5
ram_bank = 0
	Clrf INDEX
fr@lb232
	Movlw 6
	Subwf INDEX,W
	set@page nx@lb233
	Btfsc STATUS,0
	Goto nx@lb233
F15_000038 equ $ ; in [STARTUNIT.INC] Toggle Green
	Movlw 2
	Xorwf PORTC,F
	Bsf STATUS,5
ram_bank = 1
	Bcf TRISC,1
F15_000039 equ $ ; in [STARTUNIT.INC] DELAYMS 300
	Movlw 1
	Bcf STATUS,5
ram_bank = 0
	Movwf PP1H
	Movlw 44
	F@Call dly@w
F15_000040 equ $ ; in [STARTUNIT.INC] Next Index
	Incf INDEX,F
	set@page fr@lb232
	Btfss STATUS,2
	Goto fr@lb232
nx@lb233
F15_000041 equ $ ; in [STARTUNIT.INC] High Green
	Bsf PORTC,1
	Bsf STATUS,5
ram_bank = 1
	Bcf TRISC,1
F15_000043 equ $ ; in [STARTUNIT.INC] DelayMS 60000  'Leave start relay on for 60 sec
	Movlw 234
	Bcf STATUS,5
ram_bank = 0
	Movwf PP1H
	Movlw 96
	F@Call dly@w
F15_000044 equ $ ; in [STARTUNIT.INC] High StartEnable     'Shut off Start Relay
	Bsf PORTC,0
	Bsf STATUS,5
ram_bank = 1
	Bcf TRISC,0
F15_000045 equ $ ; in [STARTUNIT.INC] Low Green      'Shut off the Green Led
	Bcf STATUS,5
ram_bank = 0
	Bcf PORTC,1
	Bsf STATUS,5
ram_bank = 1
	Bcf TRISC,1
F15_000046 equ $ ; in [STARTUNIT.INC] CLS
	Bcf STATUS,5
ram_bank = 0
	F@Call Lcd@Cls
F15_000048 equ $ ; in [STARTUNIT.INC] Goto GoSleep     'Sleep Forever
	F@Jump GOSLEEP
TIMEOUT2
F15_000052 equ $ ; in [STARTUNIT.INC] Timeout2: High RFIDEnable       ' Turn off RFID Reader ..No Tag detected for 30 sec
	Bsf PORTD,4
	Bsf STATUS,5
ram_bank = 1
	Bcf TRISD,4
F15_000054 equ $ ; in [STARTUNIT.INC] Low Green
	Bcf STATUS,5
ram_bank = 0
	Bcf PORTC,1
	Bsf STATUS,5
ram_bank = 1
	Bcf TRISC,1
F15_000055 equ $ ; in [STARTUNIT.INC] For Index = 0 to 10
	Bcf STATUS,5
ram_bank = 0
	Clrf INDEX
fr@lb234
	Movlw 11
	Subwf INDEX,W
	set@page nx@lb235
	Btfsc STATUS,0
	Goto nx@lb235
F15_000056 equ $ ; in [STARTUNIT.INC] Toggle Red
	Movlw 4
	Xorwf PORTC,F
	Bsf STATUS,5
ram_bank = 1
	Bcf TRISC,2
F15_000057 equ $ ; in [STARTUNIT.INC] DELAYMS 300
	Movlw 1
	Bcf STATUS,5
ram_bank = 0
	Movwf PP1H
	Movlw 44
	F@Call dly@w
F15_000058 equ $ ; in [STARTUNIT.INC] Next Index
	Incf INDEX,F
	set@page fr@lb234
	Btfss STATUS,2
	Goto fr@lb234
nx@lb235
F15_000059 equ $ ; in [STARTUNIT.INC] Low Red
	Bcf PORTC,2
	Bsf STATUS,5
ram_bank = 1
	Bcf TRISC,2
F15_000060 equ $ ; in [STARTUNIT.INC] Goto GoSleep
	Bcf STATUS,5
ram_bank = 0
	F@Jump GOSLEEP
F15_EOF equ $ ; STARTUNIT.INC
F16_SOF equ $ ; GOSLEEP.INC
GOSLEEP
F16_000003 equ $ ; in [GOSLEEP.INC] CLS
	F@Call Lcd@Cls
F16_000004 equ $ ; in [GOSLEEP.INC] Print AT 1,1, "Going to sleep.."
	Movlw 128
	Movwf BPFH
	Movlw 128
	F@Call LCD@crs
	Movlw 'G'
	F@Call Print
	Movlw 'o'
	F@Call Print
	Movlw 'i'
	F@Call Print
	Movlw 'n'
	F@Call Print
	Movlw 'g'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw 'o'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 'l'
	F@Call Print
	Movlw 'e'
	F@Call Print
	F@Call Print
	Movlw 'p'
	F@Call Print
	Movlw '.'
	F@Call Print
	F@Call Print
F16_000005 equ $ ; in [GOSLEEP.INC] Pause 2000
	Movlw 7
	Movwf PP1H
	Movlw 208
	F@Call dly@w
F16_000006 equ $ ; in [GOSLEEP.INC] INTCON.4 = 1 'Allow a the pulse on PortB.0 to wake program from sleep
	Bsf INTCON,4
F16_000007 equ $ ; in [GOSLEEP.INC] INTCON.1 = 0  'Clear the interrupt flag for PortB.0
	Bcf INTCON,1
F16_000008 equ $ ; in [GOSLEEP.INC] LOW Red      'Turn off the Tri-Led
	Bcf PORTC,2
	Bsf STATUS,5
ram_bank = 1
	Bcf TRISC,2
F16_000009 equ $ ; in [GOSLEEP.INC] LOW Green  'Turn off the Tri-Led
	Bcf STATUS,5
ram_bank = 0
	Bcf PORTC,1
	Bsf STATUS,5
ram_bank = 1
	Bcf TRISC,1
F16_000010 equ $ ; in [GOSLEEP.INC] Sleep    'Chip goes into low power until it is triggered by a High to Low pulse on PortB.0
	Sleep
F16_000011 equ $ ; in [GOSLEEP.INC] INTCON.4 = 0 'Stop any pulse from waking up program cause we just woke up
	Bcf INTCON,4
F16_000012 equ $ ; in [GOSLEEP.INC] CLS
	Bcf STATUS,5
ram_bank = 0
	F@Call Lcd@Cls
F16_000013 equ $ ; in [GOSLEEP.INC] Print AT 1,1, "I just woke up!!"
	Movlw 128
	Movwf BPFH
	Movlw 128
	F@Call LCD@crs
	Movlw 'I'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'j'
	F@Call Print
	Movlw 'u'
	F@Call Print
	Movlw 's'
	F@Call Print
	Movlw 't'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'w'
	F@Call Print
	Movlw 'o'
	F@Call Print
	Movlw 'k'
	F@Call Print
	Movlw 'e'
	F@Call Print
	Movlw ' '
	F@Call Print
	Movlw 'u'
	F@Call Print
	Movlw 'p'
	F@Call Print
	Movlw '!'
	F@Call Print
	F@Call Print
F16_000018 equ $ ; in [GOSLEEP.INC] Pause 500
	Movlw 1
	Movwf PP1H
	Movlw 244
	F@Call dly@w
F16_000019 equ $ ; in [GOSLEEP.INC] CE[0] = 0
	Clrf CE#0
F16_000020 equ $ ; in [GOSLEEP.INC] CE[1] = 0
	Clrf CE#1
F16_000021 equ $ ; in [GOSLEEP.INC] CE[2] = 0
	Clrf CE#2
F16_000023 equ $ ; in [GOSLEEP.INC] GoSub WriteH      'Here we will go write "000000" into the history file
	F@Call WRITEH
F16_000025 equ $ ; in [GOSLEEP.INC] DELAYMS 60000     'Wait until unit has been started
	Movlw 234
	Movwf PP1H
	Movlw 96
	F@Call dly@w
F16_000026 equ $ ; in [GOSLEEP.INC] Goto GoSleep      'Go back to sleep
	F@Jump GOSLEEP
F16_EOF equ $ ; GOSLEEP.INC
F17_SOF equ $ ; BINARY.INC
SPLIT
F17_000002 equ $ ; in [BINARY.INC] B1 = CE[0]
	Movfw CE#0
	Movwf B1
F17_000003 equ $ ; in [BINARY.INC] B2 = 0
	Clrf B2
F17_000004 equ $ ; in [BINARY.INC] B2.3 = B1.7
; Bit_Bit B1,7,B2,3
	Bsf B2,3
	Btfss B1,7
	Bcf B2,3
F17_000005 equ $ ; in [BINARY.INC] B2.2 = B1.6
; Bit_Bit B1,6,B2,2
	Bsf B2,2
	Btfss B1,6
	Bcf B2,2
F17_000006 equ $ ; in [BINARY.INC] B2.1 = B1.5
; Bit_Bit B1,5,B2,1
	Bsf B2,1
	Btfss B1,5
	Bcf B2,1
F17_000007 equ $ ; in [BINARY.INC] B2.0 = B1.4
; Bit_Bit B1,4,B2,0
	Bsf B2,0
	Btfss B1,4
	Bcf B2,0
F17_000008 equ $ ; in [BINARY.INC] EmpIN[0] = B2
	Movfw B2
	Movwf EMPIN#0
F17_000009 equ $ ; in [BINARY.INC] B2 = 0
	Clrf B2
F17_000010 equ $ ; in [BINARY.INC] B2.3 = B1.3
; Bit_Bit B1,3,B2,3
	Bsf B2,3
	Btfss B1,3
	Bcf B2,3
F17_000011 equ $ ; in [BINARY.INC] B2.2 = B1.2
; Bit_Bit B1,2,B2,2
	Bsf B2,2
	Btfss B1,2
	Bcf B2,2
F17_000012 equ $ ; in [BINARY.INC] B2.1 = B1.1
; Bit_Bit B1,1,B2,1
	Bsf B2,1
	Btfss B1,1
	Bcf B2,1
F17_000013 equ $ ; in [BINARY.INC] B2.0 = B1.0
; Bit_Bit B1,0,B2,0
	Bsf B2,0
	Btfss B1,0
	Bcf B2,0
F17_000014 equ $ ; in [BINARY.INC] EmpIN[1] = B2
	Movfw B2
	Movwf EMPIN#1
F17_000016 equ $ ; in [BINARY.INC] B1 = CE[1]
	Movfw CE#1
	Movwf B1
F17_000017 equ $ ; in [BINARY.INC] B2 = 0
	Clrf B2
F17_000018 equ $ ; in [BINARY.INC] B2.3 = B1.7
; Bit_Bit B1,7,B2,3
	Bsf B2,3
	Btfss B1,7
	Bcf B2,3
F17_000019 equ $ ; in [BINARY.INC] B2.2 = B1.6
; Bit_Bit B1,6,B2,2
	Bsf B2,2
	Btfss B1,6
	Bcf B2,2
F17_000020 equ $ ; in [BINARY.INC] B2.1 = B1.5
; Bit_Bit B1,5,B2,1
	Bsf B2,1
	Btfss B1,5
	Bcf B2,1
F17_000021 equ $ ; in [BINARY.INC] B2.0 = B1.4
; Bit_Bit B1,4,B2,0
	Bsf B2,0
	Btfss B1,4
	Bcf B2,0
F17_000022 equ $ ; in [BINARY.INC] EmpIN[2] = B2
	Movfw B2
	Movwf EMPIN#2
F17_000023 equ $ ; in [BINARY.INC] B2 = 0
	Clrf B2
F17_000024 equ $ ; in [BINARY.INC] B2.3 = B1.3
; Bit_Bit B1,3,B2,3
	Bsf B2,3
	Btfss B1,3
	Bcf B2,3
F17_000025 equ $ ; in [BINARY.INC] B2.2 = B1.2
; Bit_Bit B1,2,B2,2
	Bsf B2,2
	Btfss B1,2
	Bcf B2,2
F17_000026 equ $ ; in [BINARY.INC] B2.1 = B1.1
; Bit_Bit B1,1,B2,1
	Bsf B2,1
	Btfss B1,1
	Bcf B2,1
F17_000027 equ $ ; in [BINARY.INC] B2.0 = B1.0
; Bit_Bit B1,0,B2,0
	Bsf B2,0
	Btfss B1,0
	Bcf B2,0
F17_000028 equ $ ; in [BINARY.INC] EmpIN[3] = B2
	Movfw B2
	Movwf EMPIN#3
F17_000030 equ $ ; in [BINARY.INC] B1 = CE[2]
	Movfw CE#2
	Movwf B1
F17_000031 equ $ ; in [BINARY.INC] B2 = 0
	Clrf B2
F17_000032 equ $ ; in [BINARY.INC] B2.3 = B1.7
; Bit_Bit B1,7,B2,3
	Bsf B2,3
	Btfss B1,7
	Bcf B2,3
F17_000033 equ $ ; in [BINARY.INC] B2.2 = B1.6
; Bit_Bit B1,6,B2,2
	Bsf B2,2
	Btfss B1,6
	Bcf B2,2
F17_000034 equ $ ; in [BINARY.INC] B2.1 = B1.5
; Bit_Bit B1,5,B2,1
	Bsf B2,1
	Btfss B1,5
	Bcf B2,1
F17_000035 equ $ ; in [BINARY.INC] B2.0 = B1.4
; Bit_Bit B1,4,B2,0
	Bsf B2,0
	Btfss B1,4
	Bcf B2,0
F17_000036 equ $ ; in [BINARY.INC] EmpIN[4] = B2
	Movfw B2
	Movwf EMPIN#4
F17_000037 equ $ ; in [BINARY.INC] B2 = 0
	Clrf B2
F17_000038 equ $ ; in [BINARY.INC] B2.3 = B1.3
; Bit_Bit B1,3,B2,3
	Bsf B2,3
	Btfss B1,3
	Bcf B2,3
F17_000039 equ $ ; in [BINARY.INC] B2.2 = B1.2
; Bit_Bit B1,2,B2,2
	Bsf B2,2
	Btfss B1,2
	Bcf B2,2
F17_000040 equ $ ; in [BINARY.INC] B2.1 = B1.1
; Bit_Bit B1,1,B2,1
	Bsf B2,1
	Btfss B1,1
	Bcf B2,1
F17_000041 equ $ ; in [BINARY.INC] B2.0 = B1.0
; Bit_Bit B1,0,B2,0
	Bsf B2,0
	Btfss B1,0
	Bcf B2,0
F17_000042 equ $ ; in [BINARY.INC] EmpIN[5] = B2
	Movfw B2
	Movwf EMPIN#5
F17_000044 equ $ ; in [BINARY.INC] Return
	Return
F17_EOF equ $ ; BINARY.INC
F18_SOF equ $ ; SOUND.INC
GOODSOUND
F18_000002 equ $ ; in [SOUND.INC] GoodSound:    Sound SPIN, [123,20]
	Movlw PORTC
	Movwf GEN
	Movlw 16
	Movwf GENH
	Movlw 123
	Movwf PP1
	Movlw 20
	F@Call Noise
F18_000003 equ $ ; in [SOUND.INC] Pause 30
	Movlw 30
	F@Call dl@ms
F18_000004 equ $ ; in [SOUND.INC] Sound SPin, [123,20]
	Movlw PORTC
	Movwf GEN
	Movlw 16
	Movwf GENH
	Movlw 123
	Movwf PP1
	Movlw 20
	F@Call Noise
F18_000005 equ $ ; in [SOUND.INC] Return
	Return
BADSOUND
F18_000009 equ $ ; in [SOUND.INC] BadSound:   Sound SPin, [107,40]
	Movlw PORTC
	Movwf GEN
	Movlw 16
	Movwf GENH
	Movlw 107
	Movwf PP1
	Movlw 40
	F@Call Noise
F18_000010 equ $ ; in [SOUND.INC] Pause 10
	Movlw 10
	F@Call dl@ms
F18_000011 equ $ ; in [SOUND.INC] Sound SPin, [97,40]
	Movlw PORTC
	Movwf GEN
	Movlw 16
	Movwf GENH
	Movlw 97
	Movwf PP1
	Movlw 40
	F@Call Noise
F18_000012 equ $ ; in [SOUND.INC] Return
	Return
F18_EOF equ $ ; SOUND.INC
	END

