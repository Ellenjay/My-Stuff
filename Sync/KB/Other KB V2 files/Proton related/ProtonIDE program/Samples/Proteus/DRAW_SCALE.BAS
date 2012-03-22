' Draw a scale with X and Y lines
' Incremental tick marks are also added

		Include "PROTON_G4.EXT"	' Use a PROTON board with a 4MHz OSC and Graphic LCD
        
        Dim S_XSTART as Byte
        Dim S_XEND as Byte
        Dim S_YSTART as Byte
        Dim S_YEND as Byte
        Dim S_YTICK as Byte
        Dim S_XTICK as Byte
        Dim XPOS as Byte 
        Dim YPOS as Byte
        Dim I as Byte    

        Delayms 500				' Wait for PICmicro to stabilise
        Cls						' Clear the LCD
        
        S_XSTART = 0			' XPOS start position
        S_XEND = 119			' XPOS end position
       	S_YSTART = 0			' YPOS start position
        S_YEND = 59				' YPOS end position
        S_XTICK = 10			' X increment of TICKS
        S_YTICK = 10 			' Y increment of TICKS
        Gosub DRAW_SCALE		' Draw the scale
        Stop
        
'---------------------------------------------------------------------------       
' Draw_Scale subroutine which draws an XY scale with tick marks
' Assumes values assigned to S_XPOS,S_YPOS,S_XTICK,X_XEND,S_YEND and S_YTICK

Draw_Scale:
' Draw vertical Y axis
		I = 0
        YPOS = S_YSTART
		Repeat
    		Plot YPOS,S_XSTART
			Inc I
			Inc YPOS
        Until YPOS > S_YEND

' Add the tick marks to the Y axis
		YPOS = S_YSTART
		Repeat
        	Plot YPOS,S_XSTART + 1
			YPOS = YPOS + S_YTICK
        Until YPOS > S_YEND

' Draw horizontal X axis
		XPOS = S_XSTART
		Repeat
			Plot s_yend,XPOS
			Inc XPOS
        Until XPOS > S_XEND
	
' Draw X axis tick marks
		XPOS = S_XSTART
		Repeat
			Plot S_YEND - 1,XPOS
			XPOS = XPOS + S_XTICK
        Until XPOS > S_XEND

		Return
        
