 NOLIST
; Value to display is held in PBP_AARG, PBP_AARGH, PBP_AARGHH, PBP_ARGHHHH
; Number of digits after the decimal point in held in WREG 
LIST
out@float
NOLIST
if(_CORE == 16)
; Round the floating point value to its nearest neighbour before display
LIST
		movwf	PPZ
		movff 	PBP_AARGH,_SIGN		; Save SIGN        
		bsf	  	STATUS,C			; set carry for rounding
		clrf  	WREG
		addwfc	PBP_AARGHHH,f
		addwfc	PBP_AARGHH,f
		addwfc	PBP_AARGH,f
		bnc		out@flt_RND_OK		; has rounding caused carryout?

		Rcall	ROR_PBP_AARG_ONLY 		; if so, right shift 	
		incf	PBP_AARG,f 				
out@flt_RND_OK
		btfss	_SIGN,7
		bcf  	PBP_AARGH,7			; clear explicit MSB if positive             	
        clrf	PBP_BARGH       
        clrf	PBP_BARGHHH
		clrf	PBP_BARGHH       
        clrf	PPZHH
		btfss	PBP_AARGH,7
		bra		fp@3A
		bsf		PPZ,6        
fp@3A	
		bsf		PBP_AARGH,7					
		movf	PBP_AARG,w
		btfsc	STATUS,Z
		bra		fp@1B8        
        movlw	0x7F
		subwf	PBP_AARG,w
		bnc		fp@120        
        movwf	PBP_AARG
		clrf	PPZHHH
		movlw	4
		movwf	_AEXP
fp@56	
		rcall	ROL_PBP_AARG
		decfsz	_AEXP,f
		bra		fp@56
fp@66	
		movlw	4						
		subwf	PBP_AARG,w
		bc		fp@84        
        movlw	3
		subwf	PBP_AARG,w
		btfss	STATUS,Z
		bra		fp@1A2       
        movlw	0x0A
		subwf	PPZHH,w
		btfss	STATUS,C
		bra		fp@1A2       
fp@84	
		movlw	3						
		subwf	PBP_AARG,f
		incf	PPZHHH,f
		rcall	fp@3A4
		rcall	ROL_PBP_AARG
		rcall	fp@366
		movlw	2
		movwf	_AEXP
fp@A0	
		rcall	ROR_PBP_AARG
		decfsz	_AEXP,f
		bra		fp@A0
		rcall	fp@3A4
		movlw	4
		movwf	_AEXP
fp@B8	
		bcf		STATUS,C				
		rrcf	PBP_BARG,f
		rrcf	PBP_BARGH,f
		rrcf	PBP_BARGHH,f
		rrcf	PBP_BARGHHH,f
		decfsz	_AEXP,f
		bra		fp@B8
		rcall	fp@366
		rcall	fp@3A4
		movff	PBP_BARGHH,PBP_BARGHHH
		movff	PBP_BARGH,PBP_BARGHH
		movff	PBP_BARG,PBP_BARGH
		clrf	PBP_BARG
		rcall	fp@366
		rcall	fp@3A4
		movff	PBP_BARGH,PBP_BARGHHH
		movff	PBP_BARG,PBP_BARGHH
		clrf	PBP_BARG
		clrf	PBP_BARGH
		rcall	fp@366
		btfsc	PPZHH,3
		bra		fp@66
		movf	PBP_AARG,f
		bnz		fp@110        
        incf	PBP_AARGHHH,f
		incf	PBP_AARGHH,f
		incf	PBP_AARGH,f
		incf	PPZHH,f
		bra		fp@1A2
fp@110	
		rcall	ROL_PBP_AARG
		decf	PBP_AARG,f
		bra		fp@66
fp@120	comf	PBP_AARG,f						
		incf	PBP_AARG,f
		movlw	0x7F
		addwf	PBP_AARG,f
		clrf	PPZHHH
		movlw	4
		movwf	_AEXP
fp@12E	
		rcall	ROL_PBP_AARG
		decfsz	_AEXP,f
		bra		fp@12E
		movlw	4
		addwf	PBP_AARG,f
fp@142	
		movlw	5						
		subwf	PBP_AARG,w
		bnc		fp@1BE       
        rcall	fp@3A4
		rcall	ROL_PBP_AARG
		rcall	ROL_PBP_AARG
		rcall	fp@366
		rcall	ROL_PBP_AARG
		incf	PPZHHH,f
		movlw	3
		movwf	_AEXP
