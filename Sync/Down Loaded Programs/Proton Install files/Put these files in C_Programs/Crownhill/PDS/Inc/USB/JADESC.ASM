 NOLIST
;
; ###############################################################################
;	filename:		JADESC.ASM
;				USB Descriptors and other user modified code
;
; Implements the descriptor lookup tables for Jan Axelson's USB Demo.  
;
; ###############################################################################
;
;   Author:             Dan Butler and Reston Condit
;    	Company:		Microchip Technology Inc
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
;   20 March 2001       DZB Put and Get use their own _USB_TEMP variable (_GP_TEMP) to
;                           avoid collisions with the ISR's use of _USB_TEMP.
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
;   15 August           RAC Added Report@desc_index function in descript.asm.
;                           This function allows more than one report descriptor
;                           to be used.  
;
;################################################################################
;
;	include files:
;		P16C7x5.inc	Rev 1.00
;		usb_defs.inc	Rev 1.21
;
;################################################################################

; ******************************************************************
; Given a configuration descriptor index, returns the beginning address
; of the descriptor within the descriptions table
; ******************************************************************
 LIST
Config@desc_index
	movwf	_USB_TEMP
	movlw	HIGH CDI@start
	movwf	PCLATH
	movlw	low  CDI@start
	addwf	_USB_TEMP,w
	btfsc	STATUS,C
	incf	PCLATH,f
	movwf	PCL
CDI@start	; this table calculates the offsets for each configuration
	retlw	low  Config@1		; descriptor from the beginning
	retlw	high Config@1		; of the table, effectively
	; more configurations can be added here
	; retlw	low Config2
	; retlw high Config2
	; etc....

; ******************************************************************
; Given a report descriptor index, returns the beginning address
; of the descriptor within the descriptions table
; ******************************************************************
Report@desc_index
	movwf   _USB_TEMP
	movlw   HIGH RDI@start
	movwf   PCLATH
	movlw   low  RDI@start
	addwf   _USB_TEMP,w
	btfsc   STATUS,C
	incf    PCLATH,f
	movwf   PCL
RDI@start       ; this table calculates the offsets for each report
	retlw   low  Report@Descriptor@Len  ; descriptor from the beginning
	retlw   high Report@Descriptor@Len  ; of the table, effectively
	; more reports can be added here
	; retlw   low  ReportDescriptorLen2
	; retlw   high ReportDescriptorLen2
	; etc....

; ******************************************************************
; This table is polled by the host immediately after USB Reset has been released.
; This table defines the maximum packet size EP0 can take.
; See section 9.6.1 of the Rev 1.0 USB specification.
; These fields are application DEPENDENT. Modify these to meet
; your specifications.
; the offset is passed in P0 and P1 (P0 is low order byte).
; ******************************************************************
Descriptions
	banksel	_EP0_START
	movf	_EP0_START + 1,w
	movwf	PCLATH
	movf	_EP0_START,w
	movwf	PCL

Device@Descriptor
Start@DevDescr
	retlw	0x12 ;.18	; bLength	Length of this descriptor
	retlw	1		; bDescType 	This is a DEVICE descriptor
	retlw	0		; bcdUSB	USB revision 1.10 (low byte)
	retlw	1		; high byte
	retlw	0		; bDeviceClass	zero means each interface operates independently
	retlw	0		; bDeviceSubClass
	retlw	0		; bDeviceProtocol
	retlw	0x08		; bMaxPacketSize0 - inited in UsbInit()
	retlw	0x25		; idVendor	0x0925 is LakeView Research ID
	retlw	0x09		; high order byte
	retlw	0x34		; idProduct
	retlw	0x12
	retlw	0x0		; bcdDevice
	retlw	0x1
	retlw	0x01		; iManufacturer
	retlw	0x02		; iProduct
	; somehow, changing iSerialNumber will cause windows to display
	; "New Hardware found" dialog. The device will function normally,
	; however, USBCheck will NOT start. From CATC we can see that
	; the string is correctly transmitted.
	retlw	0x0		; iSerialNumber - 3
	retlw	NUM#CONFIGURATIONS ; bNumConfigurations

