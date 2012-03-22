' Demonstrate the Div32 command.
' Div32 must be used immediately after a multiply statement
' in order to retain the state of the internal registers of
' the device.

' Use the serial terminal set for 9600 baud to view the results
'
' DIV32 is rather obsolete with the advent of 32-bit variables
' but is included in the compiler for support

		Include "PROTON_4.INC"

' Declare variables for testing the DIV32 command
		Dim WRESULT		As 	Word	' Used to store results to a word
		Dim EXPECTED	As 	Word	' Used to display the expected result
		Dim BRESULT		As	Byte	' Used to store results to a byte
		Dim DUMMY 		As	Word	' Used to store intermediate results of the multiply

		Dim VAR1		As	Byte	' Data in byte form
		Dim VAR2		As	Byte	' Data in byte form
		Dim WRD1		As	Word	' Data in word form
		Dim WRD2		As	Word	' Data in word form

        HRSOUT 1					' Clear the TERMINAL screen before we start
        
' Set values for testing
		VAR1 = 25
		VAR2 = 250
		WRD1 = 255
		WRD2 = 10052

		DUMMY = WRD1 * WRD2			' Multiply to load internal registers with 32-bit value
		WRESULT = Div32 VAR2		' Divide 32-bit value by byte and store in word
		EXPECTED = 10253			' Expected result for this calculation
		Gosub RESULTWORD			' Send the result with HRSOUT

		DUMMY = WRD1 * WRD2			' Multiply to load internal registers with 32-bit value
		WRESULT = Div32 WRD1		' Divide 32-bit value by word and store in word
		EXPECTED = 10052			' Expected result for this calculation
		Gosub RESULTWORD			' Send the result with HRSOUT

		DUMMY = WRD1 * WRD2			' Multiply to load internal registers with 32-bit value
		WRESULT = Div32 1000		' Divide 32-bit value by contant and store in word
		EXPECTED = 2563				' Expected result for this calculation
		Gosub RESULTWORD			' Send the result with HRSOUT


		DUMMY = VAR1 * VAR2			' Multiply to load internal registers with 32-bit value
		BRESULT = Div32 VAR1		' Divide 32-bit value by byte and store in byte
		EXPECTED = 250				' Expected result for this calculation
		Gosub RESULTBYTE			' Send the result with HRSOUT

		DUMMY = VAR1 * VAR2			' Multiply to load internal registers with 32-bit value
		BRESULT = Div32 WRD1		' Divide 32-bit value by word and store in byte
		EXPECTED = 24				' Expected result for this calculation
		Gosub RESULTBYTE			' Send the result with HRSOUT

		DUMMY = VAR1 * VAR2			' Multiply to load internal registers with 32-bit value
		BRESULT = Div32 100			' Divide 32-bit value by contant and store in byte
		EXPECTED = 62				' Expected result for this calculation
		Gosub RESULTBYTE			' Send the result with HRSOUT
		Stop

Resultbyte:							' Send byte value serially		
		HRsout "Byte Result = ",Dec BRESULT,"   ",Dec EXPECTED," Expected",13
		Delayms 500
		Return
	
Resultword:							' Send word value serially
		HRsout "Word Result = ",Dec WRESULT,"   ",dec EXPECTED," Expected",13
		Delayms 500
		Return
	
