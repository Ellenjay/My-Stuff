 LIST
;
; Buffer Descriptor Byte Aliases
;
#define	__STAT			0			; Endpoint Buffer Descriptor Status Register offset
#define	__CNT			1			; Endpoint Buffer Count offset
#define	__ADRL			2			; Endpoint Buffer Address offset Low
#define	__ADRH			3			; Endpoint Buffer Address offset High

; __STAT Bit Aliases
#define	__BC8			0			; Upper Count Bit
#define	__BC9			1			; Upper Count Bit
#define	__BSTALL		2			; Buffer Stall Enable
#define	__DTSEN			3			; Data Toggle Synch Enable
#define	__INCDIS		4			; Address Increment Disable
#define	__KEN			5			; BD Keep Enable
#define	__DTS			6			; Data Toggle Synch Value
#define	__UOWN			7			; USB Ownership
#define	__PID			2			; Packet Identifier (4 bits)

#define __USB_RAM_BANK 0x400
og@sve equ	$						; Save the current RAM location
	org		__USB_RAM_BANK			; Point to the bank holding the variables
;
; Buffer Descriptor Table (BDT) RAM
;
if(0 <= __MAX_EP_NUMBER)		
__ep0Bo				res	4			; Endpoint #0 BD OUT
__ep0Bi				res	4			; Endpoint #0 BD IN
endif

if(1 <= __MAX_EP_NUMBER)
__ep1Bo				res	4			; Endpoint #1 BD OUT
__ep1Bi				res	4			; Endpoint #1 BD IN
endif

if(2 <= __MAX_EP_NUMBER)
__ep2Bo				res	4			; Endpoint #2 BD OUT
__ep2Bi				res	4			; Endpoint #2 BD IN
endif

if(3 <= __MAX_EP_NUMBER)
__ep3Bo				res	4			; Endpoint #3 BD OUT
__ep3Bi				res	4			; Endpoint #3 BD IN
endif

if(4 <= __MAX_EP_NUMBER)
__ep4Bo				res	4			; Endpoint #4 BD OUT
__ep4Bi				res	4			; Endpoint #4 BD IN
endif

if(5 <= __MAX_EP_NUMBER)
__ep5Bo				res	4			; Endpoint #5 BD OUT
__ep5Bi				res	4			; Endpoint #5 BD IN
endif

if(6 <= __MAX_EP_NUMBER)
__ep6Bo				res	4			; Endpoint #6 BD OUT
__ep6Bi				res	4			; Endpoint #6 BD IN
endif

if(7 <= __MAX_EP_NUMBER)
__ep7Bo				res	4			; Endpoint #7 BD OUT
__ep7Bi				res	4			; Endpoint #7 BD IN
endif

if(8 <= __MAX_EP_NUMBER)
__ep8Bo				res	4			; Endpoint #8 BD OUT
__ep8Bi				res	4			; Endpoint #8 BD IN
endif

if(9 <= __MAX_EP_NUMBER)
__ep9Bo				res	4			; Endpoint #9 BD OUT
__ep9Bi				res	4			; Endpoint #9 BD IN
endif

if(10 <= __MAX_EP_NUMBER)
__ep10Bo			res	4			; Endpoint #10 BD OUT
__ep10Bi			res	4			; Endpoint #10 BD IN
endif

if(11 <= __MAX_EP_NUMBER)
__ep11Bo			res	4			; Endpoint #11 BD OUT
__ep11Bi			res	4			; Endpoint #11 BD IN
endif

if(12 <= __MAX_EP_NUMBER)
__ep12Bo			res	4			; Endpoint #12 BD OUT
__ep12Bi			res	4			; Endpoint #12 BD IN
endif

if(13 <= __MAX_EP_NUMBER)
__ep13Bo			res	4			; Endpoint #13 BD OUT
__ep13Bi			res	4			; Endpoint #13 BD IN
endif

if(14 <= __MAX_EP_NUMBER)
__ep14Bo			res	4			; Endpoint #14 BD OUT
__ep14Bi			res	4			; Endpoint #14 BD IN
endif

if(15 <= __MAX_EP_NUMBER)
__ep15Bo			res	4			; Endpoint #15 BD OUT
__ep15Bi			res	4			; Endpoint #15 BD IN
endif


; General RAM
__USB_TEMP_VAR		res	2			; Temporary storage
__PSrc				res	2			; Source pointer
__PDst				res	2			; Destination pointer

__CTRL_TRF_STATE	res	1			; Control Transfer State
__CTRL_TRF_SESSION_OWNER res 1		; Current transfer session owner
__WCount			res	2			; Data counter

