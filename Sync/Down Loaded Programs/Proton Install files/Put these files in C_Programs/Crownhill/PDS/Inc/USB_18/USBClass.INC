 NOLIST
;
; USB Driver subroutines based on Microchip's supplied C code.
;
; Added preceding double underscore to Variable and Constant names so as not to interfere with BASIC variables 
;
; ****[START OF USB9.C]***********************************************************************************
; ------------------------------------------------------------------------------
; Check@StdRequest
;
 LIST
Check@StdRequest
	movlb	((__USB_RAM_BANK >> 8) & 255)	; Point to bank holding the variables
	movf	__SetupPkt,W					; RequestType = __STANDARD?
	andlw	0x60							; Mask to proper bits
	sublw	(__STANDARD << 5)
	bnz		Check@StdRequestExit			; No
	movlw	__SET_ADR						; Handle request
	cpfseq	__SetupPkt + __bRequest
	bra		Check@StdRequest1
	movlw	__ADR_PENDING_STATE
	movwf	__USB_DEVICE_STATE
	bra		Std@SetSessionOwnerUSB9

; GET_DESCRIPTOR request?
Check@StdRequest1
	movlw	__GET_DSC
	cpfseq	__SetupPkt + __bRequest
	bra		Check@StdRequest2
	bra		Std@GetDscHandler

; GET_CONFIGURATION request?
Check@StdRequest2
	movlw	__GET_CFG
	cpfseq	__SetupPkt + __bRequest
	bra		Check@StdRequest3
	NOLIST
	if((__USB_ACTIVE_CFG & 255) == 0)
		LIST
		clrf	__PSrc
	else
		NOLIST
		if((__USB_ACTIVE_CFG & 255) == 255)
			LIST
			setf	__PSrc
			NOLIST
		else
			LIST
			movlw	(__USB_ACTIVE_CFG & 255)
			movwf	__PSrc
			NOLIST
		endif
	endif
	NOLIST
	if(((__USB_ACTIVE_CFG >> 8) & 255) == 0)
		LIST
		clrf	__PSrc + 1
		NOLIST
	else
		NOLIST
		if(((__USB_ACTIVE_CFG >> 8) & 255) == 255)
			LIST
			setf	__PSrc + 1
			NOLIST
		else
			LIST
			movlw	((__USB_ACTIVE_CFG >> 8) & 255)
			movwf	__PSrc + 1
			NOLIST
		endif
	endif
	LIST
	movlw	1
	movwf	__WCount
	clrf	__WCount + 1
	bcf		__USB_STAT,__CTRL_TRF_MEM		; Indicate RAM
	bra		Std@SetSessionOwnerUSB9
; SET_CONFIGURATION request?
Check@StdRequest3
	movlw	__SET_CFG
	cpfseq	__SetupPkt + __bRequest
	bra		$ + 4
	bra		Std@SetCfgHandler
; GET_STATUS request?
	movlw	__GET_STATUS
	cpfseq	__SetupPkt + __bRequest
	bra		$ + 4
	bra		Std@GetStatusHandler
; CLEAR_FEATURE request?
	movlw	__CLR_FEATURE
	cpfseq	__SetupPkt + __bRequest
	bra		$ + 4
	bra		Std@FeatureReqHandler
; SET_FEATURE request?
	movlw	__SET_FEATURE
	cpfseq	__SetupPkt + __bRequest
	bra		$ + 4
	bra		Std@FeatureReqHandler
; GET_INTERFACE request?
	movlw	__GET_INTF
	cpfseq	__SetupPkt + __bRequest
	bra		Check@StdRequest8
	NOLIST
	if((__USB_ALT_INTF & 255) == 0)
		LIST
		clrf	__PSrc
		NOLIST
	else
		NOLIST
		if((__USB_ALT_INTF & 255) == 255)
			LIST
			setf	__PSrc
			NOLIST
		else
			LIST
			movlw	(__USB_ALT_INTF & 255)
			movwf	__PSrc
			NOLIST
		endif
	endif
	NOLIST
	if(((__USB_ALT_INTF >> 8) & 255) == 0)
		LIST
		clrf	__PSrc + 1
		NOLIST
	else
		NOLIST
		if(((__USB_ALT_INTF >> 8) & 255) == 255)
			LIST
			setf	__PSrc + 1
			NOLIST
		else
			LIST
			movlw	((__USB_ALT_INTF >> 8) & 255)
			movwf	__PSrc + 1
			NOLIST
		endif
	endif
	LIST
	movf	__SetupPkt + __bIntfID,W
	addwf	__PSrc,F
	movlw	1
	movwf	__WCount
	clrf	__WCount + 1
	bcf		__USB_STAT,__CTRL_TRF_MEM		; Indicate RAM
	bra		Std@SetSessionOwnerUSB9

; SET_INTERFACE request?
Check@StdRequest8
	movlw	__SET_INTF
	cpfseq	__SetupPkt + __bRequest
	return
	lfsr	2,__USB_ALT_INTF
	movf	__SetupPkt + __bIntfID,W
	movff	__SetupPkt + __bAltID,PLUSW2
 NOLIST
; Branch here after decoding one of the above USB STANDARD requests.
; Assign a value to __CTRL_TRF_SESSION_OWNER, in order to prevent stalling.
 LIST
Std@SetSessionOwnerUSB9
	movlw	__MUID_USB9
	movwf	__CTRL_TRF_SESSION_OWNER
Check@StdRequestExit
	return
 NOLIST
; ------------------------------------------------------------------------------
; Std@GetDscHandler
; This routine handles the standard GET_DESCRIPTOR request.
; It utilises tables dynamically looks up descriptor size.
;
 LIST
Std@GetDscHandler
	movlw	0x80
	cpfseq	__SetupPkt + __bmRequestType
	return
	movlw	__DSC_DEV
	cpfseq	__SetupPkt + __bDscType
	bra		Std@GetDscHandler1
	if((__DeviceDescriptor & 255) == 0)
		clrf	__PSrc
	else
		if((__DeviceDescriptor & 255) == 255)
			setf	__PSrc
		else
			movlw	(__DeviceDescriptor & 255)
			movwf	__PSrc
		endif
	endif
	NOLIST
	if(((__DeviceDescriptor >> 8) & 255) == 0)
		LIST
		clrf	__PSrc + 1
		NOLIST
	else
		NOLIST
		if(((__DeviceDescriptor >> 8) & 255) == 255)
			LIST
			setf	__PSrc + 1
			NOLIST
		else
			LIST
			movlw	((__DeviceDescriptor >> 8) & 255)
			movwf	__PSrc + 1
			NOLIST
		endif	
	endif
	LIST
	movff	__PSrc,TBLPTRL					; Set __WCount
	movff	__PSrc + 1,TBLPTRH
	clrf	TBLPTRU
	tblrd*									; Read count
	movff	TABLAT,__WCount
	clrf	__WCount + 1
	bsf		__USB_STAT,__CTRL_TRF_MEM		; Indicate ROM
	bra		Std@SetSessionOwnerUSB9
Std@GetDscHandler1
	movlw	__DSC_CFG
	cpfseq	__SetupPkt + __bDscType
	bra		Std@GetDscHandler2
	if((___Config1 & 255) == 0)
		clrf	__PSrc
	else
		if((___Config1 & 255) == 255)
			setf	__PSrc
		else
			movlw	(___Config1 & 255)
			movwf	__PSrc
		endif
	endif
	if(((___Config1 >> 8) & 255) == 0)
		clrf	__PSrc + 1
	else
		if(((___Config1 >> 8) & 255) == 255)
			setf	__PSrc + 1
		else
			movlw	((___Config1 >> 8) & 255)
			movwf	__PSrc + 1
		endif	
	endif
	if((__Config1Len & 255) == 0)
		clrf	TBLPTRL
	else
		if((__Config1Len & 255) == 255)
			setf	TBLPTRL
		else
			movlw	(__Config1Len & 255)		; Set __WCount to total length
			movwf	TBLPTRL
		endif
	endif
	if(((__Config1Len >> 8) & 255) == 0)
		clrf	TBLPTRH
	else
		if(((__Config1Len >> 8) & 255) == 255)
			setf	TBLPTRH
		else
			movlw	((__Config1Len >> 8) & 255)
			movwf	TBLPTRH
		endif
	endif
	clrf	TBLPTRU
	tblrd*+									; Read count low
	movff	TABLAT,__WCount
	tblrd*+									; Skip next
	tblrd*									; Read count high
	movff	TABLAT,__WCount + 1
	bsf		__USB_STAT,__CTRL_TRF_MEM		; Indicate ROM
	bra		Std@SetSessionOwnerUSB9
Std@GetDscHandler2
	movlw	__DSC_STR
	cpfseq	__SetupPkt + __bDscType
	return
	clrf	TBLPTRU
	clrf	TBLPTRH
	rlncf	__SetupPkt + __bDscIndex,W		; Index * 2
	addlw	(__USB_SD_Ptr & 255)			; Add element offset to low address
	movwf	TBLPTRL
	movlw	((__USB_SD_Ptr >> 8) & 255)
	addwfc	TBLPTRH,F
	tblrd*+									; Get the data to TABLAT and move pointer forward
	movff	TABLAT,__PSrc					; Get low source address
	tblrd*
	movff	TABLAT,__PSrc + 1				; Get high source address
	movff	__PSrc,TBLPTRL					; Set __WCount
	movff	__PSrc + 1,TBLPTRH
	clrf	TBLPTRU
	tblrd*									; Read count
	movff	TABLAT,__WCount
	clrf	__WCount + 1	
	bsf		__USB_STAT,__CTRL_TRF_MEM		; Indicate ROM
	bra		Std@SetSessionOwnerUSB9
 NOLIST
