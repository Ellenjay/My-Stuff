' Program that demonstrates the use of the Timer1
' interrupt for a real-time clock.

		Include "PROTON_4.INC"

' Point to the hardware interrupt handler
		ON_INTERRUPT Goto myint


		Dim TICK as	Byte SYSTEM ' make sure that the variable is in bank0 if they are to be used in the interrupt handler

		Dim SECONDS as Byte		' Elapsed seconds
		Dim MINUTES as Word		' Elapsed minutes
		Dim LOOPS	as Word
	
		minutes = 0				' Clear time
		seconds = 0
	
		T1CON = $01				' Turn on Timer1, prescaler = 1
		INTCON 	= $C0			' Enable global interrupts, peripheral interrupts
		PIE1 = $01				' Enable TMR1 overflow interrupt

		Goto MAIN	' jump over the interrupt handler and sub
 
' Assembly language interrupt handler
MYINT:

; Set the high register of Timer1 to cause an interrupt every
; 16384 counts (65536-16384=49152 or $C000). At 4MHz, prescale
; set to 1, this equates to a tick every 16384uS.  This works
; out to about 61 ticks per second, with a slight error.  The
; error could be reduced substantially by setting the TMR1L
; register and playing with different values for the prescaler
; and the ticks per second.
        
		Movlw	$C0				; Prepare to set TMR1 high register
		Movwf	TMR1H			; Set TMR1H to C0h
		Incf	TICK,F			; INCREMENT TICK COUNT
  		Bcf     PIR1, 0			; Clear interrupt flag
		Context Restore

' Subroutine to update the minutes and seconds variables
GET_TIME:
' Update the time when needed. The TICK variable will
' overflow if you don't update within 4 seconds.  This could
' be done in the interrupt handler, but it's easier to do
' it in PicBasic, and you usually want the interrupt handler
' to be as short and fast as possible.
 	
		PIE1 = 0							' Mask the interrupt while we're messing with TICK
		seconds = seconds + (tick / 61)		' Add the accumulated seconds
		tick = tick // 61					' Retain the left-over ticks
		PIE1 = $01							' Interrupt on again
		minutes = minutes + (seconds / 60)	' Add the accumulated minutes
		seconds = seconds // 60				' Retain the left-over seconds
		Return								' Return to the main program
 	
' **************************************************************
' Begin program code here.  The minutes and seconds variables can
' be used in your code.  The time will be updated when you call the
' get_time routine. Disable interrupts while executing timing-critical
' commands, like serial communications.
MAIN:

		Cls						' Clear LCD
		loops = 0

loop:
	
		loops = loops + 1
		Print at 2,1,"Loops Counted: ", DEC5 loops	
		Gosub get_time	' Update minutes and seconds
		Print at 1,1, "Time: ",DEC5 minutes, ":", DEC2 seconds ' Display the elapsed time
		Goto loop 		' Repeat main loop
	



