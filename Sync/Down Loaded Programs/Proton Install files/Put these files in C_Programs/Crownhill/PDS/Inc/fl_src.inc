 NOLIST
;       PICmicro 32 BIT FLOATING POINT LIBRARY
;		For 16-bit core devices
;       Unary operations: both input and output are in PBP_AARG
;
;       Binary operations: input in PBP_AARG and PBP_BARG with output in PBP_AARG
;
;       All routines return WREG = 0 for successful completion, and WREG = 255
;       for an error condition specified in _FP_FLAGS.
;
;       NRM@3232   	32 bit normalization of unnormalised 32 bit floating point numbers
;       FLO@3232S 	32 bit integer to 32 bit floating point conversion
;       NRM@4032 	32 bit normalization of unnormalised 40 bit floating point numbers
;       INT@3232    32 bit floating point to 32 bit integer conversion
;       FPA@32		32 bit floating point add
;       FPS@32		32 bit floating point subtract
;       FPM@32		32 bit floating point multiply

;**********************************************************************************************
;**********************************************************************************************
;       32 bit floating point representation
;       EXPONENT        8 bit biased exponent
;
;		     It is important to note that the use of biased exponents produces
;		     a unique representation of a floating point 0, given by
;		     PBP_AARG = HIGHBYTE = MIDBYTE = LOWBYTE = 0, with 0 being
;		     the only number with PBP_AARG = 0.
;
;       HIGHBYTE        8 bit most significant byte of fraction in sign-magnitude representation,
;		    	 		with _SIGN = 7, implicit 7 = 1 and radix point to the right of 7
;
;       MIDBYTE         8 bit middle significant byte of sign-magnitude fraction
;
;       LOWBYTE         8 bit least significant byte of sign-magnitude fraction
;
;       EXPONENT        HIGHBYTE        MIDBYTE         LOWBYTE
;
;       xxxxxxxx        S.xxxxxxx       xxxxxxxx        xxxxxxxx
;		      |
;		    RADIX
;		    POINT
;**********************************************************************************************
;	Floating Point Relation	A != B (NOT EQUAL)
;	Input:	32 bit floating point number in PBP_AARG, PBP_AARGH, PBP_AARGHH, PBP_AARGHHH
;			32 bit floating point number in PBP_BARG, PBP_BARGH, PBP_BARGHH, PBP_BARGHHH
;	Use:	CALL	TANEB32
;	Output:	logical result in WREG
;----------------------------------------------------------------------------------------------
ifdef TANEB@32_REQ
 LIST	
TANEB@32
		Movf		PBP_AARG,W
		Cpfseq		PBP_BARG
		Retlw		1
		Movf		PBP_AARGH,W
		Cpfseq		PBP_BARGH
		Retlw		1
		Movf		PBP_AARGHH,W
		Cpfseq		PBP_BARGHH
		Retlw		1
		Movf		PBP_AARGHHH,W
		Cpfseq		PBP_BARGHHH
		Retlw		1
		Retlw		0
 NOLIST
endif

 NOLIST
ifdef TAEQB@32_REQ
;**********************************************************************************************
;	Floating Point Relation	A == B (EQUAL)
;	Input:	32 bit floating point number in PBP_AARG, PBP_AARGH, PBP_AARGHH, PBP_AARGHHH
;			32 bit floating point number in PBP_BARG, PBP_BARGH, PBP_BARGHH, PBP_BARGHHH
;	Use:	CALL	TAEQB32
;	Output:	logical result in WREG
;----------------------------------------------------------------------------------------------
 LIST	
TAEQB@32
		Movf		PBP_AARG,W
		Cpfseq		PBP_BARG
		Retlw		0
		Movf		PBP_AARGH,W
		Cpfseq		PBP_BARGH
		Retlw		0
		Movf		PBP_AARGHH,W
		Cpfseq		PBP_BARGHH
		Retlw		0
		Movf		PBP_AARGHHH,W
		Cpfseq		PBP_BARGHHH
		Retlw		0
		Retlw		1
 NOLIST
endif

 NOLIST
ifdef TAGEB@32_REQ
;**********************************************************************************************
;	Floating Point Relation	A >= B
;	Input:	32 bit floating point number in PBP_AARG, PBP_AARGH, PBP_AARGHH, PBP_AARGHHH
;			32 bit floating point number in PBP_BARG, PBP_BARGH, PBP_BARGHH, PBP_BARGHHH
;	Use:	CALL	TAGEB@32
;	Output:	logical result in W
;	Result:	if A >= B TRUE,	 W = 1
;			if A >= B FALSE, W = 0
;----------------------------------------------------------------------------------------------
 LIST
TAGEB@32		
		MOVF		PBP_BARGH,W
		XORWF		PBP_AARGH,W
		MOVWF		_FP_TEMPB0
		BTFSC		_FP_TEMPB0,7
		BRA			TAGEB@32O
		BTFSC		PBP_BARGH,7
		BRA			TAGEB@32N
TAGEB@32P	
		MOVF		PBP_BARG,W
		SUBWF		PBP_AARG,W
		BTFSS		STATUS,C
		RETLW		0
		BTFSS		STATUS,Z
		RETLW		1
		MOVF		PBP_BARGH,W
		SUBWF		PBP_AARGH,W
		BTFSS		STATUS,C
		RETLW		0
		BTFSS		STATUS,Z
		RETLW		1
		MOVF		PBP_BARGHH,W
		SUBWF		PBP_AARGHH,W
		BTFSS		STATUS,C
		RETLW		0
		BTFSS		STATUS,Z
		RETLW		1
		MOVF		PBP_BARGHHH,W
		SUBWF		PBP_AARGHHH,W
		BTFSS		STATUS,C
		RETLW		0
		RETLW		1
