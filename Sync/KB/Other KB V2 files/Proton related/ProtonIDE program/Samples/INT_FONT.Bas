
' Display 3 internally held fonts

		'Include "PROTON18_G4.INT"				' Unremark for use with 16-bit core device
        Include "PROTON_G4.INT"
       
        Delayms 500								' Wait for PICmicro to stabilise
        Cls										' Clear the LCD

        Print at 0,0,FONT 0 , "FONT 0"

        Print at 2,0,FONT 1 , "FONT 1"

        Print at 4,0,FONT 2 , "FONT 2"        
        
        Stop

' Include the 3-FONT table
		Include "FONT3.INC"						' Load the font data into memory
       
                  
