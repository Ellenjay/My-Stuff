
 LIST
    	#define P_INVERSE       _GLCD_FLAG,0        ; Set when an invert print is required  
    	#define P_XOR           _GLCD_FLAG,1        ; Set when an XOR print is required
    	#define P_OR            _GLCD_FLAG,2        ; Set when an OR print is required
        #define PYLINE2_REQ 	_GLCD_FLAG,3        ; Flag to indicate second line is required
    	#define PYLINE3_REQ 	_GLCD_FLAG,4        ; Flag to indicate third line is required
    	#define PYLINE4_REQ     _GLCD_FLAG,5        ; Flag to indicate forth line is required
    	#define TWO_Byte_FONT   _GLCD_FLAG,6        ; Flag to indicate font is 2 bytes tall
    	#define THREE_Byte_FONT _GLCD_FLAG,7        ; Flag to indicate font is 3 bytes tall 
           
    	#define PPRINT_TEMP 	PP5                 ; Temp var using pic variables
        #define MASK_TEMP       PP6H                ; Temp var using pic variables 
        #define PPRINT_TEMP2    PRODL          		; Temp var  
    	#define PFONT_BYTES     PP6                 ; Number of x pixels that makes up font length                
 NOLIST
;----[** START OF P_PRINT SUBROUTINE **]-----------------------------------------------------------
; Requires the Character to be displayed in WREG
 LIST													     
PRINT
     	Movwf 	_PCHAR#DATA                      
        Movwf	PP3								    ; Save contents of the WREG	
     ifndef LCD#IS#SETUP
     	Call	setup@lcd						    ; Setup the LCD if it hasn't been setup already
     endif
     	Movff   TBLPTRL, _PPRINT#TEMP2              ; \ >>> Save TBLPTRL/H
     	Movff   TBLPTRH, _PPRINT#TEMP3              ; /
        Movlw 	32
     	Subwf 	_PCHAR#DATA,F					    ; Subtract the ASCII offset for the FONT table						 
 NOLIST
; Calculate if we require the new PFONT shift values and how many lines to print
 LIST
		Movf  	_GLCD_YPOS,W                         	; Have we calculated the info for this line already? 
		Cpfseq 	_GLCD_YPOS#TEMP
		Bra    	P@STRT                        	    ; No so do the calcs
		Bra   	OVER@PRINT_CALC                 	; Yes so just print
P@STRT
		Movlw  	7                              	    ; Calculate how much to shift data
		Andwf  	_GLCD_YPOS,W
		Movwf  	_PSHIFT#LEFT
  
		Addwf  	_PFONT#HT,W							; Calculate the lines to print
		Movwf  	PPRINT_TEMP
                  
		Movf	_GLCD_FLAG,W					        ; Clear the control flags
        Andlw	B'00000111'						    ; But leave the modifier flags alone
        Movwf	_GLCD_FLAG
        
		Movlw  	8
		Cpfsgt 	_PFONT#HT                       	; Is this > 8 pixels high
		Bra    	IFTHENEXIT@L2
		Bsf    	TWO_BYTE_FONT                  	    ; Yes
    
IFTHENEXIT@L1 
		Movlw  	16                             	    ; Is this > 16 pixels high
		Cpfsgt 	_PFONT#HT
		Bra    	IFTHENEXIT@L2
		Bsf    	THREE_BYTE_FONT                	    ; Yes
    
IFTHENEXIT@L2 
		Movlw  	8                              	    ; 2 Lines to be printed?
		Cpfsgt 	PPRINT_TEMP
		Bra    	IFTHENEXIT@L5
		Bsf    	PYLINE2_REQ                    	    ; Yes
    
IFTHENEXIT@L3  
		Movlw  	16                             	    ; 3 Lines to be printed?
		Cpfsgt 	PPRINT_TEMP
		Bra    	IFTHENEXIT@L5
		Bsf    	PYLINE3_REQ                    	    ; Yes
    
IFTHENEXIT@L4
		Movlw  	24                             	    ; 4 Lines to be printed?
		Cpfsgt 	PPRINT_TEMP
		Bra    	IFTHENEXIT@L5
		Bsf    	PYLINE4_REQ                    	    ; Yes

IFTHENEXIT@L5
		Movf    _PFONT#HT,W                      	; Work out no rotates for masks
		Sublw    32
		Setf   	_OVERWRITE#MASK                 	
		Setf   	_OVERWRITE#MASKH
		Setf   	_OVERWRITE#MASKHH
		Setf   	_OVERWRITE#MASKHHH

    	Incf   	WREG,F
RR_LOOP@L1                                     	    ; Rotate mask first right
		Decf   	WREG,F
		Bz     	RREXIT@L1
		Clrc
		Rrcf   	_OVERWRITE#MASKHHH,F
		Rrcf   	_OVERWRITE#MASKHH,F
		Rrcf   	_OVERWRITE#MASKH,F
		Rrcf   	_OVERWRITE#MASK,F
		Bra    	RR_LOOP@L1
    
