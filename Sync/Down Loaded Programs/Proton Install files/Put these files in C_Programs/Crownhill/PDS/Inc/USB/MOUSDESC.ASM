 NOLIST
;
; ###############################################################################
; filename:           MOUSDESC.ASM
;
; This file contains a set of descriptors for a standard mouse.  
;
; ###############################################################################
;
; Author:             Dan Butler and Reston Condit
; Company:            Microchip Technology Inc
;
; Revision:           1.21
; Date:               08 August 2001
; Assembled using     MPASM 2.61
; Revision History:
; 23 August 2000      DZB Changed descriptor pointers to 16 bits.
; 24 August 2000      DZB Moved EP1 & 2 configuration from USB@Reset
;                 to Set_Configuration to implement requirement in
;                 USB V1.1 spec paragraph 5.3.1.2
; 28 August 2000      DZB Force data toggle on OUT packets in PutUSB
; 20 March 2001       DZB Reduced use of common RAM
; 20 March 2001       DZB Put and Get use their own TEMP variable (_GP_TEMP) to
;                 avoid collisions with the ISR's use of TEMP.
; 29 March 2001       DZB Fixed saving of bank bits in GetUSB
; 02 May 2001         DZB Implemented SHOW#ENUM#STATUS to show enumeration
;                 status on the PORTB LEDs: 0- Powered, 1- Default,
;                 2- addressed, 3- configured, 4- sleep, 
;                 5- EP0 Activity, 6- EP1 Activity, 7- EP2 Activity
; 03 August 2001      RAC Made distinct GetEP and PutEP macros for endpoints 1 
;                 and 2.  These functions are GetEP1, GetEP2, PutEP1, and 
;                 PutEP2.  Instances of the these macros are created in
;                 usb_ch9.asm.
; 08 August 2001      RAC Corrected various banking and paging issues.
; 15 August           RAC Added Report_desc_index function in descript.asm.
;                 This function allows more than one report descriptor
;                 to be used.  
;
;################################################################################
;
; include files:
; P16C7x5.inc     Rev 1.00
; usb_defs.inc    Rev 1.21
;
;################################################################################

; ******************************************************************
; Given a configuration descriptor index, returns the beginning address
; of the descriptor within the descriptions table
; ******************************************************************
 LIST
Config_desc_index
    movwf   TEMP
    movlw   HIGH CDI_start
    movwf   PCLATH
    movlw   low  CDI_start
    addwf   TEMP,w
    btfsc   STATUS,C
    incf    PCLATH,f
    movwf   PCL
CDI_start           			; this table calculates the offsets for each configuration
    retlw   low  Config1       ; descriptor from the beginning
    retlw   high Config1       ; of the table, effectively
    ; more configurations can be added here
    ; retlw   low Config2
    ; retlw   high Config2
    ; etc....

; ******************************************************************
; Given a report descriptor index, returns the beginning address
; of the descriptor within the descriptions table
; ******************************************************************
Report_desc_index
    movwf   TEMP
    movlw   HIGH RDI_start
    movwf   PCLATH
    movlw   low  RDI_start
    addwf   TEMP,w
    btfsc   STATUS,C
    incf    PCLATH,f
    movwf   PCL
RDI_start       ; this table calculates the offsets for each report
    retlw   low  ReportDescriptorLen  ; descriptor from the beginning
    retlw   high ReportDescriptorLen  ; of the table, effectively
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
    banksel EP0_START
    movf    EP0_START + 1,w
    movwf   PCLATH
    movf    EP0_START,w
    movwf   PCL

DeviceDescriptor
StartDevDescr
    retlw   0x12    ; bLength    Length of this descriptor
    retlw   1       ; bDescType This is a DEVICE descriptor
    retlw   0       ; bcdUSB    USB revision 1.10 (low byte)
    retlw   1       ; high byte
    retlw   0       ; bDeviceClass    zero means each interface operates independently
    retlw   0       ; bDeviceSubClass
    retlw   0       ; bDeviceProtocol
    retlw   0x08    ; bMaxPacketSize0 - inited in UsbInit()
    retlw   0xD8    ; idVendor - 0x04D8 is Microchip Vendor ID
    retlw   0x04    ; high order byte
    retlw   0x00    ; idProduct
    retlw   0x00
    retlw   0x41    ; bcdDevice
    retlw   0x04
    retlw   1       ; iManufacturer
    retlw   2       ; iProduct
    retlw   0       ; iSerialNumber - 3
    retlw   NUM_CONFIGURATIONS    ; bNumConfigurations

