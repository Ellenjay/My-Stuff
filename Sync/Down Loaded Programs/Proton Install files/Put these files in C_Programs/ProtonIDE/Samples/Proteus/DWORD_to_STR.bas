
' Convert a DWORD value into a string array
' Using only BASIC commands
' Similar principle to the STR$ command

		Include "PROTON_4.INC"
    
    	Dim P10 as Dword					' Power of 10 variable
		Dim CNT as Byte
		Dim J as Byte
    
    	Dim VALUE as Dword					' Value to convert
    	Dim STRING1[11] as Byte				' Holds the converted value
    	Dim PTR as Byte						' Pointer within the BYTE array

		Delayms 500							' Wait for PICmicro to stabilise
        Cls									' Clear the LCD
    	Clear								' Clear all RAM before we start
    	VALUE = 1234576						' Value to convert
    	Print at 1,1, "ORIG ",Dec VALUE     ' Display the original integer value
		Gosub DWORD_TO_STR					' Convert VALUE to STRING1
    	Print at 2,1,"STRN ",STR STRING1	' Display the string result
    	Stop
    
'-------------------------------------------------------------
' Convert a DWORD value into a STRING1 array
' Value to convert is placed in 'VALUE'
' Byte array 'STRING1' is built up with the ASCII equivalent
 
DWORD_TO_STR: 
		PTR = 0  
		J = 0
    	Repeat
			P10 = LREAD32 DWORD_TBL[J]       
			CNT = 0

			While VALUE >= P10
				VALUE = VALUE - P10
				Inc CNT
			Wend       

			If CNT <> 0 Then 
				STRING1[PTR] = CNT + "0"
				Inc PTR
			Endif
			Inc J
    	Until J > 8

		STRING1[PTR] = VALUE + "0"
		Inc PTR
		STRING1[PTR] = 0							' Add the NUL to terminate the STRING1
    	Return
 
' LDATA table is formatted for all 32 bit values.
' Which means each value will require 4 bytes of code space  
DWORD_TBL:
	LDATA  as DWORD 1000000000, 100000000, 10000000, 1000000, 100000, 10000, 1000, 100, 10
