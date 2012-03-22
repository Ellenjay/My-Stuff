'Main Vehicle RFID System
'Sam Bozman
'APRIL 4, 2007	
'Revised Oct 19, 2007
'Revised May 2, 2008 (Up to 24 users from 12 users)
'Revised jUNE 17 2008 Removed Master key
'Revised Sept 2008.. Shut of BODEN
'Vehicle Security Project

DEVICE = 16F877A
CONFIG XT_OSC , WDT_OFF , PWRTE_ON , BODEN_OFF , LVP_OFF , CP_OFF , DEBUG_OFF

XTAL  = 4 


	
DECLARE KEYPAD_PORT PORTB 		'Set PORTB as keypad port. Has internal

DECLARE LCD_TYPE 0 				'Declare Alpha numeric Display
DECLARE LCD_DTPIN PORTD.0		'Bottom 4-line interface
DECLARE LCD_ENPIN PORTD.6		'Declare Enable pin
DECLARE LCD_RSPIN PORTD.7		'Declare Command/Data pin
DECLARE LCD_INTERFACE 4	 		'4 Line Data interface
DECLARE LCD_LINES 2	  			'Declare this to be a 2 line LCD

'-----------------------Keypad -------------------------------------------
CLS
Print at 1,1, "Hello"
