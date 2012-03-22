' Draw circles on a graphics LCD using BASIC commands
' This is a similar routine to the compiler's built in CIRCLE command.

		Include "PROTON_G4.INT"
        
		Dim xx as Byte
        Dim yy as Byte
        Dim tr as Word
		Dim dd as Byte
		Dim a as Byte
        Dim b as Byte
        Dim c as Byte
        Dim d as Byte
              
        Dim XPOS_START as Byte		' XPOS Start position
        Dim YPOS_START as Byte		' YPOS Start position
        Dim RADIUS as Byte			' RADIUS (in pixels)
        
        Delayms 500					' Wait for PICmicro to stabilise

		For RADIUS = 5 to 150
        	Cls
        	XPOS_START = 64
        	YPOS_START = 32
        	Gosub DRAW_CIRCLE
        	Print at 0,0, "RADIUS = " , DEC RADIUS,"  "
        	Delayms 300
    	Next
        Stop
'---------------------------------------------------------         
' Plot 4 locations simultaneously
PLOT_IT:
		Plot b,a
		Plot d,a
		Plot b,c
		Plot d,c
    	Return
'---------------------------------------------------------    
' Draw a circle
DRAW_CIRCLE:        

    	dd = YPOS_START - XPOS_START
		xx = 0
    	yy = RADIUS
		tr = 3 - (2 * RADIUS)
		While xx <= yy
			a = XPOS_START + xx
    		b = YPOS_START + yy
			c = XPOS_START - xx
    		d = YPOS_START - yy   
			Gosub PLOT_IT
			a = YPOS_START + yy - dd
    		b = YPOS_START + xx
			c = YPOS_START - yy - dd
    		d = YPOS_START - xx
			Gosub PLOT_IT
        	If tr.15 =1 Then
            	tr = tr + 6
            	tr = tr + (4 * xx)
			Else
				tr = tr + 10
            	tr = tr + (4 * (xx - yy))
				Dec yy
			EndIf 
			Inc xx
		Wend
		Return

		Include "FONT.INC"




