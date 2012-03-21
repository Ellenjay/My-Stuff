
		DEVICE = 16F628
        XTAL = 4
        REMARKS = ON
        WATCHDOG = OFF
        MACRO_PARAMS = ON


		LCD_DTPIN = PORTB.4	
		LCD_RSPIN = PORTB.3
		LCD_ENPIN = PORTB.2
		LCD_INTERFACE = 4	' 4-bit Interface
		LCD_LINES = 2
		LCD_TYPE = 0

		SCL_PIN	= PORTA.0
        SDA_PIN	= PORTA.1

		SERIAL_BAUD = 9600	
		RSOUT_PIN = PORTB.0
		RSOUT_MODE = TRUE
		RSOUT_PACE = 1
		RSIN_PIN = PORTB.1
		RSIN_MODE = TRUE
		RSIN_TIMEOUT = 2000

        
		KEYPAD_PORT = PORTB
        

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
