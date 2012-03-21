'
' Toshiba T6963 Graphic LCD command tests
'
' For 16-bit core devices using PROTON+ Version 3.08 onwards
' To use this with a 14-bit core device remove all references to STRING variables
'
' The program will cycle through the standard graphic LCD commands
' View the test progress via the serial terminal set to 9600 baud
'
	Device = 18F452
    XTAL = 20
    
    FLOAT_DISPLAY_TYPE = LARGE					' Use more accurate floating point display
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
    LCD_TEXT_PAGES = 2							' Choose two text pages
    LCD_RAM_SIZE = 8192							' Amount of RAM within display
    LCD_X_RES = 240								' Horizontal resolution
    LCD_Y_RES = 64								' Vertical resolution
    LCD_FONT_WIDTH = 6							' Choose a 6 pixel font
    LCD_TEXT_HOME_ADDRESS = 0					' Ensure that text RAM starts at address 0
'
' Setup the USART for the demo
'   
    HSERIAL_BAUD = 9600							' Set baud rate to 9600
    HSERIAL_RCSTA = %10010000       			' Enable serial port and continuous receive
    HSERIAL_TXSTA = %00100100       			' Enable transmit and asynchronous mode 
    HSERIAL_CLEAR = ON							' Enable Error clearing on received characters
'
' Create some variables for the demo
'  
    Dim XPOS as Byte
    Dim YPOS as Byte
    Dim VAR1 as Byte
    Dim FLT1 as Float
    Dim DWD1 as Dword
    Dim STRING1 as String * 20
'-------------------------------------------------------------
' The main program starts here
    
    Delayms 200									' Wait for things to stabilise
    ALL_DIGITAL = True							' Set PORTA and PORTE to digital mode
    
While 1 = 1   									' Create an infinite loop 
    Cls											' Clear text and graphics area of teh LCD
    FLT1 = 3.1456
    DWD1 = 123456789
   	STRING1 = "  TOSHIBA T6963 LCD"
 	Print " GRAPHIC TESTS FOR A"
    Print at 1,0,STRING1
    Print at 3,0,"FLOAT ",Dec FLT1
    Print at 4,0,"DWORD ",Dec DWD1 
    Print at 5,0,DISPLAY_TEXT
    
    Delayms 2000  
'-------------------------------------------------------------
'    
' Print Test loop
'
   	Hserout ["PRINT Test\r"]
    For YPOS = 0 to (__LCD_Y_RES / 8) - 1
    	For XPOS = 0 to __LCD_TEXT_AREA - 2
        	Print at YPOS,XPOS, XPOS + 48 
        Next
    Next
'-------------------------------------------------------------
'    
' Read TEXT test loop
'
   	Hserout ["READ TEXT Test\r"]
    For YPOS = 0 to (__LCD_Y_RES / 8) - 1
    	Hserout ["READING \ WRITING LINE ",Dec YPOS,13]
    	For XPOS = 0 to __LCD_TEXT_AREA - 2
        	VAR1 = LCDREAD TEXT YPOS,XPOS
            Print at YPOS,XPOS, VAR1 
        Next
    Next
'-------------------------------------------------------------
'
' PIXEL Command Test
'
' Fill the LCD with pseudo random data
'
WARNINGS = Off
	Hserout ["PIXEL Test\r"]
    Seed $0345
    For YPOS = 0 to __LCD_Y_RES - 1
        For XPOS = 0 to __LCD_TEXT_AREA - 2
        	Lcdwrite YPOS , XPOS , [Random]
        Next
    Next
' Read the LCD a pixel at a time into VAR1 then write it back to it
' The data on the LCD should not change, as the same value should be read that was there originally
    For YPOS = 0 to __LCD_Y_RES - 1
    	Hserout ["READING \ WRITING LINE ",Dec YPOS,13]
        For XPOS = 0 to __LCD_X_RES - 1
        	VAR1 = Pixel YPOS , XPOS
            If VAR1 = 1 Then
            	Plot YPOS , XPOS
            Else
            	Unplot YPOS , XPOS
            Endif
        Next
    Next
WARNINGS = On 

'-------------------------------------------------------------
'
' CLS Command Test
'
    Hserout ["CLS GRAPHIC Test\r"]
    Cls GRAPHIC
    Delayms 1000
    Hserout ["CLS TEXT Test\r"]
    Cls TEXT 
    Delayms 500

' LCDREAD, LCDWRITE Test
'
' Fill the LCD with pseudo random data
WARNINGS = OFF
	Hserout ["LCDREAD\LCDWRITE Test\r"]
    SeeD $0245
    For YPOS = 0 to __LCD_Y_RES - 1
    	For XPOS = 0 to __LCD_TEXT_AREA - 2
        	Lcdwrite YPOS , XPOS , [Random]
        Next
    Next
' Read the LCD into VAR1 then write it back to it
' The data on the LCD should not change, as the same value should be read that was there originally
	For YPOS = 0 to __LCD_Y_RES - 1
    	Hserout ["READING \ WRITING LINE ",Dec YPOS,13]
    	For XPOS = 0 to __LCD_TEXT_AREA - 2
        	VAR1 = Lcdread YPOS , XPOS
            Lcdwrite YPOS , XPOS , [VAR1]
        Next
    Next
WARNINGS = ON
    Cls 
'-------------------------------------------------------------  
'
' CIRCLE Command Test
'
    Hserout ["CIRCLE Test\r"]
    For YPOS = 2 to __LCD_Y_RES Step 2
    	Circle 1,__LCD_X_RES / 2,__LCD_Y_RES / 2,YPOS * 2
    Next
    For YPOS = 2 to __LCD_Y_RES Step 2
    	Circle 0,__LCD_X_RES / 2,__LCD_Y_RES / 2,YPOS * 2
    Next  
    Cls
    Delayms 500
'-------------------------------------------------------------
'   
' LINE Command Test
'    
    Hserout ["LINE Test\r"]  
    For XPOS = 0 to __LCD_X_RES - 1
    	Line 1,XPOS,0,XPOS,__LCD_Y_RES - 1
    Next
    For XPOS = 0 to __LCD_X_RES - 1
    	Line 0,XPOS,0,XPOS,__LCD_Y_RES - 1
    Next
    Cls
'-------------------------------------------------------------
'    
' PLOT, UNPLOT Test
'
	Hserout ["PLOT Test\r"]
    For YPOS = 0 to __LCD_Y_RES - 1
    	For XPOS = 0 to __LCD_X_RES - 1
            Plot YPOS,XPOS
        Next
    Next    
    For YPOS = 0 to __LCD_Y_RES - 1
    	For XPOS = 0 to __LCD_X_RES - 1
        	UnPlot YPOS,XPOS
        Next
    Next
    Hserout ["FINISHED\r"]
    Cls
    Print "FINISHED"
    Delayms 1000
Wend

DISPLAY_TEXT:	CDATA "CDATA Test ",0


