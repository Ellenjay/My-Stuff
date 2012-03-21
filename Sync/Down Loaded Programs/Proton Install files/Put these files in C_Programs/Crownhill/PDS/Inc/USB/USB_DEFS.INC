 LIST

; Edit these as appropriate for your descriptors
#define NUM_CONFIGURATIONS  1

; Define the states that the USB interface can be in
#define	POWERED#STATE		0
#define	DEFAULT#STATE		1
#define	BUF#ADDRESS#STATE	2
#define	CONFIG#STATE		3

; Define the states for Control EndPoints
#define	EP_IDLE_STATE		0
#define	EP_SETUP_STATE		1
#define	EP_DISABLED_STATE	0xFF

#define	ENDPT_DISABLED		0
#define ENDPT_IN_ONLY		2
#define ENDPT_OUT_ONLY		4
#define ENDPT_CONTROL		6	; enable for in, out and setup
#define ENDPT_NON_CONTROL 	0x0E	; enable for in, and out


#define INT_STAT_MASK_RESET			1
#define INT_STAT_MASK_ERROR			2
#define INT_STAT_MASK_TOKEN_DONE	4
#define INT_STAT_MASK_SLEEP			8
#define INT_STAT_MASK_STALL			0x10

#define TOKEN_OUT			1 << 2
#define TOKEN_ACK       	2 << 2
#define TOKEN_IN			9 << 2
#define TOKEN_SETUP			0x0D << 2

#define USB_Buffer    		0xB8	; on page 3 so actual address 0x1B8

; offsets from the beginning of the Buffer Descriptor
#define BYTE#COUNT			1
#define	BUF#ADDRESS			2

; Descriptor types
;#define  DEVICE         	1
#define  CONFIGURATION  	2
#define  STRING         	3
#define  INTERFACE      	4
#define  ENDPOINT       	5

; offsets from the beginning of the setup data record
#define  bmRequestType  	0
#define  bRequest			1
#define  wValue				2
#define  wValueHigh			3
#define  wIndex				4
#define  wIndexHigh			5
#define	 wLength			6
#define  wLengthHigh		7

#define  CLEAR_FEATURE		1
#define  GET_CONFIGURATION	8
#define  GET#DESCRIPTOR		6
#define  GET#STRING_DESCRIPTOR	0x66
#define  GET_INTERFACE		0x0A
#define  GET_STATUS			0
#define	 SET#BUF#ADDRESS	5
#define  SET_CONFIGURATION	9
#define  SET_FEATURE		3
#define  SET_INTERFACE		0x0B
#define  HID_SET_REPORT		0x21
#define  VEND_SET_MEMORY	0x80

#define SVCUSBINT			1 << 2
#define SVCTOKENDONE		2 << 2
#define SVCRESET			3 << 2
#define SVCSLEEP			4 << 2
#define SVCSTALL			5 << 2
#define SVCERROR			6 << 2
#define SVCACTIVITY			7 << 2
#define TOKENOUT			8 << 2
#define TOKENIN				9 << 2
#define TOKENSETUP			0x0A << 2
#define CLEARFEATURE		0x0B << 2
#define GETCONFIG			0x0C << 2
#define GETDESCRIPTOR		0x0D << 2
#define GETINTERFACE		0x0E << 2
#define GETSTATUS			0x0F << 2
#define SETADDRESS			0x10 << 2
#define SETCONFIG			0x11 << 2
#define SETFEATURE			0x12 << 2
#define SETINTERFACE		0x13 << 2
#define FINISHSETADDRESS	0x14 << 2
#define COPYDESC2EP0		0x15 << 2
#define COPYSTRINGDESC2EP0	0x16 << 2
#define ZEROLENPACKET		0x17 << 2


COPYBuffer@Descriptor	macro
	bankisel BD0OST
	banksel	BD0OST
	movf	USTAT,w				; get the status register
	addlw	0xA0				; add the offset to the beginning of the BD's
	movwf	FSR					; save in the FSR.
	bcf	STATUS, RP0				; back to bank 2
	movf	INDF,w
	movwf	_BUFFER_DESCRIPTOR	; in shared RAM
	incf	FSR,f
	movf	INDF,w
	movwf	_BUFFER_DESCRIPTOR + 1
	incf	FSR,f
	movf	INDF,w
	movwf	_BUFFER_DESCRIPTOR + 2
	endm	
	
; Increments a 16bit counter, stored Lowbyte:Highbyte
INCREMENT@16	macro	index
	local	endinc16
	incfsz	index,f
	goto	endinc16
	incf	index + 1,f
