'
' Generate a SINE wave from the CCP1 pin using the Pulse Width Modulator MSSP module.
'
' Requires a low pass filter from PORTC.2 pin. This can be as simple as a resistor/capacitor combination: -
'
'                   1000 Ohms
'PORTC.2 o------o----/\/\/\----o-------> Output
'               |              |
'        100nF ---            --- 100nF
'              ---            ---
'               |              |
'             -----          -----
'              ---            ---
'               -              -

' To simulate this program in ISIS, 
' Ensure that the Labcenter Electronics PROTEUS VSM option is checked within the Compile and Program Toolbar Icon.
' Then simply press F10, or Click on the Compile and Program button.

        Device = 16F877
        XTAL = 8
       	
       	Dim SINE_COUNTER as Byte						' Internal Sine table counter
        Dim DURATION_COUNTER as Word					' Internal duration counter
        Dim SINE_FREQ as Byte      						' A measure of frequency (0 to 255)
		Dim DURATION_PERIOD as Word						' A measure of duration (0 to 65535)
'
' Setup the HPWM output on CCP1 (PORTC.2)
'                  
    	PR2 = 64             							' Set PWM Period for 31KHz (resolution is approx 8-bits)
		CCPR1L = 0      								' Set PWM Duty-Cycle to 0% (0 to 65) = 0 to 100% duty  
		CCP1CON = %00001100  							' Mode select = PWM
		T2CON = %00000100								' Timer2 ON + 1:1 prescale ratio
        
        Goto MAIN_PROGRAM								' Jump over the subroutine
        
'---------------------------------------------------------------------------
' Output a SINE wave using the CCP1 pin using hardware PWM
' Input	: SINE_FREQ = A measure of the frequency of the SINE wave. Requires calibrating
'		: DURATION_PERIOD = The duration of the SINE wave. Also requires calibrating

OUTPUT_SINE_WAVE:        
        TRISC.2 = 0        								' Enable the CCP1 pin (Set to Output)
        DURATION_COUNTER = 0							' Reset the duration counter
        Repeat											' Form a loop for the duration of the sine wave
        	SINE_COUNTER = 0							' Reset the sine wave table counter
            Repeat            							' Form a loop for the amount of values in the sine table
        		CCPR1L = LREAD8 SINETABLE[SINE_COUNTER]	' Place the sine values into the CCPR1L register
                Delayus SINE_FREQ						' Delay for 'SINE_FREQ' microseconds
            	Inc SINE_COUNTER						' Move up the sine table
            Until SINE_COUNTER > 76 					' Until all the values are read
        	Inc DURATION_COUNTER						' Increment the duration counter
        Until DURATION_COUNTER > DURATION_PERIOD		' Keep outputing the sine wave until duration is expired
        TRISC.2 = 1        								' Disable the CCP1 pin (Set to Input)
        Return
'
' Create the SINE table in code memory
'        
SINETABLE: 	LDATA 	$20, $22, $25, $27, $2A, $2C, $2F,$31, $33, $35, $37, $39,_
					$3A, $3C, $3D, $3E, $3E, $3F, $3F,$3F, $3F, $3F, $3F, $3E,_
                    $3D, $3C, $3A, $39, $37, $35, $33,$31, $2F, $2D, $2A, $28,_
                    $25, $23, $20, $1D, $1B, $18, $16,$13, $11, $0E, $0C, $0A,_
                    $08, $07, $05, $04, $02, $01, $01,$01, $01, $01, $01, $01,_
                    $01, $01, $02, $03, $04, $06, $07,$09, $0B, $0D, $10, $12,_
                    $14, $17, $19, $1C, $1F
' End of Subroutine
'-------------------------------------------------------------------------------        
' The Main Program Starts here
MAIN_PROGRAM:

		SINE_FREQ = 5									' Set the frequency value to 5
        DURATION_PERIOD = 1000							' Set the duration value to 1000
        Gosub OUTPUT_SINE_WAVE							' Call the sine generating subroutine
        Stop											' Then stop        
        	
        