; ------------------------------------------------------------------------------
; Std@SetCfgHandler
;
 LIST
Std@SetCfgHandler
	movlw	__MUID_USB9
	movwf	__CTRL_TRF_SESSION_OWNER
	lfsr	2,UEP1							; Reset all non-EP0 UEPn registers
	movlw	15
Std@SetCfgHandlerClearEPLoop
	clrf	POSTINC2
	decfsz	WREG,F
	bra		Std@SetCfgHandlerClearEPLoop
	lfsr	2,__USB_ALT_INTF				; Clear __USB_ALT_INTF array
	movlw	__MAX_NUM_INT
Std@SetCfgHandlerClearAltLoop
	clrf	POSTINC2
	decfsz	WREG,F
	bra		Std@SetCfgHandlerClearAltLoop
	movf	__SetupPkt + __bCfgValue,W
	movwf	__USB_ACTIVE_CFG
	bnz		Std@SetCfgHandler1
	movlw	__ADDRESS_STATE					; __SetupPkt + __bCfgValue = 0
	movwf	__USB_DEVICE_STATE
	return
Std@SetCfgHandler1
	movlw	__CONFIGURED_STATE
	movwf	__USB_DEVICE_STATE
ifdef __USB_USE_CDC
	rcall	CDCInit@EP
endif
ifdef __USB_USE_HID
	rcall	HIDInit@EP
endif
	return
 NOLIST
; ------------------------------------------------------------------------------
; Std@GetStatusHandler
;
 LIST
Std@GetStatusHandler
	clrf	__CtrlTrfData					; Initialise content
	clrf	__CtrlTrfData + 1
	movf	__SetupPkt,W					; Recipient = __RCPT_DEV?
	andlw	0x1F							; Mask to lower 5 bits
	sublw	__RCPT_DEV
	bnz		Std@GetStatusHandler1	; No
 NOLIST
; Recipient of this Setup packet was "Device": set bits to indicate power & remote wakeup
; Decoding of "Self-powered" & "Remote Wakeup"
; byte0:  bit0: Self-Powered Status   [0] Bus-Powered [1] Self-Powered
;         bit1: RemoteWakeup          [0] Disabled    [1] Enabled
 LIST
ifdef USB_BUS_SELF_POWER#REQ
	btfss 	USB_BUS#SELFPOWER 
	bsf		__CtrlTrfData,0
endif
	btfsc	__USB_STAT,__RemoteWakeup
	bsf		__CtrlTrfData,1
	bra		Std@GetStatusSetSessionOwner
;
Std@GetStatusHandler1
	movf	__SetupPkt,W					; Recipient = __RCPT_INTF?
	andlw	0x1F							; Mask to lower 5 bits
	sublw	__RCPT_INTF
	bnz		Std@GetStatusHandler2			; No
 NOLIST
; Recipient of this Setup packet was "Interface": No data to update
 LIST
	bra		Std@GetStatusSetSessionOwner
Std@GetStatusHandler2
	movf	__SetupPkt,W					; Recipient = __RCPT_EP?
	andlw	0x1F							; Mask to lower 5 bits
	sublw	__RCPT_EP
	bnz		Std@GetStatusHandler3			; No
 NOLIST
; Recipient of this Setup packet was "Endpoint"
 LIST
	rcall	Calc@EPAddress					; Put endpoint buffer address in FSR2
	movf	INDF2,W
	andlw	_BSTALL
	bz		Std@GetStatusSetSessionOwner
	bsf		__CtrlTrfData,0
Std@GetStatusSetSessionOwner
	movlw	__MUID_USB9
	movwf	__CTRL_TRF_SESSION_OWNER
Std@GetStatusHandler3
	movlw	__MUID_USB9
	cpfseq	__CTRL_TRF_SESSION_OWNER
	return
	if((__CtrlTrfData & 255) == 0)
		clrf	__PSrc
	else
		if((__CtrlTrfData & 255) == 255)
			setf	__PSrc
		else
			movlw	(__CtrlTrfData & 255)
			movwf	__PSrc
		endif
	endif
	if(((__CtrlTrfData >> 8) & 255) == 0)
		clrf	__PSrc + 1
	else
		if(((__CtrlTrfData >> 8) & 255) == 255)
			setf	__PSrc + 1
		else
			movlw	((__CtrlTrfData >> 8) & 255)
			movwf	__PSrc + 1
		endif
	endif
	movlw	2								; Set count
	movwf	__WCount
	clrf	__WCount + 1
	bcf		__USB_STAT,__CTRL_TRF_MEM		; Indicate RAM
	return
 NOLIST
; ------------------------------------------------------------------------------
; Std@FeatureReqHandler
;
 LIST
Std@FeatureReqHandler
	movlw	__DEVICE_REMOTE_WAKEUP			; If Feature = DEVICE_REMOTE_WAKEUP
	cpfseq	__SetupPkt + __bFeature
	bra		Std@FeatureReqHandler1
	movf	__SetupPkt,W					; Recipient = __RCPT_DEV?
	andlw	0x1F							; Mask to lower 5 bits
	sublw	__RCPT_DEV
	bnz		Std@FeatureReqHandler1			; No
	bsf		__USB_STAT,__RemoteWakeup		; Preset __RemoteWakeup to 1
	movlw	__SET_FEATURE					; Request = __SET_FEATURE?
	cpfseq	__SetupPkt + __bRequest
	bcf		__USB_STAT,__RemoteWakeup		; No,__RemoteWakeup = 0
	bra		Std@SetSessionOwnerUSB9
Std@FeatureReqHandler1
	movlw	__ENDPOINT_HALT					; If Feature = __ENDPOINT_HALT
	cpfseq	__SetupPkt + __bFeature
Std@FeatureReqHandlerExit
	return
	movf	__SetupPkt,W					; Recepient = __RCPT_EP &
	andlw	0x1F							; Mask to lower 5 bits
	sublw	__RCPT_EP
	bnz		Std@FeatureReqHandlerExit
	movf	__SetupPkt + __bEPID,W			; __EPNum != 0
	andlw	0x0F							; Mask to __EPNum
	bz		Std@FeatureReqHandlerExit
	rcall	Calc@EPAddress					; Put endpoint buffer address in FSR2
	movlw	__SET_FEATURE					; Request = __SET_FEATURE?
	cpfseq	__SetupPkt + __bRequest
	bra		Std@FeatureReqHandler2			; No
	movlw	_USIE | _BSTALL
	movwf	INDF2							; Place in endpoint buffer
	bra		Std@SetSessionOwnerUSB9
Std@FeatureReqHandler2
	movlw	_UCPU							; in
	btfss	__SetupPkt + __bEPID,__EPDir	; __EPDir = 1 (in)?
	movlw	_USIE | _DAT0 | _DTSEN			; No - out
	movwf	INDF2							; Place in endpoint buffer
	bra		Std@SetSessionOwnerUSB9
 NOLIST
; Put endpoint buffer address in FSR2 (__ep0Bo + (__EPNum * 8) + (__EPDir * 4))
 LIST