TAGEB@32N	
		MOVF		PBP_AARG,W
		SUBWF		PBP_BARG,W
		BTFSS		STATUS,C
		RETLW		0
		BTFSS		STATUS,Z
		RETLW		1
		MOVF		PBP_AARGH,W
		SUBWF		PBP_BARGH,W
		BTFSS		STATUS,C
		RETLW		0
		BTFSS		STATUS,Z
		RETLW		1
		MOVF		PBP_AARGHH,W
		SUBWF		PBP_BARGHH,W
		BTFSS		STATUS,C
		RETLW		0
		BTFSS		STATUS,Z
		RETLW		1
		MOVF		PBP_AARGHHH,W
		SUBWF		PBP_BARGHHH,W
		BTFSS		STATUS,C
		RETLW		0
		RETLW		1
TAGEB@32O	
		BTFSS		PBP_AARGH,7
		RETLW		1
		RETLW		0
 NOLIST
endif
 NOLIST
ifdef TALEB@32_REQ 
;**********************************************************************************************
;**********************************************************************************************
;	Floating Point Relation	A <= B
;	Input:	32 bit floating point number in PBP_AARG, PBP_AARGH, PBP_AARGHH, PBP_AARGHHH
;			32 bit floating point number in PBP_BARG, PBP_BARGH, PBP_BARGHH, PBP_BARGHHH
;	Use:	CALL	TALEB@32
;	Output:	logical result in W
;	Result:	if A <= B TRUE,	 W = 1
;			if A <= B FALSE, W = 0
;----------------------------------------------------------------------------------------------
 LIST
TALEB@32		
		MOVF		PBP_AARGH,W
		XORWF		PBP_BARGH,W
		MOVWF		_FP_TEMPB0
		BTFSC		_FP_TEMPB0,7
		BRA			TALEB@32O
		BTFSC		PBP_AARGH,7
		BRA			TALEB@32N
TALEB@32P	
		MOVF		PBP_AARG,W
		SUBWF		PBP_BARG,W
		BTFSS		STATUS,C
		RETLW		0
		BTFSS		STATUS,Z
		RETLW		1
		MOVF		PBP_AARGH,W
		SUBWF		PBP_BARGH,W
		BTFSS		STATUS,C
		RETLW		0
		BTFSS		STATUS,Z
		RETLW		1
		MOVF		PBP_AARGHH,W
		SUBWF		PBP_BARGHH,W
		BTFSS		STATUS,C
		RETLW		0
		BTFSS		STATUS,Z
		RETLW		1
		MOVF		PBP_AARGHHH,W
		SUBWF		PBP_BARGHHH,W
		BTFSS		STATUS,C
		RETLW		0
		RETLW		1
TALEB@32N	
		MOVF		PBP_BARG,W
		SUBWF		PBP_AARG,W
		BTFSS		STATUS,C
		RETLW		0
		BTFSS		STATUS,Z
		RETLW		1
		MOVF		PBP_BARGH,W
		SUBWF		PBP_AARGH,W
		BTFSS		STATUS,C
		RETLW		0
		BTFSS		STATUS,Z
		RETLW		1
		MOVF		PBP_BARGHH,W
		SUBWF		PBP_AARGHH,W
		BTFSS		STATUS,C
		RETLW		0
		BTFSS		STATUS,Z
		RETLW		1
		MOVF		PBP_BARGHHH,W
		SUBWF		PBP_AARGHHH,W
		BTFSS		STATUS,C
		RETLW		0
		RETLW		1
TALEB@32O	
		BTFSS		PBP_BARGH,7
		RETLW		1
		RETLW		0
 NOLIST
endif

 NOLIST
ifdef TAGTB@32_REQ
;**********************************************************************************************
;	Floating Point Relation	A > B
;	Input:	32 bit floating point number in PBP_AARG, PBP_AARGH, PBP_AARGHH, PBP_AARGHHH
;			32 bit floating point number in PBP_BARG, PBP_BARGH, PBP_BARGHH, PBP_BARGHHH
;	Use:	CALL	TAGTB@32
;	Output:	logical result in W
;	Result:	if A > B TRUE,	 W = 1
;			if A > B FALSE, W = 0
;----------------------------------------------------------------------------------------------
 LIST	
TAGTB@32		
		MOVF		PBP_BARGH,W
		XORWF		PBP_AARGH,W
		MOVWF		_FP_TEMPB0
		BTFSC		_FP_TEMPB0,7
		BRA			TAGTB@32O
		BTFSC		PBP_BARGH,7
		BRA			TAGTB@32N
TAGTB@32P	
		MOVF		PBP_BARG,W
		SUBWF		PBP_AARG,W
		BTFSS		STATUS,C
		RETLW		0
		BTFSS		STATUS,Z
		RETLW		1
		MOVF		PBP_BARGH,W
		SUBWF		PBP_AARGH,W
		BTFSS		STATUS,C
		RETLW		0
		BTFSS		STATUS,Z
		RETLW		1
		MOVF		PBP_BARGHH,W
		SUBWF		PBP_AARGHH,W
		BTFSS		STATUS,C
		RETLW		0
		BTFSS		STATUS,Z
		RETLW		1
		MOVF		PBP_BARGHHH,W
		SUBWF		PBP_AARGHHH,W
		BTFSS		STATUS,C
		RETLW		0
		BTFSS		STATUS,Z
		RETLW		1
		RETLW		0
TAGTB@32N	
		MOVF		PBP_AARG,W
		SUBWF		PBP_BARG,W
		BTFSS		STATUS,C
		RETLW		0
		BTFSS		STATUS,Z
		RETLW		1
		MOVF		PBP_AARGH,W
		SUBWF		PBP_BARGH,W
		BTFSS		STATUS,C
		RETLW		0
		BTFSS		STATUS,Z
		RETLW		1
		MOVF		PBP_AARGHH,W
		SUBWF		PBP_BARGHH,W
		BTFSS		STATUS,C
		RETLW		0
		BTFSS		STATUS,Z
		RETLW		1
		MOVF		PBP_AARGHHH,W
		SUBWF		PBP_BARGHHH,W
		BTFSS		STATUS,C
		RETLW		0
		BTFSS		STATUS,Z
		RETLW		1
		RETLW		0
TAGTB@32O	
		BTFSS		PBP_AARGH,7
		RETLW		1
		RETLW		0
 NOLIST
