' Draw two eyes on a graphic LCD
' and move the pupils

		Include "PROTON_G4.EXT"
        
        Dim YPOS as Byte
        Dim XPOS as Byte
        Dim TEMP_XPOS as Byte
        Dim RADIUS as Byte
        Dim ON_OFF as Bit
        
        Delayms 500								' Wait for PICmicro to stabilise
        Cls										' Clear the LCD
        Circle 1,30,30,25						' Draw the left eyeball
        Circle 1,90,30,25						' Draw the right eyeball      
       	Goto OVER_SUBS

'-------------------------------------------------------
' Draw or erase the pupils of the eyes
' Variable ON_OFF determines if teh pupils are erased or set        
DRAW_EYEBALLS:        
        TEMP_XPOS = XPOS    
        RADIUS = 1
        Repeat     	
            Circle ON_OFF,TEMP_XPOS,YPOS,RADIUS	' Draw the first pupil
            Inc RADIUS
        Until RADIUS > 5
    
        TEMP_XPOS = TEMP_XPOS + 60				' Move 60 pixels right
        RADIUS = 1
        Repeat     	      	
            Circle ON_OFF,TEMP_XPOS,YPOS,RADIUS	' Draw another pupil
            Inc RADIUS
        Until RADIUS > 5
		Return
'------------------------------------------------------
' Main program loop starts here        
OVER_SUBS:
		While 1 = 1								' Create an infinite loop
        XPOS = 17  								' Initial XPOS     
        YPOS = 18								' Initial YPOS
        Repeat  								' Move the pupils down and right
            Inc XPOS
            ON_OFF = 1 : Gosub DRAW_EYEBALLS
        	Delayms 80
        	ON_OFF = 0 : Gosub DRAW_EYEBALLS           
        	YPOS = YPOS + 2
        Until YPOS > 42
        
        Repeat									' Move the pupils up
            ON_OFF = 1 : Gosub DRAW_EYEBALLS
        	Delayms 60
        	ON_OFF = 0 : Gosub DRAW_EYEBALLS           
        	YPOS = YPOS - 2
        Until YPOS < 18
        
        Repeat									' Move the pupils left
        	ON_OFF = 1 : Gosub DRAW_EYEBALLS
        	Delayms 70
        	ON_OFF = 0 : Gosub DRAW_EYEBALLS
            XPOS = XPOS - 2
        Until XPOS < 17	
        Wend
        Stop
        