; ******************************************************************
; This table is retrieved by the host after the address has been set.
; This table defines the configurations available for the device.
; See section 9.6.2 of the Rev 1.0 USB specification (page 184).
; These fields are application DEPENDENT. 
; Modify these to meet your specifications.
; ******************************************************************
Config@1
	retlw	9		; bLength	Length of this descriptor
	retlw	2		; bDescType	2=CONFIGURATION

	retlw	EndConfig@1 - Config@1
	retlw	0
	retlw	1		; bNumInterfaces	Number of interfaces

	retlw	0x01		; bConfigValue	Configuration Value
	retlw	0;0x04		; iConfig	String Index for this config = #01
	retlw	0x80		; bmAttributes	attributes - bus powered
	retlw	0x0D		; MaxPower	26 mA from the bus.
Interface@1
	retlw	9		; length of descriptor
	retlw	INTERFACE
	retlw	0		; number of interface, 0 based array
	retlw	0		; alternate setting
	retlw	1		; number of endpoints used in this interface
	retlw	3		; interface class - assigned by the USB
	retlw	0		; boot device
	retlw	0		; interface protocol - mouse
	retlw 	0		; index to string descriptor that describes this interface
HID@Descriptor
        retlw	09h		; descriptor size (9 bytes)
        retlw	21h		; descriptor type (HID)
        retlw	00h
	retlw	01h		; HID class release number (1.00)
        retlw	00h		; Localized country code (none)
        retlw	01h		; # of HID class descriptor to follow (1)
        retlw	22h		; Report descriptor type (HID)
        retlw	(end@ReportDescriptor - Report@Descriptor)
        retlw	00h
Endpoint@1
	retlw	7		; length of descriptor
	retlw	ENDPOINT
	retlw	0x81		; EP1, In
	retlw	3		; Interrupt
	retlw	4		; max packet size (4 bytes) low order byte
	retlw	0		; max packet size (4 bytes) high order byte
	retlw	0x0a		; polling interval (10ms)
EndConfig@1

Report@Descriptor@Len
	retlw	low  (end@ReportDescriptor-Report@Descriptor)

Report@Descriptor
        retlw	0x06		; usage page (Vendor Defined)
	retlw	0xA0
        retlw	0xFF
	retlw	0x09		; usage (Vendor Defined)
        retlw	0x01
	retlw	0xA1		; collection (application)
        retlw	0x01
	retlw	0x09		; usage (Vendor Defined)
        retlw	0x02
	retlw	0xA1		; collection (linked)
        retlw	0x00
	retlw	0x06		; usage page (buttons)
        retlw	0xa1
	retlw	0xFF
	retlw	0x09		; usage vendor defined
        retlw	0x03
	retlw	0x09		; usage vendor defined
        retlw	0x04
	retlw	0x15		; logical minimum (-128)
        retlw	0x80
	retlw	0x25		; logical maximum (127)
        retlw	0x7F
	retlw	0x35		; Physical Minimum (0)
        retlw	0x00
	retlw	0x45		; Physical Maximum (255)
        retlw	0xFF
;	retlw	0x66		; Unit (None (2 bytes))
;       retlw	0x00
;	retlw	0x00
        retlw	0x75		; report size (8) (bits)
	retlw	0x08
        retlw	0x95		; report count (2) (fields)
	retlw	0x02
        retlw	0x81		; input (Data, Variable, Absolute)
	retlw	0x02

        retlw	0x09		; usage (Vendor Defined)
	retlw	0x05
        retlw	0x09		; useage (Vendor Defined)
	retlw	0x06
	retlw	0x15		; logical minimum (-128)
	retlw	0x80
        retlw	0x25		; logical maximum (127)
	retlw	0x7F
        retlw	0x35		; Physical Minimum (0)
	retlw	0x00
        retlw	0x45		; Physical Maximum (255)
	retlw	0xFF
