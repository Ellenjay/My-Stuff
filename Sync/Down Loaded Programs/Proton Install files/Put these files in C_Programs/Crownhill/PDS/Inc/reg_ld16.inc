
; 16Cxxx Substitutions

 #define clrw Clrf WREG ; PIC16Cxxx code substitution (WREG is addressable)
 #define negw Negf WREG ; PIC16Cxxx code substitution (WREG is addressable)

 #define Skpc Btfss STATUS,C
 #define Skpnc Btfsc STATUS,C
 #define Clrc Bcf STATUS,C
 #define Setc Bsf STATUS,C 
 #define Skpz Btfss STATUS,Z
 #define Skpnz Btfsc STATUS,Z
 #define Clrz Bcf STATUS,Z
 #define Setz Bsf STATUS,Z
 
;------------------------------------------------------------------------------------------------- 
movfw macro m#varin
	movf m#varin,w	
	endm
;-------------------------------------------------------------------------------------------------
rlf macro m#varin,m#dest
    rlcf m#varin,m#dest
    endm
;-------------------------------------------------------------------------------------------------
rrf macro m#varin,m#dest
    rrcf m#varin,m#dest
    endm
;-------------------------------------------------------------------------------------------------
jump macro label
	goto label
	endm
;-------------------------------------------------------------------------------------------------	
f@call macro m#dest
    if (m#dest < 1)
        call m#dest
    else
      if (m#dest > $)
        call m#dest
      else
        if (m#dest < ($ - 0X03FF))
            call m#dest
        else
            rcall m#dest
        endif
      endif
    endif
    endm 
;-------------------------------------------------------------------------------------------------
f@jump macro m#dest

    ifdef WATCHDOG_REQ
    	if ($ == m#dest)
    		clrwdt  	; Walk the dog
    	endif
	endif
    if (m#dest < 1)
        goto m#dest
    else
      if ((m#dest) > $)
        goto m#dest
      else
        if ((m#dest) < ($ - 0X03FF))
            goto m#dest
        else
            bra m#dest
        endif
      endif
    endif
    endm
;-------------------------------------------------------------------------------------------------
    ifdef WATCHDOG_REQ
    		chk@slf macro m#dest
			if ($ == m#dest)
        		clrwdt  	; Walk the dog
    		endif
    		endm
	endif

g@oto macro m#dest
    if (m#dest < 1)
    	btfsc STATUS,OV
        goto m#dest
    else
    	if (m#dest > $)
        	btfsc STATUS,OV
            goto m#dest
        else
        	if (m#dest < ($ - 127))
            	btfsc STATUS,OV
                goto m#dest
            else
            	bov m#dest
            endif
        endif
    endif
    endm

go@to macro m#dest
    if (m#dest < 1)
    	goto m#dest
    else
    	if (m#dest > $)
        	goto m#dest
        else
        	if (m#dest < ($ - 0X03FF))
            	goto m#dest
            else
            	bra m#dest
            endif
        endif
    endif
    endm
;-------------------------------------------------------------------------------------------------
s@b macro m#varin
    if ((m#varin > BANKA_END) & (m#varin < 0X0F80))
      if ((m#varin & 0X0F00) != (ram_bank << 8))
        movlb (m#varin >> 8)
		ram_bank = (m#varin >> 8)
      endif
    endif
    endm
;-------------------------------------------------------------------------------------------------
r@b macro
    if(ram_bank != 0)
        movlb 0
		ram_bank = 0
    endif
    endm
;-------------------------------------------------------------------------------------------------
wreg_byte macro m#byteout
    movff WREG,m#byteout
    endm
;-------------------------------------------------------------------------------------------------
wreg_bit macro m#varout,m#bitout
    s@b m#varout
    btfsc WREG,0
    bsf m#varout,m#bitout
    btfss WREG,0
    bcf m#varout,m#bitout
    r@b							; Reset the bank when the macro is finished
    endm
;-------------------------------------------------------------------------------------------------
wreg_word macro m#wordout
    movff WREG,m#wordout
    movlw 0
    movff WREG,m#wordout + 1
    endm
;-------------------------------------------------------------------------------------------------
wreg_dword macro m#dwordout
    movff WREG,m#dwordout
    movlw 0
    movff WREG,m#dwordout + 3
    movff WREG,m#dwordout + 2
    movff WREG,m#dwordout + 1
    endm
;-------------------------------------------------------------------------------------------------
byte_wreg macro m#bytein
    movff m#bytein,WREG
    endm
;-------------------------------------------------------------------------------------------------
num_wreg macro m#numin
    movlw (m#numin & 255)
    endm
;-------------------------------------------------------------------------------------------------
num_byte macro m#numin,m#byteout
    movlw (m#numin & 255)
    movff WREG,m#byteout
    endm
;-------------------------------------------------------------------------------------------------
num_bit macro m#numin,m#varout,m#bitout
    s@b m#varout
    if((m#numin & 1) == 1)
    	bsf m#varout,m#bitout
    else
    	bcf m#varout,m#bitout
        endif
    r@b							; Reset the bank when the macro is finished
    endm
;-------------------------------------------------------------------------------------------------
num_word macro m#numin,m#wordout

    ifdef _USELFSR
    	if(m#wordout == FSR0L)
    		lfsr 0,m#numin
    		exitm
    	endif
    	
    	if(m#wordout == FSR1L)
    		lfsr 1,m#numin
    		exitm
    	endif
    	
    	if(m#wordout == FSR2L)
    		lfsr 2,m#numin
    		exitm
    	endif
    endif
    
    s@b m#wordout
	movlw (m#numin & 255)
	movwf m#wordout

    s@b m#wordout + 1
	movlw ((m#numin >> 8) & 255)
	movwf m#wordout + 1
    r@b							; Reset the bank when the macro is finished
    endm
;-------------------------------------------------------------------------------------------------
num_dword macro m#numin,m#dwordout
	s@b m#dwordout
    movlw (m#numin & 255)
    movwf m#dwordout
    s@b m#dwordout + 1
    movlw ((m#numin >> 8) & 255)
    movwf m#dwordout + 1
    s@b m#dwordout + 2
    movlw ((m#numin >> 16) & 255)
    movwf m#dwordout + 2
    s@b m#dwordout + 3
    movlw ((m#numin >> 24) & 255)
    movwf m#dwordout + 3
    r@b							; Reset the bank when the macro is finished
    endm
;-------------------------------------------------------------------------------------------------
bit_wreg macro m#varin,m#bitin
    s@b m#varin
    clrw
    btfsc m#varin,m#bitin
    movlw 1
    r@b							; Reset the bank when the macro is finished
    endm
;-------------------------------------------------------------------------------------------------
bit_byte macro m#varin,m#bitin,m#byteout
    s@b m#varin
    clrw
    btfsc m#varin,m#bitin
    movlw 1
    s@b m#byteout
    movwf m#byteout
    r@b							; Reset the bank when the macro is finished
    endm
;-------------------------------------------------------------------------------------------------
bit_bit macro m#varin,m#bitin,m#varout,m#bitout
    if ((m#varin & 0x0F00) == (m#varout & 0x0F00))
        s@b m#varin
        btfsc m#varin,m#bitin
        bsf m#varout,m#bitout
        btfss m#varin,m#bitin
        bcf m#varout,m#bitout
    	else
      		if ((m#varin <= BANKA_END) | (m#varin >= 0x0F80))
        		s@b m#varout
        		btfsc m#varin,m#bitin
        		bsf m#varout,m#bitout
        		btfss m#varin,m#bitin
        		bcf m#varout,m#bitout
      			else
      				if ((m#varout <= BANKA_END) | (m#varout >= 0x0F80))
        				s@b m#varin
        				btfsc m#varin,m#bitin
        				bsf m#varout,m#bitout
        				btfss m#varin,m#bitin
        				bcf m#varout,m#bitout
        				else
        				s@b m#varin
        				clrdc
        				btfsc m#varin,m#bitin
        				setdc
        				s@b m#varout
        				skpndc
        				bsf m#varout,m#bitout
        				skpdc
        				bcf m#varout,m#bitout
        			endif
      			endif
    	endif
        r@b							; Reset the bank when the macro is finished
    endm
;-------------------------------------------------------------------------------------------------
bit_word macro m#varin,m#bitin,m#wordout
    s@b m#wordout + 1
    clrf m#wordout + 1
    bit_byte m#varin,m#bitin,m#wordout
    endm
;-------------------------------------------------------------------------------------------------
bit_dword macro m#varin,m#bitin,m#dwordout
    s@b m#dwordout + 3
    clrf m#dwordout + 3
    s@b m#dwordout + 2
    clrf m#dwordout + 2
    s@b m#dwordout + 1
    clrf m#dwordout + 1
	bit_byte m#varin,m#bitin,m#dwordout
    endm
;-------------------------------------------------------------------------------------------------
word_wreg macro m#wordin
    byte_wreg m#wordin
    endm
;-------------------------------------------------------------------------------------------------
word_byte macro m#wordin,m#byteout
    byte_byte m#wordin,m#byteout
    endm
;-------------------------------------------------------------------------------------------------
word_bit macro m#wordin,m#varout,m#bitout
    byte_bit m#wordin, m#varout, m#bitout
    endm
;-------------------------------------------------------------------------------------------------
word_word macro m#wordin,m#wordout
    movff m#wordin + 1,m#wordout + 1
    movff m#wordin,m#wordout
    endm
;-------------------------------------------------------------------------------------------------
word_dword macro m#wordin,m#dwordout
    movlw 0
    movff WREG,m#dwordout + 3
    movff WREG,m#dwordout + 2
    word_word m#wordin,m#dwordout
    endm
;-------------------------------------------------------------------------------------------------
byte_byte macro m#bytein,m#byteout
    movff m#bytein,m#byteout
    endm
;-------------------------------------------------------------------------------------------------
byte_word macro m#bytein,m#wordout
    movlw 0
    movff WREG,m#wordout + 1
    byte_byte m#bytein,m#wordout
    endm
;-------------------------------------------------------------------------------------------------
byte_dword macro m#bytein,m#dwordout
    movlw 0
    movff WREG,m#dwordout + 3
    movff WREG,m#dwordout + 2
    movff WREG,m#dwordout + 1
    byte_byte m#bytein,m#dwordout
    endm
;-------------------------------------------------------------------------------------------------
byte_bit macro m#bytein,m#varout,m#bitout
    if ((m#bytein & 0x0F00) == (m#varout & 0x0F00))
        s@b m#bytein
        btfsc m#bytein,0
        bsf m#varout,m#bitout
        btfss m#bytein,0
        bcf m#varout,m#bitout
    else
      if ((m#bytein <= BANKA_END) | (m#bytein >= 0x0F80))
        s@b m#varout
        btfsc m#bytein,0
        bsf m#varout,m#bitout
        btfss m#bytein,0
        bcf m#varout,m#bitout
      else
          if ((m#varout <= BANKA_END) | (m#varout >= 0x0F80))
        s@b m#bytein
        btfsc m#bytein,0
        bsf m#varout,m#bitout
        btfss m#bytein,0
        bcf m#varout,m#bitout
          else
        s@b m#bytein
        rrf m#bytein,w
        s@b m#varout
        skpnc
        bsf m#varout,m#bitout
        skpc
        bcf m#varout,m#bitout
        endif
      endif
    endif
    r@b							; Reset the bank when the macro is finished
    endm
;-------------------------------------------------------------------------------------------------
dword_wreg macro m#dwordin
    byte_wreg m#dwordin
	endm
;-------------------------------------------------------------------------------------------------
dword_byte macro m#dwordin,m#byteout
    byte_byte m#dwordin,m#byteout
	endm
;-------------------------------------------------------------------------------------------------
dword_word macro m#dwordin,m#wordout
    movff m#dwordin + 1,m#wordout + 1
    movff m#dwordin,m#wordout
	endm
;-------------------------------------------------------------------------------------------------
dword_dword macro m#dwordin,m#dwordout
    movff m#dwordin + 3,m#dwordout + 3
    movff m#dwordin + 2,m#dwordout + 2
    movff m#dwordin + 1,m#dwordout + 1
    movff m#dwordin,m#dwordout
	endm
;-------------------------------------------------------------------------------------------------
dword_bit macro m#dwordin,m#varout,m#bitout
    byte_bit m#dwordin,m#varout,m#bitout
	endm
;-------------------------------------------------------------------------------------------------
num_float macro m#numin,floatout
	num_byte m#numin,floatout + 3
	num_byte ((m#numin >> 8) & 255),floatout + 2
	num_byte ((m#numin >> 16) & 255),floatout + 1
	num_byte ((m#numin >> 24) & 255),floatout
	endm
;-------------------------------------------------------------------------------------------------
wreg_float macro floatout
    call FLO@0832U
	movff pbp_aarg,floatout
	movff pbp_aargh,floatout + 1
	movff pbp_aarghh,floatout + 2
	movff pbp_aarghhh,floatout + 3
    endm
;-------------------------------------------------------------------------------------------------
bit_float macro m#varin,m#bitin,floatout
    bit_wreg m#varin,m#bitin
    call FLO@0832U
	movff pbp_aarg,floatout
	movff pbp_aargh,floatout + 1
	movff pbp_aarghh,floatout + 2
	movff pbp_aarghhh,floatout + 3
    endm
;-------------------------------------------------------------------------------------------------
byte_float macro m#bytein,floatout
    byte_wreg m#bytein
    call FLO@0832U
	movff pbp_aarg,floatout
	movff pbp_aargh,floatout + 1
	movff pbp_aarghh,floatout + 2
	movff pbp_aarghhh,floatout + 3
    endm
;-------------------------------------------------------------------------------------------------
word_float macro m#wordin,floatout
    byte_byte m#wordin PBP_AARG
    byte_byte m#wordin + 1 PBP_AARGH
    call FLO@1632U
	movff pbp_aarg,floatout
	movff pbp_aargh,floatout + 1
	movff pbp_aarghh,floatout + 2
	movff pbp_aarghhh,floatout + 3
    endm
;-------------------------------------------------------------------------------------------------
dword_float macro m#dwordin,floatout			
	movff m#dwordin,pbp_aarg
	movff m#dwordin + 1,pbp_aargh
	movff m#dwordin + 2,pbp_aarghh
	movff m#dwordin + 3,pbp_aarghhh
	call FLO@3232S
	movff pbp_aarg,floatout
	movff pbp_aargh,floatout + 1
	movff pbp_aarghh,floatout + 2
	movff pbp_aarghhh,floatout + 3
	endm
;-------------------------------------------------------------------------------------------------
float_float macro floatin,floatout	
	movff floatin,floatout
	movff floatin + 1,floatout + 1
	movff floatin + 2,floatout + 2
	movff floatin + 3,floatout + 3
	endm
;-------------------------------------------------------------------------------------------------
float_wreg macro floatin

	float_float floatin,PBP_AARG
	call INT@3232
	endm
;-------------------------------------------------------------------------------------------------
float_bit macro floatin,m#varout,m#bitout
	float_float floatin,PBP_AARG
	call INT@3232
	wreg_bit m#varout,m#bitout
	endm
;-------------------------------------------------------------------------------------------------
float_byte macro floatin,m#byteout
	float_float floatin,PBP_AARG
	call INT@3232
	wreg_byte m#byteout
	endm
;-------------------------------------------------------------------------------------------------
float_word macro floatin,m#wordout
	float_float floatin,PBP_AARG
	call INT@3232
	movff pbp_aarghhh,m#wordout
	movff pbp_aarghh,m#wordout + 1
	endm
;-------------------------------------------------------------------------------------------------
float_dword macro floatin,m#dwordout
	float_float floatin,PBP_AARG
	call INT@3232
	movff pbp_aarghhh,m#dwordout
	movff pbp_aarghh,m#dwordout + 1
	movff pbp_aargh,m#dwordout + 2
	movff pbp_aarg,m#dwordout + 3
	endm
;-------------------------------------------------------------------------------------------------
; Macros for Library Manager
num_fsr0 macro m#numin
    lfsr 0, m#numin
    endm
;-------------------------------------------------------------------------------------------------
num_fsr1 macro m#numin
    lfsr 1, m#numin
    endm
;-------------------------------------------------------------------------------------------------
num_fsr2 macro m#numin
    lfsr 2, m#numin
    endm 
;-------------------------------------------------------------------------------------------------
label_word macro labelin,m#wordout  
    movlw (labelin & 255)
    movff WREG, m#wordout
    movlw ((labelin >> 8) & 255)
    movff WREG, m#wordout + 1
    endm
