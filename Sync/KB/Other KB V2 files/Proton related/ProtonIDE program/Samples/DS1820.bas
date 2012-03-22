' Program to read DS1820 1-wire temperature sensor and display temperature on LCD

		Include "PROTON_4.INC"


' Allocate variables
		Dim command as     byte            ' Storage for command
		Dim i       as     byte            ' Storage for loop counter
		Dim temp    as     word            ' Storage for temperature
		
		Symbol DQ      =     PORTC.0         ' Alias DS1820 data pin
		Symbol DQ_DIR  =     TRISC.0         ' Alias DS1820 data direction pin


        Print $fe, 1, "Temp in degrees C"      ' Display sign-on message


' Mainloop to read the temperature and display on LCD
mainloop:
        Gosub init1820          ' Init the DS1820

        command = $cc           ' Issue Skip ROM command
        Gosub write1820

        command = $44           ' Start temperature conversion
        Gosub write1820

        Delayms 2000              ' Wait 2 seconds for conversion to complete

        Gosub init1820          ' Do another init

        command = $cc           ' Issue Skip ROM command
        Gosub write1820

        command = $be           ' Read the temperature
        Gosub write1820
        Gosub read1820

        ' Display the decimal temperature
        Print $fe, 1, dec (temp >> 1), ".", dec (temp.0 * 5), " degrees C"

        Goto mainloop           ' Do it forever


' Initialize DS1820 and check for presence
init1820:
        Low DQ                  ' Set the data pin low to init
        Delayus 500             ' Wait > 480us
        DQ_DIR = 1              ' Release data pin (set to input for high)

        Delayus 100             ' Wait > 60us
        If DQ = 1 Then
                Print $fe, 1, "DS1820 not present"
                Delayms 500
                Goto mainloop   ' Try again
        Endif
        Delayus 400             ' Wait for end of presence pulse
        Return


' Write "command" byte to the DS1820
write1820:
        For i = 1 to 8          ' 8 bits to a byte
                If command.0 = 0 Then
                        Gosub write0    ' Write a 0 bit
                Else
                        Gosub write1    ' Write a 1 bit
                Endif
                command = command >> 1  ' Shift to next bit
        Next i
        Return

' Write a 0 bit to the DS1820
write0:
        Low DQ
        Delayus 60              ' Low for > 60us for 0
        DQ_DIR = 1              ' Release data pin (set to input for high)
        Return

' Write a 1 bit to the DS1820
write1:
        Low DQ                  ' Low for < 15us for 1
@       nop                     ' Delay 1us at 4MHz
        DQ_DIR = 1              ' Release data pin (set to input for high)
        Delayus 60              ' Use up rest of time slot
        Return


' Read temperature from the DS1820
read1820:
        For i = 1 to 16         ' 16 bits to a word
                temp = temp >> 1        ' Shift down bits
                Gosub readbit   ' Get the bit to the top of temp
        Next i
        Return

' Read a bit from the DS1820
readbit:
        temp.15 = 1             ' Preset read bit to 1
        Low DQ                  ' Start the time slot
@       nop                     ' Delay 1us at 4MHz
        DQ_DIR = 1              ' Release data pin (set to input for high)
        If DQ = 0 Then
                temp.15 = 0     ' Set bit to 0
        Endif
        Delayus 60              ' Wait out rest of time slot
        Return

        End
