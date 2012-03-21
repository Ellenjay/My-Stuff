 NOLIST
;#define SHOW#ENUM#STATUS

; **********************************************************************
; This section contains the functions to interface with the main 
; application.
; **********************************************************************

; **********************************************************************
; GETEP1 and GETEP2
;
; Note:  These functions are, in reality, macros defined in usb_defs.inc.
;        To save ROM, delete the instances below that you will not need.
;
; Enter with buffer pointer in IRP + FSR.  
; Checks the semaphore for the OUT endpoint, and copies the buffer 
; if available.  Restores the bank bits as we found them.
;
; Returns the bytecount in the W register and return status in the carry
; bit as follows:
; 0 - no buffer available,
; 1 - Buffer copied and buffer made available for next transfer.
; 
 LIST
; The number of bytes moved is returned in W reg.
; **********************************************************************

	GETEP1		; create instance of GETEP1
	GETEP2		; create instance of GETEP2

; **********************************************************************
; PUTEP1 and PUTEP2
;
; Note:  These functions are, in reality, macros defined in usb_defs.inc.
;        To save ROM, delete the instances below that you will not need.
;
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
; **********************************************************************
	PUTEP1      ; create instance of PUTEP1
	PUTEP2      ; create instance of PUTEP2

; *********************************************************************
; Stall Endpoint.
; Sets the stall bit in the Endpoint Control Register.  For the control
; Endpoint, this implements a Protocol stall and is used when the request
; is invalid for the current device state.  For non-control Endpoints,
; this is a Functional Stall, meaning that the device needs outside 
; intervention and trying again later won't help until it's been serviced.
; enter with endpoint # to stall in Wreg.
; *********************************************************************
Stall@USBEP
    bsf     STATUS,IRP      ; select banks 2/3
    andlw   0x03            ; try to keep things under control
    addlw   low UEP0        ; add address of endpoint control reg
    movwf   FSR
    bsf     INDF,EP_STALL   ; set stall bit
    return

; *********************************************************************
; Unstall Endpoint.
; Sets the stall bit in the Endpoint Control Register.  For the control
; Endpoint, this implements a Protocol stall and is used when the request
; is invalid for the current device state.  For non-control Endpoints,
; this is a Functional Stall, meaning that the device needs outside 
; intervention and trying again later won't help until it's been serviced.
; enter with endpoint # to stall in Wreg.
; *********************************************************************
Unstall@USBEP
    bsf     STATUS,IRP      ; select banks 2/3
    andlw   0x03            ; try to keep things under control
    addlw   low UEP0        ; add address of endpoint control reg
    movwf   FSR
    bcf     INDF,EP_STALL   ; clear stall bit
    return

; *********************************************************************
; Check@Sleep
; Checks the USB Sleep bit.  If the bit is set, the
; Endpoint, this implements a Protocol stall and is used when the request
; is invalid for the current device state.  For non-control Endpoints,
; this is a Functional Stall, meaning that the device needs outside 
; intervention and trying again later won't help until it's been serviced.
; enter with endpoint # to stall in Wreg.
; *********************************************************************
Check@Sleep
    banksel _IS_IDLE
    btfss   _IS_IDLE,0       ; test the bus idle bit
    goto    nosleep@today

 #ifdef SHOW#ENUM#STATUS
    banksel PORTB
    bsf     PORTB,4         ; turn on LED 4 to indicate we've gone to sleep
    banksel UIR
 #endif
    bsf     STATUS,RP0      ; point to bank 3
    bcf     UIR,ACTIVITY
    bsf     UIE,ACTIVITY    ; enable the USB activity interrupt
    bsf     UCTRL,SUSPND    ; put USB regulator and transciever in low power state
    sleep                   ; and go to sleep
    nop
    bcf     UCTRL,SUSPND
    bcf     UIR,UIDLE
    bsf     UIE,UIDLE
    bcf     UIR,ACTIVITY
    bcf     UIE,ACTIVITY
 #ifdef SHOW#ENUM#STATUS
    banksel PORTB
    bcf     PORTB,4         ; turn off LED 4 to indicate we're back.
 #endif

nosleep@today
    return

; *********************************************************************
; Remote Wakeup
; Checks _USB_STATUS_DEVICE to see if the host enabled Remote Wakeup
; If so, perform Remote wakeup and disable remote wakeup feature
; It is called by PortBChange
; *********************************************************************
Remote@Wakeup
    banksel _USB_STATUS_DEVICE    
    btfss   _USB_STATUS_DEVICE, 1
    goto    Remote@End

    clrf    _USB_INNER
    movlw   0xB0
    movwf   _USB_OUTER

    bsf     STATUS, RP0     ; BANK 3
    bsf     UCTRL, 2        ; RESUME SIGNALING
    bcf     STATUS, RP0     ; BANK 2

    incfsz  _USB_INNER,f         ; DELAY over 10mS
    goto    $-1
    incfsz  _USB_OUTER,f
    goto    $-3

    bsf     STATUS,RP0
    bcf     UCTRL, 2        ; Clear Resume bit
    bcf     STATUS,RP0
    bcf     _USB_STATUS_DEVICE, 1    ; Disable Remote Wakeup
    
Remote@End
    return


; *********************************************************************
; USB Soft Detach
; Clears the DEV_ATT bit, electrically disconnecting the device to the bus.
; This removes the device from the bus, then reconnects so it can be
; re-enumerated by the host.  This is envisioned as a last ditch effort
; by the software.
; *********************************************************************
SoftDetach@USB
    banksel UCTRL
    bcf     UCTRL,DEV_ATT   ; clear attach bit

    bcf     STATUS, RP0     ; bank 2
    
    clrf    _USB_OUTER
    clrf    _USB_INNER

    incfsz  _USB_INNER,f
    goto    $-1
    incfsz  _USB_OUTER,f
    goto    $-3

    pagesel Init@USB
    call    Init@USB         ; reinitialize the USB peripheral
    return


; ******************************************************************
; Init USB
; Initializes the USB peripheral, sets up the interrupts
; ******************************************************************
Init@USB
    banksel USWSTAT
    clrf    USWSTAT         ; default to powered state
    movlw   0x01            ; mask all USB interrupts except reset
    movwf   UIE
    clrf    UIR             ; clear all USB Interrupt flags
    movlw   0x08            ; Device attached
    movwf   UCTRL

    bcf     STATUS, RP0     ; bank 2
    clrf    _USB_CURR_CONFIG
    movlw   1
    movwf   _USB_STATUS_DEVICE
    clrf    _USB_INTERFACE
    clrf    _USB_INTERFACE + 1
    clrf    _USB_INTERFACE + 2
    movlw   0xFF
    movwf   _USB_DEV_REQ     ; no device requests in process
 #ifdef COUNT#ERRORS
    clrf    _USB_PID_ERR
    clrf    _USB_PID_ERR + 1
    clrf    _USB_CRC5_ERR
    clrf    _USB_CRC5_ERR + 1
    clrf    _USB_CRC16_ERR
    clrf    _USB_CRC16_ERR + 1
    clrf    _USB_DFN8_ERR
    clrf    _USB_DFN8_ERR + 1
    clrf    _USB_BTO_ERR
    clrf    _USB_BTO_ERR + 1
    clrf    _USB_WRT_ERR
    clrf    _USB_WRT_ERR + 1
    clrf    _USB_OWN_ERR
    clrf    _USB_OWN_ERR + 1
    clrf    _USB_BTS_ERR
    clrf    _USB_BTS_ERR + 1
 #endif

    banksel PIR1            ; bank 0
    bcf     PIR1,USBIF      ; clear the USB flag
    bsf     STATUS,RP0      ; bank 1
    bsf     PIE1,USBIE      ; enable usb interrupt
    bsf     INTCON, 6       ; enable global and peripheral interrupts
    bsf     INTCON, 7
 #ifdef SHOW#ENUM#STATUS
    bcf     STATUS,RP0      ; select bank 0
    bsf     PORTB,0         ; set bit zero to indicate Powered status
 #endif
    return


