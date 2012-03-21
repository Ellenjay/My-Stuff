 LIST
;
; This file contains a set of descriptors for a STANDARD mouse.
;
#define	__EP0_BUFF_SIZE			8	; 8, 16, 32, or 64
#define	__MAX_NUM_INT			1	; For tracking Alternate Setting
#define	__MAX_EP_NUMBER			1	; UEP1
#define	__NUM_CONFIGURATIONS	1
#define	__NUM_INTERFACES		1

#define	__MODE_PP			_PPBM0
#define	__UCFG_VAL			_PUEN | _TRINT | _FS | __MODE_PP	; Full-speed

#define __USB_USE_HID				; Inform the rest of the library subroutines that we're using a HID interface

; HID
; Endpoints Allocation
#define	__HID_INTF_ID			0
#define	__HID_UEP				UEP1
#define	__HID_BD_OUT			__ep1Bo
#define	__HID_INT_OUT_EP_SIZE	8
#define	__HID_BD_IN				__ep1Bi
#define	__HID_INT_IN_EP_SIZE	8
#define	__HID_NUM_OF_DSC		1

; ------------------------------------------------------------------------------
; This table is polled by the host immediately after USB Reset has been released.
; This table defines the maximum packet size EP0 can take.
; See section 9.6.1 of the Rev 1.0 USB specification.
; These fields are application dependent to be modified to meet your specifications.
;
__DeviceDescriptor
	retlw	(__EndDeviceDescriptor - __DeviceDescriptor) / 2	; bLength Length of this descriptor
	retlw	__DSC_DEV				; bDescType This is a DEVICE descriptor
	dt		0x10, 0x01				; bcdUSB Revision 1.10 low byte, high byte
	retlw	0x00					; bDeviceClass
	retlw	0x00					; bDeviceSubClass
	retlw	0x00					; bDeviceProtocol
	retlw	__EP0_BUFF_SIZE			; bMaxPacketSize for EP0
	dt		0xD8, 0x04				; idVendor - 0x04D8 is Microchip VENDOR ID low byte, high byte
	dt		0x00, 0x00				; idProduct low byte, high byte
	dt		0x01, 0x00				; bcdDevice low byte, high byte
	retlw	0x01					; iManufacturer
	retlw	0x02					; iProduct
	retlw	0x03					; iSerialNumber
	retlw	__NUM_CONFIGURATIONS	; bNumConfigurations
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
	retlw	(__Interface1 - ___Config1) / 2	; bLength Length of this descriptor
	retlw	__DSC_CFG						; bDescType2 = CONFIGURATION
__Config1Len
	retlw	low ((__EndConfig1-___Config1) / 2)	; Length of this configuration
	retlw	high ((__EndConfig1 - ___Config1) / 2)
	retlw	0x01							; bNumInterfaces Number of interfaces
	retlw	0x01							; bConfigValue Configuration Value
	retlw	0x04							; iConfigString Index for this config = #01
	retlw	0xA0							; bmAttributes attributes - bus powered
	retlw	0x50							; Max power consumption (2X mA)
__Interface1
	retlw	(__HIDDescriptor1 - __Interface1) / 2	; length of descriptor
	retlw	__DSC_INTF
	retlw	0x00							; number of interface, 0 based array
	retlw	0x00							; alternate setting
	retlw	0x01							; number of endpoints used in this interface
	retlw	0x03							; interface CLASS - assigned by the USB
	retlw	0x01							; boot device
	retlw	0x02							; interface protocol - mouse
	retlw	0x05							; index to string descriptor that describes this interface
__HIDDescriptor1
	retlw	(__Endpoint1 - __HIDDescriptor1) / 2	; descriptor size (9 bytes)
	retlw	0x21							; descriptor type (HID)
	retlw	0x00							; HID CLASS release number (1.00)
	retlw	0x01
	retlw	0x00							; Localised country code (none)
	retlw	0x01							; Number of HID CLASS descriptor to follow (1)
	retlw	0x22							; Report descriptor type (HID)
__ReportDescriptor1Len
	retlw	low ((__EndReportDescriptor1 - __ReportDescriptor1) / 2)
	retlw	high ((__EndReportDescriptor1 - __ReportDescriptor1) / 2)
__Endpoint1
	retlw	(__EndConfig1 - __Endpoint1) / 2	; length of descriptor
	retlw	__DSC_EP
	retlw	0x81							; EP1, IN
	retlw	0x03							; Interrupt
	retlw	0x08							; This should be the size of the endpoint buffer
	retlw	0x00
	retlw	0x0A							; polling interval (10ms)
__EndConfig1

