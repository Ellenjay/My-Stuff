' Program to display key number on LCD

		Include "PROTON_4.INC"

' Define program variables
		Dim Col     as  byte            ' Keypad column
		Dim Row     as  byte            ' Keypad row
		Dim Key     as  byte            ' Key value

        PORTB_PULLUPS = ON        ' Enable PORTB pullups 

        Delayms 100               ' Wait for LCD to start
        Print Cls, "Press any key"  ' Display sign on message

loop:   Gosub Getkey            ' Get a key from the keypad
        Print Cls, Dec Key     	' Display ASCII key number
        Goto Loop               ' Do it forever


' Subroutine to get a key from keypad
getkey:
        Delayms 50                ' Debounce

getkeyu:
        ' Wait for all keys up
        PORTB = 0               ' All output pins low
        TRISB = $f0             ' Bottom 4 pins out, top 4 pins in
        If (PORTB >> 4) <> $0F Then Getkeyu    ' If any keys down, loop

        Delayms 50                ' Debounce

getkeyp:
        ' Wait for keypress
        For Col = 0 to 3        ' 4 columns in keypad
                PORTB = 0       ' All output pins low
                TRISB = (Dcd Col) ^ $FF ' Set one column pin to output
                row = PORTB >> 4        ' Read row
                If Row <> $0F Then Gotkey        ' If any keydown, exit
        Next Col
        Goto Getkeyp            ' No keys down, go look again

Gotkey: ' Change row and column to key number 1 - 16
        Key = (Col * 4) + (Ncd (Row ^ $0F))
        Return                  ' Subroutine over

