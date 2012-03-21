' Fill a graphic LCD with random data
' Shows the use of SEED, and RANDOM

		Include "PROTON_G4.INT"

		DIM XPOS as BYTE
        DIM YPOS as BYTE
        DIM TEMP as BYTE
        DIM LOOP as BYTE
        
        Delayms 500
        Seed $0345
AGAIN:
        Cls										' Clear the LCD
        For LOOP = 0 to 20 						' Main loop              
        	For YPOS = 0 to 63					' YPOS loop
				For TEMP = 0 to 37				' XPOS loop
            		XPOS = ((Random / 2) & 127) ' Make sure XPOS is not greater than 127
        			PLOT YPOS,XPOS				' Set a pixel
                Next
            Next
        Next
        Cls
        Goto AGAIN
        
        