; ******************************************************************
; This table is retrieved by the host after the address has been set.
; This table defines the configurations available for the device.
; See section 9.6.2 of the Rev 1.0 USB specification (page 184).
; These fields are application DEPENDENT. 
; Modify these to meet your specifications.
; ******************************************************************
Config1
    retlw   9       ; bLength    Length of this descriptor
    retlw   2       ; bDescType    2=CONFIGURATION
    retlw   EndConfig1 - Config1
    retlw   0
    retlw   1       ; bNumInterfaces    Number of interfaces
    retlw   0x01    ; bConfigValue    Configuration Value
    retlw   0x04    ; iConfig    String Index for this config = #01
    retlw   0xA0    ; bmAttributes    attributes - bus powered
    retlw   0x32    ; MaxPower    self-powered draws 0 mA from the bus.
Interface1
    retlw   9       ; length of descriptor
    retlw   INTERFACE
    retlw   0       ; number of interface, 0 based array
    retlw   0       ; alternate setting
    retlw   1       ; number of endpoints used in this interface
    retlw   3       ; interface class - assigned by the USB
    retlw   1       ; boot device
    retlw   2       ; interface protocol - mouse
    retlw   5       ; index to string descriptor that describes this interface
HID_Descriptor
    retlw   0x09    ; descriptor size (9 bytes)
    retlw   0x21    ; descriptor type (HID)
    retlw   0x00
    retlw   0x01    ; HID class release number (1.00)
    retlw   0x00    ; Localized country code (none)
    retlw   0x01    ; # of HID class descriptor to follow (1)
    retlw   0x22    ; Report descriptor type (HID)
    retlw   (endReportDescriptor - ReportDescriptor)
    retlw   0x00
Endpoint1
    retlw   7       ; length of descriptor
    retlw   ENDPOINT
    retlw   0x81    ; EP1, In
    retlw   3       ; Interrupt
    retlw   4       ; max packet size (4 bytes) low order byte
    retlw   0       ; max packet size (4 bytes) high order byte
    retlw   0x0A    ; polling interval (10ms)
EndConfig1

ReportDescriptorLen
    retlw   low     (endReportDescriptor-ReportDescriptor)

ReportDescriptor
    retlw   0x05
    retlw   0x01    ; usage page (generic desktop)
    retlw   0x09
    retlw   0x02    ; usage (mouse)
    retlw   0xA1
    retlw   0x01    ; collection (application)
    retlw   0x09
    retlw   0x01    ; usage (pointer)
    retlw   0xA1
    retlw   0x00    ; collection (linked)
    retlw   0x05
    retlw   0x09    ; usage page (buttons)
    retlw   0x19
    retlw   0x01    ; usage minimum (1)
    retlw   0x29
    retlw   0x03    ; usage maximum (3)
    retlw   0x15
    retlw   0x00    ; logical minimum (0)
    retlw   0x25
    retlw   0x01    ; logical maximum (1)
    retlw   0x95
    retlw   0x03    ; report count (3)
    retlw   0x75
    retlw   0x01    ; report size (1)
    retlw   0x81
    retlw   0x02    ; input (3 button bits)
    retlw   0x95
    retlw   0x01    ; report count (1)
    retlw   0x75
    retlw   0x05    ; report size (5)
    retlw   0x81
    retlw   0x01    ; input (constant 5 bit padding)
    retlw   0x05
    retlw   0x01    ; usage page (generic desktop)
    retlw   0x09
    retlw   0x30    ; usage (X)
    retlw   0x09
    retlw   0x31    ; usage (Y)
    retlw   0x15
    retlw   0x81    ; logical minimum (-127)
    retlw   0x25
    retlw   0x7F    ; logical maximum (127)
    retlw   0x75
    retlw   0x08    ; report size (8)
    retlw   0x95
    retlw   0x03    ; report count (2)
    retlw   0x81
    retlw   0x06    ; input (2 position bytes X & Y)
    retlw   0xC0    ; end collection
    retlw   0xC0    ; end collection
endReportDescriptor

StringDescriptions
    banksel EP0_START
    movf    EP0_START + 1,w
    movwf   PCLATH
    movf    EP0_START,w
    movwf   PCL

; ******************************************************************
; Given a configuration descriptor index, returns the beginning address
; of the descriptor within the descriptions table
; ******************************************************************
string_index        ; langid in W reg, string offset in EP0_START
    movwf   TEMP
    bcf     STATUS,C
    rlf     TEMP, f
    pagesel langid_index
    call    langid_index
    movwf   TEMP2
    incf    TEMP, f
    pagesel langid_index
    call    langid_index
    movwf   TEMP
    
    movf    TEMP, w
    movwf   PCLATH
    movf    TEMP2,w
    addwf   EP0_START + 1,w
    btfsc   STATUS,C
    incf    PCLATH, f
    movwf   PCL

langid_index
    movlw   high langids
    movwf   PCLATH
    movlw   low langids
    addwf   TEMP, w
    btfsc   STATUS,C
    incf    PCLATH,f
    movwf   PCL

