' Program to send and receive from the hardware serial port

		Include "PROTON_4.INC"


		Dim Char    as     Byte            ' Storage for serial character
		Dim Col     as     Byte            ' Keypad column
		Dim Row     as     Byte            ' Keypad row
		Dim Key     as     Byte            ' Key value
		Dim Lastkey as     Byte            ' Last key storage
	
		Delayms 500							' Wait for LCD to startup

        PORTB_PULLUPS = ON        			' Enable PORTB pullups

        Key = 0                 			' Initialize vars
        Lastkey = 0

        Cls           						' Initialize and clear display
Loop:   Hrsin {1, Tlabel} ,Char ' Get a char from serial port
        Print Char             			' Send char to display
Tlabel: Gosub Getkey            			' Get a keypress if any
        If Key != 0 AND Key != Lastkey Then
        	Hrsout Key   					' Send key out serial port
        Endif
        Lastkey = Key           			' Save last key value
        Goto loop               			' Do it all over again

' Subroutine to get a key from keypad
Getkey:
        Key = 0                 			' Preset to no key
        For Col = 0 To 3        			' 4 columns in keypad
        	PORTB = 0       				' All output pins low
        	TRISB = (Dcd Col) ^ $FF 		' Set one column pin to output
        	row = PORTB >> 4        		' Read row
        	If Row != $0F Then Gotkey        ' If any keydown, exit
        Next

        Return                  			' No key pressed

gotkey: ' Change row and column to ASCII key number
        Key = (Col * 4) + (Ncd (Row ^ $0F)) + "0"
        Return                  			' Subroutine over

        End
