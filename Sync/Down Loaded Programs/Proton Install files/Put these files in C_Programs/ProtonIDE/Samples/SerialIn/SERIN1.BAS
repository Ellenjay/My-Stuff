' Using SERIN with TIMEOUT and the WAIT and DEC modifer

' Use serial terminal to test the software
' This should be set for 9600 baud.

' No value will be received until RETURN (enter) is pressed on the PC keyboard.
' After RETURN, enter a value between 0 and 255, then press RETURN again.
' The value entered will be displayed on the LCD

' If nothing is received within 5 seconds, then the SERIN command will 
' jump to the TIMEOUT routine.

' Note the use of a variable to WAIT for, this could also be a constant or a string of characters.

		Include "PROTON_4.INC"
      
        Dim BYTEIN as Byte
        Dim CARRIAGE_RETURN as Byte
             
        Delayms 600						' Wait for PICmicro to stabilise
        CARRIAGE_RETURN = 13			' Value to wait for
       
        Cls								' Clear the LCD
        SEROUT PORTC.6 , T9600 , ["PRESS RETURN - 8-bit VALUE - then RETURN",13]
        While 1 = 1						' Create an infinite loop
        	SERIN PORTC.7 , T9600 , 5000 , TIMEOUT,[WAIT(CARRIAGE_RETURN) , DEC BYTEIN]
        	Print at 1,1,DEC BYTEIN,"  " ' Display the value received
        Wend							' Close the loop
        
TIMEOUT:
		Cls								' Clear the LCD
        Print at 1,1,"TIMED OUT"		' Display a message
        Print at 2,1,"PRESS RESET"
        Stop							' And stop here until reset pressed