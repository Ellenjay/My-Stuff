' Descrete subroutines for floating point
' SIN, COS, and TAN

		Include "PROTON_4.INC"
		
		FLOAT_DISPLAY_TYPE = LARGE

		Dim ACC as Float
        Dim SIN_ACC as Float
		Dim XSTEP as Float
        Dim SIN_VALUE as Float
        
        Dim COS_VALUE as SIN_VALUE
        Dim TAN_VALUE as SIN_VALUE
        Dim COS_ACC as SIN_ACC
        Dim TAN_ACC as Float
        
        Dim VALUE as Float
        Dim N as Byte
        
        Dim SIN_N as Byte
        Dim COS_N as Byte
        
'---------------------------------------------------------------------        
        Delayms 500
        Cls

        TAN_VALUE = 3.4
        Gosub FLOAT_TAN
        Hrsout "TAN of ",Dec TAN_VALUE, " = ",Dec8 TAN_ACC,13
        
        SIN_VALUE = 0.3
        Gosub FLOAT_SIN
        Hrsout "SIN of ",Dec SIN_VALUE, " = ",Dec8 SIN_ACC,13
        
        COS_VALUE = 0.5
        Gosub FLOAT_COS
        Hrsout "SIN of ",Dec COS_VALUE, " = ",Dec8 COS_ACC,13
        
		Stop
        
'----------------------------------------------------------------------       
' Result returned in 'ACC'        
FACTORIAL:	
		ACC = 1
		While n > 0
			ACC = ACC * N
			N = N - 1
		Wend
		Return

'----------------------------------------------------------------------
' Expects value in 'VALUE'
' Expects 'power of' in 'N'
' Result returned in ACC
POWER:	
		ACC = 1
		While N > 0
			ACC = ACC * VALUE
			N = N - 1
		Wend
		Return

'----------------------------------------------------------------------
' Calculate a floating point SIN
' Value to SIN is held in 'SIN_VALUE'
' SIN value is returned in 'SIN_ACC'
FLOAT_SIN:

		SIN_ACC = 0
       
		SIN_N = 0
        Repeat
			VALUE = -1
       	 	N = SIN_N
        	Gosub POWER
        	XSTEP = ACC
        
        	VALUE = SIN_VALUE
        	N = (SIN_N * 2) + 1
        	Gosub POWER
        	XSTEP = XSTEP * ACC
        
        	N = (SIN_N * 2) + 1
        	Gosub FACTORIAL
        	XSTEP = XSTEP / ACC
            
            If XSTEP > 0  Then If XSTEP < 0.00000001  Then Return
        	If XSTEP < 0  Then If  XSTEP > -0.00000001 then Return
			
            SIN_ACC = SIN_ACC + XSTEP
			Inc SIN_N
        Until SIN_N > 5
		Return
'----------------------------------------------------------------------
' Calculate a floating point COS
' Value to COS is held in 'COS_VALUE'
' COS value is returned in 'COS_ACC'

FLOAT_COS:
		COS_ACC = 0

		COS_N = 0
        Repeat
        	VALUE = -1
       	 	N = COS_N
        	Gosub POWER
        	XSTEP = ACC
            
            VALUE = COS_VALUE
        	N = (COS_N * 2)
        	Gosub POWER
        	XSTEP = XSTEP * ACC
        
        	N = (COS_N * 2)
        	Gosub FACTORIAL
        	XSTEP = XSTEP / ACC

			If XSTEP > 0  Then If XSTEP < 0.00000001  Then Return
        	If XSTEP < 0  Then If  XSTEP > -0.00000001 then Return

			COS_ACC = COS_ACC + XSTEP
			Inc COS_N
        Until COS_N > 5
		Return
'----------------------------------------------------------------------
' Calculate a floating point TAN
' Value to TAN is held in 'TAN_VALUE'
' TAN value is returned in 'TAN_ACC'	
	
FLOAT_TAN:       	
        Gosub FLOAT_SIN
        TAN_ACC = SIN_ACC
        Gosub FLOAT_COS
        TAN_ACC = TAN_ACC / COS_ACC
        Return
               
        
    
