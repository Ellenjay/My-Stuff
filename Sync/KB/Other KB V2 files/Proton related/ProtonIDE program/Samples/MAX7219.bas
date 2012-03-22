' This Program demonstrates the use of the MAX7219, seven segment decoder driver
' It also incorporates placing of Decimal point.

        Device 16F84
' ** Set Xtal Value in MHz **
		XTAL = 4							' Set Xtal Frequency

' ** Declare Pins Used **
		Symbol Clk	= PORTB.0				' Data is clocked on rising edge of this pin
		Symbol Dta  = PORTB.1				' Bits are shifted out of this pin
		Symbol Load = PORTB.2				' Transfers data to LEDs when Pulsed

' ** Declare Constants **
		Symbol Decode_Reg 	9				' Decode register, a 1 turns on BCD decoding for each digit. 
		Symbol Lum_Reg		10				' Intensity register.
		Symbol Scan_Reg	    11				' Scan-limit register.
		Symbol Switch_Reg   12				' On/Off Register.
		Symbol Test_Reg		15				' Test mode register (all digits on, 100% bright)

'	Max_Digit	Con	5					' Amount of LED Displays being used.

' ** Declare Variables **
  		Dim Counts		as Word			' Variable used for the Demo Counting routine
		Dim Max_Disp	as Word			' 16-bit value to be displayed by the MAX7219
		Dim Max_Dp		as Byte			' Digit number to place Decimal point (0-4)
		Dim Register	as Byte			' Pointer to the Internal Registers of the MAX7219
		Dim R_Val		as Byte			' Data placed in Each Register
		Dim Digit		as Byte			' Position of individual numbers within MAX_Disp (0-3)
		Dim Position	as Byte			' Position of each LED display (1-4)

' ** INITIALISE THE MAX7219 ** 
' Each register address is sent along with its setting data. 
' Because the MAX7219 expects to see a packet of 16 bits, then the LOAD pin is pulsed
' Set the scan limit to 3 (4 digits, numbered 0-3)
' Set the Brightness to 5
' BCD decoding to the lower 4 digits 
' Switch the display on. 
' Turn Off test mode

		Register = Scan_Reg				' Point to the Scan Register
		R_Val = 3						' Send 3, (Four LED Displays 0-3)
		Gosub Transfer					' Transfer this 16-bit Word to the MAX7219

		Register = Lum_Reg				' Point to the Luminance Register
		R_Val = 5						' Send 5, (Value for Brightness)
		Gosub Transfer					' Transfer this 16-bit Word to the MAX7219

		Register = Decode_Reg			' Point to BCD Decode Register
		R_Val = %00011111				' Decode the first 5 digits
		Gosub Transfer					' Transfer this 16-bit Word to the MAX7219

		Register = Switch_Reg			' Point to the Switch Register 
		R_Val = 1						' Set to One, (switches the display ON)
		Gosub Transfer					' Transfer this 16-bit Word to the MAX7219

		Register = Test_Reg				' Point to the Test Register
		R_Val = 0						' Reset to Zero, (turns off Test mode)
		Gosub Transfer					' Transfer this 16-bit Word to the MAX7219


' 		***** MAIN PROGRAM *****
' This loop increments and then decrements a 16-bit number 
' And displays it on Four LED Displays
' The value to be displayed is held in the variable "Max_Disp"
' The Position of the decimal point is held in Max_DP (0-4)

		Max_Dp = 3						' Display number for Decimal Point
	
Again:	For Counts = 1 to 9999			' Increment Counter
			Max_Disp = Counts			' Load Max_Disp with Value of Counter
			Gosub Display				' Display the Value of Counter
			Delayms 150					' Delay, so we can see whats happening
		Next							' Close the Loop

		For Counts = 9999 to 1 step -1	' Decrement Counter
			Max_Disp = Counts			' Load Max_Disp with Value of Counter
			Gosub Display				' Display the Value of Counter
			Delayms 150					' Delay, so we can see whats happening
		Next							' Close the Loop		
		Goto Again						' Do it Indefinately


' ** Subroutines **
' Display the Value held in the Variable "MAX_DISP" on the four LED's
' The value held in "MAX_DP" places the decimal point on that LED (0-3)
' Sending the value 15 blanks the display, this allows Zero suppression
' By setting bit-7 of the value sent to the individual LED displays, the decimal point
' Is illuminated

Display:
		Digit = 0												' Start at Digit 0 of Max_Disp Variable
		For Position = 4 to 1 step -1							' Start at Farthest Right of Display 		
			Register = Position									' Place Position into Register
			R_Val = Dig Max_Disp,Digit							' Extract the individual numbers from Max_Disp			
			If Max_Disp < 10 AND Position = 3 then R_Val = 15	' Zero Suppression for the second digit
			If Max_Disp < 100 AND Position = 2 then R_Val = 15	' Zero Suppression for the Third digit
			If Max_Disp < 1000 AND Position = 1 then R_Val = 15	' Zero Suppression for the Forth digit
			If Max_Disp < 10000 AND Position = 0 then R_Val = 15 ' Zero Suppression for the Fifth digit
			If Digit = Max_Dp then R_Val.7 = 1					' Place the decimal point, held in Max_DP
			Gosub Transfer										' Transfer the 16-bit Word to the MAX7219
			If Digit >= 3 then Digit = 0						' We only need the first four digits
			Digit = Digit + 1									' Point to next Digit within Max_Disp
		Next													' Close the Loop
		Return													' Exit from subroutine

' Send a 16-bit word to the MAX7219 
Transfer:
  		Shout Dta,Clk,MSBFIRST,[Register,R_Val] 	' Shift Out the Register first, then the data
		High Load									' The data is now acted upon
		Delayus 2									' A small delay to ensure correct clocking times				
		Low Load									' Disable the MAX7219 
		Return										' Exit from Subroutine
        
        