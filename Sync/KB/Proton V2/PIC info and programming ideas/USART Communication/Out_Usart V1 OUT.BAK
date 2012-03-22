'Main Vehicle RFID System
'Sam Bozman


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

HSERIAL_BAUD = 9600 ' Set baud rate to 9600
HSERIAL_RCSTA = %10010000 ' Enable serial port and continuous receive
HSERIAL_TXSTA = %00100000 ' Enable transmit and asynchronous mode
HSERIAL_CLEAR = ON ' Optionally clear the buffer before receiving

DIM VAR1 AS BYTE

Loop:
HSEROUT ["XYZ"]
HSEROUT ["Hello there     "] 


Pause 500
Goto Loop