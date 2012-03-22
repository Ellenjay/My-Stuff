' SPI slave program

		Include "PROTON_4.INC"			' Configure ports for PROTON board
        
' Allocate RAM
		Dim Dataout[8] 	as Byte			' Data out array
        Dim I 			as 	BYTE		' loop counter

		Symbol SSPEN = SSPCON.5			' SSP Enable bit
		Symbol CKP = SSPCON.4			' Clock Polarity Select
		Symbol SMP = SSPSTAT.7			' Data input sample phase
		Symbol CKE = SSPSTAT.6			' Clock Edge Select bit
		Symbol SSPIF = PIR1.3			' interrupt flag - last bit set

        Delayms 500						' Wait for PICmicro to stabilise
        TRISC = %11011111				' set PORTC I/O
		SSPCON = %00000101				' configure SPI slave, no SS
		
		CKP = 0							' clock idle low
		CKE = 0							' transmit on idle to active transition
		SSPIF = 0						' clear SPI interrupt
		SMP = 0							' sample in middle of data

        ADCON1 = $0E					' PORTA.0 analogue, rest PORTA and PORTE pins to digital

        Str DataOut = "ADC= "			' Preset output data to "ADC= "


Loop:	SSPEN = 0						' disable/enable SSP to reset port
		SSPEN = 1
		Gosub Letclear					' wait for byte received
		If SSPBUF != "?" Then Loop		' wait for ? to start conversion
		
		Dataout[5] = Adin 0 			' Read ADC channel 0, store in 6th position of string
		
		Gosub Senddata					' send "!" and string of data
				
		Goto Loop						' do it forever
		

Senddata:
		Gosub Letclear					' wait until buffer ready
		SSPBUF = "!"					' send reply

		For I = 0 To 5					' loop for 6 array locations
			Gosub Letclear				' wait until buffer ready
			SSPBUF = Dataout[I]			' send array variable
		Next							' next location
		
		Return

		
Letclear:
		If SSPIF = 0 Then Letclear		'wait for interrupt flag
		SSPIF = 0						'reset flag

		Return
		




