' PicBasic Plus program to read and write to I2C Serial FRAM
'
' Write to the first 16 locations of an external Serial Eeprom
' Read first 16 locations back and send to LCD repeatedly
' Note: for serial eeproms with WORD-sized address

       	Device 16F877
		XTAL = 4
                
' LCD pin Assignments
        LCD_DTPIN = PORTD.0
        LCD_RSPIN = PORTE.0
        LCD_ENPIN = PORTE.1
        LCD_LINES = 2
        LCD_INTERFACE = 8

		SCL_PIN	= PORTC.3
        SDA_PIN	= PORTC.4             	' Data pin

		Dim W0	as	Word                ' Address
		Dim B1	as	Byte                ' Data 1
		Dim B2	as	Byte                ' Data 2

        ADCON1 = 7                     	' Set PORTA and PORTE to digital
		CLS        
Loop:

        For W0 = 0 To 10                 	' Loop 256 times
        	B1 = W0           						' B1 is data for SEEPROM
        	Busout $A0,W0,[B1]    					' Write each location
            Busin $A1,W0,[B2]  						' Read 2 locations in a row
            Print at 1,1,#W0,": ",#B2,"   "  		' Display locations
        	Delayms 400
        Next
        Goto loop

