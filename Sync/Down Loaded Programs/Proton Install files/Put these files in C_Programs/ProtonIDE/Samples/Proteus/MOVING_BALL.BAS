
' Bounce a pixel around the graphic LCD's screen

		Include "PROTON_G4.INT"
    
		Dim x as Byte
    	Dim y as Byte
    	Dim xold as Byte
   	 	Dim yold as Byte
    	Dim xx as Byte
    	Dim yy as Byte
    	Dim xxx as Byte
    	Dim yyy as Byte
    	Dim w as Byte

		Dim Xdir As Bit
		Dim Ydir As Bit

		Symbol Xmax = 126				' XPOS maximum position
		Symbol Ymax = 62				' YPOS maximum position
		Symbol Xmin = 1					' XPOS minimum position
		Symbol Ymin = 1					' YPOS minimum position
		Symbol Delay = 20				' Rate of ball movement

		Delayms 500						' Wait for PICmicro to stabilise
    	Cls								' Clear the LCD

		x = Xmin
        y = Ymin
		Xdir = 1
        Ydir = 1

		While 1 = 1
			If Xdir = 1 Then
				Inc x
				If x > Xmax Then		' Make sure ball is within X boundaries
					Xdir = 0
					x = Xmax
				Endif
			Else
				Dec x
				If x = Xmin Then		' Make sure ball is within X boundaries
					Xdir = 1
				EndIf
			EndIf
			If Ydir = 1 Then
				Inc y
				If y > Ymax Then		' Make sure ball is within Y boundaries
					Ydir = 0
					y = Ymax
				EndIf
			Else
				Dec y
				If y = Ymin Then		' Make sure ball is within Y boundaries
					Ydir = 1
				EndIf
			EndIf
			Plot y,x					' Draw the ball
    		Plot y + 1,x
    		Plot y,x + 1
    		Plot y + 1,x + 1
			Delayms Delay

			UnPlot yold,xold			' Erase the ball
    		UnPlot yold + 1,xold
    		UnPlot yold,xold + 1
    		UnPlot yold + 1,xold + 1
			Delayms Delay

			xold = xxx					' Update variables
    		yold = yyy
			xxx = xx
    		yyy = yy
			xx = x
    		yy = y
		Wend							' Do it forever


