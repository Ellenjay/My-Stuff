' Quantisized ADIN Results and display on the LCD
		
		Device 16F877
		XTAL = 20						' Set Xtal Frequency
		
		LCD_DTPIN = PORTD.4	
		LCD_RSPIN = PORTE.0
		LCD_ENPIN = PORTE.1
		LCD_INTERFACE = 4	' 4-bit Interface
		LCD_LINES = 2
		LCD_TYPE = 0
		
		
		ADIN_TAD	FRC					' Set clock source (x/FOSC or FRC)
		ADIN_STIME	150					' Set sampling time (in uS)
		ADIN_RES = 10
		
		Dim AD_Raw		as Word			' 10-bit result of A/D conversion
		Dim AD_Result	as Word			' Quantasized ADC result
		Dim Average		as Word			' Build up the average result        					
		Dim Samples		as Byte
		
		Cls								' Clear the LCD
		ADCON1 = %10000010				' Set PORTA analog and right justify result
Again:	Average = 0						' Clear the Average variable before use
		For Samples = 0 to 9			' We will take 10 samples of the ADC						
			AD_Raw = ADIN 0				' Place the conversion of channel 0 
			Average = Average + AD_Raw	' Build up the Average result	
		Next							' Close the loop after 10 revolutions 
		AD_Result = (Average/10) */ 1250' Quantasize the result
		Print at 1,1,Dec AD_Result / 1000,".",Dec3 AD_Result // 1000," Volts   "
		Goto Again						' Do it forever
