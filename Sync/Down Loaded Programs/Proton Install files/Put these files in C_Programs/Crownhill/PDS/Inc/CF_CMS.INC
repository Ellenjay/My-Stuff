 NOLIST
;
; Library subroutines for Compact Flash commands: -
; CF_INIT, CF_SECTOR, CF_READ, and CFWRITE
;
if (_CORE == 14)									; 14-bit core device subroutines
	set@page over@cf@subs							; Jump over the subroutines
 LIST
    Goto	over@cf@subs							; When using a 14-bit core device
 NOLIST
;----------------------------------------------------------------------------------
; CF_INIT subroutine
; Sets the Compact Flash pins inputs and outputs
; Input		: None
; Output	: None
; Notes		:
; If DECLARE CF_ADPORT_MASK is True then masking takes place before the value is placed on to the AD_PORT
; This is essential if the address lines are attached to a port used by other peripherals
; However, if PORTE is used on a 40-pin device for example, no masking is needed because it only contains 3 pins anyway.
ifdef CF_INIT#REQ
 LIST
CF#INIT
        Bsf 	STATUS,5      						; Point to BANK 1    
        Clrf 	CF#DTPORT  
         NOLIST
        ifdef CF_ADPORT_MASK#REQ
        	LIST
        	Movlw 	0xF8
            Andwf 	CF#ADPORT,f
            NOLIST
        else
        	LIST
        	Clrf 	CF#ADPORT
        	NOLIST
        endif
    	NOLIST
    	ifdef CF#RSTPORT							; Are we using the RESET pin ?
        	LIST
        	Bcf 	CF#RSTPORT,CF#RSTPIN			; Yes. So set it to output
    		NOLIST
    	endif
        NOLIST
        ifdef CF#CE1PORT							; Are we using the CE1 pin ?
        	LIST
        	Bcf 	CF#CE1PORT,CF#CE1PIN			; Yes. So set it to output
    		NOLIST
    	endif
    	LIST
    	Bcf 	CF#OEPORT,CF#OEPIN
    	Bcf 	CF#WEPORT,CF#WEPIN
		Bsf		CF#CD1PORT,CF#CD1PIN				; Make CF_CD1 an input (card detect)
		Bsf		CF#RDYPORT,CF#RDYPIN				; Make CF_RDY_BSY an input (CF_RDY/BSY)
	 	Bcf 	STATUS,5							; Back to BANK 0
        
    	NOLIST
    	ifdef CF#RSTPORT							; Are we using the RESET pin ?
        	LIST
        	Bsf 	CF#RSTPORT,CF#RSTPIN			; Yes. So set the RESET line High
    		NOLIST
    	endif
        ifdef CF#CE1PORT							; Are we using the CE1 pin ?
        	LIST
        	Bcf 	CF#CE1PORT,CF#CE1PIN			; Yes. So pull it low
    		NOLIST
    	endif
    	LIST
    	Bsf 	CF#OEPORT,CF#OEPIN
    	Bsf 	CF#WEPORT,CF#WEPIN
		Bsf		CF#RDYPORT,CF#RDYPIN				; Make CF_RDY_BSY an input (CF_RDY/BSY)		
		NOLIST
		ifdef CF#RSTPORT							; Are we using the RESET pin ?
        	LIST
        	Nop										; 1 cycle delay
        	Nop										; 1 cycle delay
        	Bcf 	CF#RSTPORT,CF#RSTPIN			; Pull the RESET line low
        	NOLIST
        endif
        LIST
        Goto 	I@nt
        NOLIST
endif
 LIST
 NOLIST
;----------------------------------------------------------------------------------
; CF_SECTOR subroutine
; Sets up the sector number to read or write from
; Input		: PP7/H/HH/HHH Sector number of interest
;			: PP0 Amount of sectors to read/write
;			: PP0H READ or WRITE command. $30 for WRITE, $20 for READ
; Output	: None
; Notes		: The amount of sectors is optional and if not used, the subroutine starts at SET#CF#SCT2
;			  Instead of SET#CF#SCT
; 			  If DECLARE CF_ADPORT_MASK is True then masking takes place before the value is placed on to the AD_PORT
; 			  This is essential if the address lines are attached to a port used by other peripherals
; 			  However, if PORTE is used on a 40-pin device for example, no masking is needed because it only contains 3 pins anyway.
ifdef SETUP_CF_SECTOR#REQ
LIST
SET#CF#SCT							
		NOLIST
		ifdef CF_ADPORT_MASK#REQ
        	LIST
        	Bcf		CF#ADPORT,0					; SECTOR COUNT Register
            Bsf		CF#ADPORT,1
            Bcf		CF#ADPORT,2
            NOLIST
        else
        	LIST
        	Movlw 	2
            Movwf 	CF#ADPORT
            NOLIST
        endif 
        LIST       
        Movf	PP0,w
        Call 	CF#WR
        							
