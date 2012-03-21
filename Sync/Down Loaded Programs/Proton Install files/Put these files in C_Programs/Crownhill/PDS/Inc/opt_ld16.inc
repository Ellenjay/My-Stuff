 LIST
; 16Fxxx Substitutions

 #define clrw Clrf WREG 
 #define negw Negf WREG
 #define Skpc Btfss STATUS,0
 #define Skpnc Btfsc STATUS,0
 #define Clrc Bcf STATUS,0
 #define Setc Bsf STATUS,0 
 #define Skpz Btfss STATUS,2
 #define Skpnz Btfsc STATUS,2
 #define Clrz Bcf STATUS,2
 #define Setz Bsf STATUS,2

;------------------------------------------------------------------------------------------------- 
movfw macro m#varin
 LIST
	error "Cannot use the MOVFW macro directly when using optimisation. Use MOVF VAR,W"
	endm

;-------------------------------------------------------------------------------------------------
rlf macro m#varin,m#dest
 LIST
	error "Cannot use the RLF macro directly when using optimisation. Use RLCF"
	endm
;-------------------------------------------------------------------------------------------------
rrf macro m#varin,m#dest
 LIST
	error "Cannot use the RRF macro directly when using optimisation. Use RRCF"
	endm
;-------------------------------------------------------------------------------------------------
jump macro label
 LIST
	error "Cannot use the JUMP macro directly when using optimisation. Use GOTO"
 	endm
 	
 LIST
;[START@OF@MACROS]
 NOLIST
 LIST
;-------------------------------------------------------------------------------------------------	
f@call macro m#dest
 LIST
 	error "Cannot use the F@CALL macro directly when using optimisation"
	endm 
;-------------------------------------------------------------------------------------------------
f@jump macro m#dest
 LIST
 	error "Cannot use the F@JUMP macro directly when using optimisation"
	endm
