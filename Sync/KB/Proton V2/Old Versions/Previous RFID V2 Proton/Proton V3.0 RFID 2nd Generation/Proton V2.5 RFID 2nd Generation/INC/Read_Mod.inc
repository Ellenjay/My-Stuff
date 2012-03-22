Read_Mod:
	
	For Index = 0 To 7
            ModNum[Index] = CRead 0X9C40 + Index    'Read the Module number into Variable
    Next
	Return
