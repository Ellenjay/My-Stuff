' Program to move RC servo using potentiometer


		Include "PROTON_4.INC"

' Define ADIN parameters
		ADIN_RES = 10				' Set number of bits in result
		ADIN_TAD = FRC				' Set clock source (3=rc)
		ADIN_STIME = 100				' Set sampling time in uS

		dim Pos as word   		    ' Servo position
		Symbol Pin = PORTB.3		' Alias servo pin


		Input TRISA					' Set PORTA to all input
		TRISB = %11110000			' Set PORTB.0-3 to output
		PORTB = 0					' Set PORTB.0-3 low
        ADCON1 = %10000010			' Set PORTA analog and right justify result


' Main program loop
Mainloop: 
		Pos = Adin 0				' Store value of analog input in pos
        Servo Pin , 1000 + Pos
        Delayms 16					' Servo update rate about 60Hz
        Goto Mainloop				' Do it all forever

        End

