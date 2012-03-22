' Program to demonstrate the USB commands
' Moves the computer's cursor in a small square

		Device = 16C765
        XTAL = 24

        USB_DESCRIPTOR = "MOUSDESC.ASM"				' Point to the DESCRIPTOR file
        USB_CLASS_FILE = "HIDCLASS.ASM"				' Point to the CLASS file
        USB_COUNT_ERRORS = False					' Enable/Disable error monitors
        USB_SHOW_ENUM = False						' Enable/Disable PORTB monitor
        

		Dim BUFFER[8]	as 	Byte
		Dim LOOPCNT		as 	Byte
		Dim DIRECTION	as	Byte
		
        Symbol LED = PORTA.5						' Red LED on PORTA bit 5

        Symbol USB_WRITE_ERROR = _USB_WRT_ERR.WORD
        Symbol USB_BTO_ERROR = _USB_BTO_ERR.WORD
        Symbol USB_OWN_ERROR = _USB_OWN_ERR.WORD
        Symbol USB_BTS_ERROR = _USB_BTS_ERR.WORD
        Symbol USB_DFN8_ERROR = _USB_DFN8_ERR.WORD
        Symbol USB_CRC16_ERROR = _USB_CRC16_ERR.WORD
        Symbol USB_CRC5_ERROR = _USB_CRC5_ERR.WORD
        Symbol USB_PID_ERROR = _USB_PID_ERR.WORD
        
' Define the hardware interrupt handler for the USB vector
		ON_INTERRUPT Goto USBINT
        
'-----------------------------------------------------------------------------------
        Goto START              					' Jump over the interrupt handler
'-----------------------------------------------------------------------------------
' Assembly language interrupt handler
' to check interrupt source and vector to it 
USBINT:
		Movlw	(Service@USBInt >> 8)
        Movwf	PCLATH								' Point PCLATH to the USB subroutines
		Btfsc	PIR1, USBIF							' Make sure it is a USB interrupt
		Call	(Service@USBInt)					' Implement the USB subroutines
		Context Restore								' Restore saved registers

'-----------------------------------------------------------------------------------
' *** THE MAIN PROGRAM LOOP STARTS HERE ***
START:	ALL_DIGITAL = True							' Make PORTA, and PORTE all digital

        Low LED
        USBInit                 					' Initialise USB and wait until configured
		High LED									' Turn on LED for USB ready
		STR BUFFER = 0,0,0,0,0,0,0,0				' Clear the buffer array
' Move the computer's cursor in a small square
MOVECURSOR:					
		DIRECTION = 0
        Repeat													
			LOOPCNT = 0
            Repeat
				If DIRECTION = 0 Then BUFFER#1 = 0 : BUFFER#2 = -2 : Goto SENDIT
            	If DIRECTION = 1 Then BUFFER#1 = -2 : BUFFER#2 = 0 : Goto SENDIT
            	If DIRECTION = 2 Then BUFFER#1 = 0 : BUFFER#2 = 2 : Goto SENDIT
            	If DIRECTION = 3 Then BUFFER#1 = 2 : BUFFER#2 = 0
SENDIT:			USBOut 1, BUFFER, 4, SENDIT  		' Send BUFFER to endpoint 1
				Inc LOOPCNT
            Until LOOPCNT = 16						' 16 steps in each direction
            Inc DIRECTION
        Until DIRECTION = 4
		Goto MOVECURSOR								' Do it forever
        
