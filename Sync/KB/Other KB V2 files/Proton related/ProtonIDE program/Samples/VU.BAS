' Program to display result of ADC in 3 segment bargraph.
' The last LED in the graph dims or brightens with changes in the 
' analog input.
		
		DEVICE = 16F877
        XTAL = 4
  
        
' Define ADC parameters
		ADIN_RES = 10 				' 10-bit result required 
		ADIN_TAD = FRC 				' RC OSC chosen 
		ADIN_STIME = 50 			' Allow 50us sample time

		Dim Adval as	Byte			' ADC result variable
		Dim I 		as  Byte    		' For-loop variable
		Dim Position as	Byte			' LED position variable
		Dim Bright	as	Byte			' Brightness variable


        ADCON1 = %00000010			' Set PORTA analog

Loop:   Adval = Adin 0				' Store ADC value to adval
	
		Position = Adval / 85		' Position of last lit LED
		Bright = (Adval // 85) * 3	' Brightness of last lit LED

		For I = 0 To 7				' Set each LED
			If I < Position Then
				High I				' Turn on if lower than last lit LED 
			Else
				Low I				' Turn off if higher than last lit
			Endif
		Next

		PWM Position,Bright,5		' Dim the last LED

        Goto Loop					' Do it forever

        End