; ******************************************************************
; DeInit USB
; Shuts down the USB peripheral, clears the interrupt enable.
; ******************************************************************
DeInit@USB
    banksel UCTRL
    bcf     UCTRL,DEV_ATT   ; D + /D- go high Z
    bsf     UCTRL,SUSPND    ; Place USB module in low power mode.

    clrf    USWSTAT         ; set device state to powered.

    bcf     STATUS,RP1      ; select bank 1
    bcf     PIE1,USBIE      ; clear USB interrupt enable
 #ifdef SHOW#ENUM#STATUS
    bcf     STATUS,RP0
    movlw   0x01
    movwf   PORTB           ; clear all lights except powered
    bsf     STATUS,RP0
 #endif

    return


; The functions below are the core functions
; ******************************************************************
; USB interrupt triggered, Why?
; Poll the USB interrupt flags to find the cause.
; ******************************************************************
Service@USBInt
    banksel UIR
    movf    UIR,w           ; get the USB interrupt register
    andwf   UIE,w           ; mask off the disabled interrupts
    bcf     STATUS, RP0     ; BANK 2
    btfsc   STATUS,Z        ; is there any unmasked interrupts?
    goto    ExitService@USBInt ; no, bail out.

    pagesel Token@Done
    movwf   _USBMASKEDINTERRUPTS
    btfsc   _USBMASKEDINTERRUPTS,TOK_DNE    ; was it a token done?
    call    Token@Done
    banksel _USBMASKEDINTERRUPTS
    btfsc   _USBMASKEDINTERRUPTS,USB_RST
    call    USB@Reset
    btfsc   _USBMASKEDINTERRUPTS,STALL
    call    USB@Stall
    btfsc   _USBMASKEDINTERRUPTS,UERR
    call    USB@Error
    btfsc   _USBMASKEDINTERRUPTS,UIDLE
    call    USB@Sleep
    btfsc   _USBMASKEDINTERRUPTS,ACTIVITY
    call    USB@Activity
    pagesel Service@USBInt
    goto    Service@USBInt
ExitService@USBInt
    banksel PIR1
    bcf     PIR1,USBIF
    return

; ******************************************************************
; USB Reset interrupt triggered (SE0)
; initialize the Buffer Descriptor Table,
; Transition to the DEFAULT state,
; Set address to 0
; enable the USB
; ******************************************************************
USB@Reset    ; START IN BANK2

    clrf    _USB_CURR_CONFIG
    clrf    _IS_IDLE
    bsf     STATUS, RP0     ; bank 3

    bcf     UIR,TOK_DNE     ; hit this 4 times to clear out the
    bcf     UIR,TOK_DNE     ; USTAT FIFO
    bcf     UIR,TOK_DNE    
    bcf     UIR,TOK_DNE    

    movlw   0x88            ; set owns bit (SIE can write)
    movwf   BD0OST
    movlw   USB_Buffer      ; Endpoint 0 OUT gets a buffer
    movwf   BD0OAL          ; set up buffer address
    movlw   0x8
    movwf   BD0OBC

    movlw   0x08            ; Clear owns bit (PIC can write)
    movwf   BD0IST
    movlw   USB_Buffer + 8    ; Endpoint 0 IN gets a buffer
    movwf   BD0IAL          ; set up buffer address

    clrf    UADDR           ; set USB Address to 0
    clrf    UIR             ; clear all the USB interrupt flags
    banksel PIR1            ; switch to bank 0
    bcf     PIR1,USBIF

; Set up the Endpoint Control Registers.  The following patterns are defined
; ENDPT_DISABLED - endpoint not used
; ENDPT_IN_ONLY  - endpoint supports IN transactions only
; ENDPT_OUT_ONLY - endpoint supports OUT transactions only
; ENDPT_CONTROL     - Supports IN, OUT and CONTROL transactions - Only use with EP0
; ENDPT_NON_CONTROL - Supports both IN and OUT transactions

    banksel UEP0
    movlw   ENDPT_CONTROL
    movwf   UEP0            ; endpoint 0 is a control pipe and requires an ACK

    movlw   0x3B            ; enable all interrupts except activity
    movwf   UIE

    movlw   0xFF            ; enable all error interrupts
    movwf   UEIE

    movlw   DEFAULT#STATE
    movwf   USWSTAT

    bcf     STATUS,RP0      ; select bank 2
    movlw   0x00
    movwf   _USB_STATUS_DEVICE ; Self powered, remote wakeup disabled
    bcf     STATUS,RP1      ; bank 0
 #ifdef SHOW#ENUM#STATUS
    bsf     PORTB,1         ; set bit one to indicate Reset status
 #endif
    bsf     STATUS,RP1
    return                  ; to keep straight with host controller tests

; ******************************************************************
; Enable Wakeup on interupt and Activity interrupt then put the 
; device to sleep to save power.  Activity on the D + /D- lines will
; set the ACTIVITY interrupt, waking up the part.
; ******************************************************************
USB@Sleep    ; starts from bank2
    bsf     STATUS, RP0     ; up to bank 3
    bcf     UIE,UIDLE
    bcf     UIR,UIDLE
    bcf     UIE,ACTIVITY
    bcf     UIR,ACTIVITY
    banksel PIR1            ; switch to bank 0
    bcf     PIR1,USBIF

    banksel _IS_IDLE         ; switch to bank 2
    bsf     _IS_IDLE, 0

    return

; ******************************************************************
; This is activated by the STALL bit in the UIR register.  It really
; just tells us that the SIE sent a STALL handshake.  So far, Don't 
; see that any action is required.  Clear the bit and move on.
; ******************************************************************
USB@Stall    ; starts in bank 2
    bsf     STATUS, RP0     ; bank 3
    bcf     UIR, STALL      ; clear STALL

    banksel PIR1            ; switch to bank 0
    bcf     PIR1,USBIF
    bsf     STATUS,RP1      ; bank 2    
    return

 
; ******************************************************************
; The SIE detected an error.  This code increments the appropriate 
; error counter and clears the flag.
; ******************************************************************
USB@Error    ; starts in bank 2
    bsf     STATUS, RP0     ; bank 3
    bcf     UIR,UERR
    banksel PIR1            ; switch to bank 0
    bcf     PIR1,USBIF      ; clear the USB interrupt flag.
    bsf     STATUS,RP1      ; switch to bank 2
    
 #ifdef COUNT#ERRORS
    banksel UEIR
    movf    UEIR,w          ; get the error register
    andwf   UEIE,w          ; mask with the enables
    clrf    UEIR
    bcf     STATUS, RP0     ; Bank 2
    movwf   _USBMASKEDERRORS ; save the masked errors

    btfss   _USBMASKEDERRORS,PID_ERR
    goto    CRC5@Error
    INCREMENT@16 _USB_PID_ERR