endinc16
	endm	

REQUEST@ERROR	macro
	bsf	STATUS,RP0				; page 3
	movf	USTAT,w				; get the status register
	addlw	0xA0				; add the offset to the beginning of the BD's
	movwf	FSR
	bsf	INDF,EP_STALL			; set endpoint stall bit
	bcf	STATUS,RP0				; back to page 2
	endm	

; *********************************************************************
; wait here until the enumeration process is complete.
; This is implemented as a macro to avoid chewing up another stack level
; *********************************************************************
Configured@USB macro
	local	enum@loop
	banksel	USWSTAT
enum@loop
	clrwdt						; clear the watch dog timer.
	movlw	3
	andwf	USWSTAT,w			; save lower 2 bits of USWSTAT
	xorlw	CONFIG#STATE		; compare with configured state
	btfss	STATUS,Z			; are we configured?
	goto	enum@loop			; nope, keep waiting ...
	endm

GETEP1  macro
; **********************************************************************
; GetEP1
; Enter with buffer pointer in IRP + FSR.  
; Checks the semaphore for the OUT endpoint, and copies the buffer 
; if available.  Restores the bank bits as we found them.
;
; Returns the bytecount in the W register and return status in the carry
; bit as follows:
; 0 - no buffer available,
; 1 - Buffer copied and buffer made available for next transfer.
; 
; The number of bytes moved is returned in W reg.
; **********************************************************************
;GetEP1
GetUSB1
    movf    STATUS,w        ; save bank bits before we trash them
    banksel _RP_SAVE         ; switch to bank 2
    movwf   _RP_SAVE

    movf    FSR,w
    movwf   _DEST_PTR        ; save the buffer destination pointer
    
    banksel BD1OST          ; bank 3
    btfsc   BD1OST,UOWN     ; Has the buffer been filled?
    goto    no@buffer        ; nope, OWN = 1 ==> SIE owns the buffer
                            ; Yep: OWN = 0 ==> PIC owns the buffer

    movf    BD1OBC,w        ; get byte count
    banksel _USB_COUNTER         ; bank 2
    movwf   _USB_COUNTER
    movwf   _BYTE_COUNTER     ; # of bytes that will be moved
    btfsc   STATUS,Z        ; is it a zero length buffer?
    goto    exit@getloop     ; yes, bail out now and avoid the rush
    banksel BD1OAL          ; bank 3
    movf    BD1OAL,w        ; get address pointer
    banksel _SOURCE_PTR      ; bank 2
    movwf   _SOURCE_PTR

; This loop operates with the direct bank bits set to bank 2, while IRP
; gets switched as needed to for the buffer copy
get@EPloop
    bsf     STATUS,IRP      ; select high banks on INDF
    movf    _SOURCE_PTR,w    ; get source pointer
    movwf   FSR
    movf    INDF,w
    movwf   _GP_TEMP          ; in common RAM to avoid paging issues

    movf    _DEST_PTR,w    
    movwf   FSR
    btfss   _RP_SAVE,IRP     ; should it be zero?
    bcf     STATUS,IRP      ; yes: make it so.
    movf    _GP_TEMP,w        ; no, get the byte we read.
    movwf   INDF            ; store it
    incf    _DEST_PTR,f
    incf    _SOURCE_PTR,f
    decfsz  _USB_COUNTER,f
    goto    get@EPloop

exit@getloop
    bsf     STATUS,RP0      ; bank 3
    movf    BD1OST,w
    andlw   0x40            ; save only the data 0/1 bit
    xorlw   0x40            ; toggle the data o/1 bit
    iorlw   0x88            ; set owns bit and DTS bit
    movwf   BD1OST

    movlw   8            ; reset byte counter
    movwf   BD1OBC
    bcf     STATUS,RP0      ; bank 2
    movf    _BYTE_COUNTER,w   ; return # of bytes moved in W reg
    movwf   _GP_TEMP          ; move byte counter to temporary ram
    movf    _RP_SAVE,w       ; restore bank bits
    movwf   STATUS
    movf    _GP_TEMP,w        ; load W with the byte count
    bsf     STATUS,C        ; signal success
    return

no@buffer
    banksel _RP_SAVE         ; restore the bank bits
    movf    _RP_SAVE,w
    movwf   STATUS
    bcf     STATUS,C
    return
    endm

