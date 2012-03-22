'****************************************************************
'*  Name    : Read Module Number                                    
'*  Author  : [Sam and Kim Bozman]                              
'*  Notice  : Copyright (c) 2009 [Sam and Kim Bozman]           
'*          : All Rights Reserved                               
'*  Date    : 02/01/2009                                        
'*  Version : 1.0                                               
'*  Notes   : Major Revision: April 6/10                                                  
'*          :                                                   
'****************************************************************
'NOTE: TESTED OK April 9/10

Read_Mod:
	
	For Index = 0 To 7
            ModNum[Index] = CRead 0X9C40 + Index    'Read the Module number into Variable
    Next
	Return
