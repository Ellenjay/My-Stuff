' LCD clock program using On Interrupt
' Uses TMR0 and prescaler.  Watchdog Timer should be
' set to off at program time and Nap and Sleep should not be used.
' Buttons may be used to set hours and minutes

		Include "PROTON_4.INC"

		Dim hour    as     byte    		' Define hour variable
		Dim dhour   as     byte    		' Define display hour variable
		Dim minute  as     byte    		' Define minute variable
		Dim second  as     byte    		' Define second variable
		Dim ticks   as     byte    		' Define pieces of seconds variable
		Dim update  as     byte    		' Define variable to indicate update of LCD
		Dim i       as     byte    		' Debounce loop variable

        Delayms 100       				' Wait for LCD to startup

        hour = 0        				' Set initial time to 00:00:00
        minute = 0
        second = 0
        ticks = 0

        update = 1      				' Force first display

' Set TMR0 to interrupt every 16.384 milliseconds
        OPTION_REG = $55        		' Set TMR0 configuration and enable PORTB pullups
        INTCON = $A0            		' Enable TMR0 interrupts
        On Interrupt Goto Tickint		' Create a SOFTWARE INTERRUPT

' Main program loop - in this case, it only updates the LCD with the time
mainloop:
        PORTB = 0       				' PORTB lines low to read buttons
        TRISB = $F0     				' Enable all buttons

        ' Check any button pressed to set time
        If PORTB.7 = 0 Then decmin
        If PORTB.6 = 0 Then incmin      ' Last 2 buttons set minute
        If PORTB.5 = 0 Then dechr
        If PORTB.4 = 0 Then inchr       ' First 2 buttons set hour

        ' Check for time to update screen
Chkup:  If update = 1 Then
        	Cls   						' Clear screen

       		' Display time as hh:mm:ss
       		dhour = hour    			' Change hour 0 to 12
       		If (hour // 12) = 0 Then
       			dhour = dhour + 12
       		Endif

       		' Check for AM or PM
       		If hour < 12 Then
       			Print dec2 dhour, ":", dec2 minute, ":", dec2 second, " AM"
       		Else
       			Print dec2 (dhour - 12), ":", dec2 minute, ":", dec2 second, " PM"
       		Endif

       		update = 0      			' Screen updated
       	Endif

		Goto mainloop   				' Do it all forever

' Increment minutes
Incmin: minute = minute + 1
        If minute >= 60 Then
			minute = 0
        Endif
        Goto debounce

' Increment hours
Inchr:  hour = hour + 1
        If hour >= 24 Then
			hour = 0
        Endif
        Goto debounce

' Decrement minutes
Decmin: minute = minute - 1
        If minute >= 60 Then
			minute = 59
        Endif
        Goto debounce

' Decrement hours
Dechr:  hour = hour - 1
        If hour >= 24 Then
			hour = 23
        Endif

' Debounce and delay for 250ms
Debounce: 
        For i = 1 to 25
        	Delayms 10        				' 10ms at a time so no interrupts are lost
        Next

        Update = 1      				' Set to update screen

        Goto Chkup

' Interrupt routine to handle each timer tick
        Disable         				' Disable interrupts during interrupt handler
Tickint: 
		ticks = ticks + 1      		' Count pieces of seconds
        If ticks < 61 Then tiexit       ' 61 ticks per second (16.384ms per tick)

' One second elasped - update time
        ticks = 0
        second = second + 1
        If second >= 60 Then
			second = 0
			minute = minute + 1
			If minute >= 60 Then
				minute = 0
            	hour = hour + 1
             	If hour >= 24 Then
                	hour = 0
           		Endif
    		Endif
        Endif

        update = 1      				' Set to update LCD

Tiexit: INTCON.2 = 0    				' Reset timer interrupt flag
        Resume