endif

 NOLIST
ifdef TALTB@32_REQ	
;**********************************************************************************************
;	Floating Point Relation	A < B
;	Input:	32 bit floating point number in PBP_AARG, PBP_AARGH, PBP_AARGHH, PBP_AARGHHH
;			32 bit floating point number in PBP_BARG, PBP_BARGH, PBP_BARGHH, PBP_BARGHHH
;	Use:	CALL	TALTB@32
;	Output:	logical result in W
;	Result:	if A < B TRUE,	 W = 1
;			if A < B FALSE, W = 0
;----------------------------------------------------------------------------------------------
 LIST	
TALTB@32		
		MOVF		PBP_AARGH,W
		XORWF		PBP_BARGH,W
		MOVWF		_FP_TEMPB0
		BTFSC		_FP_TEMPB0,7
		BRA			TALTB@32O
		BTFSC		PBP_AARGH,7
		BRA			TALTB@32N
TALTB@32P	
		MOVF		PBP_AARG,W
		SUBWF		PBP_BARG,W
		BTFSS		STATUS,C
		RETLW		0
		BTFSS		STATUS,Z
		RETLW		1
		MOVF		PBP_AARGH,W
		SUBWF		PBP_BARGH,W
		BTFSS		STATUS,C
		RETLW		0
		BTFSS		STATUS,Z
		RETLW		1
		MOVF		PBP_AARGHH,W
		SUBWF		PBP_BARGHH,W
		BTFSS		STATUS,C
		RETLW		0
		BTFSS		STATUS,Z
		RETLW		1
		MOVF		PBP_AARGHHH,W
		SUBWF		PBP_BARGHHH,W
		BTFSS		STATUS,C
		RETLW		0
		BTFSS		STATUS,Z
		RETLW		1
		RETLW		0
TALTB@32N	
		MOVF		PBP_BARG,W
		SUBWF		PBP_AARG,W
		BTFSS		STATUS,C
		RETLW		0
		BTFSS		STATUS,Z
		RETLW		1
		MOVF		PBP_BARGH,W
		SUBWF		PBP_AARGH,W
		BTFSS		STATUS,C
		RETLW		0
		BTFSS		STATUS,Z
		RETLW		1
		MOVF		PBP_BARGHH,W
		SUBWF		PBP_AARGHH,W
		BTFSS		STATUS,C
		RETLW		0
		BTFSS		STATUS,Z
		RETLW		1
		MOVF		PBP_BARGHHH,W
		SUBWF		PBP_AARGHHH,W
		BTFSS		STATUS,C
		RETLW		0
		BTFSS		STATUS,Z
		RETLW		1
		RETLW		0
TALTB@32O	
		BTFSS		PBP_BARGH,7
		RETLW		1
		RETLW		0
 NOLIST
endif

 NOLIST
ifdef FPS@32_REQ
;**********************************************************************************************
; 32-bit floating point subtraction
; value 1 in PBP_AARG / PBP_AARGH / PBP_AARGHH / PBP_AARGHHH
;
; value 2 in PBP_AARG / PBP_AARGH / PBP_AARGHH / PBP_AARGHHH
;
; Result returned in PBP_AARG / PBP_AARGH / PBP_AARGHH / PBP_AARGHHH

; PBP_AARG... = PBP_AARG... - PBP_BARG...

; Example: -
;		MOVFF FLOATIN1,PBP_AARG
;		MOVFF FLOATIN1H,PBP_AARGH
;		MOVFF FLOATIN1HH,PBP_AARGHH
;		MOVFF FLOATIN1HHH,PBP_AARGHHH
		
;       MOVFF FLOATIN2,PBP_BARG
;		MOVFF FLOATIN2H,PBP_BARGH
;		MOVFF FLOATIN2HH,PBP_BARGHH
;		MOVFF FLOATIN2HHH,PBP_BARGHHH
        
;        CALL FPS@32
		
;       MOVFF PBP_AARGHHH,FLOATOUTHHH
;		MOVFF PBP_AARGHH,FLOATOUTHH
;		MOVFF PBP_AARGH,FLOATOUTH
;		MOVFF PBP_AARG,FLOATOUT

; SYSTEM VARIABLES USED
; PBP_AARG,PBP_AARGH,PBP_AARGHH,PBP_AARGHHH
; PBP_BARG,PBP_BARGH,PBP_BARGHH,PBP_BARGHHH
; _AEXP, _BEXP

 LIST
	FPA@32_REQ = 1
FPS@32   
		MOVLW		0x80
		XORWF		PBP_BARGH,F
 NOLIST
endif

 NOLIST
ifdef FPA@32_REQ
;**********************************************************************************************
; 32-bit floating point addition
; value 1 in PBP_AARG / PBP_AARGH / PBP_AARGHH / PBP_AARGHHH
;
; value 2 in PBP_AARG / PBP_AARGH / PBP_AARGHH / PBP_AARGHHH
;
; Result returned in PBP_AARG / PBP_AARGH / PBP_AARGHH / PBP_AARGHHH

; PBP_AARG... = PBP_AARG... + PBP_BARG...

; Example: -
;		MOVFF FLOATIN1,PBP_AARG
;		MOVFF FLOATIN1H,PBP_AARGH
;		MOVFF FLOATIN1HH,PBP_AARGHH
;		MOVFF FLOATIN1HHH,PBP_AARGHHH
		
;       MOVFF FLOATIN2,PBP_BARG
;		MOVFF FLOATIN2H,PBP_BARGH
;		MOVFF FLOATIN2HH,PBP_BARGHH
;		MOVFF FLOATIN2HHH,PBP_BARGHHH
        
;        CALL FPA@32
		
;       MOVFF PBP_AARGHHH,FLOATOUTHHH
;		MOVFF PBP_AARGHH,FLOATOUTHH
;		MOVFF PBP_AARGH,FLOATOUTH
;		MOVFF PBP_AARG,FLOATOUT

