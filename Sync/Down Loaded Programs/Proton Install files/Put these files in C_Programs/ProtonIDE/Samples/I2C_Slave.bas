' PicBasic Plus I2C slave program - PIC16F877

        Device 16F877
        XTAL = 4
        
' Alias pins
		Symbol SCL = PORTC.3         			' I2C clock input
		Symbol SDA = PORTC.4         			' I2C data input

' Define used register flags
		Symbol SSPIF	PIR1.3          	' SSP (I2C) interrupt flag
		Symbol BF		SSPSTAT.0       	' SSP (I2C) Buffer Full
		Symbol R_W		SSPSTAT.2       	' SSP (I2C) Read/Write
		Symbol D_A		SSPSTAT.5       	' SSP (I2C) Data/Address
		Symbol CKP		SSPCON.4        	' SSP (I2C) SCK Release Control
		Symbol SSPEN	SSPCON.5        	' SSP (I2C) Enable
		Symbol SSPOV	SSPCON.6        	' SSP (I2C) Receive Overflow Indicator
		Symbol WCOL		SSPCON.7        	' SSP (I2C) Write Collision Detect

' Allocate RAM
		Dim datain  as     Byte        		' Data in 
		Dim dataout as     Byte        		' Data out 
        
'------------------------------------------------------------------------------------
        Goto main           				' Jump over the subroutines
'------------------------------------------------------------------------------------

' I2C slave subroutine
i2cslave:
        SSPIF = 0               			' Clear interrupt flag
        If R_W = 1 Then i2Crd   			' Read data from bus
        If BF = 0 Then Return  				' Nothing in buffer so exit
        If D_A = 1 Then i2cwr   			' Data for bus (not address)
        If SSPBUF != 2 Then Return     		' Clear the address from the buffer
        Return
'------------------------------------------------------------------------------------
' I2C write data to bus
i2cwr:	datain = SSPBUF       				' Put data into datain
        Return
'------------------------------------------------------------------------------------
' I2C read data from bus
i2crd:  SSPBUF = datain       				' Get data from datain
        CKP = 1                 			' Release SCL line
		Return
'------------------------------------------------------------------------------------
' Main program loop
Main:        
' Initialise ports and directions
        ADCON1 = 7              			' All PORTA, PORTE pins to digital

' Initialise I2C slave mode
        SSPADD = 2              			' Make our address 2
        SSPCON2 = 0             			' General call address disabled
        SSPCON = $36            			' Set to I2C slave with 7-bit address
        
Again:  If SSPIF = 1 Then Gosub i2cslave	' Check for I2C interrupt

' Clear any I2C collisions or errors
        SSPOV = 0
        WCOL = 0
        Goto Again           				' Do it all forever