'
' General purpose USB CDC test program.
'
' Transmits data from several different buffers.
' And displays the contents of the USBIN buffer on the LCD
'
' Uses transmit and receive detection using the CARRY flag (STATUS.0)
'
' Communicate via the serial terminal set to the com port that the USB connects too.
'
	Device = 18F4550								' Choose a device with on-board full speed USB
    XTAL = 48										' Set the oscillator speed to 48MHz (using a 20MHz crystal)
    
    REMINDERS = OFF									' Disable all reminders
    
    LCD_DTPIN = PORTD.4								' LCD data port attached to PORTD
	LCD_RSPIN = PORTE.0								' LCD RS pin attached to PORTE.0
	LCD_ENPIN = PORTE.1								' LCD EN pin attached to PORTE.1
	LCD_INTERFACE = 4								' 4-bit Interface
	LCD_LINES = 2									' 2 line LCD
	LCD_TYPE = ALPHANUMERIC							' Use an Hitachi alphanumeric LCD								
        
    USB_DESCRIPTOR = "CDCDESC.INC"					' Point to the CDC DESCRIPTOR file (located in the INC\USB_18 folder)
    
    Dim PP0 as Byte SYSTEM							' USBPOLL status return
    Dim VAR1 as Word								' General purpose variable
    Dim ARRAY1[20] as Byte 							' Used to hold some output characters
   	Dim OUT_BUFFER as String * 20					' Used to hold some output characters
    Dim IN_BUFFER as String * 20					' Used to hold some input characters
    
    Symbol CARRY_FLAG = STATUS.0					' High if microcontroller does not have control over the DP buffer
    Symbol TRNIF = UIR.3							' Low if USB Busy
'------------------------------------------------------------------------
' The main program loop starts here 
   
    Delayms 200											' Wait for things to stabilise
    ALL_DIGITAL = True									' Set PORTA and PORTD to digital mode
    Clear												' Clear all RAM before we start 
    Cls													' Clear the LCD
    
    Repeat												' \
    	USBPoll											'   Wait for the USB interface to become attached
    Until PP0 = %00000110								' /
    
    STRN ARRAY1 = " ARRAY BUFFER\n\r"    				' Fill the array with NULL terminated characters
    OUT_BUFFER = " STRING BUFFER\n\r"                   ' Fill the string with NULL terminated characters
    
	VAR1 = 0     										' Reset the counting variable
	While 1 = 1											' Create an infinite loop
        Repeat											' Wait for USB input
        	USBIn 3, IN_BUFFER, AUTO					' Poll the USB and Receive some data from endpoint 3
        Until CARRY_FLAG = 0							' Keep looking until data is able to be received
        
        Print at 1,1,"USB BUFFER"  						
        Print at 2,1,IN_BUFFER                     		' Display the contents of the USB buffer on line 2 of the LCD
        Clear IN_BUFFER                            		' Then clear the buffer for the next time
               
        __USBOUT_BUFFER = " USB BUFFER\n\r" 			' Place characters directly into the USB TX buffer string
'
' Transmit from the USB's internal TX buffer String. NULL terminated.   
        Repeat  
			USBOut 3, __USBOUT_BUFFER, AUTO 			' Poll the USB and Transmit the buffer from endpoint 3 
    	Until CARRY_FLAG = 0							' Keep trying if the microcontroller does not have control over the buffer
        Repeat : Until TRNIF = 1						' Wait for completion before transmitting anything else
' Transmit from a NULL terminated array         
        Repeat  
			USBOut 3, ARRAY1, AUTO 						' Poll the USB and Transmit the buffer from endpoint 3 
    	Until CARRY_FLAG = 0							' Keep trying if the microcontroller does not have control over the buffer
        Repeat : Until TRNIF = 1						' Wait for completion before transmitting anything else
' Transmit from a NULL terminated String         
        Repeat 
			USBOut 3, OUT_BUFFER, AUTO 					' Poll the USB and Transmit the buffer from endpoint 3 
    	Until CARRY_FLAG = 0							' Keep trying if the microcontroller does not have control over the buffer
        Repeat : Until TRNIF = 1						' Wait for completion before transmitting anything else
' Transmit from a NULL terminated code memory String         
        Repeat  
			USBOut 3, TEXT_STRING, AUTO 				' Poll the USB and Transmit the buffer from endpoint 3 
    	Until CARRY_FLAG = 0							' Keep trying if the microcontroller does not have control over the buffer
        Repeat : Until TRNIF = 1						' Wait for completion before transmitting anything else
' Transmit a NULL terminated quoted string of characters        
        Repeat  
			USBOut 3, " QUOTED STRING\n\r", AUTO 		' Poll the USB and Transmit the buffer from endpoint 3 
    	Until CARRY_FLAG = 0							' Keep trying if the microcontroller does not have control over the buffer
        Repeat : Until TRNIF = 1						' Wait for completion before transmitting anything else
' Transmit 12 characters from a code memory String         
        Repeat
        	USBOut 3, TEXT_STRING, 12 					' Poll the USB and Transmit only 12 characters of the buffer from endpoint 3
        Until CARRY_FLAG = 0							' Keep trying if the microcontroller does not have control over the buffer
        Repeat : Until TRNIF = 1						' Wait for completion before transmitting anything else
        
        __USBOUT_BUFFER = "\n\rVAR1 = " + Str$(Dec,VAR1) + "\n\r"  ' Convert VAR1 into a string
' Transmit from the USB's internal TX buffer String. NULL terminated. 
		Repeat
			USBOut 3, __USBOUT_BUFFER, AUTO  			' Poll the USB and Transmit the buffer from endpoint 3 
        Until CARRY_FLAG = 0							' Keep trying if the microcontroller does not have control over the buffer
        Repeat : Until TRNIF = 1						' Wait for completion before transmitting anything else
        Inc VAR1 
    Wend												' Go wait for the next buffer input
	
    
TEXT_STRING: Cdata " CODE MEMORY BUFFER\n\r",0