; SYSTEM VARIABLES USED
; PBP_AARG,PBP_AARGH,PBP_AARGHH,PBP_AARGHHH
; PBP_BARG,PBP_BARGH,PBP_BARGHH,PBP_BARGHHH
; _AEXP, _BEXP
; _FP_TEMP, _FP_FLAGS, _SIGN

 LIST	        
FPA@32			
	MOVF PBP_BARG,W,0					
	SUBWF PBP_AARG,W,0
	MOVWF _BEXP,0			
	BC fl@add_1								
	NEGF _BEXP,0									
	MOVFF PBP_AARG,_FP_TEMP						
	MOVFF PBP_BARG,PBP_AARG							
	MOVFF _FP_TEMP,PBP_BARG						
	MOVFF PBP_AARGH,_FP_TEMP						
	MOVFF PBP_BARGH,PBP_AARGH					
	MOVFF _FP_TEMP,PBP_BARGH						
	MOVFF PBP_AARGHH,_FP_TEMP								
	MOVFF PBP_BARGHH,PBP_AARGHH						
	MOVFF _FP_TEMP,PBP_BARGHH							
	MOVFF PBP_AARGHHH,_FP_TEMP							
	MOVFF PBP_BARGHHH,PBP_AARGHHH						
	MOVFF _FP_TEMP,PBP_BARGHHH								
fl@add_1	
	MOVLW 26
	CPFSLT _BEXP,0						
	BRA fl@add_RETURN			
	MOVF PBP_BARG,F,0					
	BZ fl@add_RETURN			
	CLRF _AEXP,0									
	MOVF PBP_AARGH,W,0							
	MOVWF _FP_TEMP,0									
	XORWF PBP_BARGH,W,0					
	MOVWF _SIGN,0			
	BSF PBP_AARGH,7,0								
	BSF PBP_BARGH,7,0										
fl@add_2	
	MOVLW 8											
	SUBWF _BEXP,F,0						
	BNC fl@add_3								
	MOVFF PBP_BARGHHH,_AEXP							
	MOVFF PBP_BARGHH,PBP_BARGHHH						
	MOVFF PBP_BARGH,PBP_BARGHH						
	CLRF PBP_BARGH,0					
	BRA fl@add_2			
fl@add_3	
	ADDWF _BEXP,F,0								
	BZ fl@add_5						 			
fl@add_4	
	BCF STATUS,C,0								
	RRCF PBP_BARGH,F,0					
	RRCF PBP_BARGHH,F,0
	RRCF PBP_BARGHHH,F,0			
	RRCF _AEXP,F,0									
	DECFSZ _BEXP,F,0						
	BRA fl@add_4
fl@add_5	
	BTFSS _SIGN,7,0					
	BRA fl@add_11			
	MOVF PBP_BARGHHH,W,0					
	SUBWF PBP_AARGHHH,F,0			
	MOVF PBP_BARGHH,W,0					
	SUBWFB PBP_AARGHH,F,0			
	MOVF PBP_BARGH,W,0					
	SUBWFB PBP_AARGH,F,0			
	BC fl@add_6								
	BSF STATUS,C,0						
	MOVLW 0
	SUBFWB PBP_AARGHHH,F,0
	SUBFWB PBP_AARGHH,F,0
	SUBFWB PBP_AARGH,F,0			
	MOVLW 128
	XORWF _FP_TEMP,F,0									
fl@add_6	
	NEGF _AEXP,0									
	BZ fl@add_7									
	DECF PBP_AARGHHH,F,0					
	MOVLW 0
	SUBWFB PBP_AARGHH,F,0
	SUBWFB PBP_AARGH,F,0			
fl@add_7	
	MOVLW 4								
	MOVWF _BEXP,0			
fl@add_8	
	TSTFSZ PBP_AARGH,0					
	BRA fl@add_9			
	MOVFF PBP_AARGHH,PBP_AARGH						
	MOVFF PBP_AARGHHH,PBP_AARGHH						
	MOVFF _AEXP,PBP_AARGHHH							
	CLRF _AEXP,0										
	MOVLW 8
	SUBWF PBP_AARG,F,0						
	BNC fl@add_RES0
	DECFSZ _BEXP,F,0	
	BRA fl@add_8						 
	BRA fl@add_RES0			
fl@add_9	
	BTFSC PBP_AARGH,7,0					
	BRA fl@add_10						
	BCF STATUS,C,0						
	RLCF _AEXP,F,0			
	RLCF PBP_AARGHHH,F,0					
	RLCF PBP_AARGHH,F,0
	RLCF PBP_AARGH,F,0			
	DECFSZ PBP_AARG,F,0							
	BRA fl@add_9						
	BRA fl@add_RES0			
fl@add_10	
	BTFSS _FP_FLAGS,6,0			
	BRA fl@add_SET_SIGN
	BTFSS _AEXP,7,0
	BRA fl@add_SET_SIGN		
	CLRF _AEXP,0							
	BRA fl@add_INCREMENT			
fl@add_11	
	MOVF PBP_BARGHHH,W,0					
	ADDWF PBP_AARGHHH,F,0			
	MOVF PBP_BARGHH,W,0					
	ADDWFC PBP_AARGHH,F,0			
	MOVF PBP_BARGH,W,0					
	ADDWFC PBP_AARGH,F,0			
	BNC fl@add_13									
fl@add_ADJUST_RIGHT	
	RRCF PBP_AARGH,F,0					
	RRCF PBP_AARGHH,F,0
	RRCF PBP_AARGHHH,F,0			
	RRCF _AEXP,F,0									
	INFSNZ PBP_AARG,F,0						
	BRA fl@add_OVERFLOW								
fl@add_13	
	BTFSS _FP_FLAGS,6,0			
	BRA fl@add_SET_SIGN
	BTFSS _AEXP,7,0
	BRA fl@add_SET_SIGN			
fl@add_INCREMENT	
	INCFSZ PBP_AARGHHH,F,0				
	BRA fl@add_SET_SIGN					
	INCFSZ PBP_AARGHH,F,0								
	BRA fl@add_SET_SIGN							
	INCFSZ PBP_AARGH,F,0						
	BRA fl@add_SET_SIGN								
	BSF STATUS,C,0
	BCF PBP_AARGHHH,0,0									
	BRA fl@add_ADJUST_RIGHT							
