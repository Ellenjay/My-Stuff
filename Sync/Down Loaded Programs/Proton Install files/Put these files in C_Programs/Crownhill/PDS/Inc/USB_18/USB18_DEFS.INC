 LIST
;
; Microchip USB CLASS ID
;
; Used to identify which of the USB classes owns the current session of control transfer over EP0
#define	__MUID_NULL		0
#define	__MUID_USB9		1
#define	__MUID_HID		2
#define	__MUID_CDC		3
#define	__MUID_MSD		4

; Buffer Descriptor Status Register Initialisation Parameters
#define	_BSTALL			0x04	; Buffer Stall enable
#define	_DTSEN			0x08	; Data Toggle Synch enable
#define	_INCDIS			0x10	; Address increment disable
#define	_KEN			0x20	; SIE keeps the buff descriptors enabled
#define	_DAT0			0x00	; DATA0 packet expected next
#define	_DAT1			0x40	; DATA1 packet expected next
#define	_DTSMASK		0x40	; __DTS Mask
#define	_USIE			0x80	; SIE owns the buffer
#define	_UCPU			0x00	; CPU owns the buffer

; USB Device States - To be used with byte __USB_DEVICE_STATE or PP0
#define	__DETACHED_STATE		0
#define	__ATTACHED_STATE		1
#define	__POWERED_STATE			2
#define	__DEFAULT_STATE			3
#define	__ADR_PENDING_STATE		4
#define	__ADDRESS_STATE			5
#define	__CONFIGURED_STATE		6

; Descriptor Types
#define __DSC_DEV     	0x01
#define __DSC_CFG     	0x02
#define __DSC_STR     	0x03
#define __DSC_INTF    	0x04
#define __DSC_EP      	0x05

; USB Endpoint Definitions
#define _EP01_OUT   	0x01
#define _EP01_IN   	 	0x81
#define _EP02_OUT   	0x02
#define _EP02_IN    	0x82
#define _EP03_OUT   	0x03
#define _EP03_IN    	0x83
#define _EP04_OUT   	0x04
#define _EP04_IN    	0x84
#define _EP05_OUT   	0x05
#define _EP05_IN    	0x85
#define _EP06_OUT   	0x06
#define _EP06_IN    	0x86
#define _EP07_OUT   	0x07
#define _EP07_IN    	0x87
#define _EP08_OUT   	0x08
#define _EP08_IN    	0x88
#define _EP09_OUT   	0x09
#define _EP09_IN    	0x89
#define _EP10_OUT   	0x0A
#define _EP10_IN    	0x8A
#define _EP11_OUT   	0x0B
#define _EP11_IN    	0x8B
#define _EP12_OUT   	0x0C
#define _EP12_IN    	0x8C
#define _EP13_OUT   	0x0D
#define _EP13_IN    	0x8D
#define _EP14_OUT   	0x0E
#define _EP14_IN    	0x8E
#define _EP15_OUT   	0x0F
#define _EP15_IN   	 	0x8F

; Standard Request Codes (USB 2.0 Spec Ref Table 9-4)
#define	__GET_STATUS			0
#define	__CLR_FEATURE			1
#define	__SET_FEATURE			3
#define	__SET_ADR				5
#define	__GET_DSC				6
#define	__SET_DSC				7
#define	__GET_CFG				8
#define	__SET_CFG				9
#define	__GET_INTF				10
#define	__SET_INTF				11
#define	__SYNCH_FRAME			12

; Standard Feature Selectors
#define	__DEVICE_REMOTE_WAKEUP	0x01
#define	__ENDPOINT_HALT			0x00

; Class-Specific Requests
#define	__GET_REPORT			0x01
#define	__GET_IDLE				0x02
#define	__GET_PROTOCOL			0x03
#define	__SET_REPORT			0x09
#define	__SET_IDLE				0x0A
#define	__SET_PROTOCOL			0x0B

; Class Descriptor Types
#define	__DSC_HID				0x21
#define	__DSC_RPT				0x22
#define	__DSC_PHY				0x23

