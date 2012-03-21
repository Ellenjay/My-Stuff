'
' Transmit the value read from the ADC on AN0 (PORTA.0) using a USB CDC interface
'
' View the results from the serial terminal set to the com port that the USB connects too.
'
	Device = 18F4550								' Use a device with full speed USB capabilities
    XTAL = 48										' Set the oscillator speed to 48MHz (using a 20MHz crystal)
    REMINDERS OFF
    
    ADIN_RES	10									' Set the resolution to 10
    ADIN_TAD	FRC									' Choose the RC osc for ADC samples
    ADIN_STIME	100        							' Allow 100us for charge time
       
    USB_DESCRIPTOR = "CDCDESC.INC"					' Point to the CDC DESCRIPTOR file (located in the INC\USB_18 folder)
    
    Dim PP0 as Byte SYSTEM							' USBPOLL status return
    Dim USB_BUFFER as String * 20					' USB buffer
    Dim AD_RESULT 	as ADRESL.Word					' \		
	Dim VALUE 		as Word							'  \
    Dim VOLTS 		as Byte							'  / ADC conversion variables
    Dim MILLIVOLTS 	as Byte							' /
    
    Symbol CARRY_FLAG = STATUS.0					' High if microcontroller does not have control over the buffer
    Symbol TRNIF = UIR.3							' Low if USB Busy
    
'-------------------------------------------------------------------------------
	
    Delayms 200										' Wait for things to stabilise
    Clear											' Clear all RAM before we start
     
    Repeat											' \
    	USBPoll										'   Wait for the USB interface to become attached
    Until PP0 = %00000110							' /
       
    TRISA.0 = 1										' Setup PORTA.0 as an input
    ADCON1 = %10001110								' Make PORTA.0 analogue
    ADCON2 = %10000000								' Right justify the ADC result

	While 1 = 1
 		USBPoll										' Keep the USB interface alive
        AD_RESULT = ADIN 0							' Read the ADC
        VALUE = 489 * (AD_RESULT / 10)				' Quantasize the result
		VOLTS = VALUE / 10000						' Split off the Volts
		MILLIVOLTS = (VALUE // 10000) / 100			' Split off the MilliVolts
        '
        ' Convert the value into a string 
		'
        USB_BUFFER = Str$(Dec1,VOLTS) + "." + Str$(Dec2,MILLIVOLTS) + " Volts\r"     	  
		Repeat
        	USBOut 3, USB_BUFFER, AUTO 				' Poll the USB and transmit the string from endpoint 3
    	Until CARRY_FLAG = 0						' Keep trying if the microcontroller does not have control over the buffer
        Repeat : Until TRNIF = 1					' Wait for completion before continuing
    Wend											' Go wait for the next buffer input
    
