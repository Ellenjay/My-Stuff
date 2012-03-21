 LIST
;
; This file contains a set of descriptors for a CDC Virtual serial com interface.
;
#define	__EP0_BUFF_SIZE			8						; 8, 16, 32, or 64
#define	__MAX_NUM_INT			1						; For tracking Alternate Setting
#define	__MAX_EP_NUMBER			3						; UEP3
#define	__NUM_CONFIGURATIONS	1
#define	__NUM_INTERFACES		2

#define	__MODE_PP	_PPBM0
#define	__UCFG_VAL	_PUEN | _TRINT | _FS | __MODE_PP	; Set bus for Full Speed

#define __USB_USE_CDC									; Inform the rest of the library subroutines that we're using a CDC interface

; CDC
#define __CDC_COMM_INTF_ID        0
#define __CDC_COMM_UEP            UEP2
#define __CDC_INT_BD_IN           __ep2Bi
#define __CDC_INT_EP_SIZE         8
#define __CDC_DATA_INTF_ID        1
#define __CDC_DATA_UEP            UEP3
#define __CDC_BULK_BD_OUT         __ep3Bo
#define __CDC_BULK_OUT_EP_SIZE    128					; 128 byte output buffer. Note maximum of 128
#define __CDC_BULK_BD_IN          __ep3Bi
#define __CDC_BULK_IN_EP_SIZE     128					; 128 byte input buffer. Note maximum of 128

; ------------------------------------------------------------------------------
; This table is polled by the host immediately after USB Reset has been released.
; These fields are application dependent to be modified to meet your specifications.
;
__DeviceDescriptor
	retlw	(__EndDeviceDescriptor - __DeviceDescriptor) / 2	; bLength Length of this descriptor
	retlw	__DSC_DEV									; bDescType DEVICE
	dt		0x10, 0x01									; bcd USB Revision 1.10 low byte, high byte
	retlw	__CDC_DEVICE								; bDeviceClass
	retlw	0x00										; bDeviceSubClass
	retlw	0x00										; bDeviceProtocol
	retlw	__EP0_BUFF_SIZE								; bMaxPacketSize for EP0
	dt		0xD8, 0x04									; idVendor - 0x04D8 is Microchip VENDOR ID low byte, high byte
	dt		0x0A, 0x00									; idProduct Product ID low byte, high byte
	dt		0x00, 0x00									; bcd Device Device release number low byte, high byte
	retlw	0x01										; iManufacturer Manufacturer string index
	retlw	0x02										; iProduct Product string index
	retlw	0x03										; iSerialNumber Device serial number string index
	retlw	__NUM_CONFIGURATIONS						; bNumConfigurations
__EndDeviceDescriptor

; ------------------------------------------------------------------------------
; This table is retrieved by the host after the address has been set.
; This table defines the configurations available for the device.
; See section 9.6.2 of the Rev 1.0 USB specification (page 184).
; These fields are application dependent to be modified to meet your specifications.
;
; Configuration pointer table
__USB_CD_Ptr
__Configs
	db	low ___Config1, high ___Config1
	db	low ___Config1, high ___Config1

; Configuration Descriptor
___Config1
	retlw	9											; bLength Length of this descriptor
	retlw	__DSC_CFG									; bDescType CONFIGURATION
__Config1Len
	retlw	low ((__EndConfig1 - ___Config1) / 2)		; Length of this configuration
	retlw	high ((__EndConfig1 - ___Config1) / 2)
	retlw	__NUM_INTERFACES							; bNumInterfaces Number of interfaces IN this configuration
	retlw	0x01										; bConfigValue Configuration Value
	retlw	0x02										; iConfigString Index for this configuration
	retlw	0x80										; bmAttributes
	retlw	0x50										; Max power consumption (2X mA)

; Interface Descriptor
	retlw	9											; bLength Length of this descriptor
	retlw	__DSC_INTF									; bDescType INTERFACE
	retlw	0											; Interface number
	retlw	0											; Alternate setting
	retlw	1											; Number of endpoints in this interface
	retlw	__COMM_INTF									; Class code
	retlw	__ABSTRACT_CONTROL_MODEL					; Subclass code
	retlw	__V25TER									; Protocol code
	retlw	0											; Interface string index

