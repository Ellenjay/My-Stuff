'
' Demonstrate a HID (Human Interface Device) interface
'
' When connected to the PC, the mouse pointer will rotate in a small square

	Device = 18F4550								' Choose a device with on-board full speed USB
    XTAL = 48										' Set the oscillator speed to 48MHz (using a 20MHz crystal)
      
    USB_DESCRIPTOR = "MOUSDESC.INC"					' Point to the MOUSE DESCRIPTOR file (located in the INC\USB_18 folder)
    
    Dim PP0 as Byte SYSTEM							' USBPOLL status return
    Dim BUFFER[4]   as Byte
	Dim LOOP_COUNT	as	Byte
	Dim POSITION	as	Byte
    Dim INDEX as Word
    
    Symbol CARRY_FLAG = STATUS.0					' High if microcontroller does not have control over the DP buffer
    Symbol TRNIF = UIR.3							' Low if USB Busy

'------------------------------------------------------------------------
' The main program loop starts here 
   
    Delayms 200											' Wait for things to stabilise
    Clear												' Clear all RAM before we start   
	
    Repeat												' \
    	USBPoll											'   Wait for the USB interface to become attached
    Until PP0 = %00000110								' /
    
	While 1 = 1
		For POSITION = 0 To 3							' Move through each position
			For LOOP_COUNT = 0 To 31					' 32 steps in each direction
				Select POSITION
                	Case 0								' Move UP ?
                    	BUFFER#1 = 0
						BUFFER#2 = -2
                    Case 1								' Move RIGHT ?
                    	BUFFER#1 = 2
						BUFFER#2 = 0
                    Case 2								' Move DOWN ?
                    	BUFFER#1 = 0
						BUFFER#2 = 2
                    Case 3								' Move LEFT ?
                    	BUFFER#1 = -2
						BUFFER#2 = 0
                End Select
				Repeat
					USBOut 1, BUFFER, 4  				' Send the buffer to endpoint 1
				Until CARRY_FLAG = 0					' Keep trying if the microcontroller does not have control over the buffer
            	Repeat : Until TRNIF = 1				' Wait for completion before continuing
            Next
		Next
	Wend
    
    