SET#CF#SCT2
        NOLIST
        ifdef CF_ADPORT_MASK#REQ
        	LIST
        	Bsf		CF#ADPORT,0					; SECTOR NUMBER Register
            Bsf		CF#ADPORT,1
            Bcf		CF#ADPORT,2
            NOLIST
        else
        	LIST
        	Movlw 	3
            Movwf 	CF#ADPORT
            NOLIST
        endif        
        LIST
        Movf	PP7,w
        Call 	CF#WR
        NOLIST
        ifdef CF_ADPORT_MASK#REQ
        	LIST
        	Bcf		CF#ADPORT,0					; LOW CYLINDER Register
            Bcf		CF#ADPORT,1
            Bsf		CF#ADPORT,2
            NOLIST
        else
        	LIST
        	Movlw 	4
            Movwf 	CF#ADPORT
            NOLIST
        endif        
        LIST
        Movf	PP7H,w
        Call 	CF#WR
        NOLIST
		ifdef CF_ADPORT_MASK#REQ
        	LIST
        	Bsf		CF#ADPORT,0					; HIGH CYLINDER Register
            Bcf		CF#ADPORT,1
            Bsf		CF#ADPORT,2
            NOLIST
        else
        	LIST
        	Movlw 	5
            Movwf 	CF#ADPORT
            NOLIST
        endif  
        LIST      
        Movf	PP7HH,w
        Call 	CF#WR
        NOLIST       
		ifdef CF_ADPORT_MASK#REQ
        	LIST
        	Bcf		CF#ADPORT,0					; HEAD/DRIVE Register
            Bsf		CF#ADPORT,1
            Bsf		CF#ADPORT,2
            NOLIST
        else
        	LIST
        	Movlw 	6
            Movwf 	CF#ADPORT
            NOLIST
        endif 
        LIST          
        Movf 	PP7HHH,w
        Andlw 	B'00001111'						; Mask upper nibble (LBA-Sign and drive)
        Iorlw 	B'11100000'						; Set the CF card to LBA mode
		Call 	CF#WR
		NOLIST
		; Write with erase					
		ifdef CF_ADPORT_MASK#REQ
        	LIST
        	Bsf		CF#ADPORT,0					; COMMAND Register
            Bsf		CF#ADPORT,1
            Bsf		CF#ADPORT,2
            NOLIST
        else	
        	LIST
        	Movlw 	7
            Movwf 	CF#ADPORT
            NOLIST
        endif
        LIST
        Movf	PP0H,w
        Call 	CF#WR
        NOLIST
        ifdef CF_ADPORT_MASK#REQ
        	LIST
        	Movlw 	0xF8
            Andwf 	CF#ADPORT,f
            NOLIST
        else
        	LIST
            Clrf 	CF#ADPORT
            NOLIST
        endif 
        LIST       
     	Return
 NOLIST
endif
 NOLIST 
;----------------------------------------------------------------------------------
; CF_WRITE subroutine
; Write a single byte to the CF card
; Input		: WREG holds the byte to write to the CF card
; Output	: None
; Notes		:
ifdef CF_WRITE#REQ
 LIST
CF#WR      
    	Movwf	CF#DTPORT
        Btfss	CF#RDYPORT,CF#RDYPIN
		Goto	$ - 1								; Ensure the Card is Ready     
		Bcf 	CF#WEPORT,CF#WEPIN					; Strobe the CF_WE Line Low to High
        Nop
		Bsf		CF#WEPORT,CF#WEPIN       
    	Return
 NOLIST
endif
 LIST
 NOLIST 
;----------------------------------------------------------------------------------
; CF_READ subroutine
; Read a single byte from the CF card
; Input		: None
; Output	: WREG holds the byte read from the CF card
; Notes		:
ifdef CF_READ#REQ
 LIST
CF#RD      
        Bsf		STATUS,5							; Point to BANK 1
        Movlw	255
        Movwf	CF#DTPORT							; Set TRIS register for CF_DATA to Input
        Bcf		STATUS,5							; Back to BANK 0
        Btfss	CF#RDYPORT,CF#RDYPIN
		Goto	$ - 1								; Ensure the Card is Ready     
		Bcf 	CF#OEPORT,CF#OEPIN					; Make CF_OE line Low
        Nop
        Nop
        Movf	CF#DTPORT,w
        Nop
        Bsf 	CF#OEPORT,CF#OEPIN					; Set CF_OE line High
        Bsf		STATUS,5							; Point to BANK 1
        Clrf	CF#DTPORT							; Change CF_DATA back to output 
       	Goto	I@nt
 NOLIST
