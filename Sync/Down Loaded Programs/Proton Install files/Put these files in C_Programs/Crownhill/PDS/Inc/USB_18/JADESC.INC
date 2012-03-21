 LIST
;
; This file contains a set of descriptors for Jan Axelson's USB Demo.
;
#define	__EP0_BUFF_SIZE			8				; 8, 16, 32, or 64
#define	__MAX_NUM_INT			1				; For tracking Alternate Setting
#define	__MAX_EP_NUMBER			1				; UEP1
#define	__NUM_CONFIGURATIONS	1
#define	__NUM_INTERFACES		1

#define	__MODE_PP			_PPBM0
#define	__UCFG_VAL			_PUEN | _TRINT | _FS | __MODE_PP	; Full-speed

#define __USB_USE_HID							; Inform the rest of the library subroutines that we're using a HID interface

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
; The table defines the maximum packet size EP0 can take.
; See section 9.6.1 of the Rev 1.0 USB specification.
; These fields are application dependent to be modified to meet your specifications.
;
__DeviceDescriptor
	retlw	(__EndDeviceDescriptor - __DeviceDescriptor) / 2	; bLength Length of this descriptor
	retlw	__DSC_DEV							; bDescType This is a DEVICE descriptor
	dt		0x10, 0x01							; bcdUSB Revision 1.10 low byte, high byte
	retlw	0x00								; bDeviceClass zero means each interface operates independently
	retlw	0x00								; bDeviceSubClass
	retlw	0x00								; bDeviceProtocol
	retlw	__EP0_BUFF_SIZE						; bMaxPacketSize for EP0
	dt		0x25, 0x09							; idVendor 0x0925 is LakeView Research ID low byte, high byte
	dt		0x34, 0x12							; idProduct low byte, high byte
	dt		0x01, 0x00							; bcdDevice low byte, high byte
	retlw	0x01								; iManufacturer
	retlw	0x02								; iProduct
	retlw	0x03								; iSerialNumber
	retlw	__NUM_CONFIGURATIONS 				; bNumConfigurations
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
	retlw	(__Interface1-___Config1) / 2	; bLength Length of this descriptor
	retlw	__DSC_CFG						; bDescType 2 = CONFIGURATION
__Config1Len
	retlw	low ((__EndConfig1 - ___Config1) / 2)	; Length of this configuration
	retlw	high ((__EndConfig1 - ___Config1) / 2)
	retlw	0x01							; bNumInterfaces Number of interfaces
	retlw	0x01							; bConfigValue Configuration Value
	retlw	0x04							; iConfig String Index for this config = #01
	retlw	0xA0							; bmAttributes attributes - bus powered
	retlw	0x50							; Max power consumption (2X mA)
__Interface1
	retlw	(__HIDDescriptor1 - __Interface1) / 2	; length of descriptor
	retlw	__DSC_INTF
	retlw	0x00							; number of interface, 0 based array
	retlw	0x00							; alternate setting
	retlw	0x02							; number of endpoints used in this interface
	retlw	0x03							; interface CLASS - assigned by the USB
	retlw	0x00							; boot device
	retlw	0x00							; interface protocol - mouse
	retlw 	0x00							; index to string descriptor that describes this interface
__HIDDescriptor1
	retlw	(__Endpoint1In - __HIDDescriptor1) / 2	; descriptor size (9 bytes)
  	retlw	0x21							; descriptor type (HID)
	dt		0x00, 0x00						; HID CLASS release number (1.00) low byte, high byte
   	retlw	0x00							; Localised country code (none)
 	retlw	0x01							; Number of HID CLASS descriptor to follow (1)
 	retlw	0x22							; Report descriptor type (HID)
__ReportDescriptor1Len
	retlw	low ((__EndReportDescriptor1 - __ReportDescriptor1) / 2)
	retlw	high ((__EndReportDescriptor1 - __ReportDescriptor1) / 2)
__Endpoint1In
	retlw	(__EndPoint1Out - __Endpoint1In) / 2	; length of descriptor
	retlw	__DSC_EP
	retlw	0x81							; EP1, IN
	retlw	0x03							; Interrupt
	dt		0x08, 0x00						; This should be the size of the endpoint buffer low byte, high byte
	retlw	0x0A							; Polling interval (10ms)
