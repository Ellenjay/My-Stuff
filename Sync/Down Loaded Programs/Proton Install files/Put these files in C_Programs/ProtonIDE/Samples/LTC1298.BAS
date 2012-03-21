' Program to read LTC1298 ADC

		Include "PROTON_4.INC"

' Alias pins
		Symbol CS = PORTC.5         ' Chip select
		Symbol CK = PORTC.3         ' Clock
		Symbol DI = PORTA.2         ' Data in
		Symbol DO = PORTC.1         ' Data out

' Allocate variables
		Dim addr    as     Byte            ' Channel address / mode
		Dim result  as     Word
		Dim x       as     Word
		Dim y       as     Word
		Dim z       as     Word

        High CS                 ' Chip select inactive
        Delayms 100               ' Wait for LCD to start

        Goto    Mainloop        ' Skip subroutines


' Subroutine to read a/d convertor
getad:
        CS = 0                  ' Chip select active

        ' Send address / mode - Start bit, 3 bit addr, null bit]
        Shout DI, CK, MSBFIRST, [1\1, addr\3, 0\1]

        Shin DO, CK, MSBPRE, [result\12]  ' Get 12-bit result

        CS = 1                  ' Chip select inactive
        Return

' Subroutine to get x value (channel 0)
getx:
        addr = $05              ' Single ended, channel 0, MSBF high
        Gosub getad
        x = result
        Return

' Subroutine to get y value (channel 1)
gety:
        addr = $07              ' Single ended, channel 1, MSBF high
        Gosub getad
        y = result
        Return

' Subroutine to get z value (differential)
getz:
        addr = $01              ' Differential (ch0 = +, ch1 = -), MSBF high
        Gosub getad
        z = result
        Return


mainloop:
        Gosub   getx            ' Get x value
        Gosub   gety            ' Get y value
        Gosub   getz            ' Get z value

        Print $fe, 1, "x=", #x, " y=", #y, " z=", #z   ' Send values to LCD
        Delayms   100             ' Do it about 10 times a second

        Goto    mainloop        ' Do it forever

        End