;	retlw	0x66		; Unit (None (2 bytes))
;       retlw	0x00
;	retlw	0x00
        retlw	0x75		; report size (8) (bits)
	retlw	0x08
        retlw	0x95		; report Count (2) (fields)
	retlw	0x02
        retlw	0x91		; Output (Data, Variable, Absolute)
	retlw	0x02
        retlw	0xC0		; end collection, end collection
	retlw	0xC0

end@ReportDescriptor


String@Descriptions
	banksel _EP0_START
	movf    _EP0_START + 1,w
	movwf   PCLATH
	movf    _EP0_START,w
	movwf   PCL

; ******************************************************************
; Given a configuration descriptor index, returns the beginning address
; of the descriptor within the descriptions table
; ******************************************************************
string@index			; langid in W reg, string offset in _EP0_START
	movwf	_USB_TEMP
	bcf	STATUS,C
	rlf	_USB_TEMP, f
	pagesel	langid@index
	call	langid@index
	movwf	_USB_TEMP2
	incf	_USB_TEMP, f
	pagesel	langid@index
	call	langid@index
	movwf	_USB_TEMP
	
	movf	_USB_TEMP, w
	movwf	PCLATH
	movf	_USB_TEMP2,w
	addwf	_EP0_START + 1,w
	btfsc	STATUS,C
	incf	PCLATH, f
	movwf	PCL

langid@index
	movlw	high langid@s
	movwf	PCLATH
	movlw	low langid@s
	addwf	_USB_TEMP, w
	btfsc	STATUS,C
	incf	PCLATH,f
	movwf	PCL

langid@s
	retlw	low lang@1
	retlw	high lang@1
	retlw	low lang@2	; string indexes of different languages
	retlw	high lang@2

lang@1				; english
	retlw	low  String@0	; LangIDs
	retlw	high String@0
	retlw	low  String1@l1	
	retlw	high String1@l1
	retlw	low  String2@l1
	retlw	high String2@l1
	retlw	low  String3@l1
	retlw	high String3@l1
	retlw	low  String4@l1
	retlw	high String4@l1
	retlw	low  String5@l1
	retlw	high String5@l1
	retlw   low  String6@l1
	retlw   high String6@l1

lang@2
	retlw	low  String@0	; also point to LangID
	retlw	high String@0
	retlw	low  String1@l2
	retlw	high String1@l2
	retlw	low  String2@l2
	retlw	high String2@l2
	retlw	low  String3@l2
	retlw	high String3@l2
	retlw	low  String4@l2
	retlw	high String4@l2
	retlw	low  String5@l2
	retlw	high String5@l2

String@0
	retlw	low (String1@l1 - String@0) ; length of string 
	retlw	0x03		; descriptor type 3?
	retlw	0x09		; language ID (as defined by MS 0x0409)
	retlw	0x04
	retlw	0x04		; some other language ID for testing
	retlw	0x08
String0@end
String1@l1
	retlw	String2@l1-String1@l1 ; length of string
	retlw	0x03		; string descriptor type 3
	retlw	'M'
	retlw	0x00
	retlw	'i'
	retlw	0x00
	retlw	'c'
	retlw	0x00
	retlw	'r'
	retlw	0x00
	retlw	'o'
	retlw	0x00
	retlw	'c'
	retlw	0x00
	retlw	'h'
	retlw	0x00
	retlw	'i'
	retlw	0x00
	retlw	'p'
	retlw	0x00
String2@l1
	retlw	String3@l1-String2@l1
	retlw	0x03
	retlw	'P'
	retlw	0x00
	retlw	'i'
	retlw	0x00
	retlw	'c'
	retlw	0x00
	retlw	'1'
	retlw	0x00
	retlw	'6'
	retlw	0x00
	retlw	'C'
	retlw	0x00
	retlw	'7'
	retlw	0x00
	retlw   '4'
	retlw   0x00
	retlw   '5'
	retlw   0x00
	retlw   '/'
	retlw   0x00
	retlw   '7'
	retlw   0x00
	retlw	'6'
	retlw	0x00
	retlw	'5'
	retlw	0x00
	retlw 	' '
	retlw	0x00
	retlw	'U'
	retlw	0x00
	retlw	'S'
	retlw	0x00
	retlw	'B'
	retlw	0x00
	retlw	' '
	retlw	0x00
	retlw	'M'
	retlw	0x00
	retlw	'o'
	retlw	0x00
	retlw	'u'
	retlw	0x00
	retlw	's'
	retlw	0x00
	retlw	'e'
	retlw	0x00