fp@178	
		rcall	ROR_PBP_AARG
		decfsz	_AEXP,f
		bra		fp@178
		movlw	3
		subwf	PBP_AARG,f
		btfss	PPZHH,4
		bra		fp@142
		rcall	ROR_PBP_AARG
		decf	PBP_AARG,f
		bra		fp@142
fp@1A2	
		comf	PBP_AARG,f						
		incf	PBP_AARG,f
		movlw	3
		addwf	PBP_AARG,f
		movlw	1
		bra		fp@1C0
fp@1B8	
		movlw	2						
		bra		fp@1C0
fp@1BE	
		movlw	0						
fp@1C0	
		movwf	_BEXP						
fp@1E4	
		btfss	PPZ,6					
		bra		fp@214
		movlw	45 					
		call	ch@snd
fp@214	
		bcf		PPZ,7					
		bcf		PPZ,6
		btfss	_BEXP,0
		bra		fp@22E
		movff	PPZHHH,_BEXP
		movff	PPZHHH,_SIGN
		incf	PPZ,w
		addwf	_SIGN,f
		bra		fp@28E
fp@22E	
		btfss	_BEXP,1					
		bra		fp@238
		incf	PPZ,w
		movwf	PPZHHH
fp@238	
		movf	PPZ,f						
		btfsc	STATUS,Z
		return
		movlw	46						
		call	ch@snd
		movff	PPZHHH,PP7HHH
		decf	PP7HHH,f
		movf	PPZ,w
		subwf	PP7HHH,w
		bnc		fp@25C        
        movff	PPZ,PP7HHH
fp@25C	
		movf	PP7HHH,f
        bz		fp@272       
fp@264	
		movlw	48											
		call	ch@snd
		decfsz	PP7HHH,f
		bra		fp@264
fp@272	
		movff	PPZHHH,_AEXP					
		incf	PPZ,w
		subwf	_AEXP,f
		btfsc	STATUS,C
		return							
		decf	PBP_AARG,f
		incf	PPZ,w
		movwf	_SIGN
		movf	PPZHHH,w
		subwf	_SIGN,f
		movff	_SIGN,_BEXP
fp@28E	
		movff	PPZHH,_FP_TEMP					
		movf	PBP_AARG,w
        bz		fp@2A6       
		movwf	PP7HH
fp@29C	
		bcf		STATUS,C				
		rrcf	_FP_TEMP,f
		decfsz	PP7HH,f
		bra		fp@29C
fp@2A6	
		movf	_SIGN,w					
		btfsc	STATUS,Z
		return
		movlw	48						
		addwf	_FP_TEMP,w
		call	ch@snd
		movf	_BEXP,w
		bnz		fp@2D0       
        movf	PPZ,f
		btfsc	STATUS,Z
		return
		movlw	46						
		call	ch@snd
fp@2D0	
		decf	_BEXP,f	
		dcfsnz	_SIGN,f
        return							
        movf	PBP_AARG,w
		bz		fp@2EE       
        movwf	PP7HH
fp@2E4	
		bcf		STATUS,C				
		rlcf	_FP_TEMP,f
		decfsz	PP7HH,f
		bra		fp@2E4
fp@2EE	
		movf	_FP_TEMP,w					
		subwf	PPZHH,f
		movff	PPZHH,PBP_BARG
		movff	PBP_AARGH,PBP_BARGH
		movff	PBP_AARGHH,PBP_BARGHH
		movff	PBP_AARGHHH,PBP_BARGHHH
		rcall	ROL_PBP_AARG
		rcall	ROL_PBP_AARG
		movf	PBP_BARGHHH,w
		addwf	PBP_AARGHHH,f      
		bnc		fp@332       
        incf	PBP_AARGHH,f
		bnz		fp@332       
        incf	PBP_AARGH,f
		bnz		fp@332        
        incf	PPZHH,f
fp@332	movf	PBP_BARGHH,w					
		addwf	PBP_AARGHH,f
		bnc		fp@346       
        incf	PBP_AARGH,f
		bnz		fp@346      
        incf	PPZHH,f
fp@346	movf	PBP_BARGH,w					
        addwf	PBP_AARGH
		btfsc	STATUS,C
		incf	PPZHH,f
		movf	PBP_BARG,w
		addwf	PPZHH,f
		rcall	ROL_PBP_AARG
		bra		fp@28E