GETEP2  macro
; **********************************************************************
; GetEP2
; Enter with buffer pointer in IRP + FSR.  
; Checks the semaphore for the OUT endpoint, and copies the buffer 
; if available.  Restores the bank bits as we found them.
;
; Returns the bytecount in the W register and return status in the carry
; bit as follows:
; 0 - no buffer available,
; 1 - Buffer copied and buffer made available for next transfer.
; 
; The number of bytes moved is returned in W reg.
; **********************************************************************
;GetEP2
GetUSB2
    movf    STATUS,w        ; save bank bits before we trash them
    banksel _RP_SAVE         ; switch to bank 2
    movwf   _RP_SAVE

    movf    FSR,w
    movwf   _DEST_PTR        ; save the buffer destination pointer
    
    banksel BD2OST          ; bank 3
    btfsc   BD2OST,UOWN     ; Has the buffer been filled?
    goto    no@buffer2       ; nope, OWN = 1 ==> SIE owns the buffer
                            ; Yep: OWN = 0 ==> PIC owns the buffer

    movf    BD2OBC,w        ; get byte count
    banksel _USB_COUNTER         ; bank 2
    movwf   _USB_COUNTER
    movwf   _BYTE_COUNTER     ; # of bytes that will be moved
    btfsc   STATUS,Z        ; is it a zero length buffer?
    goto    exit@getloop2    ; yes, bail out now and avoid the rush
    banksel BD2OAL          ; bank 3
    movf    BD2OAL,w        ; get address pointer
    banksel _SOURCE_PTR      ; bank 2
    movwf   _SOURCE_PTR

; This loop operates with the direct bank bits set to bank 2, while IRP
; gets switched as needed to for the buffer copy
get@EPloop2
    bsf     STATUS,IRP      ; select high banks on INDF
    movf    _SOURCE_PTR,w    ; get source pointer
    movwf   FSR
    movf    INDF,w
    movwf   _GP_TEMP          ; in common RAM to avoid paging issues

    movf    _DEST_PTR,w    
    movwf   FSR
    btfss   _RP_SAVE,IRP     ; should it be zero?
    bcf     STATUS,IRP      ; yes: make it so.
    movf    _GP_TEMP,w        ; no, get the byte we read.
    movwf   INDF            ; store it
    incf    _DEST_PTR,f
    incf    _SOURCE_PTR,f
    decfsz  _USB_COUNTER,f
    goto    get@EPloop2

exit@getloop2
    bsf     STATUS,RP0      ; bank 3
    movf    BD2OST,w
    andlw   0x40            ; save only the data 0/1 bit
    xorlw   0x40            ; toggle the data o/1 bit
    iorlw   0x88            ; set owns bit and DTS bit
    movwf   BD2OST

    movlw   8            ; reset byte counter
    movwf   BD2OBC
    bcf     STATUS,RP0      ; bank 2
    movf    _BYTE_COUNTER,w   ; return # of bytes moved in W reg
    movwf   _GP_TEMP          ; move byte counter to temporary ram
    movf    _RP_SAVE,w       ; restore bank bits
    movwf   STATUS
    movf    _GP_TEMP,w        ; load W with the byte count
    bsf     STATUS,C        ; signal success
    return

no@buffer2
    banksel _RP_SAVE         ; restore the bank bits
    movf    _RP_SAVE,w
    movwf   STATUS
    bcf     STATUS,C
    return
    endm

PUTEP1  macro
; ******************************************************************
; PutEP1
; Enter with bytecount in W and buffer pointer in IRP + FSR.
; the bytecount is encoded in the lower nybble of W.
;
; Tests the owns bit for the IN side of the specified Endpoint.
; If we own the buffer, the buffer pointed to by the FSR is copied
; to the EPn In buffer, then the owns bit is set so the data will be
; TX'd next time polled.  
;
; Returns the status in the carry bit as follows:
; 1 - buffer available and copied.
; 0 - buffer not available (try again later)
; ******************************************************************
;PutEP1
PutUSB1
    movwf   _GP_TEMP          ; save Bytecount temporarily in common RAM

    movf    STATUS,w        ; save bank bits before we trash them
    banksel _RP_SAVE         ; switch to bank 2
    movwf   _RP_SAVE

    movf    _GP_TEMP,w
    andlw   0x0F            ; extract byte count.
    movwf   _USB_COUNTER

    movf    FSR,w
    movwf   _SOURCE_PTR

    movf    _USB_COUNTER,w       ; prepare to copy the byte count
    banksel BD1IST          ; bank 3
    btfsc   BD1IST,UOWN     ; is the buffer already full?
    goto    no@bufferputep1  ; yes - don't write over it

    movwf   BD1IBC          ; set byte count in BD
    btfsc   STATUS,Z        ; is it a zero length buffer?
    goto    exit@putloop     ; yes, bail out now and avoid the rush
    movf    BD1IAL,w        ; get address pointer
    bcf     STATUS,RP0      ; back to bank 2
    movwf   _DEST_PTR

