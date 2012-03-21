' Draw squares on a graphics LCD using BASIC commands
' This is a similar routine to the compiler's built in BOX command

		Include "PROTON_G4.EXT"
        
        Dim X as Byte
        Dim Y as Byte
        Dim XPOS_START as Byte
        Dim YPOS_START as Byte
        Dim SIZE as Byte     

        Delayms 500						' Wait for PICmicro to stabilise
        Cls								' Clear the LCD
        
        XPOS_START = 64					' XPOS Start position
        YPOS_START = 31					' YPOS Start position
        For SIZE = 1 to 60 step 4
        Gosub DRAW_BOX
        Delayms 100
        Next
        Stop
'----------------------------------------------------        
' Draw 8 pixels simultaneously
PLOT_8:
	Plot YPOS_START + y,XPOS_START + x
    Plot YPOS_START + y,XPOS_START - x
	Plot YPOS_START - y,XPOS_START + x
    Plot YPOS_START - y,XPOS_START - x			
	Plot YPOS_START + x,XPOS_START + y
    Plot YPOS_START + x,XPOS_START - y
    Plot YPOS_START - x,XPOS_START + y
    Plot YPOS_START - x,XPOS_START - y
	Return
'--------------------------------------------------------------------        
' Draw a BOX        
' XPOS_START,YPOS_START and SIZE
DRAW_BOX:

  		X = 0
  		Y = SIZE
        While X <= Y 
      		Gosub PLOT_8 
			Inc X
  		Wend
		Return
        