langids
    retlw   low lang1
    retlw   high lang1
    retlw   low lang2      ; string indexes of different languages
    retlw   high lang2

lang1                      ; english
    retlw   low  String0    ; LangIDs
    retlw   high String0
    retlw   low  String1_l1    
    retlw   high String1_l1
    retlw   low  String2_l1
    retlw   high String2_l1
    retlw   low  String3_l1
    retlw   high String3_l1
    retlw   low  String4_l1
    retlw   high String4_l1
    retlw   low  String5_l1
    retlw   high String5_l1
    retlw   low  String6_l1
    retlw   high String6_l1

lang2
    retlw   low  String0    ; also point to LangID
    retlw   high String0
    retlw   low  String1_l2
    retlw   high String1_l2
    retlw   low  String2_l2
    retlw   high String2_l2
    retlw   low  String3_l2
    retlw   high String3_l2
    retlw   low  String4_l2
    retlw   high String4_l2
    retlw   low  String5_l2
    retlw   high String5_l2

String0
    retlw   low (String1_l1 - String0)    ; length of string 
    retlw   0x03    ; descriptor type 3?
    retlw   0x09    ; language ID (as defined by MS 0x0409)
    retlw   0x04
    retlw   0x04    ; some other language ID for testing
    retlw   0x08
String0_end
String1_l1
    retlw   String2_l1-String1_l1    ; length of string
    retlw   0x03    ; string descriptor type 3
    retlw   'M'
    retlw   0x00
    retlw   'i'
    retlw   0x00
    retlw   'c'
    retlw   0x00
    retlw   'r'
    retlw   0x00
    retlw   'o'
    retlw   0x00
    retlw   'c'
    retlw   0x00
    retlw   'h'
    retlw   0x00
    retlw   'i'
    retlw   0x00
    retlw   'p'
    retlw   0x00
String2_l1
    retlw   String3_l1-String2_l1
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
    retlw   0x00
    retlw   'U'
    retlw   0x00
    retlw   'S'
    retlw   0x00
    retlw   'B'
    retlw   0x00
    retlw   ' '
    retlw   0x00
    retlw   'M'
    retlw   0x00
    retlw   'o'
    retlw   0x00
    retlw   'u'
    retlw   0x00
    retlw   's'
    retlw   0x00
    retlw   'e'
    retlw   0x00
String3_l1
    retlw   String4_l1-String3_l1
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
String4_l1
    retlw   String5_l1-String4_l1
    retlw   0x03
    retlw   'C'
    retlw   0x00
    retlw   'f'
    retlw   0x00
    retlw    'g'
    retlw   0x00
    retlw    '1'
    retlw   0x00
String5_l1
    retlw   String6_l1-String5_l1
    retlw   0x03
    retlw   'E'
    retlw   0x00
    retlw   'P'
    retlw   0x00
    retlw   '1'
    retlw   0x00
    retlw   '0'
    retlw   0x00
    retlw   'I'
    retlw   0x00
    retlw   'n'
    retlw   0x00
String6_l1

String1_l2          ; lang 2, chinese. String can be totally different than english
    retlw   String2_l2-String1_l2    ; length of string
    retlw   0x03    ; string descriptor type 3
    retlw   'M'
    retlw   0x00
    retlw   'i'
    retlw   0x00
    retlw   'c'
    retlw   0x00
    retlw   'r'
    retlw   0x00
    retlw   'o'
    retlw   0x00
    retlw   'c'
    retlw   0x00
    retlw   'h'
    retlw   0x00
    retlw   'i'
    retlw   0x00
    retlw   'p'
    retlw   0x00
String2_l2
    retlw   String3_l2-String2_l2
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
    retlw   0x00
    retlw   'U'
    retlw   0x00
    retlw   'S'
    retlw   0x00
    retlw   'B'
    retlw   0x00
    retlw   ' '
    retlw   0x00
    retlw   'M'
    retlw   0x00
    retlw   'o'
    retlw   0x00
    retlw   'u'
    retlw   0x00
    retlw   's'
    retlw   0x00
    retlw   'e'
    retlw   0x00
String3_l2
    retlw   String4_l2-String3_l2
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
String4_l2
    retlw   String5_l2-String4_l2
    retlw   0x03
    retlw   'C'
    retlw   0x00
    retlw   'f'
    retlw   0x00
    retlw   'g'
    retlw   0x00
    retlw   '1'
    retlw   0x00
String5_l2
    retlw   String6_l2-String5_l2
    retlw   0x03
    retlw   'E'
    retlw   0x00
    retlw   'P'
    retlw   0x00
    retlw   '1'
    retlw   0x00
    retlw   '0'
    retlw   0x00
    retlw   'I'
    retlw   0x00
    retlw   'n'
    retlw   0x00
String6_l2

