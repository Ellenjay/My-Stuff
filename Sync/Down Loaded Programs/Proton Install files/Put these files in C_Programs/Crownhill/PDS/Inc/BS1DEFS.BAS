' BS1DEFS.BAS
' Compatability variable naming for BS1 and MELABS compiler


		INCLUDE "MODEDEFS.BAS"  			' Include Mode definitions

	Dim W0  as WORD	NO_LIST
	Dim W1  as WORD	NO_LIST
	Dim W2  as WORD	NO_LIST
	Dim W3  as WORD	NO_LIST
	Dim W4  as WORD	NO_LIST
	Dim W5  as WORD	NO_LIST
	Dim W6  as WORD	NO_LIST

	Symbol B0 = W0.LOWBYTE	NO_LIST
	Symbol B1 = W0.HIGHBYTE	NO_LIST
	Symbol B2 = W1.LOWBYTE	NO_LIST
	Symbol B3 = W1.HIGHBYTE	NO_LIST
	Symbol B4 = W2.LOWBYTE	NO_LIST
	Symbol B5 = W2.HIGHBYTE	NO_LIST
	Symbol B6 = W3.LOWBYTE	NO_LIST
	Symbol B7 = W3.HIGHBYTE	NO_LIST
	Symbol B8 = W4.LOWBYTE	NO_LIST
	Symbol B9 = W4.HIGHBYTE	NO_LIST
	Symbol B10 = W5.LOWBYTE	NO_LIST
	Symbol B11 = W5.HIGHBYTE	NO_LIST
	Symbol B12 = W6.LOWBYTE	NO_LIST
	Symbol B13 = W6.HIGHBYTE	NO_LIST

	Symbol BIT0 = B0.0	NO_LIST
	Symbol BIT1 = B0.1	NO_LIST
	Symbol BIT2 = B0.2	NO_LIST
	Symbol BIT3 = B0.3	NO_LIST
	Symbol BIT4 = B0.4	NO_LIST 
	Symbol BIT5 = B0.5	NO_LIST
	Symbol BIT6 = B0.6	NO_LIST
	Symbol BIT7 = B0.7	NO_LIST
	Symbol BIT8 = B1.0	NO_LIST
	Symbol BIT9 = B1.1	NO_LIST
	Symbol BIT10 = B1.2	NO_LIST
	Symbol BIT11 = B1.3	NO_LIST
	Symbol BIT12 = B1.4	NO_LIST
	Symbol BIT13 = B1.5	NO_LIST
	Symbol BIT14 = B1.6	NO_LIST
	Symbol BIT15 = B1.7	NO_LIST

	Symbol PINS  =  PORTLO	NO_LIST

	Symbol PIN0 = PINS.0	NO_LIST
	Symbol PIN1 = PINS.1	NO_LIST
	Symbol PIN2 = PINS.2	NO_LIST
	Symbol PIN3 = PINS.3	NO_LIST
	Symbol PIN4 = PINS.4	NO_LIST
	Symbol PIN5 = PINS.5	NO_LIST
	Symbol PIN6 = PINS.6	NO_LIST
	Symbol PIN7 = PINS.7	NO_LIST

'--------------------------------------------
    