Calc@EPAddress
	lfsr	2,__ep0Bo						; Point FSR2 to beginning of buffer area
	rlncf	__SetupPkt + __bEPID,W			; Move endpoint direction to Carry
	rlcf	__SetupPkt + __bEPID,W			; Endpoint number * 8 (roll in ep direction)
	rlncf	WREG,F
	rlncf	WREG,F
	addwf	FSR2L,F							; Add to FSR2 (can't overflow to FSR2H)
	return
 NOLIST
; ****[END OF USB9.C]*************************************************************************************
;
; ****[START OF USBCTRLTRF.C]*****************************************************************************
; Ctrl@EPService
;
 LIST
Ctrl@EPService
	movlw	__EP00_OUT
	cpfseq	USTAT
	bra		Ctrl@EPService1
	movf	__ep0Bo + __STAT,W
	andlw	0x3C							; Mask to __PID
	sublw	(__SETUP_TOKEN << 2)
	bz		Ctrl@TrfSetupHandler
	bra		Ctrl@TrfOutHandler
Ctrl@EPService1
	movlw	__EP00_IN
	cpfseq	USTAT
	return
	bra		Ctrl@TrfInHandler
 NOLIST
; ------------------------------------------------------------------------------
; Ctrl@TrfSetupHandler
; Pre		: __SetupPkt buffer is loaded with valid USB Setup Data
; Notes:      This routine is a task dispatcher and has 3 stages.
;              1. It initialises the control transfer state machine.
;              2. It calls on each of the module that may know how to service the Setup Request from the host.
;                 Module Example: USB9,HID,CDC,MSD,...
;                 As new classes are added,ClassReqHandler table in usbdsc.c should be updated to call all available CLASS handlers.
;              3. Once each of the modules has had a chance to check if it is responsible for servicing the request,
;				  stage 3 then checks direction of the transfer to determine how to prepare EP0 for the control transfer.
;                 Refer to Ctrl@EPServiceComplete() for more details.
;
; 			  The USB Firmware has 3 different states for the control transfer state machine: -
;              1. WAIT_SETUP
;              2. CTRL_TRF_TX
;              3. CTRL_TRF_RX
;
 LIST
Ctrl@TrfSetupHandler
	movlw	__WAIT_SETUP
	movwf	__CTRL_TRF_STATE
	if(__MUID_NULL == 0)					; Set owner to NULL
		clrf	__CTRL_TRF_SESSION_OWNER
	else
		movlw	__MUID_NULL						
		movwf	__CTRL_TRF_SESSION_OWNER
	endif
	clrf	__WCount
	clrf	__WCount + 1
	rcall	Check@StdRequest
	movlw	__MUID_NULL
	cpfseq	__CTRL_TRF_SESSION_OWNER
	bra		Ctrl@EPServiceComplete
	
ifdef __USB_USE_HID
	rcall	Check@HIDRequest
endif 										

ifdef __USB_USE_CDC
	rcall	Check@CDCRequest
endif 										
	bra		Ctrl@EPServiceComplete
 NOLIST
; ------------------------------------------------------------------------------
; Ctrl@TrfOutHandler
;
 LIST
Ctrl@TrfOutHandler
	movlw	__CTRL_TRF_RX
	cpfseq	__CTRL_TRF_STATE
	bra		Prepare@FNSTrf
	rcall	Ctrl@TrfRxService
	movlw	_USIE | _DAT1 | _DTSEN
	btfsc	__ep0Bo + __STAT,__DTS
	movlw	_USIE | _DAT0 | _DTSEN
	movwf	__ep0Bo + __STAT
	return
 NOLIST
; ------------------------------------------------------------------------------
; Ctrl@TrfInHandler 
;
 LIST
Ctrl@TrfInHandler
	movlw	__ADR_PENDING_STATE	
	cpfseq	__USB_DEVICE_STATE
	bra		Ctrl@TrfInHandler1
	movf	__SetupPkt + __bDevADR,W
	movwf	UADDR
	movlw	__ADDRESS_STATE					
	btfsc	STATUS,Z
	movlw	__DEFAULT_STATE
	movwf	__USB_DEVICE_STATE
Ctrl@TrfInHandler1
	movlw	__CTRL_TRF_TX
	cpfseq	__CTRL_TRF_STATE
	bra		Prepare@FNSTrf
	rcall	Ctrl@TrfTxService
	movlw	_USIE | _DAT1 | _DTSEN
	btfsc	__ep0Bi + __STAT,__DTS
	movlw	_USIE | _DAT0 | _DTSEN
	movwf	__ep0Bi + __STAT
	return
 NOLIST
; ------------------------------------------------------------------------------
; Ctrl@TrfTxService
; Pre		: __PSrc, __WCOUNT, __USB_STAT, and __CTRL_TRF_MEM are setup correctly.
; Notes		: This routine should be called from only two places.
;             One from Ctrl@EPServiceComplete() and one from Ctrl@TrfInHandler(). 
;			  It takes care of managing a transfer over multiple USB transactions.
;			  This routine works with isochronous endpoint larger than 256 bytes and is shown here as an example of how to deal
;             with __BC9 and __BC8. In reality, a control endpoint can never be larger than 64 bytes.
 LIST
Ctrl@TrfTxService
	movf	__WCount,W						; Preset __WCount bytes to send
	movwf	__USB_TEMP_VAR
	movf	__WCount + 1,W
	movwf	__USB_TEMP_VAR + 1
	sublw	((__EP0_BUFF_SIZE >> 8) & 255)	; Make sure count does not exceed maximium length
	bnc		Ctrl@TrfTxServiceCopy
	bnz		Ctrl@TrfTxServiceSub
	movf	__WCount,W
	sublw	(__EP0_BUFF_SIZE & 255)
	bc		Ctrl@TrfTxServiceSub
Ctrl@TrfTxServiceCopy
	if((__EP0_BUFF_SIZE & 255) == 0)		; Send buffer full of bytes
		clrf	__USB_TEMP_VAR
	else
		if((__EP0_BUFF_SIZE & 255) == 255)
			setf	__USB_TEMP_VAR
		else
			movlw	(__EP0_BUFF_SIZE & 255)		
			movwf	__USB_TEMP_VAR
		endif
	endif
	if(((__EP0_BUFF_SIZE >> 8) & 255) == 0)
		clrf	__USB_TEMP_VAR + 1
	else
		if(((__EP0_BUFF_SIZE >> 8) & 255) == 255)
			setf	__USB_TEMP_VAR + 1
		else
			movlw	((__EP0_BUFF_SIZE >> 8) & 255)
			movwf	__USB_TEMP_VAR + 1
		endif
	endif
Ctrl@TrfTxServiceSub
	movf	__USB_TEMP_VAR,W				; Subtract actual bytes to be sent from the buffer
	movwf	__ep0Bi + __CNT					; Save low number of bytes to send while we're here
	subwf	__WCount,F
	movf	__USB_TEMP_VAR + 1,W
	subwfb	__WCount + 1,F
	movf	__ep0Bi + __STAT,W				; Get full __STAT byte
	andlw	0xFC							; Clear bottom bits
	iorwf	__USB_TEMP_VAR + 1,W			; Place in high bits of bytes to send
	movwf	__ep0Bi + __STAT				; Save it out
	lfsr	2,__CtrlTrfData					; Set destination pointer
	movf	__USB_TEMP_VAR + 1,W			; Check high byte for 0
	bnz		Ctrl@TrfTxServiceRomRam			; High byte not 0,must have something to do
	movf	__USB_TEMP_VAR,W				; Check low byte for 0
	bz		Ctrl@TrfTxServiceExit			; If both 0 then nothing to send this time
Ctrl@TrfTxServiceRomRam
	btfss	__USB_STAT,__CTRL_TRF_MEM		; ROM or RAM?
	bra		Ctrl@TrfTxServiceRam			; RAM
	movff	__PSrc,TBLPTRL					; Move source pointer to TBLPTR
	movff	__PSrc + 1,TBLPTRH
	clrf	TBLPTRU
Ctrl@TrfTxServiceRomLoop
	tblrd*+
	movff	TABLAT,POSTINC2					; Copy one buffer to the other
	tblrd*+									; Skip high location
	decf	__USB_TEMP_VAR,F				; Count down number of bytes
	bnz		Ctrl@TrfTxServiceRomLoop
	decf	__USB_TEMP_VAR + 1,F
	bc		Ctrl@TrfTxServiceRomLoop
	movff	TBLPTRL,__PSrc					; Update source pointer
	movff	TBLPTRH,__PSrc + 1
	return
Ctrl@TrfTxServiceRam
	movff	__PSrc,FSR1L					; Move source pointer to FSR1
	movff	__PSrc + 1,FSR1H
Ctrl@TrfTxServiceRamLoop
	movff	POSTINC1,POSTINC2				; Copy one buffer to the other
	decf	__USB_TEMP_VAR,F				; Count down number of bytes
	bnz		Ctrl@TrfTxServiceRamLoop
	decf	__USB_TEMP_VAR + 1,F
	bc		Ctrl@TrfTxServiceRamLoop
	movff	FSR1L,__PSrc					; Update source pointer
	movff	FSR1H,__PSrc + 1
Ctrl@TrfTxServiceExit
	return
 NOLIST
; ------------------------------------------------------------------------------
; Ctrl@TrfRxService
; Pre		: __PDst and __WCount are setup properly.
;             __PSrc is always &__CtrlTrfData
;             __USB_STAT.__CTRL_TRF_MEM is always _RAM.
;             __WCount should be set to 0 at the start of each control transfer.
;
 LIST
Ctrl@TrfRxService
	movf	__ep0Bo + __CNT,W				; Get low number of bytes to read
	movwf	__USB_TEMP_VAR					; __USB_TEMP_VAR & __USB_TEMP_VAR + 1 are bytes to read
	addwf	__WCount,F						; Accumulate total number of bytes read
	movf	__ep0Bo + __STAT,W				; Get high bits to read
	andlw	3								; Mask to the count
	movwf	__USB_TEMP_VAR + 1				; Save to high byte of bytes to read
	addwfc	__WCount + 1,F					; Add overflow from low byte (C) and high byte to total number
	lfsr	1,__CtrlTrfData					; Point FSR1 to source
	movff	__PDst,FSR2L					; Move destination pointer to FSR2
	movff	__PDst + 1,FSR2H
	movf	__USB_TEMP_VAR + 1,W			; Check high byte for 0
	bnz		Ctrl@TrfRxServiceLoop			; High byte not 0, must have something to do
	movf	__USB_TEMP_VAR,W				; Check low byte for 0
	bz		Ctrl@TrfRxServiceExit			; If both 0 then nothing to send this time
Ctrl@TrfRxServiceLoop
	movff	POSTINC1,POSTINC2				; Copy one buffer to the other
	decf	__USB_TEMP_VAR,F				; Count down number of bytes
	bnz		Ctrl@TrfRxServiceLoop
	decf	__USB_TEMP_VAR + 1,F
	bc		Ctrl@TrfRxServiceLoop
	movff	FSR2L,__PDst					; Update destination pointer
	movff	FSR2H,__PDst + 1
Ctrl@TrfRxServiceExit
	return
 NOLIST
; ------------------------------------------------------------------------------
; Ctrl@EPServiceComplete
; Notes		: This routine wraps up the ramaining tasks in servicing a Setup Request. 
;			  Its main task is to set the endpoint controls appropriately for a given situation.
;             There are three main scenarios:
;               a) There was no handler for the Request,in this case a STALL should be sent out.
;               b) The host has requested a read control transfer, endpoints are required to be setup in a specific way.
;               c) The host has requested a write control transfer,or a control data stage is not required,
;				   endpoints are required to be setup in a specific way.
;             Packet processing is resumed by clearing PKTDIS bit.
;
 LIST
