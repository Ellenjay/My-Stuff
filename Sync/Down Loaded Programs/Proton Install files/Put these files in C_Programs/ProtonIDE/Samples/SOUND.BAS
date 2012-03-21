' Demonstrate the SOUND command

	Device 16F84
    
	Dim Pitch as Byte
	
	Symbol Pin = PortB.0
	
	Cls
	For Pitch = 0 to 200
		Sound Pin,[Pitch,40]
    	Print at 1,1,@Pitch,"  "
    Next
	Stop	
	