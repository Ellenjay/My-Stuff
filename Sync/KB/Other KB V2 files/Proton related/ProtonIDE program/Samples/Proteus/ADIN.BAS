' Read channel 0 of on-board ADC and display the results
       	
       	Include "PROTON_4.INC"
       	ADIN_RES	10					' Set the resolution to 10
        ADIN_TAD	FRC					' Choose the RC osc for ADC samples
       	ADIN_STIME	100        			' Allow 100us for charge time
        
        Dim Raw 		as Word			
		Dim Value 		as Word
       	Dim Volts 		as Byte
       	Dim Millivolts 	as Word	
       	
        Delayms 100						' Wait for PICmicro to stabilise
        Cls              				' Clear the LCD
		TRISA.0 = 1						' Setup bit-0 of PortA as an input
       	ADCON1 = %10000010				' Set PORTA analog and right justify result
Again: 	Raw = ADIN 0					' Read the ADC
        Print at 2,1,"RAW= ",@Raw,"   "	' Display the RAW data
        Value = 489 *(Raw / 10)			' Quantasize the result
		Volts = Value / 10000
		Millivolts = (Value // 10000) / 100
       	Print at 1,1,Dec1 Volts,".",Dec2 Millivolts,"V" ' Display the result
       	Goto Again						' Do it forever