fp@366	movf	PBP_BARGHHH,w					
		addwf	PBP_AARGHHH,f
		bnc		fp@382        
        incf	PBP_AARGHH,f
		bnz		fp@382       
        incf	PBP_AARGH,f
		bnz		fp@382        
        incf	PPZHH,f
fp@382	movf	PBP_BARGHH,w					
		addwf	PBP_AARGHH,f
		bnc		fp@396        
        incf	PBP_AARGH,f
		bnz		fp@396      
        incf	PPZHH,f
fp@396	movf	PBP_BARGH,w					
        addwf	PBP_AARGH,f
		btfsc	STATUS,C
		incf	PPZHH,f
		movf	PBP_BARG,w
		addwf	PPZHH,f
		return
fp@3A4	movff	PPZHH,PBP_BARG					
		movff	PBP_AARGH,PBP_BARGH
		movff	PBP_AARGHH,PBP_BARGHH
		movff	PBP_AARGHHH,PBP_BARGHHH
		return
		
ROL_PBP_AARG
	bcf		STATUS,C
	rlcf	PBP_AARGHHH,f
	rlcf	PBP_AARGHH,f
	rlcf	PBP_AARGH,f
	rlcf	PPZHH
	return
ROR_PBP_AARG
	bcf		STATUS,C				
	rrcf	PPZHH,f
ROR_PBP_AARG_ONLY
	rrcf	PBP_AARGH,f
	rrcf	PBP_AARGHH,f
	rrcf	PBP_AARGHHH,f
	return
 NOLIST
else										; 14-bit core code
; 352 bytes       		      
; Round the floating point value to its nearest neighbour before display
 LIST
        movwf	PPZ       
        movf	PBP_AARGH,w
        movwf	_SIGN
		incf	PBP_AARGHHH,f
		btfsc	STATUS,Z
		incf	PBP_AARGHH,f
		btfsc	STATUS,Z
		incf	PBP_AARGH,f
		btfss	STATUS,Z		    ; has rounding caused carryout?
		goto	out@flt_RND_OK 
		rrf		PBP_AARGH,f			; if so, right shift
		rrf		PBP_AARGHH,f
		rrf		PBP_AARGHHH,f
		incf	PBP_AARG,f
out@flt_RND_OK         
		btfss	_SIGN,7
		bcf		PBP_AARGH,7			; clear explicit 7 if positive        
        clrf	PBP_BARGH
        clrf	PBP_BARGHHH
		clrf	PBP_BARGHH       
        clrf	PPZHH
		btfss	PBP_AARGH,7
		goto	fp@3A
		bsf		PPZ,6       
fp@3A	bsf		PBP_AARGH,7					
		movf	PBP_AARG,w
		btfsc	STATUS,Z
		goto	fp@1B8
		movlw	0x7F
		subwf	PBP_AARG,w
		btfss	STATUS,C
		goto	fp@120
		movwf	PBP_AARG
		clrf	PPZHHH
		movlw	4
		movwf	_AEXP
fp@56	bcf		STATUS,C				
		rlf		PBP_AARGHHH
		rlf		PBP_AARGHH
		rlf		PBP_AARGH
		rlf		PPZHH
		decfsz	_AEXP
		goto	fp@56
fp@66	movlw	4						
		subwf	PBP_AARG,w
		btfsc	STATUS,C
		goto	fp@84
		movlw	3
		subwf	PBP_AARG,w
		btfss	STATUS,Z
		goto	fp@1A2
		movlw	0x0A
		subwf	PPZHH,w
		btfss	STATUS,C
		goto	fp@1A2
fp@84	movlw	3						
		subwf	PBP_AARG
		incf	PPZHHH
		call	fp@3A4
		bcf		STATUS,C
		rlf		PBP_AARGHHH
		rlf		PBP_AARGHH
		rlf		PBP_AARGH
		rlf		PPZHH
		call	fp@366
		movlw	2
		movwf	_AEXP
fp@A0	bcf		STATUS,C				
		rrf		PPZHH
		rrf		PBP_AARGH
		rrf		PBP_AARGHH
		rrf		PBP_AARGHHH
		decfsz	_AEXP
		goto	fp@A0
		call	fp@3A4
		movlw	4
		movwf	_AEXP
