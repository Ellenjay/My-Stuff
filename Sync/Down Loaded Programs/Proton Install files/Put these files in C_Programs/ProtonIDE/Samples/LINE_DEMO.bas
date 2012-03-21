
' Draw a line from 0,0 to 120,34. Then from 120,34 to 0,63

		Include "PROTON_G4.INT"		' Use the PROTON development board for the demo
        
		Dim XPOS_START as BYTE
		Dim XPOS_END as BYTE
		Dim YPOS_START as BYTE
		Dim YPOS_END as BYTE
		Dim SET_CLR as BYTE
        
		Delayms 200					' Wait for PICmicro to stabilise
		Cls							' Clear the LCD        
		XPOS_START = 0
		YPOS_START = 0
		XPOS_END = 120
		YPOS_END = 34
		SET_CLR = 1
		Line SET_CLR , XPOS_START , YPOS_START , XPOS_END , YPOS_END
		XPOS_END = 0
		YPOS_END = 63
		Lineto SET_CLR , XPOS_END , YPOS_END
		Stop