RREXIT@L1
    	Movf  	_PSHIFT#LEFT,W
		Incf   	WREG,F                         	    ; Then left
RL_LOOP@L1
		Decf   	WREG,F
		Bz    	RLEXIT@L1
		Clrc
		Rlcf   	_OVERWRITE#MASK,F
		Rlcf   	_OVERWRITE#MASKH,F
		Rlcf   	_OVERWRITE#MASKHH,F     
		Rlcf   	_OVERWRITE#MASKHHH,F         
        Bra    	RL_LOOP@L1

RLEXIT@L1
		Comf   	_OVERWRITE#MASK,F                   ; Lastly Invert
		Comf   	_OVERWRITE#MASKH,F
		Comf   	_OVERWRITE#MASKHH,F
		Comf   	_OVERWRITE#MASKHHH,F
            
    	Movff  	_GLCD_YPOS, _GLCD_YPOS#TEMP         ; Make note for next time
OVER@PRINT_CALC
 NOLIST
; Start of print routine
; Look up the address for the char number in pchar
 LIST
    	Clrf	TBLPTRU
    	Movf   _PCHAR#DATA,W                         ; Multiplier to get word address
    	Mullw   2                          		    ; Do the sums
    	Movff   _PFONT_TBL#ADDRS,TBLPTRL            ; Get the font address and save it to the table pointers
    	Movff   _PFONT_TBL#ADDRSH,TBLPTRH                   
    	Movf   PRODL,W                          	    ; Now add the font address (in the table pointers) to the result of the first sum
    	Addwf   TBLPTRL,F                                          
    	Movf   PRODH,W
    	Addwfc  TBLPTRH,F                      	    ; That done table pointers holds the address in table to look for pchar address    	
    	Bsf	    EECON1,EEPGD                        ; Set up for a read operation
    	Tblrd*+                                     ; Read the font address
    	Movf   TABLAT,W                              ; Store low byte of address in WREG for now 					
    	Tblrd*
    	Movff	TABLAT, TBLPTRH                     ; Place high byte of address into TBLPTRH	
    	Movwf  	TBLPTRL                             ; Now place the low byte (stored in WREG) into TBLPTRL   
    	Tblrd*+
    	Movff  	TABLAT,PFONT_BYTES                  ; Find out how many bytes per line make up char
     
; Main subroutine loop
MAIN_PPRINT@LOOP                                    ; Loop for as many times as there are x pixels in font
; Get the bytes that make up char
        
    	Clrf   	_PCHAR#DATAHHH                      ; Always clear these vars
		Clrf   	_PCHAR#DATAHH
		Clrf   	_PCHAR#DATAH
		Clrf   	_PCHAR#DATA
                   
    	Tblrd*+									    ; Get the lower byte
    	Movff  	TABLAT, _PCHAR#DATA				    ; Load first line

    	Btfss  	TWO_BYTE_FONT                       ; If font > 8 pixels load 2nd byte
    	Bra    	PRINT_LOOP@L1
    	Tblrd*+
    	Movff  	TABLAT, _PCHAR#DATAH				; Load second line

PRINT_LOOP@L1
    	Btfss  	THREE_BYTE_FONT                     ; If font > 16 pixels load 3rd byte
    	Bra    	PRINT_LOOP@L2
    	Tblrd*+
    	Movff  	TABLAT, _PCHAR#DATAHH			    ; Load third line

PRINT_LOOP@L2
; Shift the data into place

    	Movf  _PSHIFT#LEFT,W                         ; We need to shift the data into the correct place
		Incf   WREG,F
RL_LOOP@L2
		Decf   WREG,F
		Bz     RLEXIT@L2
		Bcf    STATUS,C
		Rlcf   _PCHAR#DATA,F
		Rlcf   _PCHAR#DATAH,F
		Rlcf   _PCHAR#DATAHH,F
		Rlcf   _PCHAR#DATAHHH,F
		Bra    RL_LOOP@L2
   	 	Movf  _PSHIFT#LEFT,W
		Incf   WREG,F
    	Bra    RL_LOOP@L2    
RLEXIT@L2  
    	Btfss  P_INVERSE                            ; If invert required make mask and xor with data
    	Bra    PRINT_LOOP@L3
    	Comf   _OVERWRITE#MASK,W
    	Xorwf  _PCHAR#DATA,F
    	Comf   _OVERWRITE#MASKH,W
    	Xorwf  _PCHAR#DATAH,F
    	Comf   _OVERWRITE#MASKHH,W
    	Xorwf  _PCHAR#DATAHH,F
    	Comf   _OVERWRITE#MASKHHH,W
    	Xorwf  _PCHAR#DATAHHH,F        
