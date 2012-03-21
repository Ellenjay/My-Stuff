' Program to create telephone pad tone
' Oscillator must be set to 20MHz

		DEVICE = 16F877
        XTAL = 20

		LCD_DTPIN = PORTD.4	
		LCD_RSPIN = PORTE.0
		LCD_ENPIN = PORTE.1
		LCD_INTERFACE = 4	' 4-bit Interface
		LCD_LINES = 2
		LCD_TYPE = 0

' Define program variables
		Dim Col     as     Byte            	' Keypad column
		Dim Row     as     Byte            	' Keypad row
		Dim Key     as     Byte            	' Key value
		Dim Tone    as     Byte            	' Tone number

		Symbol Spkr    =     PORTC.2         	' Alias speaker pin


        OPTION_REG.7 = 0        			' Enable PORTB pullups

        Print Cls , "Press any key"  		' Display sign on message

Loop:
        Gosub Getkey            			' Get a key from the keypad
        Lookupl Tone,["0123456789*#ABCD"],Key
        Print at 1,1 , Key , "  "     		' Display ASCII key number
        Dtmfout Spkr, [Tone]
        Goto Loop               			' Do it forever

' Subroutine to get a key from keypad
Getkey:
        Delayms 50                			' Debounce

Getkeyu:
        ' Wait for all keys up
        PORTB = 0               			' All output pins low
        TRISB = $f0             			' Bottom 4 pins out, top 4 pins in
        If (PORTB >> 4) != $0F Then Getkeyu    ' If any keys down, loop

        Delayms 50                			' Debounce

Getkeyp:
        ' Wait for keypress
        For Col = 0 To 3        			' 4 columns in keypad
        	PORTB = 0       				' All output pins low
        	TRISB = (Dcd Col) ^ $FF 		' Set one column pin to output
         	Row = PORTB >> 4        		' Read row
         	If Row != $0F Then Gotkey       ' If any keydown, exit
        Next

        Goto Getkeyp            ' No keys down, go look again

' Change row and column to key number 0 - 15
Gotkey: 
        Key = (Col * 4) + (Ncd (Row ^ $FF)) - 1

        ' Translate key to telephone keypad tone
        ' 10 = *
        ' 11 = #
        ' 12 = A
        ' 13 = B
        ' 14 = C
        ' 15 = D
        Lookupl Key,[1,2,3,12,4,5,6,13,7,8,9,14,10,0,11,15],Tone
        Return                  			' Subroutine over

        End