CRC5@Error
    btfss   _USBMASKEDERRORS,CRC5
    goto    CRC16@Error
    INCREMENT@16 _USB_CRC5_ERR
CRC16@Error
    btfss   _USBMASKEDERRORS,CRC16
    goto    DFN8@Error
    INCREMENT@16 _USB_CRC16_ERR
DFN8@Error
    btfss   _USBMASKEDERRORS,DFN8
    goto    BTO@Error
    INCREMENT@16 _USB_DFN8_ERR
BTO@Error
    btfss   _USBMASKEDERRORS,BTO_ERR
    goto    WRT@Error
    INCREMENT@16 _USB_BTO_ERR
WRT@Error
    btfss   _USBMASKEDERRORS,WRT_ERR
    goto    OWN@Error
    INCREMENT@16 _USB_WRT_ERR
OWN@Error
    btfss   _USBMASKEDERRORS,OWN_ERR
    goto    BTS@Error
    INCREMENT@16 _USB_OWN_ERR
BTS@Error
    btfss   _USBMASKEDERRORS,BTS_ERR
    goto    End@Error
    INCREMENT@16 _USB_BTS_ERR
End@Error
 #endif
    banksel _USBMASKEDINTERRUPTS 
    return

; ******************************************************************
; Service the Activity Interrupt.  This is only enabled when the
; device is put to sleep as a result of inactivity on the bus.  This
; code wakes up the part, disables the activity interrupt and reenables
; the idle interrupt.
; ******************************************************************
USB@Activity     ; starts in bank 2
    bsf     STATUS, RP0     ; Bank 3
    bcf     UIE,ACTIVITY    ; clear the Activity and Idle bits
    bcf     UIR,ACTIVITY
    bcf     UIE,UIDLE
    bcf     UIR,UIDLE

    banksel PIR1            ; switch to bank 0
    bcf     PIR1,USBIF      ; clear the USB interrupt flag.
    bsf     STATUS,RP1      ; switch to bank 2
    
    clrf    _IS_IDLE

    return

; ******************************************************************
; Process token done interrupt...  Most of the work gets done through
; this interrupt.  Token Done is signaled in response to an In, Out,
; or Setup transaction.
; ******************************************************************
Token@Done       ; starts in bank 2
    COPYBuffer@Descriptor    ; copy BD from dual port to unbanked RAM
    banksel USTAT
    movf    USTAT,w         ; copy USTAT register before...
    bcf     UIR,TOK_DNE     ; clearing the token done interrupt.

    banksel PIR1            ; switch to bank 0
    bcf     PIR1,USBIF      ; clear the USB interrupt flag.
    bsf     STATUS,RP1      ; switch to bank 2

    movwf   _USB_USTAT       ; Save USTAT in bank 2

 #ifdef SHOW#ENUM#STATUS
; This toggles the activity bits on portB  (EP0 -> Bit 5; EP1 -> bit 6; EP2 -> bit 7)
    bcf     STATUS,RP1      ; bank 0
    andlw   0x18            ; save endpoint bits
    btfss   STATUS,Z        ; is it EP0?
    goto    try@EP1@activity
    movlw   0x20
    goto    mask@port
try@EP1@activity
    xorlw   0x08            ; is it bit one?
    btfss   STATUS,Z
    movlw   0x80            ; No, It's not EP0, nor 1 so it must be EP2.  toggle bit 7
    btfsc   STATUS,Z    
    movlw   0x40            ; Yes, toggle bit 6 to Show EP1 activity
mask@port
    xorwf   PORTB,f
    bsf     STATUS,RP1      ; bank 2
 #endif

; check UOWN bit here if desired
    movf    _BUFFER_DESCRIPTOR,w    ; get the first byte of the BD
    andlw   0x3c            ; save the _PIDS
    movwf   _PIDS

    xorlw   TOKEN_IN
    btfsc   STATUS,Z
    goto    Token@InPID    

    movf    _PIDS,w
    xorlw   TOKEN_OUT
    btfsc   STATUS,Z    
    goto    Token@OutPID

    movf    _PIDS,w
    xorlw   TOKEN_SETUP
    btfsc   STATUS,Z    
    goto    Token@SetupPID

    return                  ; should never get here...

; ******************************************************************
; Process out tokens
; For EP0, just turn the buffer around.  There should be no EP0 
; tokens to deal with.
; EP1 and EP2 have live data destined for the application
; ******************************************************************
Token@OutPID    ; STARTS IN BANK2
    movf    _USB_USTAT,w     ; get the status register
    btfss   STATUS,Z        ; was it EP0?
    goto    try@EP1          ; no, try EP1

    movf    _USB_DEV_REQ,w
    xorlw   HID_SET_REPORT
    btfss   STATUS,Z
    goto    Reset@EP0OutBuffer

HID@SetReport
;   Copy buffer to EP1 Out so it looks like it was received from an EP1 OUT
    movlw   0xFF
    movwf   _USB_DEV_REQ     ; clear the request type
    banksel BD1IST
    movf    BD0OST,w
    movwf   BD1OST          ; Copy status register to EP1 Out
    movf    BD0OAL,w        ; get EP0 Out buffer address
    bcf     STATUS,RP0      ; bank 2
    movwf   _HID_SOURCE_PTR
    bsf     STATUS,RP0      ; bank 3
    movf    BD1OAL,w        ; get EP1 Out Buffer Address
    bcf     STATUS,RP0      ; bank 2
    movwf   _HID_DEST_PTR
    bsf     STATUS,RP0      ; bank 3
    movf    BD0OBC,w        ; Get byte count
    movwf   BD1OBC          ; copy to EP1 Byte count
    bcf     STATUS,RP0      ; bank 2
    movwf   _USB_COUNTER

    bankisel BD1IST         ; indirectly to bank 3
HIDSR@CopyLoop
    movf    _HID_SOURCE_PTR,w
    movwf   FSR
    movf    INDF,w
    movwf   TEMP
    movf    _HID_DEST_PTR,w
    movwf   FSR
    movf    TEMP,w
    movwf   INDF
    incf    _HID_SOURCE_PTR,f
    incf    _HID_DEST_PTR,f
    decfsz  _USB_COUNTER,f
    goto    HIDSR@CopyLoop

    bsf     STATUS,RP0      ; bank 3
    movlw   0x08
    movwf   BD0OST          ; REset EP0 Status back to SIE

Reset@EP0OutBuffer
    bsf     STATUS,RP0      ; no, just reset buffer and move on.

    movlw   0x08            ; it's EP0.. buffer already copied,
    movwf   BD0OBC          ; just reset the buffer
    movlw   0x88        
    movwf   BD0OST          ; set OWN and DTS Bit
    bcf     STATUS,RP0      ; bank 2
    goto    Send@0Len_pkt
    return

