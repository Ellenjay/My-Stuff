 NOLIST
; ###############################################################################
;   filename:           HIDCLASS.ASM
;
;   Implements USB Human Interface Device (HID) class specific commands.
;
; ###############################################################################
;
;   Author(s):          Dan Butler and Reston Condit
;   Company:            Microchip Technology Inc
;
;   Revision:           1.21
;   Date:               08 August 2001
;   Assembled using     MPASM 2.61
;   Revision History:
;   23 August 2000      DZB Changed descriptor pointers to 16 bits.
;   24 August 2000      DZB Moved EP1 & 2 configuration from USB@Reset
;                           to Set_Configuration to implement requirement in
;                           USB V1.1 spec paragraph 5.3.1.2
;   28 August 2000      DZB Force data toggle on OUT packets in PutUSB
;   20 March 2001       DZB Reduced use of common RAM
;   20 March 2001       DZB Put and Get use their own TEMP variable (_GP_TEMP) to
;                           avoid collisions with the ISR's use of TEMP.
;   29 March 2001       DZB Fixed saving of bank bits in GetUSB
;   02 May 2001         DZB Implemented SHOW#ENUM#STATUS to show enumeration
;                           status on the PORTB LEDs: 0- Powered, 1- Default,
;                           2- addressed, 3- configured, 4- sleep, 
;                           5- EP0 Activity, 6- EP1 Activity, 7- EP2 Activity
;   03 August 2001      RAC Made distinct GetEP and PutEP macros for endpoints 1 
;                           and 2.  These functions are GetEP1, GetEP2, PutEP1, and 
;                           PutEP2.  Instances of the these macros are created in
;                           usb_ch9.asm.
;   08 August 2001      RAC Corrected various banking and paging issues.
;   15 August           RAC Added Report_desc_index function in descript.asm.
;                           This function allows more than one report descriptor
;                           to be used. 
;   06 September 2001	JMS Changed to work with PBP compiler.
;
;################################################################################
;
;   include files:
;       P16C7x5.inc     Rev 1.00
;       usb_defs.inc    Rev 1.21
;
;################################################################################

; ******************************************************************
; Get Class Specific Descriptor
; ******************************************************************
 LIST
ClassSpecificRequest
    pagesel Dev2HostHIDRequest
    movf    _BUFFER_DATA + bmRequestType,w
    xorlw   0x21
    btfsc   STATUS,Z
    goto    Host2DevHIDRequest

    movf    _BUFFER_DATA + bmRequestType,w
    xorlw   0x22
    btfsc   STATUS,Z
    goto    Host2DevReportRequest

    movf    _BUFFER_DATA + bmRequestType,w
    xorlw   0x23
    btfsc   STATUS,Z
    goto    Host2DevPhysicalRequest

    movf    _BUFFER_DATA + bmRequestType,w
    xorlw   0xA1
    btfsc   STATUS,Z
    goto    Dev2HostHIDRequest

    movf    _BUFFER_DATA + bmRequestType,w
    xorlw   0xA2
    btfsc   STATUS,Z
    goto    Dev2HostReportRequest

    movf    _BUFFER_DATA + bmRequestType,w
    xorlw   0xA3
    btfsc   STATUS,Z
    goto    Dev2HostPhysicalRequest

    pagesel wrong@state
    goto    wrong@state    

    ; Need to add code if you need to handle optional functions
    ; such as get/set_idle. Otherwise, send STALL buy calling
    ; to signal the host that the feature is not implemented.

Host2DevHIDRequest
    movf    _BUFFER_DATA + bRequest,w
    xorlw   0x01
    btfsc   STATUS,Z
    goto    GetHIDReport

    movf    _BUFFER_DATA + bRequest,w
    xorlw   0x02
    btfsc   STATUS,Z
    goto    GetIdle

    movf    _BUFFER_DATA + bRequest,w
    xorlw   0x03
    btfsc   STATUS,Z
    goto    GetPhysical

    movf    _BUFFER_DATA + bRequest,w
    xorlw   0x06
    btfsc   STATUS,Z
    goto    Get_Report_Descriptor

    movf    _BUFFER_DATA + bRequest,w
    xorlw   0x09
    btfsc   STATUS,Z
    goto    SetHIDReport

    movf    _BUFFER_DATA + bRequest,w
    xorlw   0x0A
    btfsc   STATUS,Z
    goto    SetIdle

    movf    _BUFFER_DATA + bRequest,w
    xorlw   0x0B
    btfsc   STATUS,Z
    goto    SetProtocol

    pagesel wrong@state
    goto    wrong@state
    
