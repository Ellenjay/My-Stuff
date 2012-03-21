
' This demo shows how to implement the SIN , COS and TAN functions
' Using only BASIC commands
' These routines are quite fast but memory hungry

' View the results on the serial terminal

		Include "PROTON_4.INC"
    
    	Dim VALUE As Float 
		Dim S1 As Float 
		Dim S2 As Float 
		Dim S3 As Float

		Delayms 500							' Wait for PICmicro to stabilise

		VALUE = 0.3
		Hrsout "SIN of ", DEC VALUE, " = "
        Gosub _Sin       					' Get SIN of VALUE
		Hrsout Dec8 VALUE,13

		VALUE = 0.5
		Hrsout "COS of ", DEC VALUE, " = "
        Gosub _Cos        					' Get COS of VALUE
		Hrsout DEC8 VALUE,13

		VALUE = 1
		Hrsout "TAN of ", DEC VALUE, " = "
        Gosub _Tan							' Get TAN of VALUE
		Hrsout DEC8 VALUE,13

    	Stop
'---------------------------------------------------
' SIN subroutine 
' Expects value to SIN with in 'VALUE' (in radians)
' Returns result in 'VALUE' (in radians)
_SIN:
  		S1 = VALUE
  		VALUE = VALUE * VALUE
  		S2 = VALUE
  		VALUE = (VALUE * 0.01388888899236917) - 1.0        	' 1/72
  		VALUE = (VALUE * S2) * 0.02380952425301075			' 1/42
  		VALUE = (VALUE + 1.0) * S2
  		VALUE = (VALUE * 0.05) - 1.0                      	' 1/20
  		VALUE = (VALUE * S2) * 0.1666666716337204			' 1/6
  		VALUE = (VALUE + 1.0) * S1
		Return

'---------------------------------------------------
' COS subroutine
' Expects value to COS with in 'VALUE' (in radians)
' Returns result in VALUE (in radians)
_COS:
  		VALUE = VALUE * VALUE                               ' Angle squared
  		S1 = VALUE                                    		' Save
  		VALUE = (VALUE * 0.01785714365541935) - 1.0        	' 1/56
  		VALUE = (VALUE * S1) * 0.03333333507180214 			' 1/30
  		VALUE = (VALUE + 1.0) * S1
  		VALUE = (VALUE * 0.0833333358168602) - 1.0      	' 1/12
  		VALUE = VALUE * S1
  		VALUE = VALUE * 0.5                             	' 1/2
  		VALUE = VALUE + 1.0
		Return

'---------------------------------------------------
' TAN subroutine
' Expects value to TAN with in 'VALUE' (in radians)
' Returns result in VALUE (in radians)
_TAN:
  		S3 = VALUE
  		Gosub _SIN         		' Get SIN
  		S2 = VALUE            	' Store in S2
  		VALUE = S3           	' Get original value back
  		Gosub _COS				' Get COS
  		VALUE = S2 / VALUE		' Divide SIN by COS
		Return

        