Ctrl@EPServiceComplete
	movlw	__MUID_NULL
	cpfseq	__CTRL_TRF_SESSION_OWNER
	bra		Ctrl@EPServiceComplete1
 NOLIST
; No handlers claimed ownership of this Setup packet.
; If no one knows how to service this request then stall.
; Must also prepare EP0 to receive the next SETUP transaction.
 LIST
	movlw	__EP0_BUFF_SIZE
	movwf	__ep0Bo + __CNT
	if((__SetupPkt & 255) == 0)
		clrf	__ep0Bo + __ADRL
	else
		if((__SetupPkt & 255) == 255)
			setf	__ep0Bo + __ADRL
		else
			movlw	(__SetupPkt & 255)
			movwf	__ep0Bo + __ADRL
		endif
	endif
	if(((__SetupPkt >> 8) & 255) == 0)
		clrf	__ep0Bo + __ADRH
	else
		if(((__SetupPkt >> 8) & 255) == 255)
			setf	__ep0Bo + __ADRH
		else
			movlw	((__SetupPkt >> 8) & 255)
			movwf	__ep0Bo + __ADRH
		endif
	endif
	movlw	_USIE | _BSTALL
	movwf	__ep0Bo + __STAT
	movwf	__ep0Bi + __STAT
	bra		Ctrl@EPServiceCompleteExit
 NOLIST
; A module has claimed ownership of the control transfer session.
 LIST
Ctrl@EPServiceComplete1
	btfss	__SetupPkt,__DataDir
	bra		Ctrl@EPServiceComplete2
	movf	__WCount + 1,W						; Make sure count does not exceed maximium length
	subwf	__SetupPkt + __wLength + 1,W
	bnc		Ctrl@EPServiceCompleteCopy
	bnz		Ctrl@EPServiceComplete11
	movf	__WCount,W
	subwf	__SetupPkt + __wLength,W
	bc		Ctrl@EPServiceComplete11
Ctrl@EPServiceCompleteCopy
	movff	__SetupPkt + __wLength,__WCount		; Set count to maximum
	movff	__SetupPkt + __wLength + 1,__WCount + 1
;
; Setup packet's data direction is "Device to Host"
;
Ctrl@EPServiceComplete11
	rcall	Ctrl@TrfTxService
	movlw	__CTRL_TRF_TX
	movwf	__CTRL_TRF_STATE
 NOLIST
; Control Read:
; <SETUP[0]> <IN[1]> <IN[0]> ... <OUT[1]> | <SETUP[0]>
; 1. Prepare OUT EP to respond to early termination
;
; Note:
; If something went wrong during the control transfer,the last status stage may not be sent by the host.
; When this happens,two different things could happen depending on the host.
; a) The host could send out a Reset.
; b) The host could send out a new Setup transaction without sending a Reset first.
; To properly handle case (b),the out EP must be setup to receive either a zero length out transaction,or a new Setup transaction.
;
; Since the Setup transaction requires the __DTS bit to be DAT0 while the zero length out status requires the __DTS
; bit to be DAT1,the __DTS bit check by the hardware should be disabled. 
; This way the SIE could accept either of the two transactions.
;
; Also, the __CNT byte should be set to prepare for the SETUP data (8-byte or more),
; and the buffer address should be pointed to __SetupPkt.
 LIST
	movlw	__EP0_BUFF_SIZE
	movwf	__ep0Bo + __CNT
	if((__SetupPkt & 255) == 0)
		clrf	__ep0Bo + __ADRL
	else
		if((__SetupPkt & 255) == 255)
			setf	__ep0Bo + __ADRL
		else
			movlw	(__SetupPkt & 255)
			movwf	__ep0Bo + __ADRL
		endif
	endif
	if(((__SetupPkt >> 8) & 255) == 0)
		clrf	__ep0Bo + __ADRH
	else
		if(((__SetupPkt >> 8) & 255) == 255)
			setf	__ep0Bo + __ADRH
		else
			movlw	((__SetupPkt >> 8) & 255)
			movwf	__ep0Bo + __ADRH
		endif
	endif
	movlw	_USIE							; Note: __DTSEN is 0!
;
; 2. Prepare IN EP to transfer data,__CNT should have been initialised by responsible request owner.
	movwf	__ep0Bo + __STAT
	if((__CtrlTrfData & 255) == 0)
		clrf	__ep0Bi + __ADRL
	else
		if((__CtrlTrfData & 255) == 255)
			setf	__ep0Bi + __ADRL
		else
			movlw	(__CtrlTrfData & 255)
			movwf	__ep0Bi + __ADRL
		endif
	endif
	if(((__CtrlTrfData >> 8) & 255) == 0)
		clrf	__ep0Bi + __ADRH
	else
		if(((__CtrlTrfData >> 8) & 255) == 255)
			setf	__ep0Bi + __ADRH
		else
			movlw	((__CtrlTrfData >> 8) & 255)
			movwf	__ep0Bi + __ADRH
		endif
	endif
	movlw	_USIE | _DAT1 | _DTSEN
	movwf	__ep0Bi + __STAT
	bra		Ctrl@EPServiceCompleteExit
; Setup packet's data direction is "Host to Device"
Ctrl@EPServiceComplete2
	movlw	__CTRL_TRF_RX
	movwf	__CTRL_TRF_STATE
 NOLIST
; Control Write:
; <SETUP[0]><OUT[1]><OUT[0]>...<IN[1]> | <SETUP[0]>
;
; 1. Prepare IN EP to respond to early termination
; This is the same as a Zero Length Packet Response for control transfer without a data stage
 LIST
	clrf	__ep0Bi + __CNT
	movlw	_USIE | _DAT1 | _DTSEN
	movwf	__ep0Bi + __STAT
; 2. Prepare OUT EP to receive data.
	movlw	__EP0_BUFF_SIZE
	movwf	__ep0Bo + __CNT
	if((__CtrlTrfData & 255) == 0)
		clrf	__ep0Bo + __ADRL
	else
		if((__CtrlTrfData & 255) == 255)
			setf	__ep0Bo + __ADRL
		else
			movlw	(__CtrlTrfData & 255)
			movwf	__ep0Bo + __ADRL
		endif
	endif
	if(((__CtrlTrfData >> 8) & 255) == 0)
		clrf	__ep0Bo + __ADRH
	else
		if(((__CtrlTrfData >> 8) & 255) == 255)
			setf	__ep0Bo + __ADRH
		else
			movlw	((__CtrlTrfData >> 8) & 255)
			movwf	__ep0Bo + __ADRH
		endif
	endif
	movlw	_USIE | _DAT1 | _DTSEN
	movwf	__ep0Bo + __STAT
 NOLIST
; PKTDIS bit is set when a Setup Transaction is received.
; Clear to resume packet processing.
 LIST
Ctrl@EPServiceCompleteExit
	bcf		UCON,PKTDIS
	return
 NOLIST
; ------------------------------------------------------------------------------
; Prepare@FNSTrf
; Force the EP0 out to be ready for a new Setup transaction,and forces EP0 in to be owned by CPU.
;
 LIST
Prepare@FNSTrf
	movlw	__WAIT_SETUP
	movwf	__CTRL_TRF_STATE
	movlw	__EP0_BUFF_SIZE
	movwf	__ep0Bo + __CNT
	if((__SetupPkt & 255) == 0)
		clrf	__ep0Bo + __ADRL
	else
		if((__SetupPkt & 255) == 255)
			setf	__ep0Bo + __ADRL
		else
			movlw	(__SetupPkt & 255)
			movwf	__ep0Bo + __ADRL
		endif
	endif
	if(((__SetupPkt >> 8) & 255) == 0)
		clrf	__ep0Bo + __ADRH
	else
		if(((__SetupPkt >> 8) & 255) == 255)
			setf	__ep0Bo + __ADRH
		else
			movlw	((__SetupPkt >> 8) & 255)
			movwf	__ep0Bo + __ADRH
		endif
	endif
	movlw	_USIE | _DAT0 | _DTSEN			; EP0 buff dsc init
	movwf	__ep0Bo + __STAT
	movlw	_UCPU							; EP0 in buffer initialisation
	movwf	__ep0Bi + __STAT
	return
 NOLIST
; ****[END OF USBCTRLTRF.C]*******************************************************************************
;
; ****[START OF USBDRV.C]*********************************************************************************
 LIST
InitialiseUSB@Driver
	movlb	((__USB_RAM_BANK >> 8) & 255)	; Point to bank holding the variables
	movlw	__UCFG_VAL
	movwf	UCFG
	clrf	__USB_DEVICE_STATE
	clrf	__USB_STAT
	clrf	__USB_ACTIVE_CFG