; Protocol Selection
#define	__BOOT_PROTOCOL			0x00
#define	__RPT_PROTOCOL			0x01

; HID Interface Class Code
#define	__HID_INTF				0x03

; HID Interface Class SubClass Codes
#define	__BOOT_INTF_SUBCLASS	0x01

; HID Interface Class Protocol Codes
#define	__HID_PROTOCOL_NONE		0x00
#define	__HID_PROTOCOL_KEYBOAD	0x01
#define	__HID_PROTOCOL_MOUSE	0x02

; HID Report codes used in GET_REPORT and SET_REPORT requests
#define	__HID_INPUT_REPORT		1
#define	__HID_OUTPUT_REPORT		2
#define	__HID_FEATURE_REPORT	3

; Class-Specific Requests
#define	__SEND_ENCAPSULATED_COMMAND 0x00
#define	__GET_ENCAPSULATED_RESPONSE 0x01
#define	__SET_COMM_FEATURE		0x02
#define	__GET_COMM_FEATURE		0x03
#define	__CLEAR_COMM_FEATURE	0x04
#define	__SET_LINE_CODING		0x20
#define	__GET_LINE_CODING		0x21
#define	__SET_CONTROL_LINE_STATE	0x22
#define	__SEND_BREAK			0x23

; Notifications
; Note: Notifications are polled over Communication Interface (Interrupt Endpoint)
#define	__NETWORK_CONNECTION	0x00
#define	__RESPONSE_AVAILABLE	0x01
#define	__SERIAL_STATE			0x20

; Device Class Code
#define	__CDC_DEVICE			0x02

; Communication Interface Class Code
#define	__COMM_INTF				0x02

; Communication Interface Class SubClass Codes
#define	__ABSTRACT_CONTROL_MODEL	0x02

; Communication Interface Class Control Protocol Codes
#define	__V25TER				0x01	; Common AT commands ("Hayes(TM)")

; Data Interface Class Codes
#define	__DATA_INTF				0x0A

; Data Interface Class Protocol Codes
#define	__NO_PROTOCOL			0x00	; No Class specific protocol required

; Communication Feature Selector Codes
#define	__ABSTRACT_STATE		0x01
#define	__COUNTRY_SETTING		0x02

; Functional Descriptors
; Type Values for the bDscType Field
#define	__CS_INTERFACE			0x24
#define	__CS_ENDPOINT			0x25

; bDscSubType in Functional Descriptors
#define	__DSC_FN_HEADER			0
#define	__DSC_FN_CALL_MGT		1
#define	__DSC_FN_ACM			2	; ACM - Abstract Control Management
#define	__DSC_FN_DLM			3	; DLM - Direct Line Managment
#define	__DSC_FN_TELEPHONE_RINGER	4
#define	__DSC_FN_RPT_CAPABILITIES	5
#define	__DSC_FN_UNION			6
#define	__DSC_FN_COUNTRY_SELECTION 7
#define	__DSC_FN_TEL_OP_MODES	8
#define	__DSC_FN_USB_TERMINAL	9
; more.... see Table 25 in USB CDC Specification 1.1

; CDC Bulk in transfer states
#define	__CDC_TX_READY			0
#define	__CDC_TX_BUSY			1
#define	__CDC_TX_BUSY_ZLP		2	; ZLP (Zero Length Packet)
#define	__CDC_TX_COMPLETING		3

#define	__LINE_CODING_LENGTH	7
#define __DUMMY_LENGTH			8

; Control Transfer States
#define	__WAIT_SETUP		0
#define	__CTRL_TRF_TX		1
#define	__CTRL_TRF_RX		2

; USB __PID: Token Types - See chapter 8 in the USB specification
#define	__SETUP_TOKEN	0x0D
#define	__OUT_TOKEN		0x01
#define	__IN_TOKEN		0x09

; bmRequestType Definitions
#define	__HOST_TO_DEV		0
#define	__DEV_TO_HOST		1

#define	__STANDARD		0
#define	__CLASS			1
#define	__VENDOR		2