endif
 LIST 
OVER@CF@SUBS
 LIST
 NOLIST
else												; 16-bit core device subroutines
NOLIST
;----------------------------------------------------------------------------------
; CF_INIT subroutine
; Sets the Compact Flash pins inputs and outputs
; Input		: None
; Output	: None
; Notes		:
; If DECLARE CF_ADPORT_MASK is True then masking takes place before the value is placed on to the AD_PORT
; This is essential if the address lines are attached to a port used by other peripherals
; However, if PORTE is used on a 40-pin device for example, no masking is needed because it only contains 3 pins anyway.
ifdef CF_INIT#REQ
LIST
CF#INIT   
        Clrf 	CF#DTPORT + 0x12  
        NOLIST
        ifdef CF_ADPORT_MASK#REQ
        	LIST
        	Movlw 	0xF8
            Andwf 	CF#ADPORT + 0x12,f
            NOLIST
        else
        	LIST
        	Clrf 	CF#ADPORT + 0x12
        	NOLIST
        endif
        NOLIST
    	ifdef CF#RSTPORT									; Are we using the RESET line ?
        	LIST
        	Bcf 	(CF#RSTPORT + 0x12),CF#RSTPIN			; Yes. So set it as an output
    		NOLIST
    	endif
    	NOLIST
        ifdef CF#CE1PORT									; Are we using the CE1 line ?
        	LIST
        	Bcf 	(CF#CE1PORT + 0x12),CF#CE1PIN			; Yes. So set it as an output
    		NOLIST
    	endif
        LIST
        Bcf 	(CF#OEPORT + 0x12),CF#OEPIN
    	Bcf 	(CF#WEPORT + 0x12),CF#WEPIN
		Bsf		(CF#CD1PORT + 0x12),CF#CD1PIN				; Make CF_CD1 an input (card detect)
		Bsf		(CF#RDYPORT + 0x12),CF#RDYPIN				; Make CF_RDY_BSY an input (CF_RDY/BSY)
        NOLIST
    	ifdef CF#RSTPORT									; Are we using the RESET line ?
        	LIST
        	Bsf 	CF#RSTPORT,CF#RSTPIN					; Yes. So set it high to place the CF card in reset
    		NOLIST
    	endif
        NOLIST
        ifdef CF#CE1PORT									; Are we using the CE1 line ?
        	LIST
        	Bcf 	CF#CE1PORT,CF#CE1PIN					; Yes. So pull it low
    		NOLIST
    	endif
        LIST
        Bsf 	CF#OEPORT,CF#OEPIN
    	Bsf 	CF#WEPORT,CF#WEPIN
		NOLIST
		ifdef CF#RSTPORT									; Are we using the RESET line ?
        	LIST
        	Bra		$ + 2									; 2 cycle delay
        	Bcf 	CF#RSTPORT,CF#RSTPIN					; Pull the CF_RST line low to bring the CF card out of reset
			Bra		$ + 2									; 2 cycle delay
        	NOLIST
        endif
        LIST
        Return	
        NOLIST
endif
 LIST
 NOLIST
;----------------------------------------------------------------------------------
; CF_SECTOR subroutine
; Sets up the sector number to read or write from
; Input		: PP7/H/HH/HHH Sector number of interest
;			: PP0 Amount of sectors to read/write
;			: PP0H READ or WRITE command. $30 for WRITE, $20 for READ
; Output	: None
; Notes		: The amount of sectors is optional and if not used, the subroutine starts at SET#CF#SCT2
;			  Instead of SET#CF#SCT
; 			  If DECLARE CF_ADPORT_MASK is True then masking takes place before the value is placed on to the AD_PORT
; 			  This is essential if the address lines are attached to a port used by other peripherals
; 			  However, if PORTE is used on a 40-pin device for example, no masking is needed because it only contains 3 pins anyway.
ifdef SETUP_CF_SECTOR#REQ
 LIST
SET#CF#SCT							
		NOLIST
		ifdef CF_ADPORT_MASK#REQ
        	LIST
        	Bcf		CF#ADPORT,0					; SECTOR COUNT Register
            Bsf		CF#ADPORT,1
            Bcf		CF#ADPORT,2
            NOLIST
        else
        	LIST
        	Movlw 	2
            Movwf 	CF#ADPORT
            NOLIST
        endif
        LIST        
        Movf	PP0,w
        RCall 	CF#WR
        							
SET#CF#SCT2
        NOLIST
        ifdef CF_ADPORT_MASK#REQ
        	LIST
        	Bsf		CF#ADPORT,0					; SECTOR NUMBER Register
            Bsf		CF#ADPORT,1
            Bcf		CF#ADPORT,2
            NOLIST
        else
        	LIST
        	Movlw 	3
            Movwf 	CF#ADPORT
            NOLIST
        endif
        LIST        
        Movf	PP7,w
        RCall 	CF#WR
        NOLIST
        ifdef CF_ADPORT_MASK#REQ
        	LIST
        	Bcf		CF#ADPORT,0					; LOW CYLINDER Register
            Bcf		CF#ADPORT,1
            Bsf		CF#ADPORT,2
            NOLIST
        else
        	LIST
        	Movlw 	4
            Movwf 	CF#ADPORT
            NOLIST
        endif 
        LIST       
        Movf	PP7H,w
        RCall 	CF#WR
        NOLIST
		ifdef CF_ADPORT_MASK#REQ
        	LIST
        	Bsf		CF#ADPORT,0					; HIGH CYLINDER Register
            Bcf		CF#ADPORT,1
            Bsf		CF#ADPORT,2
            NOLIST
        else
        	LIST
        	Movlw 	5
            Movwf 	CF#ADPORT
            NOLIST
        endif 
        LIST       
        Movf	PP7HH,w
        RCall 	CF#WR
        NOLIST       
		ifdef CF_ADPORT_MASK#REQ
        	LIST
        	Bcf		CF#ADPORT,0					; HEAD/DRIVE Register
            Bsf		CF#ADPORT,1
            Bsf		CF#ADPORT,2
            NOLIST
        else
        	LIST
        	Movlw 	6
            Movwf 	CF#ADPORT
            NOLIST
        endif           
        LIST
        Movf 	PP7HHH,w
        Andlw 	B'00001111'						; Mask upper nibble (LBA-Sign and drive)
        Iorlw 	B'11100000'						; Set the CF card to LBA mode
		RCall 	CF#WR
		NOLIST
		; Write with erase					
		ifdef CF_ADPORT_MASK#REQ
        	LIST
        	Bsf		CF#ADPORT,0					; COMMAND Register
            Bsf		CF#ADPORT,1
            Bsf		CF#ADPORT,2
            NOLIST
        else
        	LIST
        	Movlw 	7
            Movwf 	CF#ADPORT
            NOLIST
        endif
        LIST
        Movf	PP0H,w
        RCall 	CF#WR
        NOLIST
        ifdef CF_ADPORT_MASK#REQ
        	LIST
        	Movlw 	0xF8
            Andwf 	CF#ADPORT,f
            NOLIST
        else
        	LIST
            Clrf 	CF#ADPORT
            NOLIST
        endif 
        LIST      
     	Return
 NOLIST
endif 
 LIST
 NOLIST
;----------------------------------------------------------------------------------
; CF_WRITE subroutine
; Write a single byte to the CF card
; Input		: WREG holds the byte to write to the CF card
; Output	: None
; Notes		:
ifdef CF_WRITE#REQ
 LIST
CF#WR      	
        Movwf	CF#DTPORT
        Btfss	CF#RDYPORT,CF#RDYPIN
		Bra		$ - 2								; Ensure the Card is Ready     
		Bcf 	CF#WEPORT,CF#WEPIN					; Strobe the CF_WE Line Low to High
        Bra		$ + 2								; 2 cycle delay
		Bsf		CF#WEPORT,CF#WEPIN       
		Return 
 NOLIST     
endif 
 LIST
 NOLIST
;----------------------------------------------------------------------------------
; CF_READ subroutine
; Read a single byte from the CF card
; Input		: None
; Output	: WREG holds the byte read from the CF card
; Notes		:
ifdef CF_READ#REQ
 LIST
CF#RD      
        Setf	CF#DTPORT + 0x12					; CF_DATA to Input
        Btfss	CF#RDYPORT,CF#RDYPIN
		Bra		$ - 2								; Ensure the Card is Ready     
		Bcf 	CF#OEPORT,CF#OEPIN					; Make CF_OE line Low
        Bra		$ + 2								; 2 cycle delay
        Movf	CF#DTPORT,w
        Bra		$ + 2								; 2 cycle delay
        Bsf 	CF#OEPORT,CF#OEPIN					; Set CF_OE line High
        Bra		$ + 2								; 2 cycle delay
        Clrf	CF#DTPORT + 0x12					; Change CF_DATA back to output 
		Return
 NOLIST      
endif 
 NOLIST
endif
 LIST