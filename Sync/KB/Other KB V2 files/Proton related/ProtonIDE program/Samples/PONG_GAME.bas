' Game of PONG
' Written by Les Johnson September 2003 for the PROTON+ BASIC Compiler Version 2.1 onwards
'
' Uses a graphic LCD and two buttons for left and right
' Left button connects to PORTB.0
' Right button connects to PORTB.1
' Speaker connects to PORTB.2 for sound effects
'

		Include "PROTON_G4.INT"					' Use the PROTON Development board with 4MHz xtal

		Dim BAT_XPOS As Byte  					' Player's position (X)
		Dim BALLX As Word   					' Ball's X position
		Dim BALLY As Word						' Ball's Y position
		Dim DELTAX As Word  					' DELTAX and DELTAY
		Dim DELTAY As Word
		Dim ACCX As Byte    					' error accumulators for X & Y
		Dim ACCY As Byte
		Dim LASTX As Byte   					' Last ball position for erase
		Dim LASTY As Byte
		Dim SIGN As Word    					' Direction of delta
		Dim SCORE As Byte   					' Number of hits
		Dim LIVES As Byte    					' Number of lives left
        Dim HI_SCORE_XPOS as Byte				' X position of HI-SCORE entry

' High score variables
		Dim HISCORE As Byte
		Dim INITIAL1 As Byte
		Dim INITIAL2 As Byte
		Dim INITIAL3 As Byte
		Dim LETTER As Byte
        Dim L_BUT_TEMP as Byte
		Dim R_BUT_TEMP as Byte
        
        Symbol SPEAKER = PORTB.2				' Speaker connection
        Symbol LEFTKEY = PORTB.0				' Left button
		Symbol RIGHTKEY = PORTB.1				' Right button
        Symbol BOTTOM_OF_DISPLAY = 50			' The position that locates the bottom of the display
        Symbol RIGHT_OF_DISPLAY = 124			' The position that locates the right hand of the display
        Symbol BAT_LENGTH = 20					' Length of the bat
        Symbol BAT_YPOS = BOTTOM_OF_DISPLAY + 3	' Y position of bat
 
' Place hi-score data and initials in eeprom memory       
		EDATA	0,"AAA"
		
		Delayms 200								' Wait for PICmicro to stabilise
        PORTB_PULLUPS = ON						' enable pullup resistors for buttons
       	TRISB = %00000011						' Set button pins as inputs
		Goto MAIN_PROGRAM_LOOP					' Jump over the subroutines

'----[SUBROUTINES]--------------------------------------------
 
'----[WAIT FOR A KEY PRESS]-----------------------------------------------
KEYWAIT:
  		While LEFTKEY = 1 AND RIGHTKEY = 1: Wend		' Sense a keypress
        While LEFTKEY = 0 OR RIGHTKEY = 0: Wend			' Wait for it to be released
  		Return
        
'----[GET A LETTER ARCADE STYLE]------------------------------------------
GET_A_LETTER:
  		Print at 5,HI_SCORE_XPOS,LETTER 			
GET_LETTER_LOOP:
  		Delayms 5  										' Delay for button loop
  		Button LEFTKEY,0,100,50,L_BUT_TEMP,1,NEXT_LETTER
  		Button RIGHTKEY,0,255,0,R_BUT_TEMP,1,NEXT_POSITION
  		Goto GET_LETTER_LOOP
NEXT_LETTER:
  		Inc LETTER   					
  		If LETTER <> "!" Then							' A follows Space
            If LETTER > "Z" Then LETTER = " "			' Space follows Z
  		Else
  			LETTER = "A"
        Endif
  		Print at 5,HI_SCORE_XPOS,LETTER
  		Goto GET_LETTER_LOOP

NEXT_POSITION:
  		Inc HI_SCORE_XPOS
        Return
        
