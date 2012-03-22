'
' General purpose USB CDC test program
' Transmits data from several different buffers.
' And displays the contents of the USBIN buffer on the LCD
'
' Uses transmit and receive detection with labels in the USBIN\USBOUT commands (not recommended)
'
' Communicate via the serial terminal set to the com port that the USB connects too.
'
	Device = 18F4550								' Use a device with full speed USB capabilities
    XTAL = 48										' Set the oscillator speed to 48MHz (using a 20MHz crystal)
    
    REMINDERS = OFF									' Disable all reminders
    
    LCD_DTPIN = PORTD.4								' LCD data port attached to PORTD
	LCD_RSPIN = PORTE.0								' LCD RS pin attached to PORTE.0
	LCD_ENPIN = PORTE.1								' LCD EN pin attached to PORTE.1
	LCD_INTERFACE = 4								' 4-bit Interface
	LCD_LINES = 2									' 2 line LCD
	LCD_TYPE = ALPHANUMERIC							' Use an alphanumeric LCD								
 
    USB_DESCRIPTOR = "CDCDESC.INC"					' Point to the CDC DESCRIPTOR file (located in the INC\USB_18 folder)
    
    Dim VAR1 as Word								' General purpose variable
    Dim ARRAY1[20] as Byte 							' Used to hold some output characters
   	Dim OUT_BUFFER as String * 20					' Used to hold some output characters
    Dim IN_BUFFER as String * 20					' Used to hold some input characters
    
'------------------------------------------------------------------------
' The main program loop starts here
   
    Delayms 200											' Wait for things to stabilise
    ALL_DIGITAL = True									' Set PORTA and PORTD to digital mode
    Clear												' Clear all RAM before we start
    Cls													' Clear the LCD
    
    STRN ARRAY1 = " ARRAY BUFFER\n\r"    				' Fill the array with NULL terminated characters
    OUT_BUFFER = " STRING BUFFER\n\r"                   ' Fill the string with NULL terminated characters
    
	VAR1 = 0     										' Reset the counting variable
    While 1 = 1											' Create an infinite loop
RX_LOOP:												' Wait for USB input
		USBIn 3, IN_BUFFER, AUTO, RX_LOOP				' Poll the USB and Receive some data from endpoint 3  

        Print at 1,1,"USB BUFFER"  						
        Print at 2,1,IN_BUFFER                          ' Display the contents of the USB buffer on line 2 of teh LCD
        Clear IN_BUFFER                                	' Then clear the buffer for the next time
        
        __USBOUT_BUFFER = " USB BUFFER\n\r" 			' Place characters directly into the USB TX buffer string
'
' Transmit from the USB's internal TX buffer String. NULL terminated.   
TX_LOOP1: 
		USBOut 3, __USBOUT_BUFFER, AUTO, TX_LOOP1  		' Poll the USB and Transmit the buffer from endpoint 3 
    	Delayms 5										' Wait before transmitting anything else (not more than 10ms)
' Transmit from a NULL terminated array        
TX_LOOP2: 
		USBOut 3, ARRAY1, AUTO, TX_LOOP2 				' Poll the USB and Transmit the buffer from endpoint 3 
    	Delayms 5										' Wait before transmitting anything else (not more than 10ms)
' Transmit from a NULL terminated String        
TX_LOOP3:
		USBOut 3, OUT_BUFFER, AUTO, TX_LOOP3 			' Poll the USB and Transmit the buffer from endpoint 3
    	Delayms 5										' Wait before transmitting anything else (not more than 10ms)
' Transmit from a NULL terminated code memory String        
TX_LOOP4:
		USBOut 3, TEXT_STRING, AUTO, TX_LOOP4 			' Poll the USB and Transmit the buffer from endpoint 3
    	Delayms 5										' Wait before transmitting anything else (not more than 10ms)
' Transmit a NULL terminated quoted string of characters         
TX_LOOP5: 
		USBOut 3, " QUOTED STRING\n\r", AUTO, TX_LOOP5 	' Poll the USB and Transmit the buffer from endpoint 3
        Delayms 5										' Wait before transmitting anything else (not more than 10ms)
' Transmit 12 characters from a code memory String 
TX_LOOP6: 
		USBOut 3, TEXT_STRING, 12, TX_LOOP6 				' Poll the USB and Transmit only 12 characters of the buffer from endpoint 3
        Delayms 5										' Wait before transmitting anything else (not more than 10ms)
' Transmit from the USB's internal TX buffer String. NULL terminated.		       
        __USBOUT_BUFFER = "\n\rVAR1 = " + Str$(Dec,VAR1) + "\n\r" ' Convert VAR1 into a string
TX_LOOP7: 
		USBOut 3, __USBOUT_BUFFER, AUTO, TX_LOOP7  		' Poll the USB and Transmit the buffer from endpoint 3 
    	Inc VAR1   
    Wend												' Go wait for the next buffer input
	
    
TEXT_STRING: Cdata " CODE MEMORY BUFFER\n\r",0

