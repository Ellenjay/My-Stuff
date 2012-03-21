' Display text and graphics on a graphic LCD

		Include "PROTON18_G4.INT" 
	    OPTIMISER_LEVEL = 2
		 
		WARNINGS = OFF        
        Declare STAMP_COMPATIBLE_SIN = On
' Set up some Variables
        
        Dim Xpos		As	Byte
        Dim	Ypos		As	Byte
 
        DelayMS 400
        Cls
        Print "Graphic LCD Test"
        
Again:        
        For Xpos = 0 To 63
        	Ypos = Sin Xpos
        	Plot Xpos , Ypos
        	DelayMS 10
        Next
        For Xpos = 0 To 63
        	Ypos = Sin Xpos
        	UnPlot Xpos , Ypos
        	DelayMS 10
        Next                
		GoTo Again
        
		Include "FONT.INC"

