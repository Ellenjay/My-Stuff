'****************************************************************
'*  Name    :Write_M_H.BAS                                      
'*  Author  : [select VIEW...EDITOR OPTIONS]                    
'*  Notice  : Copyright (c) 2009 [select VIEW...EDITOR OPTIONS] 
'*          : All Rights Reserved                               
'*  Date    : 3/27/2009                                         
'*  Version : 1.1 Revision Oct 24/09                                              
'*  Notes   :  Major revision: April 6/10                                                 
'*          :                                                   
'****************************************************************

'NOTE: NOT TESTED


  '---------Write Manager Update Code (4 digit Hex) to Manager History File ---------------------- 
 Write_Manager:        
 
 For Index = 0 To 3                         'Get manager update code from SD card and place it in
    M_U_Code[Index] = SD_Read_From_File      'variable array. (M_U_Code[])
 Next Index       
 
Byte_Var = ERead (num_MHE)                  'Get number of stored Manager Update entries.. 
For Index = 0 To 3                          'Write 4 Manager Update code into addressed spot
    EWrite MHA + (4 * Byte_Var) + Index, [M_U_Code[Index]]
Next Index

Inc Byte_Var                                'Add 1 to pointer of Update code entries.
If Byte_Var > Max_MH Then Byte_Var = 0      'If our history file is full then start over at beginning.
EWrite num_MHE, [Byte_Var]                  'Write next open spot pointer.
End If   
                
SD_Close_File 
Cls
Print "Manager Done"   
Return   
        
        

