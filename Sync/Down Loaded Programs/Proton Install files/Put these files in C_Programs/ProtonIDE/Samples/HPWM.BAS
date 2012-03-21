' Demonstrate Hardware PWM
' Output a 1KHz signal with duty cycle sweeping from 20% to 80% once per second
		
		Device 16F877
		Declare XTAL 4
        
		Dim Duty	as	WORD		' Duty cycle value (CCPR1L:CCP1CON<5:4>)
		
		TRISC.2 = 0					' Set PORTC.2 (CCP1) to output
		CCP1CON = %00001100			' Set CCP1 to PWM 
		T2CON = %00000101			' Turn on Timer2, Prescale=4
		PR2 = 249					' Set PR2 to get 1KHz out	
		Duty = 200					' Set duty cycle to 20%
Loop:	CCP1CON.4 = Duty.0			' Store duty to registers as
		CCP1CON.5 = Duty.1			' a 10-bit word
		CCPR1L = Duty >> 2
		Duty = Duty + 10			' Increase duty cycle	
		Delayms 17					' Delayms 1/60 of second
		If Duty < 800 Then loop		' Do it again unless 80% duty cycle
		Duty = 200					' Reset to 20% duty cycle
		Goto Loop					' Do it forever