fl@add_RES0	
	CLRF PBP_AARG,0					
	BRA fl@add_MANTISSA			
fl@add_OVERFLOW	
	BSF _FP_FLAGS,1,0				
	SETF PBP_AARG,0							
fl@add_MANTISSA	
	CLRF PBP_AARGHHH,0						
	CLRF PBP_AARGHH,0
	MOVLW 128
	MOVWF PBP_AARGH,0			
fl@add_SET_SIGN	
	BTFSS _FP_TEMP,7,0									
	BCF PBP_AARGH,7,0							
fl@add_RETURN	
	MOVF PBP_AARGHHH,W,0					
	RETURN
 NOLIST
endif

 NOLIST
ifdef FPD@32_REQ
;**********************************************************************************************
; 32-bit floating point division
; value 1 in PBP_AARG / PBP_AARGH / PBP_AARGHH / PBP_AARGHHH
;
; value 2 in PBP_BARG / PBP_AARGH / PBP_AARGHH / PBP_AARGHHH
;
; Result returned in PBP_AARG / PBP_AARGH / PBP_AARGHH / PBP_AARGHHH

; PBP_AARG = PBP_AARG / PBP_BARG

; Example: -
;		MOVFF FLOATIN1,PBP_AARG
;		MOVFF FLOATIN1H,PBP_AARGH
;		MOVFF FLOATIN1HH,PBP_AARGHH
;		MOVFF FLOATIN1HHH,PBP_AARGHHH
		
;       MOVFF FLOATIN2,PBP_BARG
;		MOVFF FLOATIN2H,PBP_BARGH
;		MOVFF FLOATIN2HH,PBP_BARGHH
;		MOVFF FLOATIN2HHH,PBP_BARGHHH
        
;        RCALL FPD@32
		
;       MOVFF PBP_AARGHHH,FLOATOUTHHH
;		MOVFF PBP_AARGHH,FLOATOUTHH
;		MOVFF PBP_AARGH,FLOATOUTH
;		MOVFF PBP_AARG,FLOATOUT

; SYSTEM VARIABLES USED
; PBP_AARG,PBP_AARGH,PBP_AARGHH,PBP_AARGHHH
; PBP_BARG,PBP_BARGH,PBP_BARGHH,PBP_BARGHHH
; _FP_TEMP, _FP_FLAGS, _SIGN
; PPZ, PPZH, PPZHH

 LIST
FPD@32
	MOVF PBP_AARGH,W,0
	MOVWF PPZHH,0
	XORWF PBP_BARGH,W,0
	MOVWF _SIGN,0
	MOVF PBP_BARG,W,0
	BZ fl@div_Div0
	MOVF PBP_AARG,F,0
	BZ fl@div_RES0
	SUBWF PBP_AARG,F,0
	MOVLW 127
	BC fl@div_1
	ADDWF PBP_AARG,F,0
	BC fl@div_2
	BRA fl@div_UNDERFLOW
fl@div_1	
	ADDWF PBP_AARG,F,0
	BC fl@div_OVERFLOW1
fl@div_2	
	MOVFF PBP_AARGHHH,PPZ
	MOVFF PBP_AARGHH,PPZH
	BSF PPZHH,7,0
	BSF PBP_BARGH,7,0
	MOVLW 24
	MOVWF _FP_TEMP,0
	CLRF PBP_AARGHHH,0
	CLRF PBP_AARGHH,0
	CLRF PBP_AARGH,0
	BRA fp@div_START
fl@div_TEST_ZERO_L	
	MOVF PBP_BARGHHH,W,0
	SUBWF PPZ,W,0
	MOVF PBP_BARGHH,W,0
	SUBWFB PPZH,W,0
	BNC fl@div_SHIFT_IN_C
	MOVWF PPZH,0
	CLRF PPZHH,0
	MOVF PBP_BARGHHH,W,0
	SUBWF PPZ,F,0
	BRA fl@div_SET_AND_SHIFT_IN_C
fl@div_LOOP	
	BC fl@div_6
fp@div_START	
	MOVF PBP_BARGH,W,0
	SUBWF PPZHH,W,0
	BZ fl@div_TEST_ZERO_L
	BNC fl@div_SHIFT_IN_C
fl@div_6	
	MOVF PBP_BARGHHH,W,0
	SUBWF PPZ,F,0
	MOVF PBP_BARGHH,W,0
	SUBWFB PPZH,F,0
	MOVF PBP_BARGH,W,0
	SUBWFB PPZHH,F,0
fl@div_SET_AND_SHIFT_IN_C	
	BSF STATUS,C,0
fl@div_SHIFT_IN_C	
	RLCF PBP_AARGHHH,F,0
	RLCF PBP_AARGHH,F,0
	RLCF PBP_AARGH,F,0
	RLCF PPZ,F,0
	RLCF PPZH,F,0
	RLCF PPZHH,F,0
	DECFSZ _FP_TEMP,F,0
	BRA fl@div_LOOP
	BTFSC PBP_AARGH,7,0
	BRA fl@div_9
	MOVF PBP_AARG,F,0
	BZ fl@div_UNDERFLOW
	RRCF _SIGN,F,0
	DECF PBP_AARG,F,0
	INCF _FP_TEMP,F,0
	RLCF _SIGN,F,0
	BRA fl@div_LOOP
fl@div_9	
	BTFSS _FP_FLAGS,6,0
	BRA fl@div_SET_SIGN
	BC fl@div_10
	MOVF PBP_BARGHHH,W,0
	SUBWF PPZ,F,0
	MOVF PBP_BARGHH,W,0
	SUBWFB PPZH,F,0
	MOVF PBP_BARGH,W,0
	SUBWFB PPZHH,F,0
	BNC fl@div_SET_SIGN