String3@l1
	retlw	String4@l1-String3@l1
	retlw	0x03
	retlw	'V'
	retlw	0x00
	retlw	'1'
	retlw	0x00
	retlw	'.'
	retlw	0x00
	retlw	'1'
	retlw	0x00
	retlw	'1'
	retlw	0x00
String4@l1
	retlw	String5@l1-String4@l1
	retlw	0x03
	retlw	'C'
	retlw	0x00
	retlw	'f'
	retlw	0x00
	retlw 	'g'
	retlw	0x00
	retlw 	'1'
	retlw	0x00
String5@l1
	retlw	String6@l1-String5@l1
	retlw	0x03
	retlw	'E'
	retlw	0x00
	retlw	'P'
	retlw	0x00
	retlw	'1'
	retlw	0x00
	retlw	'0'
	retlw	0x00
	retlw	'I'
	retlw	0x00
	retlw	'n'
	retlw	0x00
String6@l1

String1@l2				; lang 2, chinese. String can be totally different than english
	retlw	String2@l2-String1@l2	; length of string
	retlw	0x03			; string descriptor type 3
	retlw	'M'
	retlw	0x00
	retlw	'i'
	retlw	0x00
	retlw	'c'
	retlw	0x00
	retlw	'r'
	retlw	0x00
	retlw	'o'
	retlw	0x00
	retlw	'c'
	retlw	0x00
	retlw	'h'
	retlw	0x00
	retlw	'i'
	retlw	0x00
	retlw	'p'
	retlw	0x00
String2@l2
	retlw	String3@l2-String2@l2
	retlw   0x03
	retlw   'P'
	retlw   0x00
	retlw   'i'
	retlw   0x00
	retlw   'c'
	retlw   0x00
	retlw   '1'
	retlw   0x00
	retlw   '6'
	retlw   0x00
	retlw   'C'
	retlw   0x00
	retlw   '7'
	retlw   0x00
	retlw   '4'
	retlw   0x00
	retlw   '5'
	retlw   0x00
	retlw   '/'
	retlw   0x00
	retlw   '7'
	retlw   0x00
	retlw   '6'
	retlw   0x00
	retlw   '5'
	retlw   0x00
	retlw   ' '
	retlw	0x00
	retlw	'U'
	retlw	0x00
	retlw	'S'
	retlw	0x00
	retlw	'B'
	retlw	0x00
	retlw	' '
	retlw	0x00
	retlw	'D'
	retlw	0x00
	retlw	'e'
	retlw	0x00
	retlw	'm'
	retlw	0x00
	retlw	'o'
	retlw	0x00
String3@l2
	retlw	String4@l2-String3@l2
	retlw   0x03
	retlw   'V'
	retlw   0x00
	retlw   '1'
	retlw   0x00
	retlw   '.'
	retlw   0x00
	retlw   '1'
	retlw   0x00
	retlw   '1'
	retlw   0x00
String4@l2
	retlw	String5@l2-String4@l2
	retlw	0x03
	retlw	'C'
	retlw	0x00
	retlw	'f'
	retlw	0x00
	retlw 	'g'
	retlw	0x00
	retlw 	'1'
	retlw	0x00
String5@l2
	retlw	String6@l2-String5@l2
	retlw	0x03
	retlw	'E'
	retlw	0x00
	retlw	'P'
	retlw	0x00
	retlw	'1'
	retlw	0x00
	retlw	'0'
	retlw	0x00
	retlw	'I'
	retlw	0x00
	retlw	'n'
	retlw	0x00
String6@l2

