'
' Toshiba T6963 Graphic LCD Demo
'
' Using PROTON+ Version 3.08 onwards
'
' Print on two text screens of the LCD then pan between them
'
' Ensure that a 6 pixel font is implemented for the LCD's circuit
'
	Device = 18F452
    XTAL = 4   
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
    LCD_RAM_SIZE = 8192							' 8192 bytes of RAM within display
    LCD_X_RES = 128								' 128 pixels horizontally
    LCD_Y_RES = 64								' 64 pixels vertically
    LCD_FONT_WIDTH = 6							' Choose a 6 pixel font
    LCD_TEXT_HOME_ADDRESS = 0					' Ensure that text RAM starts at address 0
'    
' LCD Display Constants
'
' Register set commands:
'
    Symbol T_CURSOR_POINTER_SET   =     $21   	' Cursor Pointer Set
    Symbol T_OFFSET_REG_SET       =     $22   	' Offset Register Set (CGRAM start address offset)
    Symbol T_ADDR_POINTER_SET     =     $24   	' Address Pointer Set
'
' Control Word Set commands:
'
    Symbol T_TEXT_HOME_SET        =     $40   	' Text Home Address Set
    Symbol T_TEXT_AREA_SET        =     $41   	' Text Area Set
    Symbol T_GRAPH_HOME_SET       =     $42   	' Graphics Home address Set
    Symbol T_GRAPH_AREA_SET       =     $43   	' Graphics Area Set
'
' Mode Set commands:
'
    Symbol T_OR_MODE              =     $80   	' OR mode
    Symbol T_XOR_MODE             =     $81   	' XOR mode
    Symbol T_AND_MODE             =     $83   	' AND mode
    Symbol T_TEXT_ATTR_MODE       =     $84   	' Text Attribute mode
    Symbol T_INT_CG_MODE          =     $80   	' Internal CG ROM mode
    Symbol T_EXT_CG_MODE          =     $88   	' External CG ROM mode
'
' Display Mode commands (OR together required bits):
'
    Symbol T_DISPLAY_OFF          =     $90   	' Display off
    Symbol T_BLINK_ON             =     $91		' Cursor Blink on
    Symbol T_CURSOR_ON            =     $92		' Cursor on
    Symbol T_TEXT_ON              =     $94		' Text mode on
    Symbol T_GRAPHIC_ON           =     $98		' Graphic mode on
    Symbol T_TEXT_AND_GRAPH_ON	  =     $9C		' Text and graphic mode on
'
' Cursor Pattern Select:
'
    Symbol T_CURSOR_1LINE         =     $A0		' 1 line cursor
    Symbol T_CURSOR_2LINE         =     $A1		' 2 line cursor
    Symbol T_CURSOR_3LINE         =     $A2		' 3 line cursor
    Symbol T_CURSOR_4LINE         =     $A3		' 4 line cursor
    Symbol T_CURSOR_5LINE         =     $A4		' 5 line cursor
    Symbol T_CURSOR_6LINE         =     $A5		' 6 line cursor
    Symbol T_CURSOR_7LINE         =     $A6		' 7 line cursor
    Symbol T_CURSOR_8LINE         =     $A7		' 8 line cursor
'
' Data Auto Read/Write:
'
    Symbol T_DATA_AUTO_WR         =     $B0		' Data write with auto increment of address
    Symbol T_DATA_AUTO_RD         =     $B1		' Data read with auto increment of address
    Symbol T_AUTO_DATA_RESET      =     $B2		' Disable auto read/write
'
' Data Read/Write:
'
    Symbol T_DATA_WR_INC          =     $C0   	' Data write and increment address
    Symbol T_DATA_RD_INC          =     $C1   	' Data read and increment address
    Symbol T_DATA_WR_DEC          =     $C2   	' Data write and decrement address
    Symbol T_DATA_RD_DEC          =     $C3   	' Data read and decrement address
    Symbol T_DATA_WR              =     $C4   	' Data write with no address change
    Symbol T_DATA_RD              =     $C5   	' Data read with no address change
'
' Screen Peek:
'
    Symbol T_SCREEN_PEEK          =     $E0		' Read the display
'
' Screen Copy:
'
    Symbol T_SCREEN_COPY          =     $E8		' Copy a line of the display
'
' Bit Set/Reset (OR with bit number 0-7):
'
    Symbol T_BIT_RESET            =     $F0		' Pixel clear
    Symbol T_BIT_SET              =     $F8		' Pixel set
'
' Create two variables for the demonstration
'   
    Dim PAN_LOOP as Byte						' Holds the amount of pans to perform
    Dim YPOS as Byte							' Holds the Y position of the displayed text
'-----------------------------------------------------------------------------
' The main demo loop starts here
    Delayms 200									' Wait for things to sabilise
    ALL_DIGITAL = True							' Set PORTA and PORTE to digital mode
    Cls											' Clear both text and graphics of the LCD
'
' Place text on two screen pages
' 
    For YPOS = 1 to 6
    	Print at YPOS,0,"  THIS IS PAGE ONE      THIS IS PAGE TWO"
    Next
'
' Draw a box around the display
'   	
    Line 1,0,0,127,0							' Top line
    LineTo 1,127,63								' Right line
    LineTo 1,0,63								' Bottom line
    LineTo 1,0,0								' Left line
'
' Pan from one screen to the next then back
'    
    While 1 = 1									' Create an infinite loop
    	For PAN_LOOP = 0 to 22
    		TOSHIBA_COMMAND T_TEXT_HOME_SET , WORD PAN_LOOP ' Increment the Text home address
    		Delayms 200
    	Next
        Delayms 200
    	For PAN_LOOP = 22 to 0 Step -1
    		TOSHIBA_COMMAND T_TEXT_HOME_SET , WORD PAN_LOOP	' Decrement the Text home address
    		Delayms 200
    	Next
        Delayms 200
    Wend										' Do it forever
    
	