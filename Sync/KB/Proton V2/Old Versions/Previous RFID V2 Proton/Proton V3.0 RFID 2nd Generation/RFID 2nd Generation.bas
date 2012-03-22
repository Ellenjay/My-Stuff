'****************************************************************
'*  Name    : KeyBuster RFID 2nd Generation                                     
'*  Author  : [Sam and Kim Bozman]                    
'*  Notice  : Copyright (c) 2008 [Sam and Kim Bozman] 
'*          : All Rights Reserved                               
'*  Date    : 31/12/2008                                        
'*  Version : 1.0                                               
'*  Notes   : Added "Read Tag"  31/12/2008                                                
'*  Revision: Cleaning up code Oct 24/09
'*  Revision: Continue cleaning up code April 4/10 
'*  Major Revision April 6/10. Redo Variables and rewrite code                                              
'****************************************************************
Device 18F4525
CONFIG_START
   OSC = XT ; XT
   PWRT = On ; Enabled
   BOREN = OFF ; Disabled
   MCLRE = On ; Enabled
   PBADEN = OFF ; PORTB<4:0> digital on Reset
   STVREN = OFF ; Disabled
   LVP = On ; Enabled
CONFIG_END


XTAL = 4                        'Pic chip frequency is 4 mhz

'Declare KEYPAD_PORT PORTB 		'Set PORTB as keypad port. Has internal

Declare LCD_TYPE 0 				'Declare Alpha numeric Display
Declare LCD_DTPIN PORTD.0		'Bottom 4-line interface
Declare LCD_ENPIN PORTD.6		'Declare Enable pin
Declare LCD_RSPIN PORTD.7		'Declare Command/Data pin
Declare LCD_INTERFACE 4	 		'4 Line Data interface
Declare LCD_LINES 2	  			'Declare this to be a 2 line LCD

ALL_DIGITAL = TRUE

 HSERIAL_BAUD = 9600        ' Set baud rate to 9600
 HSERIAL_RCSTA = %10010000  ' Enable serial port and continuous receive
 HSERIAL_TXSTA = %00100000  ' Enable transmit and asynchronous mode 
 HSERIAL_CLEAR = On         ' Optionally clear the buffer before receiving



'----- SD Card port assignments ----------------------------------------------
Rem FWD Symbol SD_CS = PORTC.2          'Slave Select [SS](SD pin 1)
Rem FWD Symbol SD_DI = PORTC.5          'Master Out/Slave In [MOSI] (SD Pin 2)
Rem FWD Symbol SD_CLK = PORTC.3         'Clock  (SD Pin 5)
Rem FWD Symbol SD_DO = PORTC.4          'Master In Slave Out [MISO] (SD Pin 7)
Symbol SD_Detect = PORTB.0              'A GND is used to detect an fully inserted SD Card

  'Standard SD Card
 'Pin #   	 	 Spi signal function spi mode 
' -----------------------------------------------
'9 	DAT2/NC      Unused ...Note: This is the first offest pin numbering goes 9,1,2,3,4,5,6,7,8.
'1 	DAT3/CS      Chip Select/Slave Select [SS]
'2 	CMD/DI 	     Master Out/Slave In [MOSI]
'3 	VSS1 	     Ground 
'4 	Vdd 	     Voltage Supply [2.7v or 3.6v] 
'5 	Clock 	     Clock [SCK]
'6 	Vss2 	     Ground 
'7 	DAT0/D0      Master In Slave Out [MISO]
'8 	DAT1/IRQ     Unused or IRQ


 'microSD
'Pinout 	   Signal Function
'1 	DAT2 	   Data Bit 2
'2 	CD/DAT3    Card Detect / Data Bit 3
'3 	CMD 	   Command Line
'4 	Vdd 	   Supply Voltage 2.7v / 3.6v
'5 	CLK 	   Clock
'6 	Vss 	   Ground
'7 	DAT0 	   Data Bit 0
'8 	DAT1 	   Data Bit 1

'----------------- User ID and Tag variables and symbols --------------------------------------
 'NOTE: Declare arrays near beginning to prevent page boundry problems.