fp@B8	bcf		STATUS,C				
		rrf		PBP_BARG
		rrf		PBP_BARGH
		rrf		PBP_BARGHH
		rrf		PBP_BARGHHH
		decfsz	_AEXP
		goto	fp@B8
		call	fp@366
		call	fp@3A4
		movf	PBP_BARGHH,w
        movwf	PBP_BARGHHH
		movf	PBP_BARGH,w
        movwf	PBP_BARGHH
		movf	PBP_BARG,w
        movwf	PBP_BARGH
		clrf	PBP_BARG
		call	fp@366
		call	fp@3A4
		movf	PBP_BARGH,w
        movwf	PBP_BARGHHH
		movf	PBP_BARG,w
        movwf	PBP_BARGHH
		clrf	PBP_BARG
		clrf	PBP_BARGH
		call	fp@366
		btfsc	PPZHH,3
		goto	fp@66
		movf	PBP_AARG
		btfss	STATUS,Z
		goto	fp@110
		incf	PBP_AARGHHH
		incf	PBP_AARGHH
		incf	PBP_AARGH
		incf	PPZHH
		goto	fp@1A2
fp@110	bcf		STATUS,C				
		rlf		PBP_AARGHHH
		rlf		PBP_AARGHH
		rlf		PBP_AARGH
		rlf		PPZHH
		decf	PBP_AARG
		goto	fp@66
fp@120	comf	PBP_AARG						
		incf	PBP_AARG
		movlw	0x7F
		addwf	PBP_AARG
		clrf	PPZHHH
		movlw	4
		movwf	_AEXP
fp@12E	bcf		STATUS,C				
		rlf		PBP_AARGHHH
		rlf		PBP_AARGHH
		rlf		PBP_AARGH
		rlf		PPZHH
		decfsz	_AEXP
		goto	fp@12E
		movlw	4
		addwf	PBP_AARG
fp@142	movlw	5						
		subwf	PBP_AARG,w
		btfss	STATUS,C
		goto	fp@1BE
		call	fp@3A4
		bcf		STATUS,C
		rlf		PBP_AARGHHH
		rlf		PBP_AARGHH
		rlf		PBP_AARGH
		rlf		PPZHH
		bcf		STATUS,C
		rlf		PBP_AARGHHH
		rlf		PBP_AARGHH
		rlf		PBP_AARGH
		rlf		PPZHH
		call	fp@366
		bcf		STATUS,C
		rlf		PBP_AARGHHH
		rlf		PBP_AARGHH
		rlf		PBP_AARGH
		rlf		PPZHH
		incf	PPZHHH
		movlw	3
		movwf	_AEXP
fp@178	bcf		STATUS,C				
		rrf		PPZHH
		rrf		PBP_AARGH
		rrf		PBP_AARGHH
		rrf		PBP_AARGHHH
		decfsz	_AEXP
		goto	fp@178
		movlw	3
		subwf	PBP_AARG
		btfss	PPZHH,4
		goto	fp@142
		bcf		STATUS,C
		rrf		PPZHH
		rrf		PBP_AARGH
		rrf		PBP_AARGHH
		rrf		PBP_AARGHHH
		decf	PBP_AARG
		goto	fp@142
fp@1A2	comf	PBP_AARG						
		incf	PBP_AARG
		movlw	3
		addwf	PBP_AARG
		movlw	1
		goto	fp@1C0
fp@1B8	movlw	2						
		goto	fp@1C0
fp@1BE	movlw	0						
fp@1C0	movwf	_BEXP						
fp@1E4	btfss	PPZ,6					
		goto	fp@214
		movlw	'-'
		call	ch@snd
fp@214	bcf		PPZ,7					
		bcf		PPZ,6
		btfss	_BEXP,0
		goto	fp@22E
		movf	PPZHHH,w
        movwf	_BEXP
		movf	PPZHHH,w
        movwf	_SIGN
		incf	PPZ,w
		addwf	_SIGN
		goto	fp@28E
fp@22E	btfss	_BEXP,1					
		goto	fp@238
		incf	PPZ,w
		movwf	PPZHHH
fp@238	movf	PPZ						
		btfsc	STATUS,Z
		goto	i@nt
		movlw	'.'
		call	ch@snd
		movf	PPZHHH,w
        movwf	PP7HHH
		decf	PP7HHH
		movf	PPZ,w
		subwf	PP7HHH,w
		btfss	STATUS,C
		goto	fp@25C
		movf	PPZ,w
        movwf	PP7HHH
fp@25C	movf	PP7HHH						
		btfsc	STATUS,Z
		goto	fp@272
fp@264	movlw	'0'
		call	ch@snd
		decfsz	PP7HHH
		goto	fp@264
