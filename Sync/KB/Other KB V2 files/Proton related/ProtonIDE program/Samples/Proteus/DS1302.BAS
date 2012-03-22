' Pre-load a Dallas DS1302 (RTC) with the time and date. 
' Then display time and date on the LCD  
'
' For use with the ISIS 16F628 Virtual Evaluation Board.          
                                             
		Device = 16F628A
        XTAL = 4
        
		LCD_DTPIN = PORTB.4	
		LCD_RSPIN = PORTB.3
		LCD_ENPIN = PORTB.0
		LCD_INTERFACE = 4					' 4-bit Interface
		LCD_LINES = 2 						' 2-Line LCD
		LCD_TYPE = 0						' Alphanumeric LCD type
		 
		Dim RTCCMD		as Byte
		
		Dim TEMP		as Byte
		Dim TEMP1 		as Byte
		Dim TIMEDATA[6]	as Byte
		Dim OLDSECONDS 	as Byte
		Dim SECONDS 	as timedata#0
		Dim MINUTES 	as timedata#1
		Dim HOURS		as timedata#2
		Dim DATE		as timedata#3
		Dim MONTH		as timedata#4
		Dim YEAR		as timedata#5

'Define registers
		Symbol SECREG	= %00000
		Symbol MINREG	= %00001
		Symbol HRSREG	= %00010
		Symbol DATEREG	= %00011
		Symbol MONREG	= %00100
		Symbol YRREG	= %00110
		Symbol CTRLREG = %00111
		Symbol BRSTREG = %11111
        
        Symbol CLK 		= PORTA.0
		Symbol DTA		= PORTA.1
		Symbol RST		= PORTB.6

' Time setup data held in eeprom memory
PRST 	Edata $00,$00,$12,$20,$03,$02

		ALL_DIGITAL = True
		Cls
        
' Clear Write Protect bit in control register of DS1302
		Temp = $10
		RTCCmd = CtrlReg
		Gosub DS1302_WRITE

' Pre-set the time registers using a data table stored in eeprom memory
		For temp1 = 0 To 5
			Temp = Eread PRST + temp1
			RTCCmd = temp1
			Gosub DS1302_WRITE
		Next

		Temp = $80
		RTCCmd = CtrlReg
		Gosub DS1302_READ

'Only Displays on the LCD if the seconds have changed
		While 1 = 1
			Gosub DS1302_READ
			If oldseconds <> seconds Then
				Print at 1,1, "TIME ", Hex2 Hours,":",Hex2 Minutes,":",Hex2 Seconds
				Print at 2,1, "DATE ", Hex2 Date,"/",Hex2 Month,"/",Hex2 Year
			Endif
		Wend

'-----------------------------------------------------------------------------------
' Write to DS1302 RTC
DS1302_WRITE:		
		High RST
		Shout Dta, Clk, LSBFIRST, [%0\1,RTCCmd\5,%10\2,Temp\8]
		Low RST
		Return
'-----------------------------------------------------------------------------------
' Read from the DS1302
DS1302_READ:
		High RST
		Shout DTA, Clk, LSBFIRST, [%111111\6,%10\2]
		oldseconds = seconds
		Shin DTA, Clk, LSBPRE, [Seconds,Minutes,Hours,Date,Month,Year,Year]
		Low RST
		Return
