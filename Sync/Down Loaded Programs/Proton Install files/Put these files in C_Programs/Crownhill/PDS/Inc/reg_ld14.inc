jump macro label
	goto label
	endm
;-------------------------------------------------------------------------------------------------
wreg_byte macro m#byteout
    s@b m#byteout
    movwf m#byteout
    r@b							; Reset the bank when the macro is finished
    endm
;-------------------------------------------------------------------------------------------------
wreg_bit macro m#varout,m#bitout
    s@b m#varout
    andlw 1
    skpnz
    bcf m#varout,m#bitout
    skpz
    bsf m#varout,m#bitout
    r@b							; Reset the bank when the macro is finished
    endm
;-------------------------------------------------------------------------------------------------
wreg_word macro m#wordout
    s@b m#wordout
    movwf m#wordout
    s@b m#wordout + 1
    clrf m#wordout + 1
    r@b							; Reset the bank when the macro is finished
    endm
;-------------------------------------------------------------------------------------------------
wreg_dword macro m#dwordout
    s@b m#dwordout + 3
    clrf m#dwordout + 3
    s@b m#dwordout + 2
    clrf m#dwordout + 2
    s@b m#dwordout + 1
    clrf m#dwordout + 1
    s@b m#dwordout
    movwf m#dwordout
    r@b							; Reset the bank when the macro is finished
    endm
;-------------------------------------------------------------------------------------------------
byte_wreg macro m#bytein
    s@b m#bytein
    movfw m#bytein
    r@b							; Reset the bank when the macro is finished
    endm