fp@272	movf	PPZHHH,w
		movwf	_AEXP					
		incf	PPZ,w
		subwf	_AEXP
		btfsc	STATUS,C
		goto	i@nt							
		decf	PBP_AARG
		incf	PPZ,w
		movwf	_SIGN
		movf	PPZHHH,w
		subwf	_SIGN
		movf	_SIGN,w
        movwf	_BEXP
fp@28E	movf	PPZHH,w
		movwf	_FP_TEMP					
		movf	PBP_AARG,w
		btfsc	STATUS,Z
		goto	fp@2A6
		movwf	PP7HH
fp@29C	bcf		STATUS,C				
		rrf		_FP_TEMP
		decfsz	PP7HH
		goto	fp@29C
fp@2A6	movf	_SIGN,w					
		btfsc	STATUS,Z
		goto	i@nt
		movlw	'0'						
		addwf	_FP_TEMP,w
		call	ch@snd
		movf	_BEXP,w
		btfss	STATUS,Z
		goto	fp@2D0
		movf	PPZ
		btfsc	STATUS,Z
		goto	i@nt
		movlw	'.'
		call	ch@snd
fp@2D0	decf	_BEXP						
		decf	_SIGN
		btfsc	STATUS,Z
		goto	i@nt      
        movf	PBP_AARG,w
		btfsc	STATUS,Z
		goto	fp@2EE
		movwf	PP7HH
fp@2E4	bcf		STATUS,C				
		rlf		_FP_TEMP
		decfsz	PP7HH
		goto	fp@2E4
fp@2EE	movf	_FP_TEMP,w				
		subwf	PPZHH
		movf	PPZHH,w
        movwf	PBP_BARG
		movf	PBP_AARGH,w
        movwf	PBP_BARGH
		movf	PBP_AARGHH,w
        movwf	PBP_BARGHH
		movf	PBP_AARGHHH,w
        movwf	PBP_BARGHHH
		bcf		STATUS,C
		rlf		PBP_AARGHHH
		rlf		PBP_AARGHH
		rlf		PBP_AARGH
		rlf		PPZHH
		bcf		STATUS,C
		rlf		PBP_AARGHHH
		rlf		PBP_AARGHH
		rlf		PBP_AARGH
		rlf		PPZHH
		movf	PBP_BARGHHH,w
		addwf	PBP_AARGHHH
		btfss	STATUS,C
		goto	fp@332
		incf	PBP_AARGHH
		btfss	STATUS,Z
		goto	fp@332
		incf	PBP_AARGH
		btfss	STATUS,Z
		goto	fp@332
		incf	PPZHH
fp@332	movf	PBP_BARGHH,w					
		addwf	PBP_AARGHH
		btfss	STATUS,C
		goto	fp@346
		incf	PBP_AARGH
		btfss	STATUS,Z
		goto	fp@346
		incf	PPZHH
fp@346	movf	PBP_BARGH,w					
        addwf	PBP_AARGH
		btfsc	STATUS,C
		incf	PPZHH
		movf	PBP_BARG,w
		addwf	PPZHH
		bcf		STATUS,C
		rlf		PBP_AARGHHH
		rlf		PBP_AARGHH
		rlf		PBP_AARGH
		rlf		PPZHH
		goto	fp@28E
fp@366	movf	PBP_BARGHHH,w					
		addwf	PBP_AARGHHH
		btfss	STATUS,C
		goto	fp@382
		incf	PBP_AARGHH
		btfss	STATUS,Z
		goto	fp@382
		incf	PBP_AARGH
		btfss	STATUS,Z
		goto	fp@382
		incf	PPZHH
fp@382	movf	PBP_BARGHH,w					
		addwf	PBP_AARGHH
		btfss	STATUS,C
		goto	fp@396
		incf	PBP_AARGH
		btfss	STATUS,Z
		goto	fp@396
		incf	PPZHH
fp@396	movf	PBP_BARGH,w					
        addwf	PBP_AARGH
		btfsc	STATUS,C
		incf	PPZHH
		movf	PBP_BARG,w
		addwf	PPZHH
		return
fp@3A4	movf	PPZHH,w
		movwf	PBP_BARG					
		movf	PBP_AARGH,w
        movwf	PBP_BARGH
		movf	PBP_AARGHH,w
        movwf	PBP_BARGHH
		movf	PBP_AARGHHH,w
        movwf	PBP_BARGHHH
		return
 NOLIST
endif
 LIST
        