try@EP1  ; bank 3
    xorlw   0x08            ; was it EP1?
    btfss   STATUS,Z    
    goto    try@EP2

; **** Add Callout here to service EP1 in transactions.  ****

    return

try@EP2  ; bank 3
    movf    _USB_USTAT,w
    xorlw   0x10            ; was it EP2?
    btfsc   STATUS,Z    
    return                  ; unrecognized EP (Should never take this exit)

; **** Add Callout here to service EP2 in transactions.  ****
    return

; ******************************************************************
; Process in tokens
; ******************************************************************
Token@InPID      ; starts in bank2
; Assumes EP0 vars are setup in a previous call to setup.  
EP0_in
    movf    _USB_USTAT,w     ; get the status register
    andlw   0x18            ; save only EP bits (we already know it's an IN)
    btfss   STATUS,Z        ; was it EP0?
    goto    try@EP1in        ; no, try EP1

    movf    _USB_DEV_REQ,w
    xorlw   GET#DESCRIPTOR
    btfss   STATUS,Z
    goto    check@GSD
    pagesel copy@descriptor_to_EP0
    call    copy@descriptor_to_EP0
    goto    exit@EP0in

; Check for Get String Descriptor
check@GSD
    movf    _USB_DEV_REQ,w
    xorlw   GET#STRING_DESCRIPTOR
    btfss   STATUS,Z
    goto    check@SA
    call    copy@descriptor_to_EP0
    goto    exit@EP0in

; Check for Set Address
check@SA
    movf    _USB_DEV_REQ,w
    xorlw   SET#BUF#ADDRESS
    btfss   STATUS,Z
    goto    check@SF
    call    finish@set_address
    goto    exit@EP0in

check@SF
    movf    _USB_DEV_REQ,w
    xorlw   SET_FEATURE
    btfss   STATUS,Z
    goto    check@CF
    goto    exit@EP0in

check@CF
    movf    _USB_DEV_REQ,w
    xorlw   CLEAR_FEATURE
    btfss   STATUS,Z
    goto    Class@Specific
    goto    exit@EP0in

Class@Specific
    pagesel Check_Class_Specific_IN
    goto    Check_Class_Specific_IN

exit@EP0in
    return


; ******************************************************************
; though not required, it might be nice to have a callback function here
; that would take some action like setting up the next buffer when the
; previous one is complete.  Not necessary because the same functionality
; can be provided through the PutUSB call.  
; ******************************************************************
try@EP1in        ; starts in bank 2
    xorlw   0x08            ; was it EP1?
    btfss   STATUS,Z    
    goto    try@EP2in
; **** Add Callout here to service EP1 in transactions.  ****
    return

try@EP2in        ; starts in bank 2
; **** Add Callout here to service EP2 in transactions.  ****
    return
; ******************************************************************
; Return a zero length packet on EP0 In
; ******************************************************************
Send@0Len_pkt
    banksel BD0IBC
    clrf    BD0IBC          ; set byte count to 0
    movlw   0xc8
    movwf   BD0IST          ; set owns bit
    bcf     STATUS,RP0      ; back to bank 2
    clrf    _USB_DEV_REQ
    return

; ********************************************************************
; process setup tokens
; ******************************************************************
Token@SetupPID    ; starts in bank 2
    bsf     STATUS,IRP      ; indirectly to pages 2/3
    movf    _BUFFER_DESCRIPTOR + BUF#ADDRESS,w ; get the status register
    movwf   FSR             ; save in the FSR.
    movf    INDF,w
    movwf   _BUFFER_DATA      ; in shared RAM
    incf    FSR,f
    movf    INDF,w
    movwf   _BUFFER_DATA + 1
    incf    FSR,f
    movf    INDF,w
    movwf   _BUFFER_DATA + 2
    incf    FSR,f
    movf    INDF,w
    movwf   _BUFFER_DATA + 3
    incf    FSR,f
    movf    INDF,w
    movwf   _BUFFER_DATA + 4
    incf    FSR,f
    movf    INDF,w
    movwf   _BUFFER_DATA + 5
    incf    FSR,f
    movf    INDF,w
    movwf   _BUFFER_DATA + 6
    incf    FSR,f
    movf    INDF,w
    movwf   _BUFFER_DATA + 7

    bsf     STATUS, RP0
    movlw   0x88            ; set UOWNs bit back to SIE
    movwf   BD0OST
    movlw   0x08
    movwf   BD0OBC          ; reset the byte count too.
    movwf   BD0IST          ; return the in buffer to us (dequeue any pending requests)

    bcf     UCTRL,PKT_DIS   ; Assuming there is nothing to dequeue, clear the packet disable bit

    bcf     STATUS,RP0      ; bank 2
    clrf    _USB_DEV_REQ     ; clear the device request..

    movf    _BUFFER_DATA + bmRequestType,w
    btfsc   STATUS,Z
    goto    Host@ToDevice

    movf    _BUFFER_DATA + bmRequestType,w
    xorlw   0x01            ; test for host to Interface tokens
    btfsc   STATUS,Z
    goto    Host@ToInterface

    movf    _BUFFER_DATA + bmRequestType,w
    xorlw   0x02            ; test for host to Endpoint tokens
    btfsc   STATUS,Z
    goto    Host@ToEndpoint

    movf    _BUFFER_DATA + bmRequestType,w
    xorlw   0x80            ; test for device to Host tokens
    btfsc   STATUS,Z
    goto    Device@ToHost
 
    movf    _BUFFER_DATA + bmRequestType,w
    xorlw   0x81            ; test for device to Interface tokens
    btfsc   STATUS,Z
    goto    Interface@ToHost

    movf    _BUFFER_DATA + bmRequestType,w
    xorlw   0x82            ; test for device to Endpoint tokens
    btfsc   STATUS,Z
    goto    Endpoint@ToHost

    pagesel ClassSpecificRequest
    movf    _BUFFER_DATA + bmRequestType,w
    andlw   0x60            ; mask off type bits
    xorlw   0x20            ; test for class specific
    btfsc   STATUS,Z        ; was it a standard request?
    goto    ClassSpecificRequest    ; nope, see if it was a class specific request

Check@ForVendorRequest
    movf    _BUFFER_DATA + bmRequestType,w
    andlw   0x60            ; mask off type bits
    xorlw   0x40            ; test for vendor specific
    pagesel wrong@state	; MOVED
    btfss   STATUS,Z        ; was it a standard request?
    goto    wrong@state
    pagesel Check@Vendor
    goto    Check@Vendor     ; nope, see if it was a vendor specific
    return
                
; now test bRequest to see what the request was.

Check@ForStandardRequest
; bmRequestType told us it was a Host to Device transfer.  Now look at
; the specifics to see what's up
Host@ToDevice    ; starts in bank 2
    movf    _BUFFER_DATA + bRequest,w   ; what was our request
    xorlw   CLEAR_FEATURE
    btfsc   STATUS,Z
    goto    Clear@Device_Feature

    movf    _BUFFER_DATA + bRequest,w   ; was our request Set Address
    xorlw   SET#BUF#ADDRESS
    btfsc   STATUS,Z
    goto    Set@Address_Code

    movf    _BUFFER_DATA + bRequest,w   ; was our request Set Configuration
    xorlw   SET_CONFIGURATION
    btfsc   STATUS,Z
    goto    Set@Configuration_Code

    movf    _BUFFER_DATA + bRequest,w   ; was our request Set Feature
    xorlw   SET_FEATURE
    btfsc   STATUS,Z
    goto    Set@Device_Feature
    goto    wrong@state

Host@ToInterface ; starts in bank 2
    movf    _BUFFER_DATA + bRequest,w   ; what was our request
    xorlw   CLEAR_FEATURE
    btfsc   STATUS,Z
    goto    Clear@Interface_Feature

    movf    _BUFFER_DATA + bRequest,w   ; was our request Set Interface
    xorlw   SET_INTERFACE
    btfsc   STATUS,Z
    goto    Set@Interface_Code

    movf    _BUFFER_DATA + bRequest,w   ; was our request Set Feature
    xorlw   SET_FEATURE
    btfsc   STATUS,Z
    goto    Set@Interface_Feature

Host@ToEndpoint  ; starts in bank2
    movf    _BUFFER_DATA + bRequest,w   ; what was our request
    xorlw   CLEAR_FEATURE
    btfsc   STATUS,Z
    goto    Clear@Endpoint_Feature

    movf    _BUFFER_DATA + bRequest,w   ; was our request Set Feature
    xorlw   SET_FEATURE
    btfsc   STATUS,Z
    goto    Set@Endpoint_Feature

Device@ToHost    ; starts in bank2
    movf    _BUFFER_DATA + bRequest,w   ; what was our request
    xorlw   GET_CONFIGURATION
    btfsc   STATUS,Z
    goto    Get@Configuration_Code

    movf    _BUFFER_DATA + bRequest,w   ; was our request Get Decriptor?
    xorlw   GET#DESCRIPTOR
    btfsc   STATUS,Z
    goto    Get@Descriptor_Code

    movf    _BUFFER_DATA + bRequest,w   ; was our request Get Status?
    xorlw   GET_STATUS
    btfsc   STATUS,Z
    goto    Get@Device_Status

Interface@ToHost ; starts in bank2
    movf    _BUFFER_DATA + bRequest,w   ; was our request Get Interface?
    xorlw   GET_INTERFACE
    btfsc   STATUS,Z
    goto    Get@Interface_Code

    movf    _BUFFER_DATA + bRequest,w   ; was our request Get Status?
    xorlw   GET_STATUS
    btfsc   STATUS,Z
    goto    Get@Interface_Status

    movf    _BUFFER_DATA + bRequest,w   ; was our request Get Decriptor?
    xorlw   GET#DESCRIPTOR
    btfsc   STATUS,Z
    goto    Get@Descriptor_Code

Endpoint@ToHost  ; starts in bank2
    movf    _BUFFER_DATA + bRequest,w   ; was our request Get Status?
    xorlw   GET_STATUS
    btfsc   STATUS,Z
    goto    Get@Endpoint_Status

    pagesel wrong@state              ; unrecognised token, stall EP0
    goto    wrong@state

    return

; ******************************************************************
; Get Descriptor
; Handles the three different Get Descriptor commands
; ******************************************************************
Get@Descriptor_Code  ; starts in bank2
    pagesel Get_Report_Descriptor
    movf    _BUFFER_DATA + (wValue + 1),w ; request, which seems to be undefined,
    xorlw   0x22                    ; but it won't enumerate without it
    btfsc   STATUS,Z
    goto    Get_Report_Descriptor

    movf    _BUFFER_DATA + (wValue + 1),w
    xorlw   0x21
    btfsc   STATUS,Z
    goto    Get_HID_Descriptor
    pagesel Get@Ch9Descriptor

Get@Ch9Descriptor
    movlw   high Start@GDIndex       ; set up PCLATH with the current address
    movwf   PCLATH                  ; set up pclath for the computed goto
    movf    _BUFFER_DATA + (wValue + 1),w ; get descriptor type
    andlw   0x03                    ; keep things under control
    addlw   low  Start@GDIndex
    btfsc   STATUS,C                ; was there an overflow?
    incf    PCLATH,f                ; yes, bump PCLATH
    movwf   PCL                     ; adjust PC
Start@GDIndex
    goto    wrong@state               ; 0
    goto    Get@DeviceDescriptor    ; 1
    goto    Get@Config_Descriptor    ; 2
    goto    Get@String_Descriptor_Code	; 3
;    goto    Get_Interface_Descriptor ; 4 - not used
;    goto    Get_EndPoint_Descriptor  ; 5 - not used
;    goto    wrong@state               ; 6
;    goto    wrong@state               ; 7


; *********************************************************************
; Looks up the offset of the device descriptor via the low order byte
; of wValue.  The pointers are set up and the data is copied to the 
; buffer, then the flags are set.
;
; EP0_START points to the first word to transfer
; _EP0_END points to the last, limited to the least of the message length
;         or the number of bytes requested in the message (wLength).
; _EP0_MAXLENGTH is the number of bytes to transfer at a time, 8 bytes
; ******************************************************************
Get@DeviceDescriptor           ; starts in bank 2
    pagesel Descriptions        ; set up PCLATH for call below
    movlw   GET#DESCRIPTOR
    movwf   _USB_DEV_REQ         ; currently processing a get descriptor request

    movlw   8
    movwf   _EP0_MAXLENGTH

    movlw   low DeviceDescriptor
    movwf   EP0_START
    movlw   high DeviceDescriptor
    movwf   EP0_START + 1
    call    Descriptions        ; get length of device descriptor
    movwf   _EP0_END             ; save length
    pagesel Device@EndPtr

    movf    _BUFFER_DATA + (wLength + 1),f ; move it to itself, check for non zero.
    btfss   STATUS,Z            ; if zero, we need to compare _EP0_END to requested length.
    goto    Device@EndPtr        ; if not, no need to compare.  _EP0_END is shorter than request length

    subwf   _BUFFER_DATA + wLength,w    ; compare against requested length
    movf    _BUFFER_DATA + wLength,w
    btfss   STATUS,C
    movwf   _EP0_END

Device@EndPtr
    incf    _EP0_END,f
    pagesel copy@descriptor_to_EP0
    call    copy@descriptor_to_EP0

    return
        

; *********************************************************************
; Looks up the offset of the config descriptor via the low order byte
; of wValue.  The pointers are set up and the data is copied to the 
; buffer, then the flags are set.
;
; EP0_START points to the first word to transfer
; _EP0_END points to the last, limited to the least of the message length
;         or the number of bytes requested in the message (wLength).
; _EP0_MAXLENGTH is the number of bytes to transfer at a time, 8 bytes
; ******************************************************************
Get@Config_Descriptor   ; starts in bank2
    pagesel Descriptions        ; set up PCLATH for call below
    movlw   GET#DESCRIPTOR
    movwf   _USB_DEV_REQ         ; currently processing a get descriptor request

    bcf     STATUS,C
    rlf     _BUFFER_DATA + wValue,w
    call    Config_desc_index   ; translate index to offset into descriptor table
    movwf   EP0_START
    bcf     STATUS,C
    rlf     _BUFFER_DATA + wValue,w
    addlw   1                   ; point to high order byte
    call    Config_desc_index   ; translate index to offset into descriptor table
    movwf   EP0_START + 1

    movlw   2                   ; bump pointer by 2 to get the complete descriptor 
    addwf   EP0_START,f         ; length, not just config descriptor
    btfsc   STATUS,C
    incf    EP0_START + 1,f
    call    Descriptions        ; get length of the config descriptor
    movwf   _EP0_END             ; Get message length

    movlw   2                   ; move EP0_START pointer back to beginning
    subwf   EP0_START,f
    btfss   STATUS,C
    decf    EP0_START + 1,f

    movf    _BUFFER_DATA + (wLength + 1),f ; test for 0
    pagesel Cmp@LowerByte	; MOVED
    btfsc   STATUS,Z
    goto    Cmp@LowerByte
    goto    Config@EndPtr        ; if not, no need to compare.  _EP0_END is shorter than request length

Cmp@LowerByte
    movf    _EP0_END,w
    subwf   _BUFFER_DATA + wLength,w    ; compare against requested length
    btfsc   STATUS,C
    goto    Config@EndPtr
Limit@Size
    movf    _BUFFER_DATA + wLength,w    ; if requested length is shorter..
    movwf   _EP0_END                 ; save it.
Config@EndPtr

    movlw   8
    movwf   _EP0_MAXLENGTH
    incf    _EP0_END,f

    pagesel copy@descriptor_to_EP0
    call    copy@descriptor_to_EP0
    return

; ******************************************************************
; Set up to return String descriptors
; Looks up the offset of the string descriptor via the low order byte
; of wValue.  The pointers are set up and the data is copied to the 
; buffer, then the flags are set.
; ******************************************************************
Get@String_Descriptor_Code    ; starts in bank2
    movlw   GET#STRING_DESCRIPTOR
    movwf   _USB_DEV_REQ         ; currently processing a get descriptor request

    movf    _BUFFER_DATA + wIndex,w
    btfss   STATUS,Z
    goto    not@string0
    movf    _BUFFER_DATA + (wIndex + 1),w
    btfss   STATUS,Z
    goto    not@string0
    movlw   low String0
    movwf   EP0_START
    movlw   high String0
    movwf   EP0_START + 1
    goto    found@string

not@string0
    movlw   high (String0 + 2)
    movwf   EP0_START + 1
    movlw   low (String0 + 2)
    movwf   EP0_START
    clrf    _USB_INNER

check@langid
    pagesel StringDescriptions
    call    StringDescriptions
    pagesel wrong@langid 
    incf    EP0_START,f
    subwf   _BUFFER_DATA + wIndex, w
    btfss   STATUS, Z
    goto    wrong@langid
    pagesel StringDescriptions
    call    StringDescriptions
    pagesel right@langid 
    subwf   _BUFFER_DATA + (wIndex + 1), w
    btfsc   STATUS, Z
    goto    right@langid
    
wrong@langid
    incf    EP0_START,f
    incf    _USB_INNER,f
    movlw   low String0_end     ; compare EP0_START to the addr of
    subwf   EP0_START,w         ; the last langid
    btfss   STATUS,C            ; if EP0_START is equal or lager,
    goto    check@langid        ; we've checked all langid and didn't find it
    clrf    _USB_DEV_REQ         ; clear _USB_DEV_REQ, since GET_descriptor is over
    pagesel wrong@state
    goto    wrong@state

right@langid
    movlw   6                   ; number of strings we have per language   +   1
    subwf   _BUFFER_DATA + wValue,w
    btfss   STATUS,C
    goto    right@string
    clrf    _USB_DEV_REQ
    pagesel   wrong@state
    goto    wrong@state

right@string
    rlf     _BUFFER_DATA + wValue,w
    movwf   EP0_START + 1
    movf    _USB_INNER,w
    pagesel string_index
    call    string_index
    movwf   EP0_START
    incf    EP0_START + 1,f
    movf    _USB_INNER,w
    call    string_index
    movwf   EP0_START + 1

found@string
    pagesel StringDescriptions
    call    StringDescriptions  ; get length of the string descriptor
    movwf   _EP0_END             ; save length

    subwf   _BUFFER_DATA + wLength,w    ; compare against requested length
    movf    _BUFFER_DATA + wLength,w    ; if requested length is shorter..
    btfss   STATUS,C
    movwf   _EP0_END             ; save it.

    movlw   8                   ; each transfer may be 8 bytes long
    movwf   _EP0_MAXLENGTH

    incf    _EP0_END,f
    pagesel copy@descriptor_to_EP0
    call    copy@descriptor_to_EP0
    return

; ******************************************************************
; Stalls the EP0 endpoint to signal that the command was not recognised.
; This gets reset as the result of a Setup Transaction.
; ******************************************************************
wrong@state
    banksel UEP0
    bsf     UEP0,EP_STALL
    bcf     STATUS,RP0      ; back to page 2

    return

; ******************************************************************
; Loads the device status byte into the EP0 In Buffer.
; ******************************************************************
Get@Device_Status           ; starts in bank2
    bsf     STATUS,RP0
    movf    BD0IAL,w        ; get buffer pointer
    movwf   FSR
    bcf     STATUS,RP0      ; bank 2
    bsf     STATUS,IRP      ; select indirectly banks 2-3
    movf    _USB_STATUS_DEVICE,w ; get device status byte
    movwf   INDF
    incf    FSR,f
    clrf    INDF

    bsf     STATUS,RP0      ; bank 3
    movlw   0x02
    movwf   BD0IBC          ; set byte count to 2
    movlw   0xC8
    movwf   BD0IST          ; Data 1 packet, set owns bit
    return

; ******************************************************************
; A do nothing response.  Always returns a two byte record, with all
; bits zero.
; ******************************************************************
Get@Interface_Status        ; starts in bank 2
    bsf     STATUS, RP0     ; bank 3
    movf    BD0IAL,w        ; get buffer pointer
    movwf   FSR
    clrf    INDF
    incf    FSR,f
    clrf    INDF

    movlw   0x02
    movwf   BD0IBC          ; set byte count to 2
    movlw   0xC8
    movwf   BD0IST          ; Data 1 packet, set owns bit
    return

; ******************************************************************
; Returns the Endpoint stall bit via a 2 byte in buffer
; ******************************************************************
Get@Endpoint_Status         ; starts in bank 2
    movlw   0x0f
    andwf   _BUFFER_DATA + wIndex,w    ; get endpoint, strip off direction bit
    xorlw   0x01            ; is it EP1?
    btfsc   STATUS,Z
    goto    get@EP1_status

    movlw   0x0f
    andwf   _BUFFER_DATA + wIndex,w    ; get endpoint, strip off direction bit
    xorlw   0x02            ; is it EP2?
    btfss   STATUS,Z
    goto    wrong@state

get@EP2_status
    bcf     STATUS,C
    bsf     STATUS,RP0
    btfsc   UEP2,EP_STALL
    bsf     STATUS,C
    goto    build@status_buffer

get@EP1_status
    bcf     STATUS,C
    bsf     STATUS,RP0
    btfsc   UEP1,EP_STALL
    bsf     STATUS,C
         
build@status_buffer
    movf    BD0IAL,w        ; get address of buffer
    movwf   FSR
    clrf    INDF            ; clear byte 0 in buffer
    rlf     INDF,f          ; rotate in carry bit (EP_stall bit)
    incf    FSR,f           ; bump pointer
    clrf    INDF            ; clear byte

    movlw   0x02
    movwf   BD0IBC          ; set byte count to 2
    movlw   0xC8
    movwf   BD0IST          ; Data 1 packet, set owns bit
    return


; *********************************************************************
; The low order byte of wValue now has the new device address as assigned
; from the host.  Save it in the UADDR, transition to the ADDRESSED state
; and clear the current configuration.
; This assumes the SIE has already sent the status stage of the transaction
; as implied by Figure 3-35 of the DOS (Rev A-7)
; ******************************************************************
Set@Address_Code     ; starts in bank 2
    movlw   SET#BUF#ADDRESS
    movwf   _USB_DEV_REQ            ; currently processing a get descriptor request
    movf    _BUFFER_DATA + wValue,w    ; new address in low order byte of wValue
    movwf   _USB_ADDRESS_PENDING

    bsf     STATUS, RP0
    clrf    BD0IBC
    movlw   0xc8
    movwf   BD0IST          ; write the whole mess back
    return

finish@set_address          ; starts in bank 2
    clrf    _USB_DEV_REQ     ; no request pending
    clrf    _USB_CURR_CONFIG ; make sure current configuration is 0
    movf    _USB_ADDRESS_PENDING,w
    bsf     STATUS, RP0
    movwf   UADDR           ; set the device address
    btfsc   STATUS,Z        ; was address 0?
    goto    end@finishsetaddr    ; yes: don't change state

    movlw   BUF#ADDRESS#STATE   ; non-zero: transition to addressed state
    movwf   USWSTAT         ; transition to addressed state
 #ifdef SHOW#ENUM#STATUS
    banksel PORTB
    bsf     PORTB,2         ; set bit 2 to indicate Addressed state
    banksel USWSTAT         ; not necessary, Send_0LenPkt resets bank bits
 #endif

end@finishsetaddr
    return

; ******************************************************************
; only feature valid for device feature is Device Remote wakeup
; ******************************************************************
Clear@Device_Feature        ; starts in bank2
    movf    _BUFFER_DATA + wValue,w
    xorlw   0x01            ; was it a Device Remote wakeup? If not, return STALL,
    btfss   STATUS,Z        ; since we only implement this feature on this device.
    goto    wrong@state

right@state_clear_feature
    bcf     _USB_STATUS_DEVICE,1 ; set device remote wakeup
    call    Send@0Len_pkt
    return

; ******************************************************************
; Only endpoint feature is Endpoint halt.
; ******************************************************************
Clear@Endpoint_Feature  ; starts in bank 2
    movlw   0x0f
    andwf   _BUFFER_DATA + wIndex,w ; mask off the EP number bits
    xorlw   0x01            ; is it EP1?
    btfsc   STATUS,Z
    goto    Clear@EP1

    movlw   0x0f
    andwf   _BUFFER_DATA + wIndex,w ; mask off the EP number bits
    xorlw   0x02            ; is it EP2?
    btfss   STATUS,Z
    goto    wrong@state

Clear@EP2
    bsf     STATUS, RP0
    bcf     UEP2,EP_STALL       ; set the stall bit
    goto    clear@endpoint_end  ; skip the second stall
Clear@EP1
    bsf     STATUS, RP0
    bcf     UEP1,EP_STALL   ; set the stall bit

clear@endpoint_end
    call    Send@0Len_pkt
    return

Clear@Interface_Feature     ; starts in bank2
    return

; ******************************************************************
; only feature valid for device feature is Device Remote wakeup
; ******************************************************************
Set@Device_Feature  ; starts in bank 2
    movf    _BUFFER_DATA + wValue,w ; get high order byte of wValue    
    xorlw   0x01            ; was it a Device Remote wakeup?
    btfss   STATUS,Z
    goto    wrong@state      ; request error
    bsf     _USB_STATUS_DEVICE,1 ; set device remote wakeup
    call    Send@0Len_pkt
    return

; ******************************************************************
; Only endpoint feature is Endpoint halt.
; ******************************************************************
Set@Endpoint_Feature            ; starts in bank 2
    movlw   0x0f
    andwf   _BUFFER_DATA + wIndex,w ; mask off the EP number bits
    xorlw   0x01            ; is it EP1?
    btfsc   STATUS,Z
    goto    Stall@EP1

    movlw   0x0f
    andwf   _BUFFER_DATA + wIndex,w ; mask off the EP number bits
    xorlw   0x02            ; is it EP2?
    btfss   STATUS,Z
    goto    wrong@state

Stall@EP2
    bsf     STATUS, RP0
    bsf     UEP2,EP_STALL   ; set the stall bit
    goto    Stall@End        ; skip the second stall

Stall@EP1
    bsf     STATUS, RP0
    bsf     UEP1,EP_STALL   ; set the stall bit
Stall@End
    call    Send@0Len_pkt
    return

Set@Interface_Feature       ; starts in bank 2
    goto    wrong@state      ; invalid request
    return

; ********************************************************************
; Get configuration returns a single byte Data1 packet indicating the 
; configuration in use.
; Default State    - undefined
; Addressed State  - returns 0
; Configured state - returns current configured state.
; ******************************************************************
Get@Configuration_Code           ; starts in bank 2
    bsf     STATUS, RP0
    movf    low BD0IAL,w    ; get address of buffer
    movwf   FSR
    bcf     STATUS, RP0
    bsf     STATUS,IRP      ; indirectly to banks 2-3
    movf    _USB_CURR_CONFIG,w
    movwf   INDF            ; write byte to buffer
    bsf     STATUS, RP0
    movlw   0x01
    movwf   BD0IBC          ; set byte count to 1
    movlw   0xc8            ; DATA1 packet, DTS enabled
    movwf   BD0IST          ; give buffer back to SIE
    return

; ******************************************************************
; Set configuration uses the configuration selected by the low order
; byte of wValue.  Sets up a zero length data1 packet as a reply.
; ******************************************************************
Set@Configuration_Code           ; starts in bank 2
; All we do is set a meaningless number.  This'll 
; need more code here to actually give meaning to each configuration
; we choose.
    movf    _BUFFER_DATA + wValue,w ; is it a valid configuration?
    sublw   NUM_CONFIGURATIONS    
    btfss   STATUS,C        ; if config <= num configs, request appears valid
    goto    wrong@state

    movf    _BUFFER_DATA + wValue,w    
    movwf   _USB_CURR_CONFIG ; store new state in configuration

    btfsc   STATUS,Z        ; was the configuration zero?
    goto    Ack@SetConfigCmd ; yes: stay in the addressed state

    bsf     STATUS, RP0     ; bank 3
    movlw   CONFIG#STATE    ; No: transition to configured
    movwf   USWSTAT         ; save new state.
 #ifdef SHOW#ENUM#STATUS
    banksel PORTB
    bsf     PORTB,3         ; set bit 3 to show configured
;    banksel USWSTAT         ; not necessary, Send_0LenPkt resets bank bits
 #endif

Ack@SetConfigCmd
    call    Send@0Len_pkt

; These configure the EP1 and EP2  endpoints.  Change these as necessary
; for your application.
    banksel BD1OST
    movlw   0x88            ; set own bit of EP1 (SIE can write)
    movwf   BD1OST
    movlw   USB_Buffer + 0x10 ; Endpoint 1 OUT gets a buffer
    movwf   BD1OAL          ; set up buffer address
    movlw   8
    movwf   BD1OBC          ; set byte count

    movlw   0x48            ; set own bit of EP1 (PIC can write)
    movwf   BD1IST        
    movlw   USB_Buffer + 0x18 ; Endpoint 1 IN gets a buffer
    movwf   BD1IAL          ; set up buffer address

    movlw   0x88            ; set own bit of EP2 (SIE can write)
    movwf   BD2OST
    movlw   USB_Buffer + 0x20 ; Endpoint 2 OUT gets a buffer
    movwf   BD2OAL          ; set up buffer address
    movlw   8
    movwf   BD2OBC          ; set byte count

    movlw   0x48            ; set own bit of EP2 (PIC can write)
    movwf   BD2IST
    movlw   USB_Buffer + 0x20 ; EP1 In and EP2 In share a buffer
    movwf   BD2IAL          ; set up buffer address
; Set up the Endpoint Control Registers.  The following patterns are defined
; ENDPT_DISABLED - endpoint not used
; ENDPT_IN_ONLY  - endpoint supports IN transactions only
; ENDPT_OUT_ONLY - endpoint supports OUT transactions only
; ENDPT_CONTROL     - Supports IN, OUT and CONTROL transactions - Only use with EP0
; ENDPT_NON_CONTROL - Supports both IN and OUT transactions
    movlw   ENDPT_NON_CONTROL
    movwf   UEP1            ; enable EP's 1 and 2 for In and Outs...
    movlw   ENDPT_NON_CONTROL
    movwf   UEP2

;    pagesel Set@Configuration    ; call Set@Configuration etc. after configuration changed
;    movf    _USB_CURR_CONFIG,w   ; if you have multiple configurations
;    call    Set@Configuration
;    pagesel Set_Configuration
    return


; ********************************************************************
; Get interface returns a single byte Data1 packet indicating the 
; interface in use.
; Default State    - undefined
; Addressed State  - Not valid - returns stall
; Configured state - returns current configured state.
; ******************************************************************
Get@Interface_Code   ; STARTS IN BANK 2
    bsf     STATUS, RP0
    movf    USWSTAT,w       ; Not valid in the addressed state
    bcf     STATUS,RP0      ; bank 2
    andlw   0x03
    xorlw   BUF#ADDRESS#STATE
    btfsc   STATUS,Z
    goto    wrong@state

    movf    _BUFFER_DATA + wIndex,w ; get interface ID
    addlw   low _USB_INTERFACE
    movwf   FSR
    bsf     STATUS,IRP
    movf    INDF,w        
    movwf   TEMP            ; store in TEMP register
    
    bsf     STATUS,RP0      ; bank 3
    movf    BD0IAL,w        ; get address of buffer
    movwf   FSR
    movf    TEMP,w          ; load TEMP
    movwf   INDF            ; write byte to buffer

    movlw   0x01
    movwf   BD0IBC          ; set byte count to 1
    movlw   0xc8            ; DATA1 packet, DTS enabled
    movwf   BD0IST          ; give buffer back to SIE
    return

; ******************************************************************
; Set configuration uses the configuration selected by the low order
; byte of wValue.  Sets up a zero length data1 packet as a reply.
; ******************************************************************
Set@Interface_Code   ; start bank 2
    bsf     STATUS, RP0
    movf    USWSTAT,w       ; test to make sure we're configured
    bcf     STATUS,RP0      ; bank2
    andlw   0x03
    xorlw   CONFIG#STATE
    btfss   STATUS,Z
    goto    wrong@state

    bcf     STATUS, RP0
    movf    _BUFFER_DATA + wIndex,w ; get interface
    addlw   low _USB_INTERFACE   ; add offset to array
    movwf   FSR
    bsf     STATUS,IRP      ; indirectly to banks 2-3
    movf    _BUFFER_DATA + wValue,w ; get alternate interface
    movwf   INDF            ; store in array
; All we do is set a meaningless number.  This'll 
; need more code here to actually give meaning to each configuration
; we choose.

    call    Send@0Len_pkt
    return

; *********************************************************************
; copies the next chunk of buffer descriptor over to the EP0 In buffer.
; Inputs:
;    EP0_START - points to first byte of configuration table to transfer
;    _EP0_END - total number of bytes to transfer
;    _EP0_MAXLENGTH - maximum number of bytes that can be sent during
;    a single transfer
;
; toggles the data0/1 bit before setting the UOWN bit over to SIE.
; ******************************************************************
copy@descriptor_to_EP0
    banksel BD0IAL
    bankisel BD0IAL
    movf    BD0IAL,w        ; get buffer address
    movwf   FSR 
    banksel _BUF_INDEX
    clrf    _BUF_INDEX        ; _BUF_INDEX = 0
gdd@loop
    movf    _BUF_INDEX,w      ; while (_BUF_INDEX < _EP0_MAXLENGTH)
    subwf   _EP0_MAXLENGTH,w ;    && (EP0_START < _EP0_END)
    btfsc   STATUS,Z
    goto    end@gdd_loop

    decfsz  _EP0_END, f
    goto    gdd@copy_loop
    goto    end@gdd_loop_short_packet

gdd@copy_loop
    pagesel Descriptions
    call    Descriptions
    pagesel gdd@copy_loop
    movwf   INDF
    
    incf    _BUF_INDEX,f    
    incf    FSR,f
    incfsz  EP0_START,f
    goto    gdd@loop
    incf    EP0_START + 1,f
    goto    gdd@loop

end@gdd_loop_short_packet
    clrf    _USB_DEV_REQ     ; we're sending a short packet, clear the device request
end@gdd_loop
    movf    _BUF_INDEX,w      ; write number of bytes to byte count
    bsf     STATUS,RP0      ; Bank 3
    movwf   BD0IBC
    movlw   (0x01<<DATA01)  ; toggle data0/1 bit
    xorwf   BD0IST,w
    andlw   (0x01<<DATA01)  ; clear PID bits
    iorlw   0x88            ; set OWN and DTS bits
    movwf   BD0IST          ; write the whole mess back
    pagesel copy@descriptor_to_EP0
    return
; *********************************************************************
; Set@Configuration
; 
; This function is called when the host issues a Set Configuration 
; command.  The housekeeping within USB is handled within the CH9 commands
; This function should be filled in to give meaning to the command within
; the application.
;
; Set@Configuration is called from within the ISR so this function should
; be kept as short as possible.
; *********************************************************************
Set@Configuration
    return

; *********************************************************************
; Vendor Specific calls
; control is transferred here when bmRequestType bits 5 & 6 = 10 indicating
; the request is a vendor specific request.  This function then would 
; interpret the bRequest field to determine what action is required.
; The end of each vendor specific command should be terminated with a 
; return.  
; *********************************************************************
Check@Vendor    
    return  ; *** remove this line and uncomment out the remainder    

