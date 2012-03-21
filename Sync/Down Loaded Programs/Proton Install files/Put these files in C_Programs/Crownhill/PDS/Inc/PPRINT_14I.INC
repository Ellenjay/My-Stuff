   

 LIST
    #define P@INVERSE       _GLCD_FLAG,0        ; Set when an invert print is required  
    #define P@XOR           _GLCD_FLAG,1        ; Set when an XOR print is required
    #define P@OR            _GLCD_FLAG,2        ; Set when an OR print is required
    #define PYLINE2@REQ 	_GLCD_FLAG,3        ; Flag to indicate second line is required
    #define PYLINE3@REQ 	_GLCD_FLAG,4        ; Flag to indicate third line is required
    #define PYLINE4@REQ     _GLCD_FLAG,5        ; Flag to indicate forth line is required
    #define TWO_BYTE@FONT   _GLCD_FLAG,6        ; Flag to indicate font is 2 bytes tall
    #define THREE_BYTE@FONT _GLCD_FLAG,7        ; Flag to indicate font is 3 bytes tall 
 NOLIST    
     
 	if((EEADR >> 8) != 0x01)					; Make sure the BANK arrangement is correct
 		LIST
 		error "This PICmicro is not suitable for PPRINT because the eeprom banks are different"
 	NOLIST
 	endif
 	LIST

 NOLIST		  	   
; Requires the Character to be displayed in WREG
 LIST
    	Movlw  	255
    	Movwf	_GLCD_YPOS#TEMP              	; Force a re calc
    	set@page over@ext@pprint
    	Goto	over@ext@pprint  			    ; Jump over the PPRINT subroutines, because we are in the line of the program      
 NOLIST
;-----[READ FROM MEMORY A BYTE OF DATA]-------------------------        
; Enter here to perform a pre-inc read
LIST 
c@readpdata    
    	Bsf 	STATUS,RP1                          ; BANK 2
    	Incf 	EEADR,F                             ; Increment the address
    	Skpnz
    	Incf 	EEADRH,F
NOLIST
; Enter here to perform a normal read EEADR/EEADRH has to be pre-loaded
LIST
c@readpdata2
    	Bsf 	STATUS,RP0                           
    	Bsf 	STATUS,RP1                          ; BANK 3 
    	Bsf 	EECON1,EEPGD                        ; Instigate the read
    	Bsf 	EECON1,RD
    	Goto	$ + 1								; Waste 2 cycles
    	Bcf 	STATUS,RP0							; Back down to BANK 2
    	Movf 	EEDATA,W                              ; Get the low data into wreg
   		NOLIST
    	if($ > 2047)
    	LIST
    		set@page I@nt
    	NOLIST
    	endif
    	LIST
    	Goto	I@nt
NOLIST 
;----[Restore the WREG and exit routine]----------------------------------------------------
LIST
PPRINT@EXIT
    	Movf	PP3,W								    ; Restore WREG
    	NOLIST
    	if($ > 2047)
    	LIST
    		set@page I@nt
    	NOLIST
    	endif
    	LIST
    	Goto	I@nt							    ; Exit the routine 
