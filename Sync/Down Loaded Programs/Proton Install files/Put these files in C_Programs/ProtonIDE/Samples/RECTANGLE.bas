' Draw a rectangle on a graphic LCD using BASIC comands

		Include "PROTON_G4.EXT"
        
        Dim XPOS_START as Byte
        Dim XPOS_END as Byte
        Dim YPOS_START as Byte
        Dim YPOS_END as Byte
        Dim XPOS as Byte       

        Delayms 500						' Wait for PICmicro to stabilise
        Cls								' Clear the LCD
        
        XPOS_START = 20					' XPOS START
        XPOS_END = 60					' XPOS END
        YPOS_START = 10					' YPOS START
        YPOS_END = 30					' YPOS END
        Gosub RECTANGLE
        Stop
        
'----------------------------------------------------------        
' Draw a rectangle        
RECTANGLE:
		XPOS = XPOS_START
    	Repeat							' Create a loop for the X lines
        	Plot YPOS_START,XPOS
        	Plot YPOS_END,XPOS
			Inc XPOS
    	Until XPOS > XPOS_END
    	Repeat							' Create a loop for the Y lines
        	Plot YPOS_START,XPOS_START
        	Plot YPOS_START,XPOS_END
			Inc YPOS_START
    	Until YPOS_START > YPOS_END
		Return
        