ifdef __USB_USE_CDC
	rcall	CDCInit@EP
endif
ifdef __USB_USE_HID
	rcall	HIDInit@EP
endif
	return
 NOLIST
; ------------------------------------------------------------------------------
; Check@BusStatus
; Enable/disable the USB module by monitoring the USB power signal.
; Bus Attachment & Detachment Detection.
 LIST
Check@BusStatus
	movlb	((__USB_RAM_BANK >> 8) & 255)	; Point to bank holding the variables
ifdef USB_BUS_SENSE_IO#REQ
	btfss	USB_BUS#SENSE					; Is USB bus attached?
	bra		Check@BusStatusDetached			; No
endif
	btfss	UCON,USBEN						; Is the module off?
	rcall	Module@Enable					; If off then enable it
ifdef USB_BUS_SENSE_IO#REQ
	bra		Check@BusStatus1
Check@BusStatusDetached
	btfsc	UCON,USBEN						; Is the module on?
	rcall	Module@Disable					; If on then disable it
endif
 NOLIST
;
; After enabling the USB module, it takes some time for the voltage on the D+ or D- line to rise high 
; enough to get out of the SE0 condition.
; The USB Reset interrupt should not be unmasked until the SE0 condition is cleared. 
; This helps prevent the firmware from misinterpreting this unique event as a USB bus reset from the USB host.
 LIST
Check@BusStatus1
	movlw	__ATTACHED_STATE
	cpfseq	__USB_DEVICE_STATE
	return
	btfsc	UCON,SE0
	return
	clrf	UIR								; Clear all USB interrupts
	clrf	UIE								; Mask all USB interrupts
	bsf		UIE,URSTIE						; Unmask RESET interrupt
	bsf		UIE,IDLEIE						; Unmask IDLE interrupt
	movlw	__POWERED_STATE
	movwf	__USB_DEVICE_STATE
	return
; --------------------------------------------
Module@Enable
	clrf	UCON
	clrf	UIE								; Mask all USB interrupts
	bsf		UCON,USBEN						; Enable module & attach to bus
	movlw	__ATTACHED_STATE
	movwf	__USB_DEVICE_STATE
	return
; --------------------------------------------
Module@Disable
	clrf	UCON							; Disable module & detach from bus
	clrf	UIE								; Mask all USB interrupts
	clrf	__USB_DEVICE_STATE				; Saet state to DETACHED
	return
 NOLIST
; ------------------------------------------------------------------------------
; Driver@Service
; This routine is the heart of this firmware. It manages all USB interrupts.
; Device state transitions through the following stages:
; DETACHED -> ATTACHED -> POWERED -> DEFAULT -> ADDRESS_PENDING -> ADDRESSED -> CONFIGURED -> READY
;
 LIST
Driver@Service
	movlb	((__USB_RAM_BANK >> 8) & 255)	; Point to bank holding the variables
	movlw	__DETACHED_STATE
	subwf	__USB_DEVICE_STATE,W
	bz		Driver@ServiceExit				; Pointless to continue servicing if USB cable is not attached.
; Task A: Service USB Activity Interrupt
	btfss	UIR,ACTVIF
	bra		Driver@Service1
	btfsc	UIE,ACTVIE
	rcall	Wake@FromSuspend
;
Driver@Service1
	btfsc	UCON,SUSPND						; Are we suspended?
	return									; Pointless to continue servicing if the device is in suspend mode.
 NOLIST
; Task B: Service USB Bus Reset Interrupt.
; When bus reset is received during suspend,ACTVIF will be set first,
; once the UCON.SUSPND is clear, then the URSTIF bit will be asserted.
; This is why URSTIF is checked after ACTVIF.
;
; The USB reset flag is masked when the USB state is in DETACHED_STATE or ATTACHED_STATE,
; and therefore cannot cause a USB reset event during these two states.
 LIST
	btfss	UIR,URSTIF        				; USB Bus Reset Interrupt?
	bra		$ + 6
	btfsc	UIE,URSTIE
	rcall	Protocol@ResetHandler
; Task C: Check & service other USB interrupts
	btfss	UIR,IDLEIF
	bra		$ + 6
	btfsc	UIE,IDLEIE
	rcall	Suspend@USB
	btfss	UIR,SOFIF
	bra		$ + 6
	btfsc	UIE,SOFIE
	rcall	SOF@Handler
	btfss	UIR,STALLIF
	bra		$ + 6
	btfsc	UIE,STALLIE
	rcall	Stall@Handler
	btfss	UIR,UERRIF
	bra		$ + 6
	btfsc	UIE,UERRIE
	rcall	Error@Handler
 NOLIST
; Pointless to continue servicing if the host has not sent a bus reset.
; Once a bus reset is received, the device transitions into the default state and is ready for communication.
 LIST
	movlw	__DEFAULT_STATE
	subwf	__USB_DEVICE_STATE,W
	bnc	Driver@ServiceExit
; Task D: Servicing USB Transaction Complete Interrupt
	btfss	UIR,TRNIF
	bra		Driver@ServiceExit
	btfss	UIE,TRNIE
	bra		Driver@ServiceExit
 NOLIST
; Ctrl@EPService only services transactions over EP0.
; It ignores all other EP transactions.
 LIST
	rcall	Ctrl@EPService
 NOLIST
; Other EPs can be serviced later by responsible device Class firmware.
; Each device driver knows when an out or in transaction is ready by checking the buffer ownership bit.
; An OUT EP should always be owned by SIE until the data is ready.
; An IN EP should always be owned by CPU until the data is ready.
;
; Because of this logic,it is not necessary to save the USTAT value of non-EP0 transactions.
 LIST
	bcf		UIR,TRNIF
Driver@ServiceExit
	return
 NOLIST