__USB_DEVICE_STATE 	res	1			; Device States: DETACHED, ATTACHED etc
__USB_ACTIVE_CFG	res	1			; Value of current configuration
__USB_ALT_INTF		res	__MAX_NUM_INT	; buffer to keep track of the current alternate setting for each interface ID
__USB_STAT			res	1

; __USB_STAT bit aliases
#define	__RemoteWakeup	0			; [0]Disabled [1]Enabled
#define	__CTRL_TRF_MEM	1			; [0]RAM      [1]ROM
#define	__cdc_mem_type	2			; [0]RAM      [1]ROM

; Endpoint 0 buffers
__SetupPkt		res	__EP0_BUFF_SIZE		
__CtrlTrfData	res	__EP0_BUFF_SIZE	

; __SetupPkt Byte and Bit Aliases
#define	__bmRequestType	0
#define	__bRequest		1
#define	__wValue		2
#define	__wIndex		4
#define	__wLength		6

#define	__Recipient		0		; Device,Interface,Endpoint,Other (5 bits)
#define	__RequestType	5		; Standard, Class, Vendor, Reserved (2 bits)
#define	__DataDir		7		; Host-to-device, Device-to-host
#define	__bFeature		2		; DEVICE_REMOTE_WAKEUP, ENDPOINT_HALT

#define	__bReportID		2		; In a SET_REPORT or GET_REPORT request
#define	__bReportType	3		; In a SET_REPORT or GET_REPORT request

#define	__bDscIndex		2		; For Configuration and String DSC Only
#define	__bDscType		3		; Device Configuration String
#define	__wLangID		4		; Language ID

#define	__bDevADR		2		; Device Address 0 - 127
#define	__bDevADRH		3		; Must equal zero

#define	__bCfgValue		2		; Configuration Value 0 - 255
#define	__bCfgRSD		3		; Must equal zero (Reserved)

#define	__bAltID		2		; Alternate Setting Value 0 - 255
#define	__bAltID_H		3		; Must equal zero (Reserved)
#define	__bIntfID		4		; Interface Number Value 0 - 255
#define	__bIntfID_H		5		; Must equal zero

#define	__bEPID			4		; Endpoint ID (Number & Direction)
#define	__bEPID_H		5		; Must equal zero

#define	__EPNum			0		; Endpoint Number 0 - 15 (4 bits)
#define	__EPDir			7		; Endpoint Direction: 0 - OUT, 1 - IN


; HID RAM
ifdef __USB_USE_HID
__IDLE_RATE			res	1
__ACTIVE_PROTOCOL	res	1			; [0] Boot Protocol [1] Report Protocol
endif

; CDC RAM
ifdef __USB_USE_CDC			
__LINE_CODING					  res	__LINE_CODING_LENGTH
__CONTROL_SIGNAL_BITMAP 		  res 1
__DUMMY_ENCAPSULATED_CMD_RESPONSE res __DUMMY_LENGTH

; line_coding Byte and Bit Aliases
#define	__dwDTERate	0				; Complex data structure
#define	__bCharFormat	4
#define	__bParityType	5
#define	__bDataBits	6

; control_signal_bitmap Byte and Bit Aliases
#define	__DTE_PRESENT	0			; [0] Not Present  [1] Present
#define	__CARRIER_CONTROL	1		; [0] Deactivate   [1] Activate
endif
;
; All previous RAM must be in bank 4
; The following buffers may be in any dual-port RAM bank from 0x0500 to 0x0700
;
; CDC Buffer RAM	
ifdef __USB_USE_CDC
	org 0x0500										; Place the NOTICE buffer at address 0x0500								
__CDC_NOTICE	res	__CDC_INT_EP_SIZE + 1			; +1 for size at front
	org 0x0510										; Place the TX buffer at address 0x0510
__CDC_DATA_TX	res	__CDC_BULK_IN_EP_SIZE + 1		; +1 for size at front
	org 0x0600										; Place the RX buffer at address 0x0600
__CDC_DATA_RX	res	__CDC_BULK_OUT_EP_SIZE + 1		; +1 for size at front
endif
;
; HID Buffer RAM
ifdef __USB_USE_HID
	org 0x0510										; Place the TX buffer at address 0x0600
__HID_REPORT_IN	res		__HID_INT_IN_EP_SIZE + 1	; +1 for size at front
	org 0x0600										; Place the RX buffer at address 0x0510
__HID_REPORT_OUT res	__HID_INT_OUT_EP_SIZE + 1	; +1 for size at front
endif

	org	og@sve									; Restore the previous RAM location