;-------------------------------------------------------------------------------------------------
num_wreg macro m#numin
    movlw (m#numin & 255)
    endm
;-------------------------------------------------------------------------------------------------
num_byte macro m#numin,m#byteout
    s@b m#byteout
    NOLIST
    if(m#numin == 0)
    	LIST
    	clrf m#byteout
    	NOLIST
    else
    	LIST
    	movlw (m#numin & 255)
        movwf m#byteout
        NOLIST
    endif
    r@b							; Reset the bank when the macro is finished
    LIST
    endm
;-------------------------------------------------------------------------------------------------
num_bit macro m#numin,m#varout,m#bitout
    NOLIST
    s@b m#varout
    if((m#numin & 1) == 1)
    	LIST
    	bsf m#varout,m#bitout
    	NOLIST
    else
    	LIST
    	bcf m#varout,m#bitout
    	NOLIST
        endif
    r@b							; Reset the bank when the macro is finished
    LIST
    endm
;-------------------------------------------------------------------------------------------------
num_word macro m#numin,m#wordout
    NOLIST
    if((m#numin & 255) == 0)
    	s@b m#wordout
        LIST
        clrf m#wordout
        NOLIST
    else
    	s@b m#wordout
    	LIST
        movlw (m#numin & 255)
        movwf m#wordout
        NOLIST
    endif
    if(((m#numin >> 8) & 255) == 0)
    	s@b m#wordout + 1
        LIST
        clrf m#wordout + 1
        NOLIST
    else
    	s@b m#wordout + 1
    	LIST
        movlw ((m#numin >> 8) & 255)
        movwf m#wordout + 1
        NOLIST
    endif
    r@b							; Reset the bank when the macro is finished
    LIST
    endm
;-------------------------------------------------------------------------------------------------
num_dword macro m#numin,m#dwordout

    if ((m#numin >> 24 & 255) == 0)
        s@b m#dwordout + 3
    	clrf m#dwordout + 3
    else
        s@b m#dwordout + 3
    	movlw ((m#numin >> 24) & 255)
    	movwf m#dwordout + 3
    endif
 
    if( ((m#numin >> 16) & 255) == 0)
        s@b m#dwordout + 2
    	clrf m#dwordout + 2
    else
        s@b m#dwordout + 2
    	movlw ((m#numin >> 16) & 255)
    	movwf m#dwordout + 2
    endif

    if( ((m#numin >> 8) & 255) == 0)
        s@b m#dwordout + 1
    	clrf m#dwordout + 1
    else
        s@b m#dwordout + 1
    	movlw ((m#numin >> 8) & 255)
    	movwf m#dwordout + 1
    endif

    if((m#numin & 255) == 0)
    	s@b m#dwordout
    	clrf m#dwordout
    else
    	s@b m#dwordout
    	movlw (m#numin & 255)
    	movwf m#dwordout
    endif
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
    if((m#varin & 65408) == (m#varout & 65408))
    	s@b m#varout
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
    s@b m#wordin + 1
    movfw m#wordin + 1
    s@b m#wordout + 1
    movwf m#wordout + 1
    byte_byte m#wordin,m#wordout
    endm
;-------------------------------------------------------------------------------------------------
word_dword macro m#wordin,m#dwordout
    s@b m#dwordout + 3
    clrf m#dwordout + 3
    s@b m#dwordout + 2
    clrf m#dwordout + 2
    byte_byte m#wordin + 1,m#dwordout + 1
    byte_byte m#wordin,m#dwordout
    endm
;-------------------------------------------------------------------------------------------------
byte_byte macro m#bytein,m#byteout
    s@b m#bytein
    movfw m#bytein
    s@b m#byteout
    movwf m#byteout
    r@b							; Reset the bank when the macro is finished
    endm
;-------------------------------------------------------------------------------------------------
byte_word macro m#bytein,m#wordout
    s@b m#wordout + 1
    clrf m#wordout + 1
    byte_byte m#bytein,m#wordout
    endm
;-------------------------------------------------------------------------------------------------
byte_dword macro m#bytein,m#dwordout
    s@b m#dwordout + 3
    clrf m#dwordout + 3
    s@b m#dwordout + 2
    clrf m#dwordout + 2
    s@b m#dwordout + 1
    clrf m#dwordout + 1
    byte_byte m#bytein,m#dwordout
    endm
;-------------------------------------------------------------------------------------------------
	byte_bit macro m#bytein,m#varout,m#bitout
    if((m#bytein & 65408) == (m#varout & 65408))
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
    s@b m#dwordin + 1
    movfw m#dwordin + 1
    s@b m#wordout + 1
    movwf m#wordout + 1
    byte_byte m#dwordin,m#wordout
	endm
;-------------------------------------------------------------------------------------------------
dword_dword macro m#dwordin,m#dwordout
    byte_byte m#dwordin + 3,m#dwordout + 3
    byte_byte m#dwordin + 2,m#dwordout + 2
    byte_byte m#dwordin + 1,m#dwordout + 1
    byte_byte m#dwordin,m#dwordout
	endm
;-------------------------------------------------------------------------------------------------
dword_bit macro m#dwordin,m#varout,m#bitout
    byte_bit m#dwordin,m#varout,m#bitout
	endm
;-------------------------------------------------------------------------------------------------	
Variable current@page = 0
Variable m#dest@page = 0
find@page macro	LabelIn

local current_addr = $
local dest_addr = LabelIn
	if((current_addr >= 0x1800) && (current_addr <= 0x2000))
 current@page = 3
	endif
	if((current_addr >= 0x1000) && (current_addr <= 0x1800))
 current@page = 2
	endif
	if((current_addr >= 0x0800) && (current_addr <= 0x1000))
 current@page = 1
	endif
	if((current_addr >= 0) && (current_addr <= 0x0800))
 current@page = 0
	endif

	if((dest_addr >= 0x1800) && (dest_addr <= 0x2000))
 m#dest@page = 3
	endif
	if((dest_addr >= 0x1000) && (dest_addr <= 0x1800))
 m#dest@page = 2
	endif
	if((dest_addr >= 0x0800) && (dest_addr <= 0x1000))
 m#dest@page = 1
	endif
	if((dest_addr >= 0) && (dest_addr <= 0x0800))
 m#dest@page = 0
	endif
	endm
;-------------------------------------------------------------------------------------------------
; Macros for Library Manager
num_fsr MACRO m#numin
	num_byte m#numin, FSR 
	if (((m#numin >> 8) & 255) == 1) 
		bsf STATUS,7 
	else
		bcf STATUS,7
	endif
    ENDM
;-------------------------------------------------------------------------------------------------
label_word MACRO labelin,m#wordout  
    movlw (labelin & 255)
    s@b m#wordout
    movwf m#wordout
    movlw ((labelin >> 8) & 255)
    wreg_byte m#wordout + 1
    ENDM
;-------------------------------------------------------------------------------------------------