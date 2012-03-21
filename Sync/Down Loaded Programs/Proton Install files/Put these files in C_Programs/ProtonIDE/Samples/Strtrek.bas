' Star Trek The Next Generation...Theme and ship take-off
' Output "0" to +side of 10uF capacitor, -side to -speaker (40 ohm or
' 8 ohm with 3 10 ohm series resistors), +speaker to ground.
		
        Include "PROTON_4.INC"
        
        Dim B2 as Byte
        Symbol Pin = PORTA.0
   
Theme:	Sound Pin, [50,60,70,20,85,120,83,40,70,20,50,20,70,20,90,120,90,20,98,160]
		Delayms 500
take_off:
		For B2 = 128 to 255					'ascending white noises
       		Sound Pin, [b2,2]               'for warp drive sound
		Next
one:	Sound Pin, [43,80,63,20,77,20,71,80,51,20,90,20,85,140,77,20,80,20,85,20,90,20,80,20,85,60,90,60,92,60,87,60,96,70,0,10,96,10,0,10,96,10,0,10,96,30,0,10,92,30,0,10,87,30,0,10,96,40,0,20,63,10,0,10,63,10,0,10,63,10,0,10,63,20]

		Delayms 10000
		Goto theme
 
                                                                      