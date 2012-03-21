' Program to display key number on LCD

		Include "PROTON_4.INC"

' Define program variables
		Dim Col     as     Byte            		' Keypad column
		Dim Row     as     Byte            		' Keypad row
		Dim Key     as     Byte            		' Key value


        OPTION_REG.7 = 0        				' Enable PORTB pullups

        Delayms 100               				' Wait for LCD to start
        Print 254,1, "Press any key"  			' Display sign on message

Loop:   Gosub Getkey            				' Get a key from the keypad
        Print $FE, 1, #Key     				' Display ASCII key number
        Goto Loop               				' Do it forever


' Subroutine to get a key from keypad
Getkey:
        Delayms 50                				' Debounce

Getkeyu:
        ' Wait for all keys up
        PORTB = 0               				' All output pins low
        TRISB = $F0             				' Bottom 4 pins out, top 4 pins in
        If (PORTB >> 4) <> $0F Then Getkeyu    	' If any keys down, loop

        Delayms 50                				' Debounce

Getkeyp:
        ' Wait for keypress
        For Col = 0 to 3        				' 4 columns in keypad
                PORTB = 0       				' All output pins low
                TRISB = (Dcd Col) ^ $FF 		' Set one column pin to output
                Row = PORTB >> 4        		' Read row
                If Row <> $0F Then Gotkey        ' If any keydown, exit
        Next
        Goto Getkeyp            				' No keys down, go look again

Gotkey: ' Change row and column to key number 1 - 16
        Key = (Col * 4) + (Ncd (Row ^ $0F))
        Return                  				' Subroutine over

Label:
        End