'----[GAME OVER]------------------------------------------------------------
GAME_OVER:
  		Cls
  		Sound SPEAKER,[80,10,70,20]
        Print at 2,0,"      GAME OVER",_
              at 4,0,"      YOU SCORED ",_
              at 5,9,Dec SCORE
  		HISCORE  =  Eread 0								' Read the saved hi-score
  		Gosub KEYWAIT									' Wait for a keypress
        Cls
  		If HISCORE < SCORE Then   						' New high score ?
  			Print at 3,0,"NEW HIGH SCORE!",_
              	  at 4,0,"<O> CHANGE <O> ACCEPT"
  			INITIAL1 = "A"
  			INITIAL2 = "A"
  			INITIAL3 = "A"
  			L_BUT_TEMP = 0
            R_BUT_TEMP = 0  									
	
        	LETTER = INITIAL1  							' Get Hiscore winner's name
  			Gosub GET_A_LETTER
  			INITIAL1 = LETTER
  			LETTER = INITIAL2
  			Gosub GET_A_LETTER
  			INITIAL2 = LETTER
  			LETTER = INITIAL3
  			Gosub GET_A_LETTER
  			INITIAL3 = LETTER
  			Ewrite 0,[SCORE,INITIAL1,INITIAL2,INITIAL3]	' Write high score info to eeprom
		Endif
' Display the high score
  		HISCORE = Eread 0
  		INITIAL1 = Eread 1
  		INITIAL2 = Eread 2
  		INITIAL3 = Eread 3
        Cls
  		Print At 3,0,"HIGH SCORE: ",Dec HISCORE,At 4,0," BY ",INITIAL1,INITIAL2,INITIAL3
  		Gosub KEYWAIT
  		Goto MAIN_PROGRAM_LOOP  						' Start the game again
               
'----[MOVE THE BAT RIGHT]----------------------------------------------------
RIGHTMOVE:
        If BAT_XPOS >= RIGHT_OF_DISPLAY - BAT_LENGTH Then Return
		Unplot BAT_YPOS , BAT_XPOS 
        Unplot BAT_YPOS + 1 , BAT_XPOS
		Plot BAT_YPOS , BAT_XPOS + BAT_LENGTH       
		Plot BAT_YPOS + 1 , BAT_XPOS + BAT_LENGTH 
		Inc BAT_XPOS
		Return

'----[MOVE THE BAT LEFT]-----------------------------------------------------
LEFTMOVE:
        If BAT_XPOS = 0 Then Return
		Unplot BAT_YPOS , BAT_XPOS + BAT_LENGTH
        Unplot BAT_YPOS + 1 , BAT_XPOS + BAT_LENGTH
		Plot BAT_YPOS, BAT_XPOS - 1
        Plot BAT_YPOS + 1 , BAT_XPOS - 1	 
		Dec BAT_XPOS
		Return

'----[DRAW THE BALL]---------------------------------------------------------
' The ball is made up of 9 pixels
DRAW_BALL:
  		Unplot LASTY , LASTX 			' Clear the old Ball      
        Unplot LASTY , LASTX + 1
        Unplot LASTY , LASTX + 2      
        Unplot LASTY + 1, LASTX
        Unplot LASTY + 1, LASTX + 1
        Unplot LASTY + 1, LASTX + 2
        Unplot LASTY + 2, LASTX
        Unplot LASTY + 2, LASTX + 1
        Unplot LASTY + 2, LASTX + 2

  		Plot BALLY , BALLX				' Draw the Ball
  		Plot BALLY , BALLX + 1			
        Plot BALLY , BALLX + 2        	
        Plot BALLY + 1, BALLX		
        Plot BALLY + 1, BALLX + 1			
        Plot BALLY + 1, BALLX + 2      
        Plot BALLY + 2, BALLX		
        Plot BALLY + 2, BALLX + 1			
        Plot BALLY + 2, BALLX + 2
        
        LASTX = BALLX									' Remember where the ball was
  		LASTY = BALLY
  		Return
        
'----[MOVE THE BALL]--------------------------------------------------------
MOVE_BALL:
  		WARNINGS = OFF									' Disable sign comparison warnings
        Inc ACCX
  		Inc ACCY
  		If ACCX = ABS DELTAX Then
  			SIGN = 1
  			If DELTAX < 0 Then SIGN = -1
			BALLX = BALLX + SIGN
  			BALLX = BALLX // RIGHT_OF_DISPLAY
            ACCX = 0
		Endif

  		If ACCY = ABS DELTAY Then 
  			SIGN = 1
  			If DELTAY < 0 Then SIGN = -1
            BALLY = BALLY + SIGN
            BALLY = BALLY // 64 
  			ACCY = 0
		Endif
        WARNINGS = ON									' Enable warnings again
        Return

