' Program to send and receive from the hardware serial port

		Include "PROTON_4.INC"

		Dim Char    as     Byte            ' Storage for serial character
		Dim Key     as     Byte            ' Key value
		Dim Lastkey as     Byte            ' Last key storage
	
		Delayms 500							' Wait for LCD to startup

        Key = 0                 			' Initialize vars
        Lastkey = 0

        Cls           						' Initialize and clear display
Loop:   Hrsin {1, Tlabel}, Char 			' Get a char from serial port
        Print Char             			' Send char to display
Tlabel: Key = (Inkey + 48)					' Get a keypress if any
		Delayms 50							' Debounce the key
        If Key != 48 + 16 AND Key != Lastkey Then Hrsout Key   	' Send key out serial port
        Lastkey = Key           			' Save last key value
        Goto loop               			' Do it all over again

        End
