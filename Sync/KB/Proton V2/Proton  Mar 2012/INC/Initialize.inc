'****************************************************************
'*  Name    : UNTITLED.BAS                                      *
'*  Author  : [Sam and Kim Bozman]                              *
'*  Notice  : Copyright (c) 2011 Copyright (c) 2010 All rights  *
'*          : All Rights Reserved                               *
'*  Date    : 3/22/2011                                         *
'*  Version : 1.0                                               *
'*  Notes   :                                                   *
'*          :                                                   *
'****************************************************************
Device 18F4525
CONFIG_START
   OSC = XT ; XT
   PWRT = On ; Power Up Timer Enabled
   BOREN = OFF ;Brown Out Reset  Disabled
   MCLRE = On ; Master Clear Reset Pin Enabled
   PBADEN = OFF ; PORTB<4:0> digital on Reset
   STVREN = OFF ; Disabled
   WDT = OFF    ; Watch Dog Timer is Disabled
   LVP = On ; Enabled
   XINST = OFF ; Enhanced CPU disabled
   CP0 = OFF ; Block 0 not code-protected
   CP1 = OFF ; Block 1 not code-protected
   CPB = OFF ; Boot block not code-protected
   CPD = OFF ; Data EEPROM not code-protected
   WRT0 = OFF ; Block 0 not write-protected
   WRT1 = OFF ; Block 1 not write-protected
   WRTB = OFF ; Boot block not write-protected
   WRTC = OFF ; Configuration registers (300000-3000FFh) not write-protected
   WRTD = OFF ; Data EEPROM not write-protected
   EBTR0 = OFF ; Block 0 not protected from table reads executed in other blocks
   EBTR1 = OFF ; Block 1 not protected from table reads executed in other blocks
   EBTRB = OFF ; Boot block not protected from table reads executed in other blocks
CONFIG_END


XTAL = 4                        'Pic chip frequency is 4 mhz

'Set up alpknumeric disply---------------------------------------
Declare LCD_TYPE 0 				'Declare Alpha numeric Display
Declare LCD_DTPIN PORTD.0		'Bottom 4-line interface
Declare LCD_ENPIN PORTD.6		'Declare Enable pin
Declare LCD_RSPIN PORTD.7		'Declare Command/Data pin
Declare LCD_INTERFACE 4	 		'4 Line Data interface
Declare LCD_LINES 2	  			'Declare this to be a 2 line LCD

ALL_DIGITAL = TRUE          'set up digital defaults
 'Set up communications for RFID reader------------------------------
 HSERIAL_BAUD = 9600        ' Set baud rate to 9600
 HSERIAL_RCSTA = %10010000  ' Enable serial port and continuous receive
 HSERIAL_TXSTA = %00100000  ' Enable transmit and asynchronous mode 
 HSERIAL_CLEAR = On         ' Optionally clear the buffer before receiving

'----- SD Card port assignments ----------------------------------------------
Rem Fwd Symbol SD_CS = PORTC.2          'Chip Select [CS]
Rem Fwd Symbol SD_DI = PORTC.5          'Master Out/Slave In [MOSI] 
Rem Fwd Symbol SD_CLK = PORTC.3         'Clock  
Rem Fwd Symbol SD_DO = PORTC.4          'Master In Slave Out [MISO]
Symbol SD_Detect = PORTC.1             'A GND is used to detect an fully inserted SD Card

  'Standard SD Card
 'Pin SPI Mode

   ' 1 	CS 	I 	Chip selection in low status
   ' 2  DI 	I 	Data input (MOSI)
   ' 3 	VSS 	S 	GND
   ' 4 	VDD 	S 	Power supply
   ' 5 	SCLK 	I 	Clock
   ' 6 	VSS2 	S 	GND
   ' 7 	DO 	O/PP 	Data output (MISO)
   ' 8 	RSV 	  	 
   ' 9 	RSV 	  	 


 'microSD
'Pinout SPI Mode

'1 	NC 	No Connect
'2 	/CS 	Chip Select
'3 	DI 	Master Out/Slave In (MOSI)
'4 	Vdd 	Supply Voltage 2.7v / 3.6v
'5 	CLK 	Clock
'6 	Vss 	Ground
'7 	DO 	Master In/Slave Out (MISO)
'8 	RSV 	Reserved

'----------------- User ID, Tag variables and other symbols --------------------------------------
 'NOTE: Declare arrays near beginning to prevent page boundry problems.
