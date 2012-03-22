
'================Subroutine to get a key from keypad===========================
Getkey:			 
        		 Delayms 50                				' Debounce


Getkeyu:         ' Wait for all keys up      		 					
			 	 PORTB = 0               				' All output pins low
        		 TRISB = $F0  '1111 binary           	' Bottom 4 pins out, top 4 pins in
        		 If (PORTB >> 4) <> $0F Then Getkeyu    ' If any keys down, loop
				 Delayms 50                				' Debounce


Getkeyp:         ' Wait for keypress
				 For Col = 0 to 3        				' 4 columns in keypad
                 	 PORTB = 0       					' All output pins low
                	 TRISB = (Dcd Col) ^ $FF 			' Set one column pin to output
                	 Row = PORTB >> 4        			' Read row
                	 If Row <> $0F Then Gotkey        	' If any keydown, exit
        		Next
        		Goto Getkeyp            				' No keys down, go look again

Gotkey: 		' Change row and column to key number 1 - 16
				Key = (Col * 4) + (Ncd (Row ^ $0F))	  	' Ncd is Priority encoder of a 16-bit value
        		Select Key
					   Case 4
					   Key = "U"  'Up
					   Case 5
					   Key = 4
					   Case 6
					   Key = 5
					   Case 7
					   Key = 6
					   Case 8
					   Key = "D" 'Down
					   Case 9
					   Key = 7
					   Case 10
					   Key = 8
					   Case 11
					   Key = 9
					   Case 12
					   Key = "N" '2nd
					   Case 13
					   Key = "C" 'Clear
					   Case 14 
					   Key = 0 
					   Case 15
					   Key = "H" 'Help
					   Case 16
					   Key = "E" 'Enter
					  EndSelect 
Return                  				
'..................GetKey Subroutine over.....................................