fl@div_10	
	INCFSZ PBP_AARGHHH,F,0
	BRA fl@div_SET_SIGN
	INCFSZ PBP_AARGHH,F,0
	BRA fl@div_SET_SIGN
	INCFSZ PBP_AARGH,F,0
	BRA fl@div_SET_SIGN
	RRCF PBP_AARGH,F,0
	RRCF PBP_AARGHH,F,0
	RRCF PBP_AARGHHH,F,0
	INCFSZ PBP_AARG,F,0
	BRA fl@div_SET_SIGN
	BRA fl@div_OVERFLOW1
fl@div_Div0	
	BSF _FP_FLAGS,3,0
	BRA fl@div_SATURATE
fl@div_UNDERFLOW	
	BSF _FP_FLAGS,2,0
fl@div_RES0	
	CLRF PBP_AARG,0
	BRA fl@div_MANTISSA
fl@div_OVERFLOW1	
	BSF _FP_FLAGS,1,0
fl@div_SATURATE	
	SETF PBP_AARG,0
fl@div_MANTISSA	
	CLRF PBP_AARGHHH,0
	CLRF PBP_AARGHH,0
	MOVLW 128
	MOVWF PBP_AARGH,0
fl@div_SET_SIGN	
	BTFSS _SIGN,7,0
	BCF PBP_AARGH,7,0
	MOVF PBP_AARGHHH,W,0
	RETURN
 NOLIST
endif

 NOLIST
ifdef FPM@32_REQ
;**********************************************************************************************
; 32-bit floating point multiply (optimised for size)
; value 1 in PBP_AARG / PBP_AARGH / PBP_AARGHH / PBP_AARGHHH
;
; value 2 in PBP_BARG / PBP_AARGH / PBP_AARGHH / PBP_AARGHHH
;
; Result returned in PBP_AARG / PBP_AARGH / PBP_AARGHH / PBP_AARGHHH

; PBP_AARG = PBP_AARG * PBP_BARG

; Example: -
;		MOVFF FLOATIN1,PBP_AARG
;		MOVFF FLOATIN1H,PBP_AARGH
;		MOVFF FLOATIN1HH,PBP_AARGHH
;		MOVFF FLOATIN1HHH,PBP_AARGHHH
		
;       MOVFF FLOATIN2,PBP_BARG
;		MOVFF FLOATIN2H,PBP_BARGH
;		MOVFF FLOATIN2HH,PBP_BARGHH
;		MOVFF FLOATIN2HHH,PBP_BARGHHH
        
;        RCALL FPM@32
		
;       MOVFF PBP_AARGHHH,FLOATOUTHHH
;		MOVFF PBP_AARGHH,FLOATOUTHH
;		MOVFF PBP_AARGH,FLOATOUTH
;		MOVFF PBP_AARG,FLOATOUT

; SYSTEM VARIABLES USED
; PBP_AARG,PBP_AARGH,PBP_AARGHH,PBP_AARGHHH
; PBP_BARG,PBP_BARGH,PBP_BARGHH,PBP_BARGHHH
; _FP_TEMP, _FP_FLAGS, _SIGN
; PPZ, PPZH, PPZHH

 LIST
FPM@32
	MOVF  PBP_AARGH,W,0
	MOVWF PPZHH,0
	XORWF PBP_BARGH,W,0
	MOVWF _SIGN,0
	MOVF  PBP_AARG,W,0
	BTFSS STATUS,Z,0
	MOVF  PBP_BARG,W,0
	BZ    fp@mul_RES0
	ADDWF PBP_AARG,F,0
	MOVLW 126
	BNC   fp@mul_1
	SUBWF PBP_AARG,F,0
	BNC   fp@mul_2
	BRA   fp@mul_OVERFLOW
fp@mul_1	
	SUBWF PBP_AARG,F,0
	BNC   fp@mul_UNDERFLOW
fp@mul_2	
	MOVFF PBP_AARGHHH,PPZ
	MOVFF PBP_AARGHH,PPZH
	BSF   PPZHH,7,0
	BSF   PBP_BARGH,7,0
	CLRF  PBP_AARGHHH,0
	CLRF  PBP_AARGHH,0
	CLRF  PBP_AARGH,0
	MOVLW 24
	MOVWF _FP_TEMP,0
fp@mul_3	
	RRCF  PPZHH,F,0
	RRCF  PPZH,F,0
	RRCF  PPZ,F,0
	BNC   fp@mul_4
	MOVF  PBP_BARGHHH,W,0
	ADDWF PBP_AARGHHH,F,0
	MOVF  PBP_BARGHH,W,0
	ADDWFC PBP_AARGHH,F,0
	MOVF  PBP_BARGH,W,0
	ADDWFC PBP_AARGH,F,0
fp@mul_4	
	RRCF  PBP_AARGH,F,0
	RRCF  PBP_AARGHH,F,0
	RRCF  PBP_AARGHHH,F,0
	DECFSZ _FP_TEMP,F,0
	BRA   fp@mul_3
	BTFSC PBP_AARGH,7,0
	BRA   fp@mul_5
	RLCF  PBP_AARGHHH,F,0
	RLCF  PBP_AARGHH,F,0
	RLCF  PBP_AARGH,F,0
	MOVF  PBP_AARG,F,0
	BZ    fp@mul_UNDERFLOW
	DECF  PBP_AARG,F,0
	RLCF  PPZHH,W,0
fp@mul_5	
	BTFSS _FP_FLAGS,6,0
	BRA   fp@mul_SET_SIGN
	BNC   fp@mul_SET_SIGN
	INCFSZ PBP_AARGHHH,F,0
	BRA   fp@mul_SET_SIGN
	INCFSZ PBP_AARGHH,F,0
	BRA   fp@mul_SET_SIGN
	INCFSZ PBP_AARGH,F,0
	BRA   fp@mul_SET_SIGN
	BSF   STATUS,C,0
	RRCF  PBP_AARGH,F,0
	RRCF  PBP_AARGHH,F,0
	RRCF  PBP_AARGHHH,F,0
	INCFSZ PBP_AARG,F,0
	BRA   fp@mul_SET_SIGN
	BRA   fp@mul_OVERFLOW