;-------------------------------------------------------------------------------------------------
 NOLIST
	ifdef WATCHDOG_REQ
 NOLIST
	chk@slf macro m#dest
 NOLIST
	if ($ == m#dest)
 LIST
	clrwdt
 NOLIST
	endif
 LIST
	endm
	endif
 LIST
 	
g@oto macro m#dest
 LIST
 	error "Cannot use the G@OTO macro directly when using optimisation"
	endm 
 
go@to macro m#dest
 LIST
 	error "Cannot use the GO@TO macro directly when using optimisation"
	endm
;-------------------------------------------------------------------------------------------------
s@b macro m#varin
 NOLIST
	if ((m#varin > BANKA_END) & (m#varin < 0X0F80))
	if ((m#varin & 0X0F00) != (ram_bank << 8))
 LIST
	movlb (m#varin >> 8)
ram_bank = (m#varin >> 8)
 NOLIST
	endif
	endif
 LIST
	endm
;-------------------------------------------------------------------------------------------------
r@b macro
 NOLIST
	if(ram_bank != 0)
 LIST
	movlb 0
ram_bank = 0
 NOLIST
	endif
 LIST
	endm
;-------------------------------------------------------------------------------------------------
wreg_byte macro m#byteout
 NOLIST
 	if(m#byteout <= BANKA_END)
 LIST
 	movwf m#byteout
 NOLIST
	else
 LIST
	movff WREG,m#byteout
 NOLIST
	endif
 LIST
	endm
;-------------------------------------------------------------------------------------------------
wreg_bit macro m#varout,m#bitout
 NOLIST
	s@b m#varout
 LIST
	btfsc WREG,0
	bsf m#varout,m#bitout
	btfss WREG,0
	bcf m#varout,m#bitout
 NOLIST
	r@b	
 LIST
	endm
;-------------------------------------------------------------------------------------------------
wreg_word macro m#wordout
 LIST
	movff WREG,m#wordout
	movlw 0
	movff WREG,m#wordout + 1
	endm
;-------------------------------------------------------------------------------------------------
wreg_dword macro m#dwordout
 LIST
	movff WREG,m#dwordout
	movlw 0
	movff WREG,m#dwordout + 3
	movff WREG,m#dwordout + 2
	movff WREG,m#dwordout + 1
	endm
;-------------------------------------------------------------------------------------------------
byte_wreg macro m#bytein
 NOLIST
 	if(m#bytein <= BANKA_END)
 LIST
 	movf m#bytein,W
 NOLIST
	else
 LIST
	movff m#bytein,WREG
 NOLIST
	endif
 LIST
	endm
;-------------------------------------------------------------------------------------------------
num_wreg macro m#numin
 NOLIST
	if(m#numin < 256)
 LIST
	movlw m#numin
 NOLIST
	else
 LIST
	movlw (m#numin & 255)
 NOLIST
	endif
 LIST
	endm
;-------------------------------------------------------------------------------------------------
num_byte macro m#numin,m#byteout
 LIST
	movlw m#numin
 NOLIST
 	if(m#byteout > BANKA_END)
 LIST
	movff WREG,m#byteout
 NOLIST
	else
 NOLIST
	s@b m#byteout
 LIST
	movwf m#byteout
 NOLIST
	r@b
 NOLIST
 	endif		
 LIST
	endm
;-------------------------------------------------------------------------------------------------
num_bit macro m#numin,m#varout,m#bitout
 NOLIST
	s@b m#varout
 NOLIST
	if((m#numin & 1) == 1)
 LIST
	bsf m#varout,m#bitout
 NOLIST
	else
 LIST
	bcf m#varout,m#bitout
 NOLIST
	endif
 NOLIST
	r@b	
 LIST
	endm
;-------------------------------------------------------------------------------------------------
num_word macro m#numin,m#wordout	
 NOLIST
 
 LIST
	movlw (m#numin & 255)
 NOLIST
	if(m#wordout > BANKA_END)
 LIST		
	movff WREG,m#wordout
 NOLIST
	else
 NOLIST
	s@b m#wordout
 LIST
	movff WREG,m#wordout
 NOLIST
	endif
 NOLIST
 
 LIST
	movlw ((m#numin >> 8) & 255)
 NOLIST
	if(m#wordout + 1 > BANKA_END)
 LIST		
	movff WREG,m#wordout + 1
 NOLIST
	else
 NOLIST
	s@b m#wordout + 1
 LIST
	movwf m#wordout + 1
 NOLIST
	endif
 NOLIST
	if(m#wordout > BANKA_END)
		r@b
 NOLIST
	endif
 LIST
	endm
;-------------------------------------------------------------------------------------------------
num_dword macro m#numin,m#dwordout
 NOLIST
	s@b m#dwordout
 LIST
	movlw (m#numin & 255)
	movwf m#dwordout
 NOLIST
	s@b m#dwordout + 1
 LIST
	movlw ((m#numin >> 8) & 255)
	movwf m#dwordout + 1
 NOLIST
	s@b m#dwordout + 2
 LIST
	movlw ((m#numin >> 16) & 255)
	movwf m#dwordout + 2
 NOLIST
	s@b m#dwordout + 3
 LIST
	movlw ((m#numin >> 24) & 255)
	movwf m#dwordout + 3
 NOLIST
	r@b	
 LIST
	endm
;-------------------------------------------------------------------------------------------------
bit_wreg macro m#varin,m#bitin
 NOLIST
	s@b m#varin
 LIST
	clrf WREG
	btfsc m#varin,m#bitin
	movlw 1
 NOLIST
	r@b	
 LIST
	endm
;-------------------------------------------------------------------------------------------------
bit_byte macro m#varin,m#bitin,m#byteout
 NOLIST
	s@b m#varin
 LIST
	clrf WREG
	btfsc m#varin,m#bitin
	movlw 1
 NOLIST
	s@b m#byteout
 LIST
	movwf m#byteout
 NOLIST
	r@b	
 LIST
	endm
;-------------------------------------------------------------------------------------------------
bit_bit macro m#varin,m#bitin,m#varout,m#bitout
 NOLIST
	if ((m#varin & 0x0F00) == (m#varout & 0x0F00))
 NOLIST
	s@b m#varin
 LIST
	btfsc m#varin,m#bitin
	bsf m#varout,m#bitout
	btfss m#varin,m#bitin
	bcf m#varout,m#bitout
 NOLIST
	else
	if ((m#varin <= BANKA_END) | (m#varin >= 0x0F80))
	s@b m#varout
 LIST
	btfsc m#varin,m#bitin
	bsf m#varout,m#bitout
	btfss m#varin,m#bitin
	bcf m#varout,m#bitout
	 NOLIST
	else
 NOLIST
	if ((m#varout <= BANKA_END) | (m#varout >= 0x0F80))
	s@b m#varin
 LIST
	btfsc m#varin,m#bitin
	bsf m#varout,m#bitout
	btfss m#varin,m#bitin
	bcf m#varout,m#bitout
 NOLIST
	else
	s@b m#varin
 LIST
	clrdc
	btfsc m#varin,m#bitin
	setdc
 NOLIST
	s@b m#varout
 LIST
	skpndc
	bsf m#varout,m#bitout
	skpdc
	bcf m#varout,m#bitout
 NOLIST
	endif
	endif
	endif
	r@b	
 LIST
	endm
;-------------------------------------------------------------------------------------------------
bit_word macro m#varin,m#bitin,m#wordout
 NOLIST
	s@b m#wordout + 1
 LIST
	clrf m#wordout + 1
 NOLIST
	bit_byte m#varin,m#bitin,m#wordout
 LIST
	endm
;-------------------------------------------------------------------------------------------------
bit_dword macro m#varin,m#bitin,m#dwordout
 NOLIST
	s@b m#dwordout + 3
 LIST
	clrf m#dwordout + 3
 NOLIST
	s@b m#dwordout + 2
 LIST
	clrf m#dwordout + 2
 NOLIST
	s@b m#dwordout + 1
 LIST
	clrf m#dwordout + 1
 NOLIST
	bit_byte m#varin,m#bitin,m#dwordout
 LIST
	endm
;-------------------------------------------------------------------------------------------------
byte_byte macro m#bytein,m#byteout
 LIST
	movff m#bytein,m#byteout
 LIST
	endm
;-------------------------------------------------------------------------------------------------
byte_word macro m#bytein,m#wordout
 LIST
	movlw 0
	movff WREG,m#wordout + 1
	movff m#bytein,m#wordout
 LIST
	endm
;-------------------------------------------------------------------------------------------------
byte_dword macro m#bytein,m#dwordout
 LIST
	movlw 0
	movff WREG,m#dwordout + 3
	movff WREG,m#dwordout + 2
	movff WREG,m#dwordout + 1
	movff m#bytein,m#dwordout
 LIST
	endm
;-------------------------------------------------------------------------------------------------
byte_bit macro m#bytein,m#varout,m#bitout
 NOLIST
	if ((m#bytein & 0x0F00) == (m#varout & 0x0F00))
	s@b m#bytein
 LIST
	btfsc m#bytein,0
	bsf m#varout,m#bitout
	btfss m#bytein,0
	bcf m#varout,m#bitout
 NOLIST
	else
 NOLIST
	if ((m#bytein <= BANKA_END) | (m#bytein >= 0x0F80))
	s@b m#varout
 LIST
	btfsc m#bytein,0
	bsf m#varout,m#bitout
	btfss m#bytein,0
	bcf m#varout,m#bitout
 NOLIST
	else
 NOLIST
	if ((m#varout <= BANKA_END) | (m#varout >= 0x0F80))
	s@b m#bytein
 LIST
	btfsc m#bytein,0
	bsf m#varout,m#bitout
	btfss m#bytein,0
	bcf m#varout,m#bitout
 NOLIST
	else
	s@b m#bytein
 LIST
	rrf m#bytein,w
 NOLIST
	s@b m#varout
 LIST
	skpnc
	bsf m#varout,m#bitout
	skpc
	bcf m#varout,m#bitout
 NOLIST
	endif
	endif
	endif
	r@b	
  LIST
	endm
;-------------------------------------------------------------------------------------------------
word_wreg macro m#wordin
 NOLIST
 	if(m#wordin <= BANKA_END)
 LIST
 	movf m#wordin,W
 NOLIST
	else
 LIST
	movff m#wordin,WREG
 NOLIST
	endif
 LIST
; NOLIST
;	byte_wreg m#wordin
; LIST
	endm
;-------------------------------------------------------------------------------------------------
word_byte macro m#wordin,m#byteout
 NOLIST
 	movff m#wordin,m#byteout
 LIST
	endm
;-------------------------------------------------------------------------------------------------
word_bit macro m#wordin,m#varout,m#bitout
 NOLIST
	byte_bit m#wordin, m#varout, m#bitout
 LIST
	endm
;-------------------------------------------------------------------------------------------------
word_word macro m#wordin,m#wordout
 LIST
	movff m#wordin + 1,m#wordout + 1
	movff m#wordin,m#wordout
	endm
;-------------------------------------------------------------------------------------------------
word_dword macro m#wordin,m#dwordout
 LIST
	movlw 0
	movff WREG,m#dwordout + 3
	movff WREG,m#dwordout + 2
 NOLIST
	word_word m#wordin,m#dwordout
 LIST
	endm
;-------------------------------------------------------------------------------------------------
dword_wreg macro m#dwordin
 NOLIST
 	if(m#dwordin <= BANKA_END)
 LIST
 	movf m#dwordin,W
 NOLIST
	else
 LIST
	movff m#dwordin,WREG
 NOLIST
	endif
 LIST
; NOLIST
;	byte_wreg m#dwordin
; LIST
	endm
;-------------------------------------------------------------------------------------------------
dword_byte macro m#dwordin,m#byteout
 NOLIST
	movff m#dwordin,m#byteout
	endm
;-------------------------------------------------------------------------------------------------
dword_word macro m#dwordin,m#wordout
 LIST
	movff m#dwordin + 1,m#wordout + 1
	movff m#dwordin,m#wordout
	endm
;-------------------------------------------------------------------------------------------------
dword_dword macro m#dwordin,m#dwordout
 NOLIST
 	if(m#dwordin != m#dwordout)
 LIST
	movff m#dwordin + 3,m#dwordout + 3
	movff m#dwordin + 2,m#dwordout + 2
	movff m#dwordin + 1,m#dwordout + 1
	movff m#dwordin,m#dwordout
 NOLIST
 	endif
 LIST
	endm
;-------------------------------------------------------------------------------------------------
dword_bit macro m#dwordin,m#varout,m#bitout
 NOLIST
	byte_bit m#dwordin,m#varout,m#bitout
 LIST
	endm
;-------------------------------------------------------------------------------------------------
num_float macro m#numin,floatout
 NOLIST
	num_byte m#numin,floatout + 3
	num_byte ((m#numin >> 8) & 255),floatout + 2
	num_byte ((m#numin >> 16) & 255),floatout + 1
	num_byte ((m#numin >> 24) & 255),floatout
 LIST
	endm
;-------------------------------------------------------------------------------------------------
wreg_float macro floatout
 LIST
NOP;@USE@_CALL FLO@0832U
	movff pbp_aarg,floatout
	movff pbp_aargh,floatout + 1
	movff pbp_aarghh,floatout + 2
	movff pbp_aarghhh,floatout + 3
	endm
;-------------------------------------------------------------------------------------------------
bit_float macro m#varin,m#bitin,floatout
 NOLIST
	bit_wreg m#varin,m#bitin
 LIST
NOP;@USE@_CALL FLO@0832U
	movff pbp_aarg,floatout
	movff pbp_aargh,floatout + 1
	movff pbp_aarghh,floatout + 2
	movff pbp_aarghhh,floatout + 3
	endm
;-------------------------------------------------------------------------------------------------
byte_float macro m#bytein,floatout
; NOLIST
;	byte_wreg m#bytein
; LIST
 NOLIST
 	if(m#bytein <= BANKA_END)
 LIST
 	movf m#bytein,W
 NOLIST
	else
 LIST
	movff m#bytein,WREG
 NOLIST
	endif
 LIST
NOP;@USE@_CALL FLO@0832U
	movff pbp_aarg,floatout
	movff pbp_aargh,floatout + 1
	movff pbp_aarghh,floatout + 2
	movff pbp_aarghhh,floatout + 3
	endm
;-------------------------------------------------------------------------------------------------
word_float macro m#wordin,floatout
 NOLIST
	movff m#wordin PBP_AARG
	movff m#wordin + 1 PBP_AARGH
 LIST
NOP;@USE@_CALL FLO@1632U
	movff pbp_aarg,floatout
	movff pbp_aargh,floatout + 1
	movff pbp_aarghh,floatout + 2
	movff pbp_aarghhh,floatout + 3
	endm
;-------------------------------------------------------------------------------------------------
dword_float macro m#dwordin,floatout	
 LIST
	movff m#dwordin,pbp_aarg
	movff m#dwordin + 1,pbp_aargh
	movff m#dwordin + 2,pbp_aarghh
	movff m#dwordin + 3,pbp_aarghhh
NOP;@USE@_CALL FLO@3232S
	movff pbp_aarg,floatout
	movff pbp_aargh,floatout + 1
	movff pbp_aarghh,floatout + 2
	movff pbp_aarghhh,floatout + 3
	endm
;-------------------------------------------------------------------------------------------------
float_float macro floatin,floatout	
 NOLIST
	if(floatin != floatout)
 LIST
	movff floatin,floatout
	movff floatin + 1,floatout + 1
	movff floatin + 2,floatout + 2
	movff floatin + 3,floatout + 3
 NOLIST
 	endif
 LIST
	endm
;-------------------------------------------------------------------------------------------------
float_wreg macro floatin
 NOLIST
	float_float floatin,PBP_AARG
 LIST
NOP;@USE@_CALL INT@3232
	endm
;-------------------------------------------------------------------------------------------------
float_bit macro floatin,m#varout,m#bitout
 NOLIST
	float_float floatin,PBP_AARG
 LIST
NOP;@USE@_CALL INT@3232
 NOLIST
	wreg_bit m#varout,m#bitout
 LIST
	endm
;-------------------------------------------------------------------------------------------------
float_byte macro floatin,m#byteout
 NOLIST
	float_float floatin,PBP_AARG
 LIST
NOP;@USE@_CALL INT@3232
 NOLIST
 	if(m#byteout <= BANKA_END)
 LIST
 	movwf m#byteout
 NOLIST
	else
 LIST
	movff WREG,m#byteout
 NOLIST
	endif
 LIST
	endm
;-------------------------------------------------------------------------------------------------
float_word macro floatin,m#wordout
 NOLIST
	float_float floatin,PBP_AARG
 LIST
NOP;@USE@_CALL INT@3232
	movff pbp_aarghhh,m#wordout
	movff pbp_aarghh,m#wordout + 1
	endm
;-------------------------------------------------------------------------------------------------
float_dword macro floatin,m#dwordout
 NOLIST
	float_float floatin,PBP_AARG
 LIST
NOP;@USE@_CALL INT@3232
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
 LIST
;[END@OF@MACROS]
 LIST 