Dim TagIn[10] As Byte		          'VARIABLE array used for Tag ID read from SD card
Dim TagByte[10] As Byte            'Variable to store double characters in Tag read for checksum calculation
Dim ModNum[7] As Byte       'Used to store Module number located at 0X9C40 in program memory.
Dim M_U_Code[4] As Byte     'Used for temporary storage of Manager update code from SD card.
Dim bBoot_Cnt   As Byte     ; our restart counter
Dim bReset_Type As Byte     ; our type of reset deduced from PCON 
Symbol RFIDEnable = PORTD.4	  'When high the RFID reader is active 
Symbol StartEnable = PORTE.1  'Port goes high for start enable

Symbol BUA = 0X9C80           'Start of User Table Address in Flash (program memory) where User Tag numbers are stored.  
'In order to write to flash the Cwrite block needs to be on a 64 byte boundry...
Symbol FlashEraseSeg = 64            'Cerase needs to be done in 64 byte increments..
Symbol EndOfCodeSpace = 0XA676    'End of User table
Symbol FlashWriteBlock = 16 ; The memory size Flash write needs to do in one block

Symbol num_Users = 0X001              'Total # of Authorized User Tags is stored here. (Maximum 255 )
Symbol num_UHE = 0X002                'Number of User Tag history entries is stored here. (Maximum 80)
Symbol num_MHE = 0X003                'Number of Manager Update Code history entries is stored here.
Symbol DBO = 0X004                  'Delay Before Operate in seconds (Max 255 seconds)
Symbol TOP = 0X005                   'Time in seconds that output is on. (Max 255 seconds)
Symbol SOO = 0X006                  'Sound Status ON (1) or OFF (0)
Symbol MOP = 0X007                   ' Module is Normal (0), Open (1) or Closed(3)
Symbol eBoot_Cnt_Location = 0X10     '(Start of Reset Logger code location - Max 10 bytes)
Symbol SP1 = PORTC.0                 'Sound Out 
Symbol Red = PORTA.0               'TRI LED red lead control
Symbol Green = PORTA.1            'Tri LED green lead control
Symbol VC = PORTA.3                'Voltage control. High VC = 3.6V ... Low VC = 5V
Symbol SDC = PORTD.5                'SD card 'on-off' control  Low SDC (SD card ON) or High SDC (SD card OFF)
'---------------- User History variables and Symbols ------------------------------------------
Symbol UHA = 0X01A              'Beginning address in EEprom used to store 10 digit User Tag ID History
Symbol MHA = 0X390              'Beginning address in EEprom used to store 4 digit Manager & Date Update code.
Symbol Max_UH = 50             'Maximum User History.. Keeps track of last 50 Tags
Symbol Max_MH = 10              'Maximum Manager History...Keeps track of last 10 Managers and dates of changes.
'-----------------------------------------------------------------------------------------------
Dim ETX As Byte             'End Of Text (0X83) for end of Tag ID data
Dim CheckSum As Byte        'Used to hold Check Sum byte of Tag read..
Dim Response As Byte        'Temporary Byte variable
Dim MyCount As Byte         'Used for looping
Dim Index As Byte           'Used for looping
Dim Index2 As Byte          'Used for looping
Dim Byte_Var As Byte        'Temporary Byte variable
Dim Word_Var As Word        'Temporary Word Variable
Dim MyNum As String * 3
Dim Reset_Cause As String * 10 ' Used to hold cause of last reset


'------------------   Initialize Ports   -----------------------

DelayMS 200               'Allow chip to settle
High SDC              'Turn SD card power off
Input SD_Detect           'Set SD Detect port as input...  (PORTC.1 ) 
GoSub High_V          '5V ON (Voltage_Control)
Low RFIDEnable		       ' Turn off RFID Reader     (PORTD.4 )
Low StartEnable         'Make sure start enable is off
Low Red            'Turn off Red &
Low Green          'Green LED



Byte_Var = ERead num_UHE
    If Byte_Var = 0XFF Then         'If the value read from EEprom is OXFFFF then this is a new chip so....
        EWrite num_Users, [0x00]    'Initialize total number of users to zero
        EWrite num_UHE, [0X00]      'Initialize number of User histories to zero
        EWrite num_MHE, [0X00]      'Initialize number of Manager histories to zero
        EWrite DBO, [0X00]          'Intialize DBO (Delay before Operate) to zero (Default)
        EWrite TOP, [0X1E]          'Initialize TOP (Time for Operate) to 30 sec. (Default)
        EWrite SOO, [0X01]          'Initialize Sound to 'ON' (Default)
        EWrite MOP, [0X00]           'Initialize Module operating parameter to 'Normal'
    EndIf


