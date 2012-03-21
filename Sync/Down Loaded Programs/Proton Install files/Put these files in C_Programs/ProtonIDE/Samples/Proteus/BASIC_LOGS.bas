'
' Perform the floating point functions LOGx and LN using only BASIC commands
' Check the results by using the Windows Calculator
'
' This program is suitable for both 14 and 16-bit core devices without change

		Include "PROTON_4.INC"
		
		'FLOAT_DISPLAY_TYPE = LARGE				' Unremark for more accurate display

' Create some variables for use with LN and LOG

		Dim LOG_VALUE as Float
		Dim LOG_POWER as Float
		Dim LOG_TEMP as Float
		Dim LOG_X as Float
		Dim LOG_FACTOR as Float
		Dim LOG_XSQR as Float
		Dim LOG_N as Byte
		Dim LOG_TEMP2 as Byte
			
  		
  		Goto OVER_LOG_SUBROUTINES  				' Jump over the subroutines

'----------------------------------------------------------------------
' LN Funtion
' Input		: LOG_VALUE holds the value to perform the LN on
' Output	: LOG_VALUE holds the result of the LN
' Notes		: LOG_FACTOR LOG_N to get result >= 0.5 LOG_X <= 1.0 and get LOG_N*ln2
' 			  The Exponent of the floatin point values is LOG_N.BYTE0
' 			  If LOG_N.BYTE0 = $7E then the number is between 0.5 and 1.0 (2^-1 and 2^0)
LN:

' We can't have ln(1) so we must return a zero if it is
		If LOG_VALUE.Byte0 = 0 Then LOG_VALUE = 0: Return
		
' The difference between LOG_N.BYTE0 and $7E will be the 
' amount of 2^LOG_N's that we want to multiply times ln(2)
		If LOG_VALUE.Byte0 <= $7E Then 
			LOG_N = $7E - LOG_VALUE.Byte0
			LOG_FACTOR = -0.69314718 * LOG_N
		Else 
			LOG_N = LOG_VALUE.Byte0 - $7E
			LOG_FACTOR = 0.69314718 * LOG_N
		Endif
		LOG_VALUE.Byte0 = $7E
		
' Begin the taylor series expansion
' ln(1+LOG_X) = LOG_X - (LOG_X^2/2) + (LOG_X^3/3) -+...
		
		LOG_VALUE = LOG_VALUE - 1
		LOG_X = LOG_VALUE
		LOG_XSQR = LOG_VALUE
		LOG_N = 2
		Repeat
			LOG_XSQR = LOG_XSQR * LOG_X
			LOG_VALUE = LOG_VALUE - (LOG_XSQR / LOG_N)
			LOG_XSQR = LOG_XSQR * LOG_X
			LOG_TEMP2 = (LOG_N + 1)
			LOG_VALUE = LOG_VALUE + (LOG_XSQR / LOG_TEMP2)
			LOG_N = LOG_N + 2
		Until LOG_N > 12
		LOG_VALUE = LOG_VALUE + LOG_FACTOR
		Return
'----------------------------------------------------------------------
' LOG N Funtion
' Input		: LOG_VALUE holds the value to perform the LOG on
'			: LOG_POWER holds the base power of the LOG
' Output	: LOG_VALUE holds the result of the LOG
' Notes		: Uses the LN subroutine
'
LOGX:
		Gosub ln
		LOG_TEMP = LOG_VALUE
		LOG_VALUE = LOG_POWER
		Gosub ln
		LOG_VALUE = LOG_TEMP / LOG_VALUE
		Return

'----------------------------------------------------------------------
' Main Demo starts here

OVER_LOG_SUBROUTINES:      

		
		LOG_POWER = 10
		LOG_VALUE = 2				
		Hserout ["LOG(",Dec2 LOG_VALUE,",",Dec2 LOG_POWER,") = "]
		Gosub lOGX		            								' Perform the LOGX subroutine
		Hserout [Dec4 LOG_VALUE,13]
		
        LOG_VALUE = 2.4
        Hserout ["LN(",Dec2 LOG_VALUE,") = "]
		Gosub LN           											' Perform the LN subroutine
        Hserout [Dec4 LOG_VALUE,13]
		Stop 

