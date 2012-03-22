' Program to send "Hello World" on serial port

		
        Include "PROTON18_20.INC"


loop:   SerOut PORTC.6,T2400,["Hello",10,13]  ' Display "Hello", next line
        DelayMS 500	' Wait .5 second

        SerOut PORTC.6,T2400,["World",10,13,10,13]  ' Display "World", skip a line
        DelayMS 500	' Wait .5 second

        GoTo loop	' Do it forever
        End

