' Demonstrate wake on interrupt.

' The program outputs the condition of the switches on the
' LEDs, then immediately goes into power-down mode.  When
' the condition on any switch changes, the RB port change
' interrupt occurs, waking the part.
' Since the global interrupt enable bit is not set, no 
' jump to the interrupt vector occurs.  Program execution 
' is resumed, the LEDs are updated, and the part goes back
' to sleep.
' To further reduce the power consumption, all unused
' hardware peripherals should be disabled.  The PORTB
' pullups should be replaced with external resistors, and
' the internal pullups disabled.

		DEVICE = 16F877
        XTAL = 4
		       
' Define the pins that are connected to pushbuttons.
' The switches must be connected to PORTB, pins 4,5,6,
' or 7 in order to use the RB port change interrupt.
		Symbol SW1	= PORTB.4
		Symbol SW2	= PORTB.5
		Symbol SW3	= PORTB.6

' Define the pins that are connected to LEDs
		Symbol LEDS = PORTD
		Symbol LED1	= PORTD.0
		Symbol LED2	= PORTD.1
		Symbol LED3	= PORTD.2

		Set INTCON.3				' Enable the RB port change interrupt
		PORTB_PULLUPS = ON			' Enable the internal PORTB pull-up resistors
		Input PORTB					' Set PORTB to all inputs for the switches
		Output PORTD				' Set PORTD to all outputs for the LEDs
		
'------------------------------------------------------------
' MAIN PROGRAM BEGINS HERE
		While 1 = 1					' Create an infinite loop	

			Clear LEDS				' Turn off all LEDs

' Check any button pressed to toggle an LED
			If SW1 = 0 Then Set LED1
			If SW2 = 0 Then Set LED2
			If SW3 = 0 Then Set LED3
	
			Clear INTCON.0			' Clear the RB port change flag bit
	
			Nap 7					' Go to sleep.  When the watchdog is
									' disabled, NAP won't wake up until
									' an interrupt occurs.
		Wend						' Do it again upon waking

