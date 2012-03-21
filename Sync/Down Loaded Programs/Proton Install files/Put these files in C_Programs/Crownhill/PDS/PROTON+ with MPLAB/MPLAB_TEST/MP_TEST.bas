'
' Program MP_TEST.BAS
'
' Demonstration program testing the PROTON+ compiler
' used in MPLAB 7.10 onwards
'

        OPTIMISER_LEVEL = 2
		Device = 16F628					' This will be ignored once inside MPLAB
        
        Symbol SYSLED   = PORTB.4
        
        While 1 = 1						' Create an infinite loop
        	High SYSLED
           ' Delayms 100				' Don't want delays when simulating
            Low SYSLED
           ' Delayms 100				' Don't want delays when simulating
		Wend							' Do it forever
        
