' Using SERIN with the WAIT and DEC modifer

' Use serial terminal to test the software
' This should be set for 9600 baud.

' No value will be received until RETURN (enter) is pressed on the PC keyboard.
' After RETURN, enter a value between 0 and 255, then press RETURN again.
' The value entered will be displayed on the LCD

' Note the use of a constant to WAIT for, this could also be a variable or a string of characters.

		Include "PROTON_4.INC"
      
        Dim BYTEIN as Byte
        Symbol CARRIAGE_RETURN = 13		' Value to wait for
             
        Delayms 500						' Wait for PICmicro to stabilise		
       
        Cls								' Clear the LCD
        SEROUT PORTC.6 , T9600 , ["PRESS RETURN - 8-bit VALUE - then RETURN",13]
        While 1 = 1						' Create an infinite loop       	
            SERIN PORTC.7 , T9600 , [WAIT(CARRIAGE_RETURN) , DEC BYTEIN]
        	Print at 1,1,DEC BYTEIN,"  " ' Display the value received
        Wend							' Close the loop