; This loop operates with the direct bits set to bank 2, while IRP
; gets switched as needed to for the buffer copy
put@EPloop
    bsf     STATUS,IRP      ; assume IRP is set
    btfss   _RP_SAVE,IRP     ; should it be zero?
    bcf     STATUS,IRP      ; yes: make it so.
    movf    _SOURCE_PTR,w
    movwf   FSR
    movf    INDF,w
    movwf   _GP_TEMP

    bsf     STATUS,IRP      ; select high banks on INDF
    movf    _DEST_PTR,w
    movwf   FSR
    movf    _GP_TEMP,w        ; no, get the byte we read.
    movwf   INDF            ; store it

    incf    _DEST_PTR,f
    incf    _SOURCE_PTR,f
    decfsz  _USB_COUNTER,f
    goto    put@EPloop

exit@putloop
    bsf     STATUS,RP0      ; back to bank 3
    movf    BD1IST,w
    andlw   0x40            ; save only the data 0/1 bit
    xorlw   0x40            ; toggle the data o/1 bit
    iorlw   0x88            ; set owns bit and DTS bit
    movwf   BD1IST
    banksel _RP_SAVE
    movf    _RP_SAVE,w       ; restore bank bits the way we found them
    movwf   STATUS
    bsf     STATUS,C        ; set carry to show success
    return

no@bufferputep1
    bcf     STATUS,C
    return
    endm

PUTEP2  macro
; ******************************************************************
; PutEP2
; Enter with bytecount in W and buffer pointer in IRP + FSR.
; the bytecount is encoded in the lower nybble of W.
;
; Tests the owns bit for the IN side of the specified Endpoint.
; If we own the buffer, the buffer pointed to by the FSR is copied
; to the EPn In buffer, then the owns bit is set so the data will be
; TX'd next time polled.  
;
; Returns the status in the carry bit as follows:
; 1 - buffer available and copied.
; 0 - buffer not available (try again later)
; ******************************************************************
;PutEP2
PutUSB2
    movwf   _GP_TEMP          ; save Bytecount temporarily in common RAM

    movf    STATUS,w        ; save bank bits before we trash them
    banksel _RP_SAVE         ; switch to bank 2
    movwf   _RP_SAVE

    movf    _GP_TEMP,w
    andlw   0x0F            ; extract byte count.
    movwf   _USB_COUNTER

    movf    FSR,w
    movwf   _SOURCE_PTR

    movf    _USB_COUNTER,w       ; prepare to copy the byte count
    banksel BD2IST          ; bank 3
    btfsc   BD2IST,UOWN     ; is the buffer already full?
    goto    no@bufferputep2  ; yes - don't write over it

    movwf   BD2IBC          ; set byte count in BD
    btfsc   STATUS,Z        ; is it a zero length buffer?
    goto    exit@putloop2    ; yes, bail out now and avoid the rush
    movf    BD2IAL,w        ; get address pointer
    bcf     STATUS,RP0      ; back to bank 2
    movwf   _DEST_PTR

; This loop operates with the direct bits set to bank 2, while IRP
; gets switched as needed to for the buffer copy
put@EPloop2
    bsf     STATUS,IRP      ; assume IRP is set
    btfss   _RP_SAVE,IRP     ; should it be zero?
    bcf     STATUS,IRP      ; yes: make it so.
    movf    _SOURCE_PTR,w
    movwf   FSR
    movf    INDF,w
    movwf   _GP_TEMP

    bsf     STATUS,IRP      ; select high banks on INDF
    movf    _DEST_PTR,w
    movwf   FSR
    movf    _GP_TEMP,w        ; no, get the byte we read.
    movwf   INDF            ; store it

    incf    _DEST_PTR,f
    incf    _SOURCE_PTR,f
    decfsz  _USB_COUNTER,f
    goto    put@EPloop2

exit@putloop2
    bsf     STATUS,RP0      ; back to bank 3
    movf    BD2IST,w
    andlw   0x40            ; save only the data 0/1 bit
    xorlw   0x40            ; toggle the data o/1 bit
    iorlw   0x88            ; set owns bit and DTS bit
    movwf   BD2IST
    banksel _RP_SAVE
    movf    _RP_SAVE,w       ; restore bank bits the way we found them
    movwf   STATUS
    bsf     STATUS,C        ; set carry to show success
    return

no@bufferputep2
    bcf     STATUS,C
    return
    endm
  LIST