'----[TEST FOR A HIT]---------------------------------------------------------
TEST_FOR_HIT:
 		If BALLY = 0 Then 							' Bounce off top ?
        	DELTAY = -DELTAY
            BALLY = 1
            ACCY = 0
            Sound SPEAKER,[95,1]
            Return
   		Endif   
' Did the bat hit the ball ?
 		If BALLY.Lowbyte = BOTTOM_OF_DISPLAY AND BALLX.Lowbyte >= BAT_XPOS AND BALLX.Lowbyte <= BAT_XPOS + BAT_LENGTH Then
        	DELTAY = -DELTAY 
			BALLY = BOTTOM_OF_DISPLAY - 1
 			Inc SCORE												' Bat hit it so count it
 			Sound SPEAKER,[90,1]									' Beep when ball hit
        	Print at 7,18,Dec SCORE									' Show score
        
        	Select BALLX.Lowbyte									' Detect where on the bat
        		Case BAT_XPOS to BAT_XPOS + 4						' the ball has hit
            		DELTAX = -1										' and alter direction accordingly
                	DELTAY = -2										' DELTAX is X direction. Negative being left
            	Case BAT_XPOS + 5 to BAT_XPOS + 9					' and positive being right
            		DELTAX = -2										' DELTAY is Y angle
                	DELTAY = -1    									'
            	Case BAT_XPOS + 10 to BAT_XPOS + 15					' This could be extended for more
            		DELTAX = 1										' areas on the bat
                	DELTAY = -2
            	Case Else
            		DELTAX = 2
                	DELTAY = -1
        	EndSelect
 			ACCY = 0
        Else														' Otherwise Bounce off sides or missed
        	Select BALLX.lowbyte
            	Case 1 to RIGHT_OF_DISPLAY - 2
            	If BALLY.Lowbyte <> BOTTOM_OF_DISPLAY Then Return	' Not close to BAT_XPOS yet
				Dec LIVES											' Remove a life
				If LIVES = 0 Then    								' End game?
 					Goto GAME_OVER
                Else
                	Print at 7,6,Dec LIVES
                    Sound SPEAKER,[95,10,100,20]
                    Delayms 30
                    BALLY = 0   									' Wrap around        
				Endif
            Case Else												' Bounce off sides by reflection
 				Sound SPEAKER,[100,1]
                DELTAX = -DELTAX
 				If BALLX.Lowbyte = 0 Then 
            		BALLX = 1
 				Else
            		BALLX = RIGHT_OF_DISPLAY - 2
            	Endif
 				ACCX = 0
 			End Select
        Endif
        Return
        
'----[MAIN PROGRAM LOOP STARTS HERE]-----------------------------------------
MAIN_PROGRAM_LOOP:
	
        Cls
        Print at 2,0,"        PONG       ",_
              at 3,0,"   BY LES JOHNSON",_
              at 5,0," PRESS A KEY TO START"
		Gosub KEYWAIT
        HI_SCORE_XPOS = 9
        SCORE = 0
		LIVES = 3
		Cls
		Print at 7,0,"LIVES 3",at 7,12,"SCORE 0"
        For BAT_XPOS = 54 To 53 + BAT_LENGTH		' Draw the initial bat shape
        	Plot BAT_YPOS , BAT_XPOS 
            Plot BAT_YPOS + 1 , BAT_XPOS 
		Next
		BAT_XPOS = 54  								' Set the initial position of the bat
		BALLX = (Random & 127)						' Set random ball drop position
  		BALLY = 1 
  		DELTAX = 1
  		DELTAY = 2
  		ACCX = 0
  		ACCY = 0
            
		While 1 = 1									' Create an infinite loop
			Delayms 15								' Adjust to speed game up or slow game down

			If LEFTKEY = 0 Then						' Move batleft 2 spaces this makes the bat move faster than the ball
        		Gosub LEFTMOVE
				Gosub LEFTMOVE
        	ElseIf RIGHTKEY = 0 Then				' Move bat right 2 spaces this makes bat move faster than the ball
        		Gosub RIGHTMOVE
				Gosub RIGHTMOVE
			Endif
            
            Gosub MOVE_BALL							' Actually move the ball's position
			Gosub DRAW_BALL							' Draw the ball
			Gosub TEST_FOR_HIT						' Check for a hit, bounce or miss
        Wend

'---[ADD THE GRAPHIC LCD FONT TABLE]-----------------------------------------       
  		Include "FONT.INC"
        
        