'
' Toshiba T6963Graphic LCD User Defined Graphic Demo
'
' Using PROTON+ Version 3.08 onwards
'
' The program shows the various methods of storing User Defined Data 
'
' Ensure that an 8 pixel font is implemented for the LCD's circuit
'
	Device = 18F452
    XTAL = 20   
    LCD_TYPE = TOSHIBA							' Target a Toshiba T6963 graphic LCD
'
' LCD pin assignments
'    
    LCD_DTPORT = PORTB							' Data port of the LCD
	LCD_WRPIN = PORTE.2							' WR line of the LCD
	LCD_RDPIN = PORTE.1							' RD line of the LCD
	LCD_CEPIN = PORTE.0							' CE line of the LCD
	LCD_CDPIN = PORTA.1							' CD line of the LCD
	LCD_RSTPIN = PORTA.0						' RESET line of the LCD (Optional)
'
' LCD characteristics
'    
    LCD_RAM_SIZE = 8192							' 8192 bytes of RAM within display
    LCD_X_RES = 128								' 128 pixels horizontally
    LCD_Y_RES = 64								' 64 pixels vertically
    LCD_FONT_WIDTH = 8							' Choose an 8 pixel font
'
' Demonstration variables
'    
    Dim UDG_3[8] as Byte						' Create a byte array to hold UDG data
    Dim DEMO_CHAR as Byte						' Holds the loop for moving the UDG
'
' Create some User Defined Graphic data in eeprom memory
'
UDG_1	EDATA $18, $18, $3C, $7E, $DB, $99, $18, $18

'-----------------------------------------------------------------------------
' The main demo loop starts here
'
    Delayms 200									' Wait for things to stabilise
    ALL_DIGITAL = True							' Set PORTA and PORTE to digital mode
    Cls											' Clear both text and graphics of the LCD  
	STR UDG_3 = $18, $18, $99, $DB, $7E, $3C, $18, $18 ' Load the array with UDG data
'
' Print the user defined graphic characters 160, 161, 162, and 162 on the LCD
' 
    Print at 1,0,"CHAR 160 = ",160
    Print at 2,0,"CHAR 161 = ",161
    Print at 3,0,"CHAR 162 = ",162
    Print at 4,0,"CHAR 163 = ",163
    
    TOSHIBA_UDG 160,[Estr UDG_1]				' Place the UDG edata into chacrater 160
    TOSHIBA_UDG 161,[UDG_2]						' Place the UDG cdata into character 161
    TOSHIBA_UDG 162,[Str UDG_3\8]				' Place the UDG array data into character 162
    TOSHIBA_UDG 163,[$0C, $18, $30, $FF, $FF, $30, $18, $0C] ' Place values into chacrater 163   
    
    Box 1,67,51,6								' Draw a box around the moving graphic    
    While 1 = 1									' Create an infinite loop
    	For DEMO_CHAR = 160 To 163				' Cycle through characters 160 to 163
        Print At 6, 8, DEMO_CHAR				' Display the character
        Delayms 200								' A small delay
        Next									' Close the loop
    Wend										' Do it forever
    
' Create some User Defined Graphic data in code memory
UDG_2:	CDATA $30, $18, $0C, $FF, $FF, $0C, $18, $30
        


    
	