; CDC Class-Specific Descriptors
	retlw	5											; bFNLength (USB_CDC_HEADER_FN_DSC)
	retlw	__CS_INTERFACE								; bDscType
	retlw	__DSC_FN_HEADER								; bDscSubType
	dt		0x10, 0x01									; bcd CDC low byte, high byte

	retlw	4											; bFNLength (USB_CDC_ACM_FN_DSC)
	retlw	__CS_INTERFACE								; bDscType
	retlw	__DSC_FN_ACM								; bDscSubType
	retlw	2											; bmCapabilities

	retlw	5											; bFNLength (USB_CDC_UNION_FN_DSC)
	retlw	__CS_INTERFACE								; bDscType
	retlw	__DSC_FN_UNION								; bDscSubType
	retlw	__CDC_COMM_INTF_ID							; bMasterIntf
	retlw	__CDC_DATA_INTF_ID							; bSaveIntf0

	retlw	5											; bFNLength (USB_CDC_CALL_MGT_FN_DSC)
	retlw	__CS_INTERFACE								; bDscType
	retlw	__DSC_FN_CALL_MGT							; bDscSubType
	retlw	0											; bmCapabilities
	retlw	__CDC_DATA_INTF_ID							; bDataInterface

; Endpoint Descriptor
	retlw	7											; bLength (USB_EP_DSC)
	retlw	__DSC_EP									; bDscType
	retlw	_EP02_IN									; bEPAdr
	retlw	3											; bmAttributes (_INT)
	retlw	low (__CDC_INT_EP_SIZE)						; wMaxPktSize
	retlw	high (__CDC_INT_EP_SIZE)
	retlw	2											; bInterval
    
; Interface Descriptor
	retlw	9											; bLength Length of this descriptor
	retlw	__DSC_INTF									; INTERFACE descriptor type
	retlw	1											; Interface Number
	retlw	0											; Alternate Setting Number
	retlw	2											; Number of endpoints in this intf
	retlw	__DATA_INTF									; Class code
	retlw	0											; Subclass code
	retlw	__NO_PROTOCOL								; Protocol code
	retlw	0											; Interface string index
    
; Endpoint Descriptors
	retlw	7											; bLength (USB_EP_DSC)
	retlw	__DSC_EP									; bDscType
	retlw	_EP03_OUT									; bEPAdr
	retlw	2											; bmAttributes (_BULK)
	retlw	low (__CDC_BULK_OUT_EP_SIZE)				; wMaxPktSize
	retlw	high (__CDC_BULK_OUT_EP_SIZE)
	retlw	0											; bInterval
	
	retlw	7											; bLength (USB_EP_DSC)
	retlw	__DSC_EP									; bDscType
	retlw	_EP03_IN									; bEPAdr
	retlw	2											; bmAttributes (_BULK)
	retlw	low (__CDC_BULK_IN_EP_SIZE)					; wMaxPktSize
	retlw	high (__CDC_BULK_IN_EP_SIZE)
	retlw	0											; bInterval
__EndConfig1


; String pointer table
__USB_SD_Ptr
__Strings
	db	low __String0, high __String0
	db	low __String1, high __String1
	db	low __String2, high __String2
	db	low __String3, high __String3
	db	low __String4, high __String4

__String0
	retlw   (__String1 - __String0) / 2					; Length of string 
	retlw   __DSC_STR									; Descriptor type 3
	dt   0x09, 0x04    									; Language ID (0x0409 as defined by Microsoft) 

__String1
	retlw   (__String2 - __String1) / 2
	retlw   __DSC_STR
	dt   'M', 0, 'i', 0, 'c', 0, 'r', 0, 'o', 0, 'c', 0, 'h', 0, 'i', 0, 'p', 0
__String2
	retlw   (__String3 - __String2) / 2
	retlw   __DSC_STR
	dt   'P', 0, 'I', 0, 'C', 0, '1', 0, '8', 0, ' ', 0 
	dt   'U', 0, 'S', 0, 'B', 0, ' ', 0, 'C', 0, 'D', 0, 'C', 0
__String3
	retlw   (__String4 - __String3) / 2
	retlw   __DSC_STR
	dt   'V', 0, '1', 0, '.', 0, '1', 0, 'F', 0, 'S', 0
__String4
	retlw   (__String5 - __String4) / 2
	retlw   __DSC_STR
	dt   'C', 0, 'f', 0, 'g', 0, '1', 0
__String5