NOLIST    	
;----[PUT THE DATA CONTAINED IN _PCHAR#DATA ON THE LCD AND RETURN]-----
LIST
PPRINT@IT                                            
    	Movf	_GLCD_XPOS,W						
    	Movwf	GENH
    	Movf	_PCHAR#DATA,W
    	NOLIST
    	if($ > 2047)
    	LIST
    		set@page GLCD@P
    	NOLIST
    	endif
    	LIST
    	Goto 	GLCD@P								; Return via GLCD@P
NOLIST    								    
;----[ROUTINE TO PUT THE DATA ON THE SCREEN]--------------------    
LIST	
PPRINT@DAT:      
    
    	Movwf	PP6H
    	NOLIST
    	if($ > 2047)
    	LIST
    		set@page PPRINT@EXIT
    	NOLIST
    	endif
    	LIST
    	Btfsc 	GEN,3                               ; Are we within screen area?
    	Goto 	PPRINT@EXIT
    	Btfsc 	_GLCD_XPOS,7
    	Goto 	PPRINT@EXIT                         ; No     
    						 	      
    	Movf	PP7,W									; Save contents of PP7, because of interference with Display float
    	Movwf	_PPRINT#TEMP3
    	Movf	_GLCD_XPOS,W
    	NOLIST
    	if($ > 2047)
    	LIST
    		set@page GLCD@G
    	NOLIST
    	endif
    	LIST
    	Call	GLCD@G							    ; Read data from the LCD into PP5
    	Movwf	PP5
    	Movf	_PPRINT#TEMP3,W						; Restore contents of PP7
        Movwf	PP7
            
    	set@page PPRINT@DAT_L1
    	Btfss 	P@OR                           	    ; "OR" Required?
    	Goto   	PPRINT@DAT_L1
    	Iorwf 	_PCHAR#DATA,F
    	NOLIST
    	if($ > 2047)
    	LIST
    		set@page PPRINT@IT
    	NOLIST
    	endif
    	LIST
    	Goto   	PPRINT@IT
    	
PPRINT@DAT_L1     
    	set@page PPRINT@DAT_L2
    	Btfss 	P@XOR                               ; "XOR" Required?
    	Goto   	PPRINT@DAT_L2	
    	Xorwf 	_PCHAR#DATA,F
    	NOLIST
    	if($ > 2047)
    	LIST
    		set@page PPRINT@IT
    	NOLIST
    	endif
    	LIST
    	Goto   	PPRINT@IT
    	
PPRINT@DAT_L2   
    ; Masking Required
    	Movf 	PP6H,W
    	Andwf 	PP5,F
   	 	Movf 	PP5,W
    	Iorwf 	_PCHAR#DATA,F                           
		NOLIST
    	if($ > 2047)
    	LIST
			set@page PPRINT@IT
		NOLIST
    	endif
    	LIST
		Goto	PPRINT@IT
NOLIST    	  	    	
;----[START OF PPRINT SUBROUTINE]-----------------------------------------------------------    	
LIST
PRINT
    	Movwf 	_PCHAR#DATA                      
    	Movwf	PP3								    ; Save contents of WREG	
    NOLIST
    ifndef LCD#IS#SETUP
    	NOLIST
    	if($ > 2047)
    	LIST
    		set@page setup@lcd
    	NOLIST
    	endif
    	LIST
    	Call	setup@lcd						    ; Setup the LCD if it hasn't been setup already    	
    NOLIST
    endif
    LIST
    	Movlw 	32
    	Subwf 	_PCHAR#DATA,F					    ; Subtract the ASCII offset for the FONT table						 
NOLIST    
; Calculate if we require the new PFONT shift values and how many lines to print
LIST
    	Movf  	_GLCD_YPOS,W                         	; Have we calculated the info for this line already? 
    	Subwf   _GLCD_YPOS#TEMP,W
    	set@page OVER@PRINT_CALC
    	Btfsc   STATUS,Z
    	Goto   	OVER@PRINT_CALC                 	; Yes so just print
    
    	Movlw  	7                              	    ; Work out how much to shift data
    	Andwf  	_GLCD_YPOS,W
    	Movwf  	_PSHIFT#LEFT
    
   		Movf  	_PSHIFT#LEFT,W                    	; Calc the lines to print
    	Addwf  	_PFONT#HT,W
    	Movwf  	PP5
              
   	 	Movf	_GLCD_FLAG,W					        ; Clear the control flags
    	Andlw	B'00000111'						    ; But leave the modifier flags alone
    	Movwf	_GLCD_FLAG
    
    	Movlw  	9
    	Subwf   _PFONT#HT,W                       	; Is this > 8 pixels high
    	Btfsc   STATUS,C        
    	Bsf    	TWO_BYTE@FONT                  	    ; Yes
     
    	Movlw  	17                             	    ; Is this > 16 pixels high
    	Subwf   _PFONT#HT,W
    	Btfsc   STATUS,C
    	Bsf    	THREE_BYTE@FONT                	    ; Yes
    
    	Movlw  	9                              	    ; 2 Lines to be printed?
    	Subwf 	PP5,W
    	Btfsc   STATUS,C    
    	Bsf    	PYLINE2@REQ                    	    ; Yes
    
    	Movlw  	17                             	    ; 3 Lines to be printed?
    	Subwf 	PP5,W
    	Btfsc   STATUS,C
    	Bsf    	PYLINE3@REQ                    	    ; Yes
    
    	Movlw  	25                             	    ; 4 Lines to be printed?
    	Subwf 	PP5,W
    	Btfsc   STATUS,C
    	Bsf    	PYLINE4@REQ                    	    ; Yes
    
    	Movf   _PFONT#HT,W                      	    ; Work out no rotates for masks
    	Sublw   32
    	Movwf   _PPRINT#TEMP2
    	Movlw   255
    	Movwf   _OVERWRITE#MASK                 	; _OVERWRITE#MASK = $FFFFFFFF
    	Movwf   _OVERWRITE#MASKH
    	Movwf   _OVERWRITE#MASKHH
    	Movwf   _OVERWRITE#MASKHHH   
    	Incf   	_PPRINT#TEMP2,F
    	
RR_LOOP@L1                                     	    ; Rotate mask first right
    	Decf   	_PPRINT#TEMP2,F
    	set@page RREXIT@L1
    	Btfsc   STATUS,Z     	
    	Goto    RREXIT@L1
    	Clrc
    	Rrf   	_OVERWRITE#MASKHHH,F
    	Rrf   	_OVERWRITE#MASKHH,F
    	Rrf   	_OVERWRITE#MASKH,F
    	Rrf   	_OVERWRITE#MASK,F
    	NOLIST
    	if($ > 2047)
    	LIST
    		set@page RR_LOOP@L1
    	NOLIST
    	endif
    	LIST
    	Goto    RR_LOOP@L1
    
RREXIT@L1
    	Movf  	_PSHIFT#LEFT,W
    	Movwf	_PPRINT#TEMP2
    	Incf   	_PPRINT#TEMP2,F                	    ; Then left
RL_LOOP@L1
    	Decf   	_PPRINT#TEMP2,F
    	set@page RLEXIT@L1
    	Btfsc   STATUS,Z
    	Goto    RLEXIT@L1
    	Clrc
    	Rlf   	_OVERWRITE#MASK,F
    	Rlf   	_OVERWRITE#MASKH,F
    	Rlf   	_OVERWRITE#MASKHH,F     
    	Rlf   	_OVERWRITE#MASKHHH,F         
    	NOLIST
    	if($ > 2047)
    	LIST
    		set@page RL_LOOP@L1
    	NOLIST
    	endif
    	LIST
    	Goto   	RL_LOOP@L1
    
RLEXIT@L1
    	Comf   	_OVERWRITE#MASK,F                    ; LASTLY INVERT
    	Comf   	_OVERWRITE#MASKH,F
    	Comf   	_OVERWRITE#MASKHH,F
    	Comf   	_OVERWRITE#MASKHHH,F
        
    	Movf  	_GLCD_YPOS,W 
    	Movwf   _GLCD_YPOS#TEMP                      ; Make note for next time
    
OVER@PRINT_CALC
 NOLIST    
; Start of print routine    
;---- Look up the address for the char no in pchar ----------
 LIST    
    	Movf	_PFONT_TBL#ADDRS,W
    	Bsf		STATUS,RP1								; Point to BANK 2
    	Movwf	EEADR             						; Load the Base Font address into the eread address regs
    	Bcf		STATUS,RP1								; Back to BANK0
    	Movf 	_PFONT_TBL#ADDRSH,W
    	Bsf		STATUS,RP1								; Point to BANK 2
    	Movwf	EEADRH
		
		Bcf		STATUS,RP1								; Back to BANK0
    	Movf 	_PCHAR#DATA,W                            ; TAKE the char_no
    	Bsf 	STATUS,RP1                               ; 
    	Addwf 	EEADR,F                                ; add that to the address held in the eread address regs 
    	Skpnc
    	Incf 	EEADRH,F                                ; NOW POINT TO THE ADDRESS OF THE FONT CHAR
    	NOLIST
    	if($ > 2047)
    	LIST
    		set@page c@readpdata2
    	NOLIST
    	endif
    	LIST
    	Call  	c@readpdata2                           
    	Bsf		STATUS,RP1								; Back up to BANK 2
    	Movwf 	EEADR                              
    	Movf 	EEDATH,W
    	Movwf	EEADRH
    	Call  	c@readpdata2                           ; Read in how many bytes per line make up the char
    	Movwf	PP6                        		; AND SAVE
NOLIST
; Main subroutine loop
LIST    
MAIN_PPRINT@LOOP                             			; Loop for as many times as there are x pixels in font
NOLIST    
; Get the bytes that make up char
LIST    
    	Clrf   	_PCHAR#DATAHHH                       ; Always clear these vars
    	Clrf   	_PCHAR#DATAHH
    	Clrf   	_PCHAR#DATAH
    	Clrf   	_PCHAR#DATA
        NOLIST
    	if($ > 2047)
    	LIST       
    		set@page c@readpdata
    	NOLIST
    	endif
    	LIST
    	Call  	c@readpdata 				         ; Get the lower byte
    	Movwf   _PCHAR#DATA				             ; Load first line
    
    
    	set@page PRINT_LOOP@L1
    	Btfss  	TWO_BYTE@FONT                        ; If font > 8 pixels load 2nd byte
    	Goto    PRINT_LOOP@L1
    	NOLIST
    	if($ > 2047)
    	LIST
    		set@page c@readpdata
    	NOLIST
    	endif
    	LIST
    	Call  	c@readpdata	
    	Movwf   _PCHAR#DATAH			             ; Load second line
    
PRINT_LOOP@L1
    	set@page PRINT_LOOP@L2
    	Btfss  	THREE_BYTE@FONT                      ; If font > 16 pixels load 3rd byte
    	Goto   	PRINT_LOOP@L2
    	NOLIST
    	if($ > 2047)
    	LIST
    		set@page c@readpdata
    	NOLIST
    	endif
    	LIST
    	Call  	c@readpdata
    	Movwf   _PCHAR#DATAHH		                 ; Load third line
    
PRINT_LOOP@L2
; Shift the data into place
    
    	Movf  	_PSHIFT#LEFT,W
    	Movwf	_PPRINT#TEMP2       				; We need to shift the data into the correct place
    
    	Incf   	_PPRINT#TEMP2,F
RL_LOOP@L2
    	set@page RLEXIT@L2
    	Decf   	_PPRINT#TEMP2,F
    	Btfsc  	STATUS,Z  
    	Goto   	RLEXIT@L2
    	Clrc
    	Rlf   	_PCHAR#DATA,F
    	Rlf   	_PCHAR#DATAH,F
    	Rlf   	_PCHAR#DATAHH,F
    	Rlf   	_PCHAR#DATAHHH,F
    	NOLIST
    	if($ > 2047)
    	LIST
    		set@page RL_LOOP@L2
    	NOLIST
    	endif
    	LIST
    	Goto    RL_LOOP@L2
    	Movf  	_PSHIFT#LEFT,W
    	Incf   	_PPRINT#TEMP2,F
    	NOLIST
    	if($ > 2047)
    	LIST
    		set@page RL_LOOP@L2
    	NOLIST
    	endif
    	LIST
    	Goto    RL_LOOP@L2
    
RLEXIT@L2  
    	Btfss  	P@INVERSE                             ; If invert required make mask and xor with data
    	Goto    PRINT_LOOP@L3
    	Comf   	_OVERWRITE#MASK,W
    	Xorwf  	_PCHAR#DATA,F
    	Comf   	_OVERWRITE#MASKH,W
    	Xorwf  	_PCHAR#DATAH,F
    	Comf   	_OVERWRITE#MASKHH,W
    	Xorwf  	_PCHAR#DATAHH,F
    	Comf   	_OVERWRITE#MASKHHH,W
   	 	Xorwf  	_PCHAR#DATAHHH,F        
    
PRINT_LOOP@L3
    	Clrc                                         ; Work out the lcdwrite line to start printing
    	Rrf    	_GLCD_YPOS,W
   	 	Movwf  	GEN
    	Clrc
    	Rrf    	GEN,F
    	Clrc
    	Rrf    	GEN,F
             
    	Movf  	_OVERWRITE#MASK,W
    	NOLIST
    	if($ > 2047)
    	LIST
    		set@page PPRINT@DAT
    	NOLIST
    	endif
    	LIST
    	Call    PPRINT@DAT
    
    	set@page PRINT_LOOP@L4
    	Btfss  	PYLINE2@REQ                         ; Do we need to print to the next line?
    	Goto    PRINT_LOOP@L4
    	Incf   	GEN,F                               ; Yes so move down a line
    	Movf	_PCHAR#DATAH,W
    	Movwf	_PCHAR#DATA        					; Get the data to print
    	Movf	_OVERWRITE#MASKH,W
    	NOLIST
    	if($ > 2047)
    	LIST
    		set@page PPRINT@DAT
    	NOLIST
    	endif
    	LIST
    	Call  	PPRINT@DAT                       	; Put the data down
    
PRINT_LOOP@L4       
    	set@page PRINT_LOOP@L5
    	Btfss  	PYLINE3@REQ                         ; Do we need to print to the next line?
    	Goto    PRINT_LOOP@L5
    	Incf    GEN,F                               ; Yes so move down a line
    	Movf  	_PCHAR#DATAHH,W
    	Movwf	_PCHAR#DATA      					; Get the data to print
    	Movf	_OVERWRITE#MASKHH,W
    	NOLIST
    	if($ > 2047)
    	LIST
    		set@page PPRINT@DAT
    	NOLIST
    	endif
    	LIST
    	Call   PPRINT@DAT                          	; Put the data down
    
PRINT_LOOP@L5
    	set@page PRINT_LOOP@L6
    	Btfss  	PYLINE4@REQ                         ; Do we need to print to the next line?
    	Goto    PRINT_LOOP@L6
    	Incf    GEN,F                               ; Yes so move down a line
    	Movf	_PCHAR#DATAHHH,W
    	Movwf 	_PCHAR#DATA     					; Get the data to print
    	Movf	_OVERWRITE#MASKHHH,W
   	 	NOLIST
    	if($ > 2047)
    	LIST
   	 		set@page PPRINT@DAT
   	 	NOLIST
    	endif
    	LIST
   	 	Call   	PPRINT@DAT                           ; Put the data down
    
PRINT_LOOP@L6
    	Incf    _GLCD_XPOS,F                        ; Move to the next X pixel
    	NOLIST
    	if($ > 2047)
    	LIST
    		set@page MAIN_PPRINT@LOOP
    	NOLIST
    	endif
    	LIST
    	Decfsz	PP6,F
    	Goto	MAIN_PPRINT@LOOP                    ; Loop until all X pixels printed   

		NOLIST
    	if($ > 2047)
    	LIST
			set@page PPRINT@EXIT
		NOLIST
    	endif
    	LIST
		Goto PPRINT@EXIT 
 NOLIST          
;-----[READ THE FONT HEIGHT]------------------------------------
 LIST    
SET@FONT
    	Movf 	_PFONT_TBL#ADDRS,W
    	Bsf		STATUS,RP1							; Point to BANK 2
    	Movwf	EEADR            					; Load the address in
    	Bcf		STATUS,RP1							; Point back to BANK 0
    	Movf 	_PFONT_TBL#ADDRSH,W
    	Bsf		STATUS,RP1							; Point to BANK 2
    	Movwf	EEADRH 
    	set@page c@readpdata2
    	Call   	c@readpdata2                        ; Read the font height
    	Movwf  	_PFONT#HT                           ; And save it
    	Incf 	_PFONT_TBL#ADDRS,F                  ; Up the address 2
    	Skpnz
    	Incf 	_PFONT_TBL#ADDRSH,F    
    	Movlw  	255
    	Movwf	_GLCD_YPOS#TEMP               		; Force a re calc
		NOLIST
    	if($ > 2047)
    	LIST
    		set@page I@nt
    	NOLIST
    	endif
    	LIST
    	Goto 	I@nt
   
over@ext@pprint
 LIST    
 