; ******************************************************************
; Get Report Descriptor
; Returns the Mouse Report descriptor
; Checks for the report type (input, output or Feature).
; ******************************************************************
Get_Report_Descriptor
    banksel EP0_START
    movlw   GET#DESCRIPTOR
    movwf   _USB_DEV_REQ     ; currently processing a get descriptor request

    movlw   8
    movwf   _EP0_MAXLENGTH

    movf    _BUFFER_DATA + (wValue + 1),w ; check report ID
    xorlw   0x01                    ; was it an Input Report?
    btfsc   STATUS,Z
    goto    TryOutputReport

    pagesel Descriptions
    bcf     STATUS,C
    rlf     _BUFFER_DATA + wIndex,w
    call    Report_desc_index   ; translate index to offset into descriptor table
    movwf   EP0_START
    bcf     STATUS,C
    rlf     _BUFFER_DATA + wIndex,w
    addlw   1                   ; point to high order byte
    call    Report_desc_index   ; translate index to offset into descriptor table
    movwf   EP0_START + 1
    call    Descriptions
    movwf   _EP0_END
    pagesel CheckReportLength
    incf    EP0_START,f
    goto    CheckReportLength

TryOutputReport
    movf    _BUFFER_DATA + (wValue + 1),w ; check report ID
    xorlw   0x02                    ; was it an Output Report?
    btfsc   STATUS,Z
    goto    TryFeatureReport

    pagesel Descriptions
    bcf     STATUS,C
    rlf     _BUFFER_DATA + wIndex,w
    call    Report_desc_index   ; translate index to offset into descriptor table
    movwf   EP0_START
    bcf     STATUS,C
    rlf     _BUFFER_DATA + wIndex,w
    addlw   1                   ; point to high order byte
    call    Report_desc_index   ; translate index to offset into descriptor table
    movwf   EP0_START + 1
    call    Descriptions
    movwf   _EP0_END
    pagesel CheckReportLength
    incf    EP0_START,f
    goto    CheckReportLength

TryFeatureReport
    movf    _BUFFER_DATA + (wValue + 1),w ; check report ID
    xorlw   0x03            ; was it an Output Report?
    pagesel wrong@state
    btfsc   STATUS,Z
    goto    wrong@state

; Fill EP0IN buffer here...
    return
    
CheckReportLength
    movf    _BUFFER_DATA + (wLength + 1),w ; Is the host requesting more than 255 bytes?
    btfss   STATUS,Z        ; If so, the host is requesting more than we have
    goto    nolimit_rpt

check_low_bytes
    movf    _BUFFER_DATA + wLength,w
    subwf   _EP0_END,w       ; if not, compare the amount the host is request
    movf    _BUFFER_DATA + wLength,w ; with the length of the descriptor
    btfsc   STATUS,C        ; if the host is request less than the descriptor
    movwf   _EP0_END         ; length, send only as much as what the host wants

nolimit_rpt
    incf    _EP0_END,f
    pagesel copy@descriptor_to_EP0        
    call    copy@descriptor_to_EP0
    return

Get_HID_Descriptor
    movlw   GET#DESCRIPTOR
    movwf   _USB_DEV_REQ     ; currently processing a get descriptor request

    movlw   8
    movwf   _EP0_MAXLENGTH

    movlw   low HID_Descriptor
    movwf   EP0_START
    movlw   high HID_Descriptor
    movwf   EP0_START   +   1
    pagesel Descriptions
    call    Descriptions    ; get the HID descriptor length
    movwf   _EP0_END
    pagesel Get_HID_Descriptor

    movf    _BUFFER_DATA + (wLength + 1),f
    btfss   STATUS,Z
    goto    nolimit_hid

    subwf   _BUFFER_DATA + wLength,w
    movf    _BUFFER_DATA + wLength,w
    btfss   STATUS,C
    movwf   _EP0_END

nolimit_hid
    incf    _EP0_END,f
    pagesel copy@descriptor_to_EP0
    call    copy@descriptor_to_EP0
    return

Get_Physical_Descriptor
    return

Check_Class_Specific_IN
    pagesel copy@descriptor_to_EP0
    movf    _USB_DEV_REQ,w
    xorlw   GET#DESCRIPTOR
    btfsc   STATUS,Z
    call    copy@descriptor_to_EP0
    return

; ******************************************************************
; These requests are parsed out, but nothing is actually done with them
; currently they simply stall EP0 to show that the request is not
; supported.  If you need to support them, fill in the code.
; ******************************************************************
Host2DevReportRequest
Host2DevPhysicalRequest
Dev2HostHIDRequest
Dev2HostReportRequest
Dev2HostPhysicalRequest
GetHIDReport
GetIdle
GetPhysical
SetIdle
    pagesel wrong@state
    goto    wrong@state

SetHIDReport
    movlw   HID_SET_REPORT
    movwf   _USB_DEV_REQ     ; store status
    banksel BD0OST
    movlw   0xc8            ; reset buffer
    movwf   BD0OST           
    return

; ******************************************************************
; As written, Set Protocol merely returns a zero length packet to keep the OS happy.
; If your application actually needs to do something with the protocol value specified
; here's where to add the code.
; ******************************************************************
SetProtocol
    banksel BD0IBC          ; select bank 3
    movlw   0x00
    movwf   BD0IBC          ; set the byte count field to zero
    movlw   0xc8    
    movwf   BD0IST          ; Set the OWNs bit

; Add code here to actually do something with the protocol value specified.
    return
 LIST
