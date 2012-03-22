' Program to read and write to code space
' Flash Program Write must be enabled on your programmer
' Write to 8 locations of code space beginning at $1800
' Read 8 locations back and send to LCD repeatedly

		Include "PROTON_4.INC"
		
		Dim I    as     byte                ' Loop count
		Dim D    as     byte                ' Data
		Dim A    as     word                ' Address

        For I = 0 To 7         				' Loop 8 times, once for each address $1800 to $1807
			A = WRITE_ADDRESS + I			' Increment Address
            D = I + $A0          			' Change Data
			Cwrite A,[D]		 			' Send value in D to code space location A
        Next

Loop:   For I = 0 To 7          			' Loop 8 times, once for each address $1800 to $1807
			A = WRITE_ADDRESS + I			' Increment Address
			D = Cread A						' Get data in location A

            Print Cls,Hex A,": ",Hex D   ' Display the location and data
            Delayms 1000
        Next

        Goto Loop
        
WRITE_ADDRESS:	ORG $1800