#define	__RCPT_DEV		0
#define	__RCPT_INTF		1
#define	__RCPT_EP		2
#define	__RCPT_OTH		3

; UCFG Initialisation Parameters
#define	_PPBM0			0x00	; Ping-Pong Buffer Mode 0
#define	_PPBM1			0x01	; Ping-Pong Buffer Mode 1
#define	_PPBM2			0x02	; Ping-Pong Buffer Mode 2
#define	_LS				0x00	; Use Low-Speed USB Mode
#define	_FS				0x04	; Use Full-Speed USB Mode
#define	_TRINT			0x00	; Use the internal transceiver
#define	_TREXT			0x08	; Use an external transceiver
#define	_PUEN			0x10	; Use the internal pull-up resistor
#define	_OEMON			0x40	; Use the SIE output indicator
#define	_UTEYE			0x80	; Use the Eye-Pattern test

; UEPn Initialisation Parameters
#define	__EP_CTRL		0x06	; Configure the Control pipe for this ep
#define	__EP_OUT		0x0C	; Configure the OUT only pipe for this ep
#define	__EP_IN			0x0A	; Configure the IN only pipe for this ep
#define	__EP_OUT_IN		0x0E	; Configure both OUT & IN pipes for this ep
#define	__HSHK_EN		0x10	; Enable the handshake packet

#define	__OUT		0
#define	__IN		1

#define	__PIC_EP_NUM_MASK	0b01111000
#define	__PIC_EP_DIR_MASK	0b00000100

#define	__EP00_OUT		(0x00 << 3) | (__OUT << 2)
#define	__EP00_IN		(0x00 << 3) | (__IN << 2)
#define	__EP01_OUT		(0x01 << 3) | (__OUT << 2)
#define	__EP01_IN		(0x01 << 3) | (__IN << 2)
#define	__EP02_OUT		(0x02 << 3) | (__OUT << 2)
#define	__EP02_IN		(0x02 << 3) | (__IN << 2)
#define	__EP03_OUT		(0x03 << 3) | (__OUT << 2)
#define	__EP03_IN		(0x03 << 3) | (__IN << 2)
#define	__EP04_OUT		(0x04 << 3) | (__OUT << 2)
#define	__EP04_IN		(0x04 << 3) | (__IN << 2)
#define	__EP05_OUT		(0x05 << 3) | (__OUT << 2)
#define	__EP05_IN		(0x05 << 3) | (__IN << 2)
#define	__EP06_OUT		(0x06 << 3) | (__OUT << 2)
#define	__EP06_IN		(0x06 << 3) | (__IN << 2)
#define	__EP07_OUT		(0x07 << 3) | (__OUT << 2)
#define	__EP07_IN		(0x07 << 3) | (__IN << 2)
#define	__EP08_OUT		(0x08 << 3) | (__OUT << 2)
#define	__EP08_IN		(0x08 << 3) | (__IN << 2)
#define	__EP09_OUT		(0x09 << 3) | (__OUT << 2)
#define	__EP09_IN		(0x09 << 3) | (__IN << 2)
#define	__EP10_OUT		(0x0A << 3) | (__OUT << 2)
#define	__EP10_IN		(0x0A << 3) | (__IN << 2)
#define	__EP11_OUT		(0x0B << 3) | (__OUT << 2)
#define	__EP11_IN		(0x0B << 3) | (__IN << 2)
#define	__EP12_OUT		(0x0C << 3) | (__OUT << 2)
#define	__EP12_IN		(0x0C << 3) | (__IN << 2)
#define	__EP13_OUT		(0x0D << 3) | (__OUT << 2)
#define	__EP13_IN		(0x0D << 3) | (__IN << 2)
#define	__EP14_OUT		(0x0E << 3) | (__OUT << 2)
#define	__EP14_IN		(0x0E << 3) | (__IN << 2)
#define	__EP15_OUT		(0x0F << 3) | (__OUT << 2)
#define	__EP15_IN		(0x0F << 3) | (__IN << 2)
