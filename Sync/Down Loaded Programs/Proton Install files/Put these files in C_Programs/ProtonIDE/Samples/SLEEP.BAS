' Demonstrate the SLEEP Command
' Slowly Flash an LED using a low power delay

		Device 16F84
        XTAL = 4
		
		Symbol LED = PortB.0                    ' LED Pin
		TRISB.0=0								' Set LED pin to output
Loop:   Toggle LED                      		' Toggle LED
		Sleep 2									' Sleep for approx 2 Seconds
        Goto Loop                       		' Forever
