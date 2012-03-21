
       	Device 16F877
		XTAL 4
        REMARKS	ON
        BOOTLOADER ON
                
' LCD pin Assignments         
        LCD_DTPIN		PORTD.4
       	LCD_RSPIN		PORTE.0
        LCD_ENPIN		PORTE.1
        LCD_LINES		2
        LCD_INTERFACE	4

' I2C pin assignments
		SCL_PIN	= PORTC.3
        SDA_PIN	= PORTC.4

        
		KEYPAD_PORT = PORTB
                
        SERIAL_BAUD = 9600	
		RSOUT_PIN = PORTC.6
		RSOUT_MODE = TRUE
		RSOUT_PACE = 1
		RSIN_PIN = PORTC.7
		RSIN_MODE = TRUE
        
        HSERIAL_BAUD = 9600             ' Set baud rate to 9600
        HSERIAL_RCSTA = %10010000       ' Enable serial port and continuous receive
        HSERIAL_TXSTA = %00100100       ' Enable transmit and asynchronous mode 
        HSERIAL_CLEAR = ON              ' Enable Error clearing on received characters
        
        
        Symbol T300 = 3313	NO_LIST
		Symbol N300 = 3313 + $4000	NO_LIST
		Symbol T600 = 1646	NO_LIST
		Symbol N600 = 1646 + $4000	NO_LIST
		Symbol T1200 = 813	NO_LIST
		Symbol N1200 = 813 + $4000	NO_LIST
		Symbol T2400 = 396	NO_LIST
		Symbol N2400 = 396 + $4000	NO_LIST
		Symbol T4800 = 188	NO_LIST
		Symbol N4800 = 188 + $4000	NO_LIST
		Symbol T9600 = 84	NO_LIST
		Symbol N9600 = 84 + $4000 NO_LIST
    
		Symbol OT2400 = 396 + $8000	NO_LIST       ' Open True
		Symbol OT1200 = 813 + $8000	NO_LIST       ' Open True
		Symbol OT9600 = 84 + $8000	NO_LIST      ' Open True
		Symbol OT300  = 3313 + $8000	NO_LIST      ' Open True

		Symbol ON2400 = 396 + $4000 + $8000	NO_LIST      ' Open Inverted
		Symbol ON1200 = 813 + $4000 + $8000	NO_LIST      ' Open Inverted
		Symbol ON9600 = 84 + $4000 + $8000	NO_LIST      ' Open Inverted
		Symbol ON300  = 3313 + $4000 + $8000 	NO_LIST     ' Open Inverted


		Symbol HOME = 1	NO_LIST
		Symbol BELL = 7	NO_LIST
		Symbol BKSP = 8	NO_LIST
		Symbol TAB = 9	NO_LIST
		Symbol CR = 13	NO_LIST
        
        ALL_DIGITAL = TRUE	' Set PORTA and PORTE to all digital