; ------------------------------------------------------------------------------
; Suspend@USB
; Note		: Do not clear UIR.ACTVIF here!
; Reason	: ACTVIF is only generated once an IDLEIF has been generated.
; 			  This is a 1:1 ratio interrupt generation.
; 			  For every IDLEIF,there will be only one ACTVIF regardless of the number of subsequent bus transitions.
;
;	 		  If the ACTIF is cleared here,a problem could occur when:
;	 		  [       IDLE       ][bus activity ->
;	 		  <--- 3 ms ----->     ^
;			                  ^     ACTVIF=1
;			                  IDLEIF=1
;			    #           #           #           #   (# = Program polling flags)
;			                            ^
;			                            This polling loop will see both
;			                            IDLEIF = 1 and ACTVIF = 1.
;			 However,the program services IDLEIF first because ACTIVIE = 0.
;		     If this routine clears the only ACTIVIF, then it can never get out of the suspend mode.
 LIST
Suspend@USB
	bsf		UIE,ACTVIE					; Enable bus activity interrupt
	bcf		UIR,IDLEIF
	bsf		UCON,SUSPND					; Put USB module in power conserve
; At this point the PIC can go into sleep,idle,or switch to a slower clock,etc.
	return
 NOLIST
; ------------------------------------------------------------------------------
; Wake@FromSuspend
;
 LIST
Wake@FromSuspend
; If using clock switching,this is the place to restore the original clock frequency.
	bcf		UCON,SUSPND
	bcf		UIE,ACTVIE
	bcf		UIR,ACTVIF
	return
 NOLIST
; ------------------------------------------------------------------------------
; Remote@Wakeup
; Note		: This function should be called by user when the device is woken up by an external stimulus other than ACTIVIF.
;             Please read the note below to understand the limitations.
;
;			 The modifiable section in this routine should be changed to meet the application needs. 
;		     Current implementation temporary blocks other functions from executing for a period of 1-13 ms depending on the core frequency.
;
;            According to USB 2.0 specification section 7.1.7.7,
;            "The remote wakeup device must hold the resume signaling for at lest 1 ms but for no more than 15 ms."
;            The idea here is to use a delay counter loop,using a common value that would work over a wide range of core frequencies.
;            That value selected is 1800. See table below:
;            ==========================================================
;            Core Freq(MHz)      MIP         RESUME Signal Period (ms)
;            ==========================================================
;                48              12          1.05
;                 4              1           12.6
;            ==========================================================
;
 LIST
Remote@Wakeup
	btfss	__USB_STAT,__RemoteWakeup	; Check if RemoteWakeup function has been enabled by the host.
	return								; No
	rcall	Wake@FromSuspend			; Unsuspend USB modue
	bsf		UCON,RESUME					; Start RESUME signaling
	movlw	0x10						; Set RESUME line for 1 - 13 ms
	movwf	PRODH						; Using PRODL\H as a temp variable
	clrf	PRODL
Remote@WakeupL
	decfsz	PRODL,F
	bra		Remote@WakeupL
	decfsz	PRODH,F
	bra		Remote@WakeupL
	bcf		UCON,RESUME
	return
 NOLIST
; ------------------------------------------------------------------------------
; SOF@Handler
; Notes		: The USB host sends out a SOF packet to full-speed devices every 1 ms. 
;			  This interrupt may be useful for isochronous pipes. 
;			  End designers should implement callback routine as necessary.
;
 LIST
SOF@Handler
; Callback routine here
	bcf 	UIR,SOFIF
	return
 NOLIST
; ------------------------------------------------------------------------------
; Stall@Handler
; Pre		: A STALL packet is sent to the host by the SIE.
; Notes		: The STALLIF is set anytime the SIE sends out a STALL packet regardless of which endpoint causes it.
;             A Setup transaction overrides the STALL function. A stalled endpoint stops stalling once it receives a setup packet.
;             In this case,the SIE will accepts the Setup packet and set the TRNIF flag to notify the firmware. 
;		      STALL function for that particular endpoint pipe will be automatically disabled (direction specific).
;
;             There are a few reasons for an endpoint to be stalled.
;              1. When a non-supported USB request is received.
;                 Example: GET_DESCRIPTOR(DEVICE_QUALIFIER)
;              2. When an endpoint is currently halted.
;              3. When the device Class specifies that an endpoint must stall in response to a specific event.
;                 Example: Mass Storage Device Class
;             If the CBW is not valid,the device shall STALL the Bulk-in pipe.
;             See USB Mass Storage Class Bulk-only Transport Specification for more details.
;
;             UEPn.EPSTALL can be scanned to see which endpoint causes the stall event.
;
; 			  Does not really have to do anything here, even for the control endpoint.
; 			  All BDs of Endpoint 0 are owned by SIE right now, but once a Setup Transaction is received,the ownership
; 			  for EP0_OUT will be returned to CPU.
; 			  When the Setup Transaction is serviced,the ownership for EP0_IN will then be forced back to CPU by firmware.
;
; 			  Above description is not quite true at this point.
;       	  It seems the SIE never returns the __UOWN bit to CPU, and a TRNIF is never generated 
;			  upon successful reception of a SETUP transaction.
;       	  A Firmware work-around is implemented below.
;
 LIST
Stall@Handler
	btfsc	UEP0,EPSTALL
	rcall	Prepare@FNSTrf		; Firmware Workaround
	bcf		UEP0,EPSTALL
	bcf		UIR,STALLIF
	return
 NOLIST
; ------------------------------------------------------------------------------
; Error@Handler
;
 LIST
Error@Handler
	bcf		UIR,UERRIF
	return
 NOLIST
; ------------------------------------------------------------------------------
; Protocol@ResetHandler
; Pre			:  A USB bus reset is received from the host.
; Side Effects	:  Currently,this routine flushes any pending USB transactions. It empties out the USTAT FIFO. This action
;                  might not be desirable in some applications.
; Notes			:  Once a USB bus reset is received from the host,this routine should be called. 
;				   It resets the device address to zero,disables all non-EP0 endpoints, 
;				   initialises EP0 to be ready for default communication,clears all USB interrupt flags,
;				   unmasks applicable USB interrupts, and reinitialises internal state-machine variables.
;
 LIST
Protocol@ResetHandler
	clrf	UEIR							; Clear all USB error flags
	clrf	UIR								; Clears all USB interrupts
	movlw	0x9F							; Unmask all USB error interrupts
	movwf	UEIE
	movlw	0x7B							; Enable all interrupts except ACTVIE
	movwf	UIE
	clrf	UADDR							; Reset to default address
	lfsr	2,UEP1							; Reset all non-EP0 UEPn registers
	movlw	15
Protocol@RstHandlerClearL
	clrf	POSTINC2
	decfsz	WREG,F
	bra		Protocol@RstHandlerClearL
	movlw	__EP_CTRL | __HSHK_EN			; Init EP0 as a Ctrl EP
	movwf	UEP0
	btfsc	UIR,TRNIF						; Flush any pending transactions
Protocol@RstHandlerFlushL
	bcf		UIR,TRNIF
	btfsc	UIR,TRNIF
	bra		Protocol@RstHandlerFlushL
	bcf		UCON,PKTDIS						; Make sure packet processing is enabled
  	rcall	Prepare@FNSTrf
	bcf		__USB_STAT,__RemoteWakeup		; Default status flag to disable
	clrf	__USB_ACTIVE_CFG				; Clear active configuration
	movlw	__DEFAULT_STATE
  	movwf	__USB_DEVICE_STATE
	return
 NOLIST
; ****[END OF USBDRV.C]*********************************************************************************
;
; ****[START OF HID.C]**********************************************************************************
 NOLIST	
ifdef __USB_USE_HID
; ------------------------------------------------------------------------------
; Check@HIDRequest
;
 LIST
Check@HIDRequest
	movlb	((__USB_RAM_BANK >> 8) & 255)	; Point to bank holding the variables
	movf	__SetupPkt,W					; Recipient = __RCPT_INTF?
	andlw	0x1F							; Mask to lower 5 bits
	sublw	__RCPT_INTF
	bnz		Check@HIDRequestEx				; No
	movlw	__HID_INTF_ID					; IntfID = __HID_INTF_ID?
	cpfseq	__SetupPkt + __bIntfID
Check@HIDRequestEx
	return									; No
;
; There are two __STANDARD requests that hid.c may support.
; 1. GET_DSC(__DSC_HID,__DSC_RPT,__DSC_PHY);
; 2. SET_DSC(__DSC_HID,__DSC_RPT,__DSC_PHY);
;
	movlw	__GET_DSC						; Request = __GET_DSC?
	cpfseq	__SetupPkt + __bRequest
	bra		Check@HIDRequestClass			; No
	movlw	__DSC_HID						; DscType = __DSC_HID?
	cpfseq	__SetupPkt + __bDscType
	bra		Check@HIDRequests				; No
	if((__HIDDescriptor1 & 255) == 0)
		clrf	__PSrc
	else
		if((__HIDDescriptor1 & 255) == 255)
			setf	__PSrc
		else
			movlw	(__HIDDescriptor1 & 255)
			movwf	__PSrc
		endif
	endif
	if(((__HIDDescriptor1 >> 8) & 255) == 0)
		clrf	__PSrc + 1
	else
		if(((__HIDDescriptor1 >> 8) & 255) == 255)
			setf	__PSrc + 1
		else
			movlw	((__HIDDescriptor1 >> 8) & 255)
			movwf	__PSrc + 1
		endif
	endif
	movff	__PSrc,TBLPTRL					; Set __WCount
	movff	__PSrc + 1,TBLPTRH
	clrf	TBLPTRU
	tblrd*									; Read count
	movff	TABLAT,__WCount
	clrf	__WCount + 1	
	bsf		__USB_STAT,__CTRL_TRF_MEM		; Indicate ROM
	bra		HID@SetSessionOwner
Check@HIDRequests
	movlw	__DSC_RPT						; DscType = __DSC_RPT?
	cpfseq	__SetupPkt + __bDscType
	bra		Check@HIDRequestClass			; No
	if((__ReportDescriptor1 & 255) == 0)
		clrf	__PSrc
	else
		if((__ReportDescriptor1 & 255) == 255)
			setf	__PSrc
		else
			movlw	(__ReportDescriptor1 & 255)
			movwf	__PSrc
		endif
	endif
	if(((__ReportDescriptor1 >> 8) & 255) == 0)
		clrf	__PSrc + 1
	else
		if(((__ReportDescriptor1 >> 8) & 255) == 255)
			setf	__PSrc + 1
		else
			movlw	((__ReportDescriptor1 >> 8) & 255)
			movwf	__PSrc + 1
		endif
	endif
	if((__ReportDescriptor1Len & 255) == 0)	 ; Set __WCount
		clrf	TBLPTRL
	else
		if((__ReportDescriptor1Len & 255) == 255)
			setf	TBLPTRL
		else
			movlw	(__ReportDescriptor1Len & 255)
			movwf	TBLPTRL
		endif
	endif
	if(((__ReportDescriptor1Len >> 8) & 255) == 0)
		clrf	TBLPTRH
	else
		if(((__ReportDescriptor1Len >> 8) & 255) == 255)
			setf	TBLPTRH
		else
			movlw	((__ReportDescriptor1Len >> 8) & 255)
			movwf	TBLPTRH
		endif
	endif
	clrf	TBLPTRU
	tblrd*+									; Read count low
	movff	TABLAT,__WCount
	tblrd*+									; Skip next
	tblrd*									; Read count high
	movff	TABLAT,__WCount + 1
	bsf		__USB_STAT,__CTRL_TRF_MEM		; Indicate ROM
	bra		HID@SetSessionOwner
Check@HIDRequestClass
	movf	__SetupPkt,W					; RequestType = CLASS?
	andlw	0x60							; Mask to proper bits
	sublw	(__CLASS << 5)
	bnz		Check@HIDRequestEx				; No
	movlw	__GET_IDLE						; Request = __GET_IDLE?
	cpfseq	__SetupPkt + __bRequest
	bra		Check@HIDRequestClassl			; No
	if((__IDLE_RATE & 255) == 0)
		clrf	__PSrc
	else
		if((__IDLE_RATE & 255) == 255)
			setf	__PSrc
		else
			movlw	(__IDLE_RATE & 255)
			movwf	__PSrc
		endif
	endif
	if(((__IDLE_RATE >> 8) & 255) == 0)
		clrf	__PSrc + 1
	else
		if(((__IDLE_RATE >> 8) & 255) == 255)
			setf	__PSrc + 1
		else
			movlw	((__IDLE_RATE >> 8) & 255)
			movwf	__PSrc + 1
		endif	
	endif
	movlw	1
	movwf	__WCount
	clrf	__WCount + 1
	bcf		__USB_STAT,__CTRL_TRF_MEM		; Indicate RAM
	bra		HID@SetSessionOwner
Check@HIDRequestClassl
	movlw	__SET_IDLE						; Request = __SET_IDLE?
	cpfseq	__SetupPkt + __bRequest
	bra		Check@HIDRequestClassl1			; No
	movff	__SetupPkt + __wValue + 1,__IDLE_RATE
	bra		HID@SetSessionOwner
Check@HIDRequestClassl1
	movlw	__GET_PROTOCOL					; Request = __GET_PROTOCOL?
	cpfseq	__SetupPkt + __bRequest
	bra		Check@HIDRequestClassl2			; No
	if((__ACTIVE_PROTOCOL & 255) == 0)
		clrf	__PSrc
	else
		if((__ACTIVE_PROTOCOL & 255) == 255)
			setf	__PSrc
		else
			movlw	(__ACTIVE_PROTOCOL & 255)
			movwf	__PSrc
		endif
	endif
	if(((__ACTIVE_PROTOCOL >> 8) & 255) == 0)
		clrf	__PSrc + 1
	else
		if(((__ACTIVE_PROTOCOL >> 8) & 255) == 255)
			setf	__PSrc + 1
		else
			movlw	((__ACTIVE_PROTOCOL >> 8) & 255)
			movwf	__PSrc + 1
		endif
	endif
	movlw	1
	movwf	__WCount
	clrf	__WCount + 1
	bcf		__USB_STAT,__CTRL_TRF_MEM		; Indicate RAM
	bra		HID@SetSessionOwner
Check@HIDRequestClassl2
	movlw	__SET_PROTOCOL					; Request = __SET_PROTOCOL?
	cpfseq	__SetupPkt + __bRequest
	return									; No
	movff	__SetupPkt + __wValue,__ACTIVE_PROTOCOL
HID@SetSessionOwner
	movlw	__MUID_HID
	movwf	__CTRL_TRF_SESSION_OWNER
	return
 NOLIST
; ------------------------------------------------------------------------------
; HIDInit@EP
; Initialise HID endpoints, buffer descriptors, internal state-machine, and variables.
; It should be called after the USB host has sent out a SET_CONFIGURATION request.
;
 LIST
HIDInit@EP
	movlw	1							; Endpoint 1 out
	movwf	FSR0L
	lfsr	1,__HID_REPORT_OUT			; FSR1 = endpoint buffer address
	movlw	__HID_INT_OUT_EP_SIZE		; WREG = endpoint size
; Inititalise the endpoint as Output
; Save maximum count at front of endpoint buffer and move buffer pointer up
	movwf 	POSTINC1 					; Store maximum count at front of endpoint buffer and move up pointer
; Point FSR2 to endpoint table
	lfsr 	2,UEP0
	movf 	FSR0L,W 					; Add in endpoint number
	addwf 	FSR2L,F
; Enable Out endpoint
	movlw 	__EP_OUT | __HSHK_EN 		; Enable Out pipe
	iorwf 	INDF2,F
; Point FSR0 to endpoint BDT
	rlncf 	FSR0L,W 					; Endpoint number * 8
	rlncf 	WREG,F
	rlncf	 WREG,F
	lfsr 	0,__ep0Bo 					; Point FSR0 to beginning of BDT area
	addwf 	FSR0L,F 					; Add endpoint offset to FSR0 
; Set endpoint buffer address from FSR1 + 1
	movlw 	__ADRL 						; Point to ADRL
	movff 	FSR1L,PLUSW0
	movlw 	__ADRH 						; Point to ADRH
	movff 	FSR1H,PLUSW0
; Set Cnt to maximum count
	movf 	POSTDEC1,W 					; Back up endpoint buffer pointer (no PREDEC1!)
	incf 	FSR0L,F 					; Point to __CNT
	movff 	INDF1,POSTDEC0 				; Set maximum count and point back to Stat
; Set endpoint status
	movlw 	_USIE | _DAT0 | _DTSEN 		; Set receive status
	movwf 	INDF0 						; Set Stat
	
	movlw	1							; Endpoint 1 in
	movwf	FSR0L
	lfsr	1,__HID_REPORT_IN			; FSR1 = endpoint buffer address
	movlw	__HID_INT_IN_EP_SIZE		; WREG = endpoint size
; Inititalise the endpoint as Input
; Save maximum count at front of endpoint buffer and move buffer pointer up (no need to put in Cnt for In)
 	movwf 	POSTINC1					; Store maximum count at front of endpoint buffer and move up pointer
; Point FSR2 to endpoint table
	lfsr 	2,UEP0
	movf 	FSR0L,W 					; Add in the endpoint number
	addwf 	FSR2L,F
; Enable In endpoint
	movlw 	__EP_IN | __HSHK_EN 		; Enable In pipe
	iorwf 	INDF2,F
; Point FSR0 to endpoint BDT
	rlncf 	FSR0L,W 					; Endpoint number * 8
	rlncf 	WREG,F
	rlncf 	WREG,F
	lfsr 	0,__ep0Bi 					; Point FSR0 to the beginning of BDT area
	addwf 	FSR0L,F 					; Add the endpoint offset to FSR0 
; Set endpoint buffer address from FSR1
	movlw 	__ADRL 						; Point to ADRL
	movff 	FSR1L,PLUSW0
	movlw 	__ADRH 						; Point to ADRH
	movff 	FSR1H,PLUSW0
; Set endpoint status
	movlw 	_UCPU | _DAT1 				; Set transmit status
	movwf 	INDF0 						; Set STAT
	return	
 NOLIST	
endif
; ****[END OF HID.C]*************************************************************************************								
;
; ****[START OF CDC.C]************************************************************************************
 NOLIST
ifdef __USB_USE_CDC
; ------------------------------------------------------------------------------
; Check@CDCRequest
; Check the setup data packet to see if it knows how to handle it
;
 LIST
Check@CDCRequest
;
; If request Recipient is not an interface then return
;
	movlb	((__USB_RAM_BANK >> 8) & 255)	; Point to bank holding the variables
	movf	__SetupPkt,W					; Recipient = __RCPT_INTF?
	andlw	0x1F							; Mask to lower 5 bits
	sublw	__RCPT_INTF
	bnz		Check@CDCRqstExit				; No
;
; If request type is not CLASS-specific then return
;
	movf	__SetupPkt,W					; RequestType = CLASS?
	andlw	0x60							; Mask to proper bits
	sublw	(__CLASS << 5)
	bnz		Check@CDCRqstExit				; No
;
; Interface ID must match interface numbers associated with CDC Class, else return
;
	movlw	__CDC_COMM_INTF_ID				; IntfID = __CDC_COMM_INTF_ID?
	subwf	__SetupPkt + __bIntfID,W
	bz		Check@CDCRqst1					; Yes
	movlw	__CDC_DATA_INTF_ID				; IntfID = __CDC_DATA_INTF_ID?
	cpfseq	__SetupPkt + __bIntfID
Check@CDCRqstExit
	return									; No   
Check@CDCRqst1
	movlw	__SEND_ENCAPSULATED_COMMAND		; Request = __SEND_ENCAPSULATED_COMMAND?
	cpfseq	__SetupPkt + __bRequest
	bra		Check@CDCRqst2					; No
	if((__DUMMY_ENCAPSULATED_CMD_RESPONSE & 255) == 0)
		clrf	__PSrc
	else
		if((__DUMMY_ENCAPSULATED_CMD_RESPONSE & 255) == 255)
			setf	__PSrc
		else
			movlw	(__DUMMY_ENCAPSULATED_CMD_RESPONSE & 255)
			movwf	__PSrc
		endif
	endif
	if(((__DUMMY_ENCAPSULATED_CMD_RESPONSE >> 8) & 255) == 0)
		clrf	__PSrc + 1
	else
		if(((__DUMMY_ENCAPSULATED_CMD_RESPONSE >> 8) & 255) == 255)
			setf	__PSrc + 1
		else
			movlw	((__DUMMY_ENCAPSULATED_CMD_RESPONSE >> 8) & 255)
			movwf	__PSrc + 1
		endif	
	endif
	bcf		__USB_STAT,__CTRL_TRF_MEM		; Indicate RAM
	movlw	__DUMMY_LENGTH
	movwf	__WCount
	clrf	__WCount + 1
	bra		USBCDCSetSessionOwner
Check@CDCRqst2
	movlw	__GET_ENCAPSULATED_RESPONSE		; Request = __GET_ENCAPSULATED_RESPONSE?
	cpfseq	__SetupPkt + __bRequest
	bra		Check@CDCRqst3					; No
; Populate __DUMMY_ENCAPSULATED_CMD_RESPONSE first.
	if((__DUMMY_ENCAPSULATED_CMD_RESPONSE & 255) == 0)
		clrf	__PDst
	else
		if((__DUMMY_ENCAPSULATED_CMD_RESPONSE & 255) == 255)
			setf	__PDst
		else
			movlw	(__DUMMY_ENCAPSULATED_CMD_RESPONSE & 255)
			movwf	__PDst
		endif
	endif
	if(((__DUMMY_ENCAPSULATED_CMD_RESPONSE >> 8) & 255) == 0)
		clrf	__PDst + 1
	else
		if(((__DUMMY_ENCAPSULATED_CMD_RESPONSE >> 8) & 255) == 255)
			setf	__PDst + 1
		else
			movlw	((__DUMMY_ENCAPSULATED_CMD_RESPONSE >> 8) & 255)
			movwf	__PDst + 1
		endif	
	endif
	bra		USBCDCSetSessionOwner
Check@CDCRqst3
	movlw	__SET_COMM_FEATURE				; Request = __SET_COMM_FEATURE?
	cpfseq	__SetupPkt + __bRequest
	bra		Check@CDCRqst4					; No
	return									; Optional
Check@CDCRqst4
	movlw	__GET_COMM_FEATURE				; Request = __GET_COMM_FEATURE?
	cpfseq	__SetupPkt + __bRequest
	bra		Check@CDCRqst5					; No
	return									; Optional
Check@CDCRqst5
	movlw	__CLEAR_COMM_FEATURE			; Request = __CLEAR_COMM_FEATURE?
	cpfseq	__SetupPkt + __bRequest
	bra		Check@CDCRqst6					; No
	return									; Optional
Check@CDCRqst6
	movlw	__SET_LINE_CODING				; Request = __SET_LINE_CODING?
	cpfseq	__SetupPkt + __bRequest
	bra		Check@CDCRqst7					; No
	if((__LINE_CODING & 255) == 0)
		clrf	__PDst
	else
		if((__LINE_CODING & 255) == 255)
			setf	__PDst
		else
			movlw	(__LINE_CODING & 255)
			movwf	__PDst
		endif
	endif
	if(((__LINE_CODING >> 8) & 255) == 0)
		clrf	__PDst + 1
	else
		if(((__LINE_CODING >> 8) & 255) == 255)
		
		else
			movlw	((__LINE_CODING >> 8) & 255)
			movwf	__PDst + 1
		endif
	endif
	bra		USBCDCSetSessionOwner
Check@CDCRqst7
	movlw	__GET_LINE_CODING				; Request = __GET_LINE_CODING?
	cpfseq	__SetupPkt + __bRequest
	bra		Check@CDCRqst8					; No
;
; Abstract line coding information
#define __USB#BAUD_RATE 115200				; Baud rate of the USB interface
;
	if((__USB#BAUD_RATE & 255) == 0)					; Baud rate low
		clrf	__LINE_CODING + __dwDTERate
	else
		if((__USB#BAUD_RATE & 255) == 255)
			setf	__LINE_CODING + __dwDTERate
		else
			movlw	(__USB#BAUD_RATE & 255)				
			movwf	__LINE_CODING + __dwDTERate
		endif
	endif
	if(((__USB#BAUD_RATE >> 8) & 255) == 0)				; Baud rate mid
		clrf	__LINE_CODING + __dwDTERate + 1
	else
		if(((__USB#BAUD_RATE >> 8) & 255) == 255)
			setf	__LINE_CODING + __dwDTERate + 1
		else
			movlw	((__USB#BAUD_RATE >> 8) & 255)
			movwf	__LINE_CODING + __dwDTERate + 1
		endif
	endif
	if(((__USB#BAUD_RATE >> 16) & 255) == 0)			; Baud rate high
		clrf	__LINE_CODING + __dwDTERate + 2
	else
		if(((__USB#BAUD_RATE >> 16) & 255) == 255)
			setf	__LINE_CODING + __dwDTERate + 2
		else
			movlw	((__USB#BAUD_RATE >> 16) & 255)
			movwf	__LINE_CODING + __dwDTERate + 2
		endif
	endif
	clrf	__LINE_CODING + __dwDTERate + 3
	clrf	__LINE_CODING + __bCharFormat				; 1 stop bit
	clrf	__LINE_CODING + __bParityType				; No Parity
	movlw	8
	movwf	__LINE_CODING + __bDataBits					; 5, 6, 7, 8, or 16 data bits
	if((__LINE_CODING & 255) == 0)
		clrf	__PSrc
	else
		if((__LINE_CODING & 255) == 255)
			setf	__PSrc
		else
			movlw	(__LINE_CODING & 255)
			movwf	__PSrc
		endif
	endif
	if(((__LINE_CODING >> 8) & 255) == 0)
		clrf	__PSrc + 1
	else
		if(((__LINE_CODING >> 8) & 255) == 255)
			setf	__PSrc + 1
		else
			movlw	((__LINE_CODING >> 8) & 255)
			movwf	__PSrc + 1
		endif
	endif
	bcf		__USB_STAT,__CTRL_TRF_MEM		; Indicate RAM
	movlw	__LINE_CODING_LENGTH
	movwf	__WCount
	clrf	__WCount + 1
	bra		USBCDCSetSessionOwner
Check@CDCRqst8
	movlw	__SET_CONTROL_LINE_STATE		; Request = __SET_CONTROL_LINE_STATE?
	cpfseq	__SetupPkt + __bRequest
	bra		Check@CDCRqst9					; No
	movff	__SetupPkt + __wValue,__control_signal_bitmap
	bra		USBCDCSetSessionOwner
Check@CDCRqst9
	movlw	__SEND_BREAK					; Request = __SEND_BREAK?
	cpfseq	__SetupPkt + __bRequest
	bra		Check@CDCRqst10					; No
	return									; Optional
Check@CDCRqst10
	return									; Default
USBCDCSetSessionOwner
	movlw	__MUID_CDC
	movwf	__CTRL_TRF_SESSION_OWNER
	return
 NOLIST
; ------------------------------------------------------------------------------
; CDCInit@EP
; Initialise CDC endpoints, buffer descriptors, internal state-machine, and variables.
; It should be called after the USB host has sent out a SET_CONFIGURATION request.
;
 LIST
CDCInit@EP
	movlw	2								; Endpoint 2 in
	movwf	FSR0L
	lfsr	1,__CDC_NOTICE					; FSR1 = endpoint buffer address
	movlw	__CDC_INT_EP_SIZE				; WREG = endpoint size
	rcall	InitEP@In						; Inititalise the endpoint as Input
	movlw	3								; Endpoint 3
	movwf	FSR0L
	lfsr	1,__CDC_DATA_RX					; FSR1 = endpoint buffer address
	movlw	__CDC_BULK_OUT_EP_SIZE			; WREG = endpoint size
; Inititalise the endpoint as Output
; Save maximum count at front of endpoint buffer and move buffer pointer up
	movwf 	POSTINC1 						; Store maximum count at front of endpoint buffer and move up pointer
; Point FSR2 to endpoint table
	lfsr 	2,UEP0
	movf 	FSR0L,W 						; Add in the endpoint number
	addwf 	FSR2L,F
; Enable Out endpoint
	movlw 	__EP_OUT | __HSHK_EN 			; Enable the Out pipe
	iorwf 	INDF2,F
; Point FSR0 to endpoint BDT
	rlncf 	FSR0L,W 						; Endpoint number * 8
	rlncf 	WREG,F
	rlncf	 WREG,F
	lfsr 	0,__ep0Bo 						; Point FSR0 to the beginning of BDT area
	addwf 	FSR0L,F 						; Add the endpoint offset to FSR0 
; Set endpoint buffer address from FSR1 + 1
	movlw 	__ADRL 							; Point to ADRL
	movff 	FSR1L,PLUSW0
	movlw 	__ADRH 							; Point to ADRH
	movff 	FSR1H,PLUSW0
; Set Cnt to maximum count
	movf 	POSTDEC1,W 						; Back up endpoint buffer pointer (no PREDEC1!)
	incf 	FSR0L,F 						; Point to __CNT
	movff 	INDF1,POSTDEC0 					; Set maximum count and point back to Stat
; Set endpoint status
	movlw 	_USIE | _DAT0 | _DTSEN 			; Set receive status
	movwf 	INDF0 							; Set Stat
	movlw	3								; Endpoint 3 in
	movwf	FSR0L
	lfsr	1,__CDC_DATA_TX					; FSR1 = endpoint buffer address
	movlw	__CDC_BULK_IN_EP_SIZE			; WREG = endpoint size
; Inititalise the endpoint as Input
InitEP@In	
; Save maximum count at front of endpoint buffer and move buffer pointer up (no need to put in CNT for In)
 	movwf 	POSTINC1						; Store maximum count at front of endpoint buffer and move up pointer
; Point FSR2 to endpoint table
	lfsr 	2,UEP0
	movf 	FSR0L,W 						; Add in endpoint number
	addwf 	FSR2L,F
; Enable In endpoint
	movlw 	__EP_IN | __HSHK_EN 			; Enable In pipe
	iorwf 	INDF2,F
; Point FSR0 to endpoint BDT
	rlncf 	FSR0L,W 						; Endpoint number * 8
	rlncf 	WREG,F
	rlncf 	WREG,F
	lfsr 	0,__ep0Bi 						; Point FSR0 to beginning of BDT area
	addwf 	FSR0L,F 						; Add endpoint offset to FSR0
; Set endpoint buffer address from FSR1
	movlw 	__ADRL 							; Point to ADRL
	movff 	FSR1L,PLUSW0
	movlw 	__ADRH 							; Point to ADRH
	movff 	FSR1H,PLUSW0
; Set endpoint status
	movlw 	_UCPU | _DAT1 					; Set transmit status
	movwf 	INDF0 							; Set Stat
	return
 NOLIST
endif									
; ****[END OF CDC.C]**************************************************************************************
 LIST