__EndPoint1Out
	retlw	(__EndConfig1 - __EndPoint1Out) / 2	; Length of this Endpoint Descriptor
	retlw	__DSC_EP						; bDescriptorType = 5 for Endpoint Descriptor
	retlw	0x01							; Endpoint number & direction
	retlw	0x03							; Transfer type supported by this Endpoint
	dt		0x08, 0x00						; This should be the size of the endpoint buffer low byte, high byte
	retlw	0x0A							; Polling interval (10ms)
__EndConfig1

__ReportDescriptor1
    retlw	0x06							; usage page (VENDOR Defined)
	retlw	0xA0
    retlw	0xFF
	retlw	0x09							; usage (VENDOR Defined)
    retlw	0x01
	retlw	0xA1							; collection (application)
    retlw	0x01
	retlw	0x09							; usage (VENDOR Defined)
    retlw	0x02
	retlw	0xA1							; collection (linked)
    retlw	0x00
	retlw	0x06							; usage page (buttons)
    retlw	0xA1
	retlw	0xFF
	retlw	0x09							; usage VENDOR defined
    retlw	0x03
	retlw	0x09							; usage VENDOR defined
    retlw	0x04
	retlw	0x15							; logical minimum (-128)
    retlw	0x80
	retlw	0x25							; logical maximum (127)
    retlw	0x7F
	retlw	0x35							; Physical Minimum (0)
    retlw	0x00
	retlw	0x45							; Physical Maximum (255)
    retlw	0xFF
    retlw	0x75							; report size (8) (bits)
	retlw	0x08
    retlw	0x95							; report count (2) (fields)
	retlw	0x02
    retlw	0x81							; input (Data, Variable, Absolute)
	retlw	0x02
    retlw	0x09							; usage (VENDOR Defined)
	retlw	0x05
    retlw	0x09							; useage (VENDOR Defined)
	retlw	0x06
	retlw	0x15							; logical minimum (-128)
	retlw	0x80
    retlw	0x25							; logical maximum (127)
	retlw	0x7F						
    retlw	0x35							; Physical Minimum (0)
	retlw	0x00						
    retlw	0x45							; Physical Maximum (255)
	retlw	0xFF							
    retlw	0x75							; report size (8) (bits)
	retlw	0x08							
    retlw	0x95							; report Count (2) (fields)
	retlw	0x02
    retlw	0x91							; Output (Data, Variable, Absolute)
	retlw	0x02
	retlw   0xC0							; end collection
	retlw   0xC0							; end collection
__EndReportDescriptor1

; String pointer table
__USB_SD_Ptr
__Strings
	db	low __String0, high __String0
	db	low __String1, high __String1
	db	low __String2, high __String2
	db	low __String3, high __String3
	db	low __String4, high __String4

__String0
	retlw	(__String1 - __String0) / 2		; Length of string 
	retlw	__DSC_STR						; Descriptor type 3
	dt   0x09, 0x04    						; Language ID (0x0409 as defined by MS)
__String1
	retlw	(__String2 - __String1) / 2
	retlw	__DSC_STR
	dt	'M', 0, 'i', 0, 'c', 0, 'r', 0, 'o', 0, 'c', 0, 'h', 0, 'i', 0, 'p', 0
__String2
	retlw	(__String3 - __String2) / 2
	retlw	__DSC_STR
	dt   'P', 0, 'I', 0, 'C', 0, '1', 0, '8', 0, ' ', 0
	dt   'J', 0, 'A', 0, ' ', 0, 'D', 0, 'e', 0, 'm', 0, 'o', 0
__String3
	retlw	(__String4 - __String3) / 2
	retlw	__DSC_STR
	dt	'V', 0, '1', 0, '.', 0, '1', 0, 'F', 0, 'S', 0
__String4
	retlw	(__String5 - __String4) / 2
	retlw	__DSC_STR
	dt	'C', 0, 'f', 0, 'g', 0, '1', 0
__String5