Dim TagIn[10] As Byte		          'VARIABLE array used for Tag ID read from SD card
Dim ModNum[7] As Byte       'Used to store Module number located at 0X9C40 in program memory.
Dim M_U_Code[4] As Byte     'Used for temporary storage of Manager update code from SD card.
Symbol RFIDEnable = PORTD.4	  'When high the RFID reader is active 
Symbol BUA = 0X9C50           'Start of User Table Address in Flash (program memory) where User Tag numbers are stored.
Symbol num_Users = 0X001              'Total # of Authorized User Tags is stored here. (Maximum 255 )
Symbol num_UHE = 0X002                'Number of User Tag history entries is stored here. (Maximum 80)
Symbol num_MHE = 0X003                'Number of Manager Update Code history entries is stored here.


'---------------- User History variables and Symbols ------------------------------------------
Symbol UHA = 0X010              'Beginning address in EEprom used to store 10 digit User Tag ID History
Symbol MHA = 0X390              'Beginning address in EEprom used to store 4 digit Manager Update code.
Symbol Max_UH = 80              'Maximum User History.. Keeps track of last 80 Tags
Symbol Max_MH = 10              'Maximum Manager History...Keeps track of last 10 Managers and dates of changes.
'-----------------------------------------------------------------------------------------------

Dim Response As Byte        'Temporary Byte variable
Dim MyCount As Byte         'Used for looping
Dim Index As Byte           'Used for looping
Dim Index2 As Byte          'Used for looping
Dim Byte_Var As Byte        'Temporary Byte variable
Dim Word_Var As Word        'Temporary Word Variable
Dim MyNum As String * 3
'------------------   Initialize     -----------------------
 DelayMS 200               'Allow chip to settle

Input SD_Detect           'Set SD Detect port as input...  (PORTB.0 ) 
Low RFIDEnable		              ' Turn off RFID Reader     (PORTD.4 )

'User_Pointer.LowByte = ERead UPA_L    'Read the low and high bytes of...
'User_Pointer.HighByte = ERead UPA_H    'user pointer address from EEprom
 Byte_Var = ERead num_UHE
 If Byte_Var = 0XFF Then                     'If the value read from EEprom is OXFFFF then this is a new chip so....
        EWrite num_Users, [0x00]             'Initialize total number of users to zero
        EWrite num_UHE, [0X00]              'Initialize number of User histories to zero
        EWrite num_MHE, [0X00]              'Initialize number of Manager histories to zero
EndIf
  Cls
  Print "Starting!"
  Pause 3000
                                                                                 
 If SD_Detect = 0 Then     ' a zero means we have detected a ground (SD card has been inserted)
    Cls
    Print "SD Detected!"
    Pause 3000
    GoSub Init_SD  '************ Only do one time when SD card detected.
    GoSub Read_SD   'This sub reads and writes users and managers to memory
 Else
    Cls
    Print "No SD.."
    Pause 3000
    'GoSub Init_SD  '************ Only do one time when SD card detected.
 End If 
 Stop
 '=================   Main Program   =======================
   
 GoSub Write_Users_SD
 Cls
 Print "Done"
 
 
  
  Pause 3000
  Start:
  'Cls
  'Print "Starting..."
  'Pause 3000
 
 Start2: 
  GoSub Read_Tag
  
  Cls
 Print "Checking TAG"
               ' Pause 2000
  GoSub Check_Tag
  If Response = 1 Then
    Cls
    Print At 1,1, "Got a match"
    Print At 2,1, Str UserIn
    GoSub WriteH
    Cls
    Print "History DONE!"
  Pause 2000
   GoTo Start2
  Else
    Cls
    Print "No Match"
    Pause 2000
    GoTo Start2
  EndIf
  Stop
  
 '------------ Includes -------------------------------------
 Include "INC\Read Tag.inc"
 Include "INC\Read SD.inc"
 Include "INC\Write SD.inc"
 Include "INC\Init SD.inc"
 Include "INC\Check Tag.inc"
 Include "INC\Write_U_H.inc"
 Include "INC\Write_M_H.inc"
 Include "INC\Write_M_SD.inc"
 Include "INC\Write_Users_SD.inc"
 Include "INC\Read_Mod.inc"
 Include "INC\GoSleep.inc"
 '-------------------- Module Number ------------------------
 Org 0X9C40            'This is the Address where the Module ID number will be stored
 CData "A27B83B", 0    ' ****** This is the unique module number for the module. ******
