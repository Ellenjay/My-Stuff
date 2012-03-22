'****************************************************************
'*  Name    : Write_U_H                                    
'*  Author  : [select VIEW...EDITOR OPTIONS]                    
'*  Notice  : Copyright (c) 2009 [select VIEW...EDITOR OPTIONS] 
'*          : All Rights Reserved                              
'*  Date    : 3/20/2009                                         
'*  Version : 1.0                                               
'*  Notes   : Major Revision: April 6/10                                                  
'*          :                                                   
'****************************************************************
 'NOTE: NOT TESTED
'------------ Write Current User into History -------------------------------------------------
Write_UH: 
Byte_Var = ERead num_UHE                  'Get number of stored user tag history entries.. 
EWrite UHA + (11 * Byte_var), [":"]          'Insert separator (:)
For Index = 1 To 10
    EWrite UHA + (11 * Byte_var) + Index, [TagIn[Index]]
Next Index

Inc Byte_Var                                'Add 1 to # of history entries
If Byte_Var > Max_UH Then Byte_Var = 0      'If our history file is full then start over at beginning.
EWrite num_UHE, [Byte_Var]                  'Write next open spot pointer.
  
Return        
       
        
        
   
