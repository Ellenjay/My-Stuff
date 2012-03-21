' Serially Display result of 10-bit A/D conversion using the Vref pin on a 12F675. 
'
' Connect analogue input to GP0
' Connect reference voltage to GP1

		Device = 12F675
		
		Dim ADVAL  as ADRESL.Word			' Alias adval to store result
		
		Delayms 300							' Wait for PICmicro to stabilise	
		ANSEL = %00110001 					' Set ADC clock to Frc and GP0 to analog mode
		ADCON0 = %11000001					' Configure and turn on A/D Module:
											' Right justify result, use Vref pin, channel 0
		While 1 = 1

			ADCON0.1 = 1					' Start Conversion	
			While ADCON0.1 = 1: Wend		' Wait for low on bit-1 of ADCON0, conversion finished	
			Serout GPIO.5,396, ["Value: ", DEC ADVAL, 13]	'Display the decimal value  	
			Delayms 100       				' Wait .1 second
	
		Wend      							'Do it forever
	
