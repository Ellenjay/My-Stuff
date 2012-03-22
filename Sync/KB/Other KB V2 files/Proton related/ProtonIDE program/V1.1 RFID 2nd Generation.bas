'****************************************************************
'*  Name    : KeyBuster RFID 2nd Generation                                     
'*  Author  : [Sam and Kim Bozman]                    
'*  Notice  : Copyright (c) 2008 [Sam and Kim Bozman] 
'*          : All Rights Reserved                               
'*  Date    : 31/12/2008                                        
'*  Version : 1.0                                               
'*  Notes   : Added "Read Tag"  31/12/2008                                                
'*          :                                                   
'****************************************************************
Device 18F4525

XTAL = 4
'Include "INC\18F4525_Config.inc" 	
Declare KEYPAD_PORT PORTB 		'Set PORTB as keypad port. Has internal

Declare LCD_TYPE 0 				'Declare Alpha numeric Display
Declare LCD_DTPIN PORTD.0		'Bottom 4-line interface
Declare LCD_ENPIN PORTD.6		'Declare Enable pin
Declare LCD_RSPIN PORTD.7		'Declare Command/Data pin
Declare LCD_INTERFACE 4	 		'4 Line Data interface
Declare LCD_LINES 2	  			'Declare this to be a 2 line LCD

'-----------------------------------------------------------

ALL_DIGITAL = TRUE

'-----------------------------------------------------------
 
 HSERIAL_BAUD = 9600        ' Set baud rate to 9600
 HSERIAL_RCSTA = %10010000  ' Enable serial port and continuous receive
 HSERIAL_TXSTA = %00100000  ' Enable transmit and asynchronous mode 
 HSERIAL_CLEAR = On         ' Optionally clear the buffer before receiving
 
Rem FWD Symbol SD_CS = PORTC.2          'Slave Select [SS](SD pin 1)
Rem FWD Symbol SD_DI = PORTC.5          'Master Out/Slave In [MOSI] (SD Pin 2)
Rem FWD Symbol SD_CLK = PORTC.3         'Clock  (SD Pin 5)
Rem FWD Symbol SD_DO = PORTC.4          'Master In Slave Out [MISO] (SD Pin 7)
Symbol SD_Detect = PORTA.1    'A GND is used to detect an fully inserted SD Card
Symbol RFIDEnable = PORTD.4	  'When high the RFID reader is active 
'----------------- User ID and Tag variables and symbols --------------------------------------
Dim User_Pointer As Word       'Variable to hold 2 byte pointer to next empty (16 byte) user spot in program memory.
Symbol BUA = 0X9C50          'Base User Address in Flash (program memory) where User numbers and Tag numbers are stored.
Symbol UPA_L = 0X000           ' Address in EEProm where low byte of User Pointer is stored
Symbol UPA_H = 0X001            'Address in EEProm where high byter of User Pointer is stored.
Symbol TagOffset = 4            'Offset from start of User address over user number to Tag number
Dim TagIn[10] As Byte		'VARIABLE array used for Tag ID
Dim UserIn[4] As Byte       'Variable array used for User ID number
Dim UTag[16] As Byte
Dim ETX As Byte             'End Of Text (0X83) for end of Tag ID data
Dim CheckSum As Byte        'Used to hold Check Sum byte of Tag read..
'---------------- User History variables and Symbols ------------------------------------------
Symbol SHA = 0X200              'Beginning address in EEprom used to store 4 digit User ID History
Symbol EHA = 0X3F4               'End address in EEprom used to store 4 digit User ID History 
Symbol UHPA = 0X002             ' Byte in EEprom holding the current next empty User OFFSET histroy address spot
Dim UHP As Word               'Variable used to hold User Pointer address
Dim String_Data As String * 16
'-----------------------------------------------------------------------------------------------
Dim ModNum[7] As Byte       'Used to store Module number located at 0X9C40 in program memory.
Dim Response As Byte
Dim SD_IO As Byte
Dim Flag As Bit
Dim MyCount As Byte

Dim Index As Byte           'Used for programming Variable
Dim Index2 As Word         'Used for programming variable
Dim TV1 As Byte             'Temporary variable

'------------------   Initialize     -----------------------
 DelayMS 200               'Allow chip to settle
 
 


Low RFIDEnable		              ' Turn off RFID Reader
User_Pointer.LowByte = ERead UPA_L    'Read the low and high bytes of...
User_Pointer.HighByte = ERead UPA_H    'User pointer address from EEprom

If User_Pointer = 0XFFFF Then             'If the values read from EEprom were OXFFFF then this is a new chip so....
    User_Pointer = BUA                   'We write the low and ..
    EWrite UPA_L, [User_Pointer.LowByte]  'High bytes of the base user address (0X9C500...
    EWrite UPA_H, [User_Pointer.HighByte]  'into the EEProm Pointer storage spot (0X000 and 0X001)
EndIf

 If ERead UHPA = 0XFF Then                      'If UHPA = 0XFF then this is a new chip and we will...
    EWrite UHPA, [0X00]                          ' Start off with the first history address OFFSET (0)                   
 EndIf
 If SD_Detect = False Then
   GoSub Init_SD  '************ Only do one time when SD card detected.
   GoSub Read_SD   
 End If 
 
 '=================   Main Program   =======================
 
   
  Start:
  Cls
  Print "Starting..."
  Pause 3000
 
 Start2: 
  GoSub Read_Tag
  GoSub Check_Tag
  If Response = 1 Then
    Cls
    Print At 1,1, "Got a match"
    Print At 2,1, Str UserIn
    GoSub WriteH
    Cls
    Print "DONE!"
  Pause 4000
   GoTo Start2
  Else
    Cls
    Print "No Match"
    Pause 3000
    GoTo Start2
  EndIf
  Stop
  
 '------------ Includes -------------------------------------
 Include "INC\Read Tag.inc"
 Include "INC\Read SD.inc"
 Include "INC\Write SD.inc"
 Include "INC\Init SD.inc"
 Include "INC\Check Tag.inc"
 Include "INC\WriteH.inc"
 Include "INC\Test.inc"
 '-------------------- Module Number ------------------------
 Org 0X9C40            'This is the Address where the Module ID number will be stored
 CData "A27B83B", 0    ' ****** This is the unique module number for the module. ******
