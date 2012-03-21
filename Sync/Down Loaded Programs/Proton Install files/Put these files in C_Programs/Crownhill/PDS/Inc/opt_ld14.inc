 LIST
;[START@OF@MACROS]

LIST
jump macro label
 LIST
	goto label
	endm
 NOLIST
 LIST
;-------------------------------------------------------------------------------------------------
wreg_byte macro m#byteout
 NOLIST
	s@b m#byteout
 LIST
	movwf m#byteout
 NOLIST
	r@b	
 LIST
	endm
;-------------------------------------------------------------------------------------------------
wreg_bit macro m#varout,m#bitout
 NOLIST
	s@b m#varout
 LIST
	andlw 1
	skpnz
	bcf m#varout,m#bitout
	skpz
	bsf m#varout,m#bitout
 NOLIST
	r@b	
 LIST
	endm
;-------------------------------------------------------------------------------------------------
wreg_word macro m#wordout
 NOLIST
	s@b m#wordout
 LIST
	movwf m#wordout
 NOLIST
	s@b m#wordout + 1
 LIST
	clrf m#wordout + 1
 NOLIST
	r@b	
 LIST
	endm
;-------------------------------------------------------------------------------------------------
wreg_dword macro m#dwordout
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
	s@b m#dwordout
 LIST
	movwf m#dwordout
 NOLIST
	r@b	
 LIST
	endm
;-------------------------------------------------------------------------------------------------
byte_wreg macro m#bytein
 NOLIST
	s@b m#bytein
 LIST
	movfw m#bytein
 NOLIST
	r@b	
 LIST
	endm
;-------------------------------------------------------------------------------------------------
num_wreg macro m#numin
 LIST
	movlw (m#numin & 255)
	endm
;-------------------------------------------------------------------------------------------------
num_byte macro m#numin,m#byteout
 NOLIST
 s@b m#byteout
 LIST
	movlw m#numin
	movwf m#byteout
 NOLIST
	r@b	
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
	r@b	
 LIST
	endm
;-------------------------------------------------------------------------------------------------
num_word macro m#numin,m#wordout	
 NOLIST
 s@b m#wordout
 LIST
	movlw (m#numin & 255)
	movwf m#wordout
 NOLIST
 s@b m#wordout + 1
 LIST
	movlw ((m#numin >> 8) & 255)
	movwf m#wordout + 1
 NOLIST
	r@b
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
	clrw
	btfsc m#varin,m#bitin
	movlw 1
 NOLIST
	r@b	
 LIST
	endm
;-------------------------------------------------------------------------------------------------
 NOLIST
bit_byte macro m#varin,m#bitin,m#byteout
 NOLIST
	s@b m#varin
 LIST
	clrw
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
	if((m#varin & 65408) == (m#varout & 65408))
 NOLIST
	s@b m#varout
 LIST
	btfsc m#varin,m#bitin
	bsf m#varout,m#bitout
	btfss m#varin,m#bitin
	bcf m#varout,m#bitout
 NOLIST
	else
 NOLIST
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
 NOLIST
	s@b m#bytein
 LIST
	movfw m#bytein
 NOLIST
	s@b m#byteout
 LIST
	movwf m#byteout
 NOLIST
	r@b
 LIST	
	endm
;-------------------------------------------------------------------------------------------------
byte_word macro m#bytein,m#wordout
 NOLIST
	s@b m#wordout + 1
 LIST
	clrf m#wordout + 1
 NOLIST
	byte_byte m#bytein,m#wordout
 LIST
	endm
;-------------------------------------------------------------------------------------------------
byte_dword macro m#bytein,m#dwordout
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
	byte_byte m#bytein,m#dwordout
 LIST
	endm
;-------------------------------------------------------------------------------------------------
byte_bit macro m#bytein,m#varout,m#bitout
 NOLIST
	if((m#bytein & 65408) == (m#varout & 65408))
 NOLIST
	s@b m#bytein
 LIST
	btfsc m#bytein,0
	bsf m#varout,m#bitout
	btfss m#bytein,0
	bcf m#varout,m#bitout
 NOLIST
	else
 NOLIST
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
 NOLIST
	r@b	
 LIST
	endm
;-------------------------------------------------------------------------------------------------
word_wreg macro m#wordin
 NOLIST
	byte_wreg m#wordin
 LIST
	endm
;-------------------------------------------------------------------------------------------------
word_byte macro m#wordin,m#byteout
 NOLIST
	byte_byte m#wordin,m#byteout
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
 NOLIST
 	if(m#wordin != m#wordout)
 NOLIST
	s@b m#wordin + 1
 LIST
	movfw m#wordin + 1
 NOLIST
	s@b m#wordout + 1
 LIST
	movwf m#wordout + 1
 NOLIST
	byte_byte m#wordin,m#wordout
 NOLIST
	endif
 LIST
	endm
;-------------------------------------------------------------------------------------------------
word_dword macro m#wordin,m#dwordout
 NOLIST
	s@b m#dwordout + 3
 LIST
	clrf m#dwordout + 3
 NOLIST
	s@b m#dwordout + 2
 LIST
	clrf m#dwordout + 2
 NOLIST
	byte_byte m#wordin + 1,m#dwordout + 1
 NOLIST
	byte_byte m#wordin,m#dwordout
 LIST
	endm
;-------------------------------------------------------------------------------------------------
dword_wreg macro m#dwordin
 NOLIST
	byte_wreg m#dwordin
 LIST
	endm
;-------------------------------------------------------------------------------------------------
dword_byte macro m#dwordin,m#byteout
 NOLIST
	byte_byte m#dwordin,m#byteout
 LIST
	endm
;-------------------------------------------------------------------------------------------------
dword_word macro m#dwordin,m#wordout
 NOLIST
	s@b m#dwordin + 1
 LIST
	movfw m#dwordin + 1
 NOLIST
	s@b m#wordout + 1
 LIST
	movwf m#wordout + 1
 NOLIST
	byte_byte m#dwordin,m#wordout
 LIST
	endm
;-------------------------------------------------------------------------------------------------
dword_dword macro m#dwordin,m#dwordout
 NOLIST
 	if(m#dwordin != m#dwordout)
 NOLIST
	byte_byte m#dwordin + 3,m#dwordout + 3
 NOLIST
	byte_byte m#dwordin + 2,m#dwordout + 2
 NOLIST
	byte_byte m#dwordin + 1,m#dwordout + 1
 NOLIST
	byte_byte m#dwordin,m#dwordout
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
; Macros for Library Manager
num_fsr macro m#numin
	num_byte m#numin, FSR 
 NOLIST
	if (((m#numin >> 8) & 255) == 1) 
 LIST
	bsf STATUS,7 
 NOLIST
	else
 LIST
	bcf STATUS,7
 NOLIST
	endif
 LIST
    endm
;-------------------------------------------------------------------------------------------------
label_word macro labelin,m#wordout  
    movlw (labelin & 255)
 NOLIST
    s@b m#wordout
 LIST
    movwf m#wordout
    movlw ((labelin >> 8) & 255)
    wreg_byte m#wordout + 1
    endm
 LIST
;[END@OF@MACROS]
 LIST
