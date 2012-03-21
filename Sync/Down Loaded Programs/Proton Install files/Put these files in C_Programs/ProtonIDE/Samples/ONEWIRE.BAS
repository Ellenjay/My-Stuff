' One-wire temperature for PROTON Board and DS1820

		Include "PROTON_4.INC"
        
		Dim Temperature as	Word			' Temperature storage
		Dim Count_remain as Byte			' Count remaining
		Dim Count_per_c as	Byte			' Count per degree C
        Dim Dum			as Byte				' Dummy variable to pad OWIN

		Symbol DQ = PORTC.0					' One-wire data pin

		Delayms 500							' Wait for PICmicro to stabilise
        Cls
Mainloop: 
		OWRITE DQ, 1, [$CC, $44]       		' Start temperature conversion

		While OREAD DQ, 4 = 0 : Wend		' Check for still busy converting

		OWRITE DQ, 1, [$CC, $BE]			' Read the temperature
        OREAD DQ, 0, [Temperature.LOWBYTE, Temperature.HIGHBYTE, Dum,Dum,Dum,Dum, Count_remain, Count_per_c]

' Calculate temperature in degrees C to 2 decimal places (not valid for negative temperature)
		Temperature = (((Temperature >> 1) * 100) - 25) + (((Count_per_c - Count_remain) * 100) / Count_per_c)
		Print $FE, 1, DEC (Temperature / 100), ".", DEC2 Temperature, " C"

' Calculate temperature in degrees F to 2 decimal places (not valid for negative temperature)
		Temperature = (Temperature */ 461) + 3200
		Print $FE, $C0, DEC (Temperature / 100), ".", DEC2 Temperature, " F"

        Delayms 1000                      	' Display once a second

		GoTo Mainloop						' Do it forever
