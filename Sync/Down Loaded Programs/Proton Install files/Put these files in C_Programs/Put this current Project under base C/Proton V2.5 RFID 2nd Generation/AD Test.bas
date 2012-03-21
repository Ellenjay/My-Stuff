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
Symbol SD_Detect = PORTA.1     '*************A GND is used to detect an fully inserted SD Card
Symbol RFIDEnable = PORTD.4	  'When high the RFID reader is active 

'----------------- Initialize for PortB.0 Inturupt   --------------------------------------
 Symbol GIE = INTCON.7 		' Global interrupt enable/disable 
  INTCON2.6 = 1        'Set to allow PortB.0 to detect a low to high pulse 
 'INTCON2.6 = 0	  'Set to allow PortB.0 to detect a high to low pulse 
 PORTB_PULLUPS = TRUE       				' Enable PORTB pullups
 INTCON.4 = 0	  	  	  	  	'Set wakeup on PortB.0 to off
 INTCON.1 = 0 	'Clear the interrupt flag for PortB.0
 
'----------------- Initialize for A/D conversion on PortA.0 ------------------------------- 
 Declare ADIN_RES 10       ' 10-bit result required 
 Declare ADIN_TAD FRC      ' RC OSC chosen 
 Declare ADIN_STIME 50     ' Allow 50us sample time 
 Dim VAR1 As Word 
 TRISA = %00000011         ' Configure AN0 and AN1(PORTA.0 and PortA.1) as an input 
 ADCON1 = %10001110        ' Set analogue input on PORTA.0 

'----------------------- Start of Main Program --------------------------------------------
Start: 
        GIE = 0 					' Turn OFF global interrupts 
        While GIE = 1 : GIE = 0 : Wend 	' And make sure they are off 
        
GoTo GoSleep
 again:
 VAR1 = ADIn 0             ' Place the conversion into variable VAR1 
 Pause 100
 Print At 1,1, Dec VAR1
 GoTo again


Include "INC\GoSleep.inc"
