' Program to demonstrate the use of the hardware capture
' module to measure the period of a frequency input.
'
' Also shows how two hardware registers can be combined for a 16-bit result
' Input signal should be connected to RC2/CCP1

		Include "PROTON_20.INC"				' Configure ports for PROTON board
        
        FLOAT_DISPLAY_TYPE = LARGE
        
		Dim PERIOD as Word					' Word variable that stores the captured value
        Dim FREQUENCY as Float
        
		Symbol CCPR1 = CCPR1L.Word			' Create a 16-bit variable out of CCPRL1
        Symbol TIMER1 = TMR1L.Word			' Create a 16-bit variable out of TMR1L
        Symbol CAPTURE = PIR1.2				' CCP1 capture flag
		Symbol OVERFLOW	= PIR1.0			' Timer1 overflow flag

		Delayms 100							' Wait for PICmicro to stabilise
        Cls
        CCP1CON = %00000100					' Enable the CCP1 capture, falling edge
		T1CON = %00000001					' TMR1 prescale=1, and turn it on (1uS per count)

		While 1 = 1
			While CAPTURE = 0 : Wend		' Wait here until captured         
			PERIOD = CCPR1					' Store the captured value in period variable
			If OVERFLOW = 0 Then			' Skip the output if the timer overflowed
				Print at 1,1, "Period: " , Dec PERIOD , "uS  "	' Output
				'FREQUENCY = 
                Print at 2,1, "Freq: " , Dec2 5000.0 / Period,"KHz  "
            Endif
			CAPTURE = 0						' Clear the capture flag
	
			While CAPTURE = 0 : Wend		' Wait for beginning of next period
			Clear TIMER1					' Clear Timer1
			CAPTURE = 0						' Clear capture flag
			OVERFLOW = 0					' Clear overflow flag	
		Wend								' Do it forever	