__ReportDescriptor1
	retlw   0x05
	retlw   0x01    						; usage page (generic desktop)
	retlw   0x09
	retlw   0x02    						; usage (mouse)
	retlw   0xA1
	retlw   0x01    						; collection (application)
	retlw   0x09
	retlw   0x01    						; usage (pointer)
	retlw   0xA1
	retlw   0x00    						; collection (linked)
	retlw   0x05
	retlw   0x09    						; usage page (buttons)
	retlw   0x19
	retlw   0x01    						; usage minimum (1)
	retlw   0x29
	retlw   0x03    						; usage maximum (3)
	retlw   0x15
	retlw   0x00    						; logical minimum (0)
	retlw   0x25
	retlw   0x01    						; logical maximum (1)
	retlw   0x95
	retlw   0x03    						; report count (3)
	retlw   0x75
	retlw   0x01    						; report size (1)
	retlw   0x81
	retlw   0x02    						; input (3 button bits)
	retlw   0x95
	retlw   0x01   	 						; report count (1)
	retlw   0x75
	retlw   0x05    						; report size (5)
	retlw   0x81
	retlw   0x01    						; input (constant 5 bit padding)
	retlw   0x05
	retlw   0x01    						; usage page (generic desktop)
	retlw   0x09
	retlw   0x30    						; usage (X)
	retlw   0x09
	retlw   0x31    						; usage (Y)
	retlw   0x15
	retlw   0x81    						; logical minimum (-127)
	retlw   0x25
	retlw   0x7F    						; logical maximum (127)
	retlw   0x75
	retlw   0x08    						; report size (8)
	retlw   0x95
	retlw   0x03    						; report count (2)
	retlw   0x81
	retlw   0x06    						; input (2 position bytes X & Y)
	retlw   0xC0    						; end collection
	retlw   0xC0   	 						; end collection
__EndReportDescriptor1


__langids
	retlw   low __lang_1
	retlw   high __lang_1
	retlw   low __lang_2      				; String indexes of different languages
	retlw   high __lang_2

__lang_1									; English
	retlw   low  __String0    				; __langids
	retlw   high __String0
	retlw   low  __String1_l1    
	retlw   high __String1_l1
	retlw   low  __String2_l1
	retlw   high __String2_l1
	retlw   low  __String3_l1
	retlw   high __String3_l1
	retlw   low  __String4_l1
	retlw   high __String4_l1
	retlw   low  __String5_l1
	retlw   high __String5_l1

__lang_2
	retlw   low  __String0    				; Also point to LangID
	retlw   high __String0
	retlw   low  __String1_l2
	retlw   high __String1_l2
	retlw   low  __String2_l2
	retlw   high __String2_l2
	retlw   low  __String3_l2
	retlw   high __String3_l2
	retlw   low  __String4_l2
	retlw   high __String4_l2
	retlw   low  __String5_l2
	retlw   high __String5_l2

; String pointer table
__USB_SD_Ptr
__Strings
	db	low __String0, high __String0
	db	low __String1_l1, high __String1_l1
	db	low __String2_l1, high __String2_l1
	db	low __String3_l1, high __String3_l1
	db	low __String4_l1, high __String4_l1
	db	low __String5_l1, high __String5_l1

__String0
	retlw   (__String1_l1 - __String0) / 2	; Length of string 
	retlw   __DSC_STR						; Descriptor type 3
	dt   0x09, 0x04    						; Language ID (0x0409 as defined by MS)
	dt   0x04, 0x08							; Some other language ID for testing

__String1_l1
	retlw   (__String2_l1 - __String1_l1) / 2	; Length of string
	retlw   __DSC_STR		; Descriptor type 3
	dt	'M', 0, 'i', 0, 'c', 0, 'r', 0, 'o', 0, 'c', 0, 'h', 0, 'i', 0, 'p', 0
__String2_l1
	retlw   (__String3_l1 - __String2_l1) / 2
	retlw   __DSC_STR
	dt   'P', 0, 'I', 0, 'C', 0, '1', 0, '8', 0, ' ', 0
	dt   'U', 0, 'S', 0, 'B', 0, ' ', 0, 'M', 0, 'o', 0, 'u', 0, 's', 0, 'e', 0
__String3_l1
	retlw   (__String4_l1 - __String3_l1) / 2
	retlw   __DSC_STR
	dt   'V', 0, '1', 0, '.', 0, '1', 0, '0', 0, 'F', 0, 'S', 0
__String4_l1
	retlw   (__String5_l1 - __String4_l1) / 2
	retlw   __DSC_STR
	dt   'C', 0, 'f', 0, 'g', 0, '1', 0
__String5_l1
	retlw   (__String6_l1 - __String5_l1) / 2
	retlw   __DSC_STR
	dt   'E', 0, 'P', 0, '1', 0, 'I', 0, 'n', 0
__String6_l1

__String1_l2			; Language 2, Chinese. Strings can be totally different than english
	retlw   (__String2_l2 - __String1_l2) / 2	; Length of string
	retlw   __DSC_STR		; Descriptor type 3
	dt	'M', 0, 'i', 0, 'c', 0, 'r', 0, 'o', 0, 'c', 0, 'h', 0, 'i', 0, 'p', 0
__String2_l2
	retlw   (__String3_l2 - __String2_l2) / 2
	retlw   __DSC_STR
	dt   'P', 0, 'I', 0, 'C', 0, '1', 0, '8', 0, ' ', 0
	dt   'U', 0, 'S', 0, 'B', 0, ' ', 0, 'M', 0, 'o', 0, 'u', 0, 's', 0, 'e', 0
__String3_l2
	retlw   (__String4_l2 - __String3_l2) / 2
	retlw   __DSC_STR
	dt   'V', 0, '1', 0, '.', 0, '1', 0, '0', 0, 'F', 0, 'S', 0
__String4_l2
	retlw   (__String5_l2 - __String4_l2) / 2
	retlw   __DSC_STR
	dt   'C', 0, 'f', 0, 'g', 0, '1', 0
__String5_l2
	retlw   (__String6_l2 - __String5_l2) / 2
	retlw   __DSC_STR
	dt   'E', 0, 'P', 0, '1', 0, 'I', 0, 'n', 0
__String6_l2