fp@mul_UNDERFLOW	
	BSF   _FP_FLAGS,2,0
fp@mul_RES0	
	CLRF  PBP_AARG,0
	BRA   fp@mul_MANTISSA
fp@mul_OVERFLOW	
	BSF   _FP_FLAGS,1,0
	SETF  PBP_AARG,0
fp@mul_MANTISSA	
	CLRF  PBP_AARGHHH,0
	CLRF  PBP_AARGHH,0
	MOVLW 128
	MOVWF PBP_AARGH,0
fp@mul_SET_SIGN	
	BTFSS _SIGN,7,0
	BCF   PBP_AARGH,7,0
	MOVF  PBP_AARGHHH,W,0
	RETURN
 NOLIST
endif

 NOLIST
ifdef INT@3232_REQ
;**********************************************************************************************	
; 32-bit Float to integer

; Float value in PBP_AARG / PBP_AARGH / PBP_AARGHH / PBP_AARGHHH 

; Integer value returned in PBP_AARGHHH / PBP_AARGHH / PBP_AARGH / PBP_AARG

; Example
;		MOVFF FLOATIN,PBP_AARG
;		MOVFF FLOATINH,PBP_AARGH
;		MOVFF FLOATINHH,PBP_AARGHH
;		MOVFF FLOATINHHH,PBP_AARGHHH
		
;        CALL _float32ToInt32
		
;       MOVFF PBP_AARGHHH,DWORDOUT
;		MOVFF PBP_AARGHH,DWORDOUTH
;		MOVFF PBP_AARGH,DWORDOUTHH
;		MOVFF PBP_AARG,DWORDOUTHHH

; SYSTEM VARIABLES USED
; PBP_AARG,PBP_AARGH,PBP_AARGHH,PBP_AARGHHH
; _FP_TEMP, _FP_FLAGS, _SIGN
; PPZ

LIST
INT@3232
	Movff PBP_AARGH,_SIGN					
	MOVLW 127					
	SUBWF PBP_AARG,W
	MOVWF _FP_TEMP 	
	BNC Fto@I_RES0							
	BSF PBP_AARGH,7						
	CLRF PBP_AARG					
	CLRF PPZ,0						
	SUBLW 23
	MOVWF _FP_TEMP							
	BC Fto@I_1							
	MOVLW 8
	ADDWF _FP_TEMP,F						
	BNC Fto@I_OVERFLOW					
	MOVFF PBP_AARGH,PBP_AARG			
	MOVFF PBP_AARGHH,PBP_AARGH			
	MOVFF PBP_AARGHHH,PBP_AARGHH					
	CLRF PBP_AARGHHH				
	BRA Fto@I_3			
Fto@I_1	
	MOVLW 8									
	SUBWF _FP_TEMP,F			
	BNC Fto@I_2							
	MOVFF PBP_AARGHHH,PPZ					
	MOVFF PBP_AARGHH,PBP_AARGHHH					
	MOVFF PBP_AARGH,PBP_AARGHH			
	CLRF PBP_AARGH			
	BRA Fto@I_1			
Fto@I_2	
	ADDWF _FP_TEMP,F					
Fto@I_3	
	MOVF _FP_TEMP,F
	BZ Fto@I_5											
Fto@I_4						
	BCF STATUS,C						
	RRCF PBP_AARG,F						
	RRCF PBP_AARGH,F			
	RRCF PBP_AARGHH,F
	RRCF PBP_AARGHHH,F			
	RRCF PPZ,F,0				
	DECFSZ _FP_TEMP,F
	BRA Fto@I_4							
Fto@I_5	
	BTFSC PBP_AARG,7		
	BRA Fto@I_OVERFLOW
	BTFSS _FP_FLAGS,6	
	BRA Fto@I_6
	BTFSS PPZ,7
	BRA Fto@I_6
	INCFSZ PBP_AARGHHH,F
	BRA Fto@I_6
	INCFSZ PBP_AARGHH,F
	BRA Fto@I_6
	INCFSZ PBP_AARGH,F
	BRA Fto@I_6			
	INCF PBP_AARGH,F						
	BTFSC PBP_AARG,7		
	BRA Fto@I_OVERFLOW			
Fto@I_6	
	BTFSS _SIGN,7			
	BRA Fto@I_RETURN			
	BSF STATUS,C				
	MOVLW 0
	SUBFWB PBP_AARGHHH,F
	SUBFWB PBP_AARGHH,F
	SUBFWB PBP_AARGH,F
	SUBFWB PBP_AARG,F
	BRA Fto@I_RETURN	
Fto@I_RES0	
	MOVLW 0
	BRA Fto@I_ASSIGNW			
Fto@I_OVERFLOW	
	BSF _FP_FLAGS,1				
	MOVLW 255								
Fto@I_ASSIGNW	
	MOVWF PBP_AARG						
	MOVWF PBP_AARGH						
	MOVWF PBP_AARGHH					
	MOVWF PBP_AARGHHH						
	BCF PBP_AARG,7						
Fto@I_RETURN	
	MOVF PBP_AARGHHH,W			
	RETURN
 NOLIST
endif

 NOLIST
ifdef FLO@0832U_REQ
;--------------------------------------------------------------------------------	
; Integer to 32-bit Float
;**********************************************************************************************
;       8 bit unsigned integer to 32 bit float conversion
;       Input:  8 bit unsigned integer in WREG
;       Use:    CALL    FLO@0832U
;       Output: 32 bit floating point number in PBP_AARG, PBP_AARGH, PBP_AARGHH, PBP_AARGHHH
;       Result: _AARG  <--  FLOAT( _AARG )
;----------------------------------------------------------------------------------------------
 LIST
	FLO@3232S_REQ = 1
	FLO@1632U_REQ = 1
FLO@0832U
		MOVWF	PBP_AARG
    	CLRF 	PBP_AARGH
 NOLIST	
endif

 NOLIST
