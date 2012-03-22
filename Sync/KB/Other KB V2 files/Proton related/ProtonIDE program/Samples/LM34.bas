
' Display the temperature serially, measured from an LM34 sensor 

       	Device 16F877
		Declare XTAL 20
                
' Graphic LCD pin Assignments         
        Declare	LCD_DTPIN		PORTD.0
        Declare	LCD_RSPIN		PORTE.0
        Declare	LCD_ENPIN		PORTE.1
        Declare LCD_LINES		2
        Declare LCD_INTERFACE	8

       	Declare ADIN_RES	10
        Declare ADIN_TAD	2					'CLK options are 0, 1, 2, 3 (0-2 are based on internal cycles)
        Declare ADIN_STIME	100

		Dim Temp as Word                   		'TEMP is now a word sized variable 
        
		Symbol N9600 = 104 - 20
		Symbol AN1 = 1     

		TRISA.0 = 1
       	ADCON1 = %10000000						' Set up the ADCON1 register, AN1 / RA1 is now analog 

Main:	Temp = Adin AN1       					' Loads the variable temp with the sample 
 		Serout PORTC.6,N9600, [ "Temperature is ",dec (Temp / 2) - 3," Degrees Fahrenheit   ",dec Temp,13]
		Delayms 500
 		Goto Main
 
 
  
