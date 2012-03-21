 NOLIST
	if(_CORE == 14)
 LIST
l@div
l@mod
		clrf	PP3H			; Clear temp variable		
		btfss	PP0HHH,7
		goto	div32@skpneg
        call	n@gt32			; Negate PP0
		bsf		PP3H,7
div32@skpneg
		btfss	PP2HHH,7
		goto	DIG@DIV       
		comf    PP2,F			; Negate PP2
        comf    PP2H,F
        comf    PP2HH,F
        comf    PP2HHH,F
        incf    PP2,F
        skpnz
        incf    PP2H,F
        skpnz
        incf    PP2HH,F
        skpnz
        incf    PP2HHH,F        
        movlw	0x80
		xorwf	PP3H,F
DIG@DIV	movlw   32
		movwf   PP3
		clrf    PPZ
		clrf    PPZH
		clrf    PPZHH
		clrf    PPZHHH
		clrc
div32@1	call	rot32@PP0			; Rotate PP0 Left
		rlf     PPZ,F
		rlf     PPZH,F
		rlf     PPZHH,F
		rlf     PPZHHH,F
		movf	PP2,W
		subwf   PPZ,W
		movf	PP2H,W
		skpc
		addlw	1
		subwf   PPZH,W
		movf   	PP2HH,W
		skpc
		addlw	1
		subwf   PPZHH,W
		movf   PP2HHH,W
		skpc
		addlw	1
		subwf   PPZHHH,W
		skpnc
		goto	div32@3
div32@2	decfsz  PP3,F 
		goto    div32@1		
		call	rot32@PP0		; Rotate PP0 Left		
		bcf		PP0HHH,7
		btfss	PP3H,7		
		goto	div32@fin		
        call	n@gt32		; Negate PP0
		goto	div32@fin		
div32@3	movf   PP2,W
		subwf   PPZ,F
		movf	PP2H,W
		skpc
		addlw	1
		subwf   PPZH,F
		movf   PP2HH,W
		skpc
		addlw	1
		subwf   PPZHH,F
		movf   PP2HHH,W
		skpc
		addlw	1
		subwf   PPZHHH,F
		setc
		goto	div32@2
div32@fin
		movf	PPZHHH,W
        movwf	PP2HHH
        movf	PPZHH,W
        movwf	PP2HH
        movf	PPZH,W
        movwf	PP2H
        movf	PPZ,W
        movwf	PP2
        goto	i@nt
rot32@PP0						; Rotate PP0 Left
		rlf     PP0,F
		rlf     PP0H,F
		rlf     PP0HH,F
		rlf     PP0HHH,F
        return
 NOLIST
	else						; *** 16-bit CORE device
 LIST
l@div
l@mod	clrf	PP3H			; Clear temp variable		
		btfss	PP0HHH,7
		bra		div32@skpneg
        rcall	n@gt32			; Negate PP0
		bsf		PP3H,7
div32@skpneg
		btfss	PP2HHH,7
		bra		DIG@DIV       
		comf    PP2,F			; Negate PP2
        comf    PP2H,F
        comf    PP2HH,F
        comf    PP2HHH,F
        incf    PP2,F
        skpnz
        incf    PP2H,F
        skpnz
        incf    PP2HH,F
        skpnz
        incf    PP2HHH,F        
        movlw	0x80
		xorwf	PP3H,F
DIG@DIV	movlw   32
		movwf   PP3
		clrf    PPZ
		clrf    PPZH
		clrf    PPZHH
		clrf    PPZHHH
		clrc
div32@1	rcall	rot32@PP0			; Rotate PP0 Left
		rlcf     PPZ,F
		rlcf     PPZH,F
		rlcf     PPZHH,F
		rlcf     PPZHHH,F
		movf	PP2,W
		subwf   PPZ,W
		movf	PP2H,W
		skpc
		addlw	1
		subwf   PPZH,W
		movf   PP2HH,W
		skpc
		addlw	1
		subwf   PPZHH,W
		movf   PP2HHH,W
		skpc
		addlw	1
		subwf   PPZHHH,W
		;skpnc
		;bra	div32@3
		bc		div32@3
div32@2	decfsz  PP3,F 
		bra    	div32@1		
		rcall	rot32@PP0		; Rotate PP0 Left		
		bcf		PP0HHH,7
		btfss	PP3H,7		
		bra		div32@fin		
        rcall	n@gt32			; Negate PP0
		bra		div32@fin		
div32@3	movf   PP2,W
		subwf   PPZ,F
		movf	PP2H,W
		skpc
		addlw	1
		subwf   PPZH,F
		movf   PP2HH,W
		skpc
		addlw	1
		subwf   PPZHH,F
		movf   PP2HHH,W
		skpc
		addlw	1
		subwf   PPZHHH,F
		setc
		bra	div32@2
div32@fin
		movff	PPZHHH,PP2HHH
        movff	PPZHH,PP2HH
        movff	PPZH,PP2H
        movff	PPZ,PP2
        return
rot32@PP0						; Rotate PP0 Left
		rlcf     PP0,F
		rlcf     PP0H,F
		rlcf     PP0HH,F
		rlcf     PP0HHH,F
        return
 NOLIST
	endif
 LIST
