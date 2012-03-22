' Program BARGRAF2.BAS
' This program generates a horizontal bargraph 
' with a 2x16 Intelligent LCD Display.
		
        Include "PROTON_4.INC"    
' ** Declare Variables **
		Dim BAR_VAL	as	Byte				' Value to be graphed. 
		Dim BARS	as	Byte				' Number of full ||| bars to draw.
		Dim BALANCE	as	Byte				' Balance left after all |||s are drawn.
		Dim BALF	as	Byte				' Is a 'Balance' character needed? (1=yes, 0=no).

' ** Declare Constants **
		Symbol B_WDTH	=	16				' Max width in characters of bar.
		Symbol MAXBAR = B_WDTH * 3			' Max bar counts. 
    	Symbol FULLBAR	=	3				' ASCII value of ||| bar. 
		Symbol BASEBAR	=	0				' ASCII value of 0 bar (blank).
		Symbol CGRAM = 64
'-------------------------------------------------------------------------------

		Delayms 500
    	Cls   
' Create the bit patterns that make up the bars in the LCD's CGRAM.
' The vertical bars are made up of 8 identical bit patterns  
' A | bar consists of 5 times %10000,
' A || bar consists of 5 times %10100
' A ||| bar consists of 5 times %10101

        Print $FE,CGRAM,Rep $0\8,$0,Rep $10\6,$0,$0,Rep $14\6,$0,$0,Rep $15\6 
		Goto OVER_BARGRAPH					' Jump over the subroutine
'-------------------------------------------------------------------------------
' The value in 'BAR_VAL' is displayed as a horizontal bar graph 
' from the current cursor location with a total width (in characters) set by the B_WDTH constant. 
' Each character position can represent a maximum value of 3 using the Fullbar character |||. 
' The routine calculates how many full bars to use by dividing by 3. 
' If there is a remainder after dividing by 3, the routine joins on a partial-bar character
' ( | or ||) to represent the balance.
' Then it pads out the remainder of the bar width with spaces to erase any leftover bars 
Bargraph:
WARNINGS = OFF
BYTE_MATH = ON
        BARS = (BAR_VAL Min MAXBAR) / 3			' One full bar for each 3 graph units.					
    	BALANCE = (BAR_VAL Min MAXBAR) //3		' Balance is the remainder after a division by 3.		 
    	BALF = BALANCE Min 1			
		Print at 1,1,Rep FULLBAR\BARS,Rep (BALANCE + BASEBAR)\BALF,Rep " " \B_WDTH - (BARS + BALF)
        Print at 2,1,Dec BAR_VAL,"  "			' Display the decimal value of BAR_VAL
        Return
BYTE_MATH = OFF
WARNINGS = ON
'-------------------------------------------------------------------------------
' Demonstration routine
OVER_BARGRAPH:
		For BAR_VAL = 0 to 40
    		Gosub BARGRAPH
    		Delayms 100
    	Next
    	For BAR_VAL = 40 to 0 step -1
    		Gosub BARGRAPH
    		Delayms 100
    	Next
    	Goto OVER_BARGRAPH
    	