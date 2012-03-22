'Main Vehicle RFID System
'Sam Bozman
'APRIL 4, 2007	
'Revised Oct 19, 2007
'Revised May 2, 2008 (Up to 24 users from 12 users)
'Revised jUNE 17 2008 Removed Master key
'Revised Sept 2008.. Shut off BODEN
'Vehicle Security Project

Device = 16F877A
Config XT_OSC , WDT_OFF , PWRTE_ON , BODEN_OFF , LVP_OFF , CP_OFF , DEBUG_OFF

XTAL  = 4 


	
Declare KEYPAD_PORT PORTB 		'Set PORTB as keypad port. Has internal

Declare LCD_TYPE 0 				'Declare Alpha numeric Display
Declare LCD_DTPIN PORTD.0		'Bottom 4-line interface
Declare LCD_ENPIN PORTD.6		'Declare Enable pin
Declare LCD_RSPIN PORTD.7		'Declare Command/Data pin
Declare LCD_INTERFACE 4	 		'4 Line Data interface
Declare LCD_LINES 2	  			'Declare this to be a 2 line LCD

Dim Index As Byte			'Used to Index a loop
Dim Index2 As Byte			'Used to Index a loop

Dim TagOffset As Byte		'Base Address offset of Tag position in table spot
Dim B1 As Byte 				'Variable for temporary storage
Dim B2 As Byte				'Variable for temporary storage
Dim Flag As Bit				'Used to indicate a decision in a sub

Dim CurrentLine As Byte		'Used as a variable for printing to LCD lines
Dim StartLine As Byte		'Used by Scroll and ScrollH for start of table
Dim EndLine As Byte			'Used by Scroll and ScrollH for end of table
Dim LastUser As Byte		'Used by ScrollH for last user history record address

Dim EmpIN[6] As Byte		'Set temporary spot of Employee #
Dim CE[3] As Byte			'Used to consolidate Emp # (6 digits to 3 using low and high bits of byte)
Dim TagIn[10] As Byte		'Set temporary spot for Tag ID
Dim CT[5] As Byte			'Used to consolidate Tag Id numbers(10 digits to 5 by simply adding each pair of digits)
Dim Footer As Byte			'end (0x0D) of Tag number
Dim NUA As Byte				'Next User Address spot in EEprom
Dim STime As Byte			'Time in MS to play sound
Symbol GIE = INTCON.7 		' Global interrupt enable/disable 
Symbol StartEnable = PORTD.5  ' This port goes Low to turn on the start solonoid

Symbol Green = PORTC.2		  'Bi LED Multi-coloured LED ..when both Port C.1 and Port C.2 are
Symbol Red = PORTC.1		  'high then LED is Orange
Symbol SPin = PORTC.4		  'Pin used to create sound by Piezo speaker
Symbol RFIDEnable = PORTD.4	  'When high the RFID reader is active  	   				 	 				
Symbol HHDetect = PORTC.3	  ' Detects when the Hand-Held is plugged in (Programming Mode)

' Define KeyPad variables
	  Dim Col     As     Byte            		' Keypad column
	  Dim Row     As     Byte            		' Keypad row
	  Dim Key     As     Byte            		' Key value      		 

	  OPTION_REG.6 = 0	  'Set to allow PortB.0 to detect a high to low pulse 
	  'Option_Reg.6 = 1 	   'Set to allow PortB.0 to detect a low to high pulse 
	  PORTB_PULLUPS = TRUE       				' Enable PORTB pullups
	  ALL_DIGITAL = TRUE		 		'Sets all Ports to digital inputs and outputs
	  Input HHDetect						'Set HHDetect as input
	  Output StartEnable					'Set PORTD.5 as OutPut


Start:		 					'Start of program

 
B1 = "C"   'Set B1 to 'Clear' so that it is not confused when checking Employee Numbers 
	  Low Red   	  		  'Set Bi-Polar Led Off
	  Low Green			  'Set Bi-Polar Led Off
	  High RFIDEnable		   	  				' Turn off RFID Reader	
	  Low StartEnable							'Shut off start relay
	  High RFIDEnable							'Shut Off RFID Reader
	  GIE = 0 					' Turn OFF global interrupts 
	  While GIE = 1 : GIE = 0 : Wend 	' And make sure they are off 
	  INTCON.4 = 0	  	  	  	  	'Set wakeup on PortB.0 to off




'IN THE NEXT SEQUENCE THIS PROGRAM WILL CHECK TO SEE IF THIS IS A 'NEW' CHIP
'If this is a new chip then ERead Address 255 will be 0xFF.
'If so then we will read the 'Master' chip and intialize the data table.
	    Print $FE, $0F							'Blinking Cursor ON
	    Cls	  	   								'Clear LCD
	    Print $FE , 2							'Move Cursor to HOME	

	    TagOffset = 3								'Unit key table OffSet
	    NUA = ERead 255								'Set 'NUA' to next empty user address in Table   

If NUA = 0xFF Then 	 'If User address spot = 0xFF then chip is new
   EWrite 255,[5] 	  'This is the first User address spot. (0-4 is used by 'Master Key')
   NUA = 5
   EWrite 254, [202]  'This is the first spot for User History records 
   GoTo MainMenu 
EndIf  
NUA = ERead 255
	
	If HHDetect = 1 Then	'We have detected that the programming HandHeld is plugged in.
	   	Cls
		Print At 1,1, "Welcome to"
		Print At 2,1, "KeyBusters..."
		Pause 3000
		GoTo MainMenu  
	
	Else 'HHDetect = 1	 		   	 'Hand Held programmer was not detected so		   				 '
		Cls
		Print At 1,1, "Ready to"	 'we will attempt to get a user key and
		Print At 2,1, "Start Unit"	 'start the unit.
		GoTo StartUnit
	
	EndIf 'HHDetect = 1	

'=======================Include Files========================================
Include "INC\GetKey.inc"      'get the key press from keypad
Include "INC\AddNewUser.inc"  'Adding a new user
Include "INC\GetUser#.inc"	  'Get employee # from keypad
Include "INC\Scroll.inc"	  'Scroll existing Users
Include "INC\ScrollH.inc"	  'Scroll User History
Include "INC\CheckUser.inc"	  'Check that user does not already exist
Include "INC\CheckTag.inc"	  'Check that Tag does not already exist
Include "INC\ReadTag.inc"	  'Read a Tag
Include "INC\Write.inc"		  'Writing User # and Tags to Table
Include "INC\WriteH.inc"	  'Write User History to table
Include "INC\UserMenu.inc"	  'Main User Menu to add, delete and view users
Include "INC\MainMenu.inc"	  'MainMenu
Include "INC\StartUnit.inc"	  'StartUnit routine
Include "INC\GoSleep.inc"	  'Sleep and wakeup routine
Include "INC\Binary.inc"	  'Used to Split hex number into decimal
Include "INC\Sound.inc"		  'Used for sound generation
'.......................End of Include Files.................................