ifdef FLO@1632U_REQ
;**********************************************************************************************
;       16 bit unsigned integer to 32 bit float conversion
;       Input:  16 bit unsigned integer right justified in PBP_AARG, PBP_AARGH
;       Use:    CALL    FLO@1632U
;       Output: 32 bit floating point number in PBP_AARG, PBP_AARGH, PBP_AARGHH, PBP_AARGHHH
;       Result: _AARG  <--  FLOAT( _AARG )
;----------------------------------------------------------------------------------------------
    
 LIST
    FLO@3232S_REQ = 1
FLO@1632U
  	
    	CLRF 	PBP_AARGHH
    	CLRF 	PBP_AARGHHH
 NOLIST
endif

 NOLIST
ifdef FLO@3232S_REQ
;**********************************************************************************************
;**********************************************************************************************
;       Integer to float conversion
;       Input:  32 bit 2's complement integer in PBP_AARG, PBP_AARGH, PBP_AARGHH, PBP_AARGHHH
;       Use:    CALL    FLO@3232
;       Output: 32 bit floating point number in PBP_AARG, PBP_AARGH, PBP_AARGHH, PBP_AARGHHH
;       Result: _AARG  <--  FLOAT( _AARG )
;----------------------------------------------------------------------------------------------
  
; Special case where PBP_AARG bytes are arranged into the correct order for the subroutine
; BYTE0 into PBP_AARGHHH
; BYTE1 into PBP_AARGHH
; BYET2 into PBP_AARGH
; BYET3 into PBP_AARG 

 LIST 
FLO@3232S

		MOVFF		PBP_AARG,_AEXP				; Save PBP_AARG for now
		MOVFF		PBP_AARGHHH,PBP_AARG		; AARGHHH into AARG		
		MOVFF		_AEXP,PBP_AARGHHH			; AARG into AARGHHH
		
		MOVFF		PBP_AARGHH,_AEXP			; Save PBP_AARGHH for now			
		MOVFF		PBP_AARGH,PBP_AARGHH		; AARGH into AARGHH		
		MOVFF		_AEXP,PBP_AARGH				; AARGHH into AARGH

 NOLIST		
; Fall through to INT32@TOFLOAT32

;-------------------------------------------------------------------------
; Integer to Float common subroutine

; Integer value in PBP_AARGHHH / PBP_AARGHH / PBP_AARGH / PBP_AARG 
; Integer value returned in PBP_AARG / PBP_AARGH / PBP_AARGHH / PBP_AARGHHH
   
; Example
;		MOVFF DWORDIN,PBP_AARGHHH
;		MOVFF DWORDINH,PBP_AARGHH
;		MOVFF DWORDINHH,PBP_AARGH
;		MOVFF DWORDINHHH,PBP_AARG
		
;        CALL INT32@TOFLOAT32			' Convert Integer to FLOAT
		
;       MOVFF PBP_AARG,FLOATOUT
;		MOVFF PBP_AARGH,FLOATOUTH
;		MOVFF PBP_AARGHH,FLOATOUTHH
;		MOVFF PBP_AARGHHH,FLOATOUTHHH

; SYSTEM VARIABLES USED
; PBP_AARG,PBP_AARGH,PBP_AARGHH,PBP_AARGHHH
; _FP_TEMP, _FP_FLAGS, _SIGN
 LIST        
INT32@TOFLOAT32
			
	MOVLW 150						
	MOVWF _FP_TEMP,0
	CLRF  _SIGN,0
	BTFSS PBP_AARG,7,0
	BRA   Ito@F_1
	BSF   STATUS,C,0
	MOVLW 0
	SUBFWB PBP_AARGHHH,F,0
	SUBFWB PBP_AARGHH,F,0
	SUBFWB PBP_AARGH,F,0
	SUBFWB PBP_AARG,F,0
	BSF   _SIGN,7,0
Ito@F_1	
	MOVF  PBP_AARG,F,0
	BZ    Ito@F_3
	BTFSS _FP_FLAGS,6,0
	BRA   Ito@F_2
	BTFSS PBP_AARGHHH,7,0
	BRA   Ito@F_2
	INCFSZ PBP_AARGHH,F,0
	BRA   Ito@F_2
	INCFSZ PBP_AARGH,F,0
	BRA   Ito@F_2
	INCFSZ PBP_AARG,F,0
	BRA   Ito@F_2
	BSF   STATUS,C,0
	RRCF  PBP_AARG,F,0
	RRCF  PBP_AARGH,F,0
	RRCF  PBP_AARGHH,F,0
	INCF  _FP_TEMP,F,0
Ito@F_2	
	MOVLW 8
	ADDWF _FP_TEMP,F,0
	MOVFF PBP_AARGHH,PBP_AARGHHH
	MOVFF PBP_AARGH,PBP_AARGHH
	MOVFF PBP_AARG,PBP_AARGH
	BRA   Ito@F_6
Ito@F_3	
	TSTFSZ PBP_AARGH,0
	BRA   Ito@F_6
	MOVLW 8
	SUBWF _FP_TEMP,F,0
	MOVF  PBP_AARGHH,W,0
	BNZ   Ito@F_4
	MOVLW 8
	SUBWF _FP_TEMP,F,0
	MOVF  PBP_AARGHHH,W,0
	BZ    Ito@F_7
	CLRF  PBP_AARGHHH,0
Ito@F_4	MOVWF PBP_AARGH,0
	MOVFF PBP_AARGHHH,PBP_AARGHH
	CLRF  PBP_AARGHHH,0
	BRA   Ito@F_6
Ito@F_5	BCF   STATUS,C,0
	RLCF  PBP_AARGHHH,F,0
	RLCF  PBP_AARGHH,F,0
	RLCF  PBP_AARGH,F,0
	DECF  _FP_TEMP,F,0
Ito@F_6	BTFSS PBP_AARGH,7,0
	BRA   Ito@F_5
	MOVFF _FP_TEMP,PBP_AARG
	BTFSS _SIGN,7,0
	BCF   PBP_AARGH,7,0
Ito@F_7	MOVF  PBP_AARGHHH,W,0
	RETURN
 NOLIST
endif
 LIST