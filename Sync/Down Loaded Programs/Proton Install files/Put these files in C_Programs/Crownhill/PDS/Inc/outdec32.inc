;-------------------------------------------------------------------------------------------------
; OUTDEC32	: Convert a 32-bit DWORD to ASCII DECIMAL
; Input		: PP7, PP7H, PP7HH, PP7HHH
;			: GEN4H amount of digits to display

if (_CORE == 14)
    	BPFH_REQ = true;		; Clear BPFH at the start of the program
        BPF_REQ = true;
		DIG_SEND_REQ = true;
		FIN_REQ = true;
		LONG_DIVIDE_REQ = true;
out@dec32
		bcf BPF,3      			; Blanking off
		movf GEN4H,W   			; 0 digits?
		skpz
		goto o@d32l1
		bsf BPF,3 		    	; Yes, blanking on
		movlw 10				; 10 digits max to do
		movwf GEN4H
o@d32l1
		movf PP7HHH,W			;PP0 = PP7
		movwf PP0HHH
		movf PP7HH,W
		movwf PP0HH
		movf PP7H,W
		movwf PP0H
		movf PP7,W
		movwf PP0
		clrf GEN4				; GEN4 = 0
o@d32l2
		clrf PP2HHH				; PP0 = PP0 / 10
		clrf PP2HH
		clrf PP2H
		movlw 10
		movwf PP2
		call l@div
		incf GEN4,f				;Inc GEN4
		movf GEN4,W				;Until GEN4 = GEN4H
		subwf GEN4H,w
		btfss STATUS,z
		goto o@d32l2
		movf PP2,W				;If PP2.Byte0 != 0 Then BLANK = 0
		btfss STATUS,z
		bcf BPF,3

		;btfsc BPF,3			;If BLANK = 0 Then
		;goto o@d32l3
		btfss BPF,3				;If BLANK = 0 Then
		goto o@d32skp
		decfsz GEN4H,w
		goto o@d32l3
o@d32skp
		movf PP2,W
		addlw 48
		call ch@snd
o@d32l3
		ifdef TIMEOUT@REQ
	  		skpc   				; Timed out?
    		return    			; Yes
  		endif
		decfsz GEN4H,f			;Until GEN4H = 0
		goto o@d32l1
		goto i@nt
endif
if (_CORE == 18)
out@dec32
		bcf BPF,3          	; Blanking off
    	movf GEN4H,W       		; 0 digits?
    	bnz	o@d32l1
    	bsf BPF,3         	; Yes, blanking on
    	movlw 10            			; 10 digits max to do
		movwf GEN4H
o@d32l1
		movff PP7HHH,PP0HHH			;PP0 = PP7
		movff PP7HH,PP0HH
		movff PP7H,PP0H
		movff PP7,PP0
		clrf GEN4					; GEN4 = 0            
o@d32l2
		clrf PP2HHH					; PP0 = PP0 / 10
		clrf PP2HH
		clrf PP2H
		movlw 10
		movwf PP2
		call l@div
		incf GEN4,f			;Inc GEN4
		movf GEN4,W				;Until GEN4 = GEN4H
		subwf GEN4H,w
		btfss STATUS,Z
		bra o@d32l2
		movf PP2,W					;If PP2.Byte0 != 0 Then BLANK = 0
		btfss STATUS,Z
		bcf BPF,3

        btfss BPF,3			;If BLANK = 0 Then
		bra o@d32skp
		decfsz GEN4H,w
		bra o@d32l3
o@d32skp
    	movf PP2,W
		addlw 48
		call ch@snd
o@d32l3
        ifdef TIMEOUT@REQ
      		skpc       			; Timed out?
        	return        		; Yes
      	endif
		decfsz GEN4H,f		;Until GEN4H = 0
		bra o@d32l1
    	goto i@nt
endif	
