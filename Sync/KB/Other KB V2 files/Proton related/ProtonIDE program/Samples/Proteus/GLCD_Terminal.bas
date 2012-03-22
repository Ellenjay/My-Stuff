' Simple Graphic LCD terminal emulator.
' Receives data at 9600 baud, and displays characters on a graphic LCD.

' Uses a software interrupt to flash the cursor, and display the characters

        Include "PROTON_G10.INT"
        
        Dim XPOS as Byte				' X position of cursor
        Dim YPOS as Byte				' Y position of cursor
        Dim Shadow_YPOS as Byte			' Previous Y position
        Dim Shadow_XPOS as Byte			' Previous X position
        Dim RCV  as Byte 				' Byte received from serial pin
        Dim PRINT_IT as Bit				' Signal to display a character
        Dim SET_CURSOR as Bit			' Signal to move cursor only
        Dim TIMESHARE as Word			' Flash rate variable
        Dim DATA_BYTE as Byte			' Used for scrolling the display UP a line
        
'---------------------------------------------------------------------               
        Delayms 500											' Wait for PICmicro to stabilise
        ALL_DIGITAL = true									' Set PORTA to all digital
        Cls													' Clear the LCD before we start
        Clear XPOS											' \
        Clear YPOS											'   Reset variables
        Clear TIMESHARE										' /

' Set TMR0 to interrupt
        OPTION_REG = %00000111
        INTCON = %00100000									' Attach interrupt to TMR0
        ON INTERRUPT Goto FLASH_CURSOR						' Point the interrupt to FLASH_CURSOR
        DISABLE
        Goto OVER_INTERRUPT									' Jump over the interrupt handler
        
'---------------------------------------------------------------------                       
' Interrupt handler to flash the cursor, and print to the LCD	
FLASH_CURSOR:
            If TIMESHARE = 256 Then Print at YPOS , XPOS ,_	' Is it time to flash the cursor ?
             FONT 0 , XOR 1 , INVERSE 1 , " " , XOR 0, INVERSE 0
            	
            If SET_CURSOR = 1 Then 
                Print at SHADOW_YPOS , SHADOW_XPOS , " " , at YPOS , XPOS                 
                SET_CURSOR = 0            
            Else If PRINT_IT = 1 Then
            	Print at YPOS , XPOS , RCV
                If XPOS < 20 Then Inc XPOS : Else : XPOS = 0 : Inc YPOS                                
                PRINT_IT = 0
            Endif
FINISH:
            Inc TIMESHARE
            If TIMESHARE = 512 then Clear TIMESHARE			' Ensure an even flash rate
        RESUME
        ENABLE

'----[SCROLL THE SCREEN UP ONE LINE]---------------------------------------------
SCROLL:
		DISABLE												' Disable interrupts while we scroll
        YPOS = 1											' Start at line 0
        Repeat
         	XPOS = 0										' and position 0 on the line
            Repeat    	
            	DATA_BYTE = LCDREAD YPOS, XPOS  			' Read from a line             
                LCDWRITE YPOS - 1 , XPOS , [DATA_BYTE]		' And write to the line above
            	Inc XPOS
            Until XPOS.7 = 1								' Until a count less than 127
        	Inc YPOS
        Until YPOS.3 = 1									' Until a count less than 8
        Print at 7,0,REP " "\21								' Blank the bottom line
        XPOS = 0
        YPOS = 7
        Return 
        ENABLE												' Enable interrupts for the main program loop
        
'----[MAIN PROGRAM LOOP STARTS HERE]----------------------------------------------
                
OVER_INTERRUPT:
		Print at 0,0,"Type some characters in"
		Print at 1,0,"  the serial terminal"               
        While 1 = 1											' Create an infinite loop
Receive:    RCV = HRSIN, {1,Receive} 						' Receive serial with timeout of 1ms       	
			SET_CURSOR = 0
            SHADOW_YPOS = YPOS
            SHADOW_XPOS = XPOS
            If RCV = 8 Then 								' Found Backspace ?
                If XPOS > 0 Then Dec XPOS
                SET_CURSOR = 1								' Signal we want to move the cursor only
                Goto Receive
           	Endif
            If RCV = 13 Then 								' Found Carriage Return ?
            	Inc YPOS
                XPOS = 0
                SET_CURSOR = 1								' Signal we want to move the cursor only
                If YPOS > 7 Then Gosub SCROLL
                Goto Receive
			Endif           
            If YPOS > 7 Then Gosub SCROLL
            PRINT_IT = 1									' Signal we want to print a character
        Wend   
                    
        Include "FONT.INC"
        
