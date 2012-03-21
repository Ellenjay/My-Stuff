'
' Implement the functionality of a Jan Axelson demo. 
' Accept two numbers from the host, increment each then send them back. 
'
' The application to run on the PC is named USBHIDIO.EXE and can be found in the INC\USB_18 folder
'
	Device = 18F4550									' Choose a device with on-board full speed USB
    XTAL = 48											' Set the oscillator speed to 48MHz (using a 20MHz crystal)
        
    USB_DESCRIPTOR = "JADESC.INC"						' Point to the DEMO DESCRIPTOR file (located in the INC\USB_18 folder)

	Dim PP0 as Byte SYSTEM								' USBPOLL status return
    Dim BUFFER[4]   as Byte								' USB IO buffer

	Symbol LED = PORTD.0
    Symbol CARRY_FLAG = STATUS.0						' High if microcontroller does not have control over the buffer
    Symbol TRNIF = UIR.3								' Low if USB Busy

'-----------------------------------------------------------------------
' The main program loop starts here 
   
    Delayms 200											' Wait for things to stabilise
    ALL_DIGITAL = True									' Set PORTA and PORTD to digital mode
    Clear												' Clear all RAM before we start   
	
    Repeat												' \
    	USBPoll											'   Wait for the USB interface to become attached
    Until PP0 = %00000110								' /

	While 1 = 1											' Create an infinite loop
        Low LED											' Extinguish the LED while waiting for USB input
        Repeat											' Wait for USB input of 2 numbers.
        	USBIn 1, BUFFER, AUTO						' Poll the USB and Receive some data from endpoint 1
        Until CARRY_FLAG = 0							' Keep looking until data is able to be received	
'        
' Message received. So Illuminate the LED, Increment the bytes and transmit them back.
'
		High LED										' Illuminate the LED when bytes received
        Inc BUFFER#0									' Increment the first byte received
		Inc BUFFER#1									' Increment the second byte received
        Repeat
    		USBOut 1, BUFFER, 2							' Send the 2 bytes back from endpoint 1
		Until CARRY_FLAG = 0							' Keep trying if the microcontroller does not have control over the buffer
        Repeat : Until TRNIF = 1						' Wait for completion before continuing
	Wend												' Wait for next buffer input

