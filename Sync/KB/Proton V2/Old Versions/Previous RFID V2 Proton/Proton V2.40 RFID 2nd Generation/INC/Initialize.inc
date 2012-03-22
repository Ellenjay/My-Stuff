'****************************************************************
'*  Name    : Initialize.Inc                                     *
'*  Author  : [select VIEW...EDITOR OPTIONS]                    *
'*  Notice  : Copyright (c) 2009 [select VIEW...EDITOR OPTIONS] *
'*          : All Rights Reserved                               *
'*  Date    : 3/27/2009                                         *
'*  Version : 1.0                                               *
'*  Notes   :                                                   *
'*          :                                                   *
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
Symbol SD_Detect = PORTA.1     'A GND is used to detect an fully inserted SD Card
Symbol RFIDEnable = PORTD.4	  'When high the RFID reader is active 






