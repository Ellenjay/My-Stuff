
	INCLUDE "PROTON_G10.INT"				' Demo using PROTON Dev board

    GLCD_EXTERNAL_PRINT = PPRINT			' Point to PPRINT.INC file
    
    DIm VAR1 as Byte
    Dim WRD1 as Word
    Dim DWD as DWord
    Dim FLT as FLOAT
    Dim STRING1[20] as Byte
    
    Delayms 100
    Cls
    
' Pre-load some variables    
    VAR1 = 129
    WRD1 = 54321
    DWD = 1234567
    FLT = 1.2
    STRN STRING1 = "STR STRING"						' Load STRING1 with NULL terminated characters

    
    Print FONT TIMES_BOLD14  						' Choose the font
    
    Print IHEX VAR1 ," ",IBIN VAR1					' Display HEX and BINARY

    Print at 10,0,"HELLO"							' Display a quoted character string

    Print at 20,0,"Decimal ",DEC DWD							' Display a DWORD
    	
    Print at 30,0,"Float ",DEC2 FLT							' Display a FLOATING POINT
    
    Print at 40,0,FONT ARIAL_BOLD11,CSTR STRING2	' Display a Virtual String
    
    Print at 50,0,STR STRING1						' Display a String
    Stop    
	
'
' Load the fonts used
    Include "ARIAL_BOLD_11.FNT"
    Include "TIMES_BOLD_14.FNT"
 
STRING2: CDATA "CSTR STRING",0   