PRINT_LOOP@L3
		Clrc                                        ; Calculate the lcdwrite line to start printing
		Rrcf    	_GLCD_YPOS,W
		Movwf  	GEN
		Clrc
		Rrcf    	GEN,F
		Clrc
		Rrcf    	GEN,F
                
		Movf  	_OVERWRITE#MASK,W						; Print the first line
		RCall   PPRINT@DAT
        
    	Btfss  	PYLINE2_REQ                         ; Do we need to print to the next line?
    	Bra    	PRINT_LOOP@L4
    	Incf   	GEN,F                               ; Yes so move down a line
    	Movff  	_PCHAR#DATAH, _PCHAR#DATA           ; Get the data to print
    	Movf  	_OVERWRITE#MASKH,W
    	RCall  	PPRINT@DAT                          ; Put the data down
PRINT_LOOP@L4       
    	Btfss  	PYLINE3_REQ                         ; Do we need to print to the next line?
    	Bra    	PRINT_LOOP@L5
    	Incf    GEN,F                               ; Yes so move down a line
    	Movff  	_PCHAR#DATAHH, _PCHAR#DATA          ; Get the data to print
    	Movf  	_OVERWRITE#MASKHH,W
    	RCall   PPRINT@DAT                          ; Put the data down
PRINT_LOOP@L5
    	Btfss  	PYLINE4_REQ                         ; Do we need to print to the next line?
    	Bra    	PRINT_LOOP@L6
    	Incf    GEN,F                               ; Yes so move down a line
    	Movff  	_PCHAR#DATAHHH, _PCHAR#DATA         ; Get the data to print
    	Movf	_OVERWRITE#MASKHHH,W
    	RCall   PPRINT@DAT                          ; Put the data down
PRINT_LOOP@L6
    	Incf    _GLCD_XPOS,F                        ; Move to the next X pixel
    	Decfsz	PFONT_BYTES,F
    	Bra		MAIN_PPRINT@LOOP				    ; Loop until all X pixels printed   
; Restore the WREG and TBLPTRL/H before exiting
PPRINT@EXIT
     	Movff   _PPRINT#TEMP2,TBLPTRL               ; \	
     	Movff   _PPRINT#TEMP3,TBLPTRH 				; / <<< Restore TBLPTRL\H
		Movf	PP3,W								; Restore WREG
    	Return							    		; Exit the routine 
NOLIST        
;----[ROUTINE TO PUT THE DATA ON THE SCREEN]--------------------
LIST
PPRINT@DAT:      
     	Movwf	MASK_TEMP							
     	Btfsc 	GEN,3                               ; Are we within screen area?
     	Bra 	PPRINT@EXIT
     	Btfsc 	_GLCD_XPOS,7
     	Bra 	PPRINT@EXIT                         ; No     
						
        Movff	PP7,PRODL						    ; Save contents of PP7, because of interference with Display float      
        Movf	_GLCD_XPOS,W
        Call	GLCD@G							    ; Read data from the LCD into PPRINT_TEMP 
        Movwf	PPRINT_TEMP
        Movff	PRODL,PP7						    ; Restore contents of PP7
                
     	Btfss 	P_OR                           	    ; "OR" Required?
     	Bra   	PPRINT@DAT_L1
     	Iorwf 	_PCHAR#DATA,F
     	Bra   	PPRINT@IT
PPRINT@DAT_L1         
     	Btfss 	P_XOR                               ; "XOR" Required?
     	Bra   	PPRINT@DAT_L2	
     	Xorwf 	_PCHAR#DATA,F
     	Bra   	PPRINT@IT
PPRINT@DAT_L2   
; Masking Required
		Movf 	MASK_TEMP,W
	 	Andwf 	PPRINT_TEMP,F
	 	Movf 	PPRINT_TEMP,W
	 	Iorwf 	_PCHAR#DATA,F                                
PPRINT@IT                                            
 		Movff	_GLCD_XPOS,GENH						
        Movf	_PCHAR#DATA,W
        Goto 	GLCD@P							    ; Put the data contained in _PCHAR#DATA on the LCD and return
NOLIST        
;-----[READ THE FONT HEIGHT]------------------------------------
LIST   
SET@FONT
		Movff  	_PFONT_TBL#ADDRSH,TBLPTRLH 		    ; Read in the font height
		Movff  	_PFONT_TBL#ADDRS,TBLPTRL
    	Tblrd*
		Movff  	TABLAT,_PFONT#HT
		Movlw  	2
		Addwf  	_PFONT_TBL#ADDRS,F                  ; And move pointer forward 2
		Movlw  	0
		Addwfc 	_PFONT_TBL#ADDRSH,F  
		Setf   	_GLCD_YPOS#TEMP                     ; Force a re-calc
    	Return										
 LIST    
