' Perform an ADC conversion on the 12F675 8-pin PICmicro device
' Using register addressing

		Device = 12F675
'                     
' Setup for internal MCLR pin, and internal Oscillator
'		
		REMINDERS = OFF
		CONFIG CPD_OFF,CP_OFF,BODEN_OFF,MCLRE_OFF,PWRTE_OFF,WDT_OFF	,INTRC_OSC_NOCLKOUT	
		REMINDERS = ON
		
        XTAL = 4
        
        SERIAL_BAUD = 9600	
		RSOUT_PIN = GPIO.1
		RSOUT_MODE = TRUE
		RSOUT_PACE = 10
        
'-------[DEFINE SOME ALIAS'S TO ADC REGISTERS]---------------------------

' ANSEL register's bits
        Symbol ANS0 = ANSEL.0
        Symbol ANS1 = ANSEL.1
        Symbol ANS2 = ANSEL.2
        Symbol ANS3 = ANSEL.3
        Symbol ADCS0 = ANSEL.4		' ADC conversion clock select bit
        Symbol ADCS1 = ANSEL.5		' ADC conversion clock select bit        
        Symbol ADCS2 = ANSEL.6		' ADC conversion clock select bit       
		
' ADCON0 register's bits		
        Symbol ADFM = ADCON0.7
        Symbol VCFG = ADCON0.6
        Symbol CHS2 = ADCON0.4		' ADC channel select bit
		Symbol CHS1 = ADCON0.3		' ADC channel select bit
		Symbol CHS0 = ADCON0.2		' ADC channel select bit
		Symbol GO_DONE = ADCON0.1	' ADC Conversion status/ plus enable conversion-bit
		Symbol ADON = ADCON0.0		' ADC Enable bit: 1 = enabled, 0 = disabled.
        
'-------[ASSIGN A VARIABLE FOR THE ADC RESULT]---------------------------
        
        Dim AD_RESULT as ADRESL.WORD	' Convert the ADRESL register into a WORD variable 

'-------[INITIALISE THE PICMICRO]----------------------------------------
        Delayms 100						' Wait for the PICmicro to stabilise

		Goto OVER_ADC_SUBS				' Jump over the subroutines
        
'-------[START AN ADC CONVERSION]----------------------------------------
GET_ADC:
		ADON = 1						' Enable the ADC
        Delayus 50              		' Wait for sample/hold capacitors to charge
        GO_DONE = 1            			' Start conversion
		While GO_DONE = 1 : Wend		' Poll the GO_DONE flag for completion of conversion
        ADON = 0						' Disable the ADC, to save power
        Return
        		
'-------[INITIALISE THE ADC REGISTERS]----------------------------------
' Standard procedures for setting up the ADC	
OVER_ADC_SUBS:                
        TRISIO = %11111111				' All pins set for input
        
        ADCS0 = 1						' \
        ADCS1 = 1						'   Setup ADC's clock for FRC
        ADCS2 = 0						' /
        
        VCFG = 0						' VREF is set to VDD of PICmicro
        ADFM = 1						' Right justify the ADC result
        
        ANS0 = 1						' Set AN0 (GPIO.0) as Digital input
        ANS1 = 0						' Set AN1 (GPIO.1) as Digital input
        ANS2 = 0						' Set AN2 (GPIO.2) as Analogue input
        ANS3 = 0						' Set AN3 (GPIO.3) as Analogue input
        
'-------[MAIN PROGRAM LOOP STARTS HERE]----------------------------------
' Perform ADC conversions and display the result serially
       
		While 1 = 1						' Create an infinite loop
        	WARNINGS = OFF
			BYTE_MATH = ON				' Enable expression optimisation
            ADCON0 = ADCON0 | (0 << 2) 	' Select the channel to read          
            BYTE_MATH = OFF				' Disable expression optimisation
            WARNINGS = ON
			Gosub GET_ADC				' Perform an ADC conversion
        	Rsout at 1,1,"ADC CHANNEL 0 = " , DEC AD_RESULT,13		' Display the result serially
         	Delayms 100					' Delay between samples
        Wend							' Do another conversion
	
        
