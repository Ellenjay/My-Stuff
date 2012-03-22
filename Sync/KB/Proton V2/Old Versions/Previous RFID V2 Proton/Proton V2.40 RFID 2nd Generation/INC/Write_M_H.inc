'****************************************************************
'*  Name    :Write_M_H.BAS                                      *
'*  Author  : [select VIEW...EDITOR OPTIONS]                    *
'*  Notice  : Copyright (c) 2009 [select VIEW...EDITOR OPTIONS] *
'*          : All Rights Reserved                               *
'*  Date    : 3/27/2009                                         *
'*  Version : 1.0                                               *
'*  Notes   :                                                   *
'*          :                                                   *
'****************************************************************
  '----------------- Write Manager and Date into Manager History File ---------------------- 
 Write_Manager:        
        For Index = num_MH To 0 Step -1       'Here we move all old history down one notch to ready 1st place for new entry
            For Index2 = 0 To 7
            TV1 = ERead (Index * 8) + Index2 + MHA
            EWrite (Index * 8) + Index2 + 8 + MHA,[TV1]
            Next Index2
        Next Index
        
             For Index = 0 To 7	 		'Write Manager ID and date to history file in spot 1
				Response = SD_Read_Byte_From_File
				EWrite MHA + Index, [Response]
 			Next 'Index  
 			TV1 = ERead num_MHE
         If TV1 < num_MH Then
            Inc TV1
            EWrite num_MHE, [TV1]
         EndIf	
    SD_Close_File 
    Cls
    Print "Manager Done"   
    Return   
        
        
 '@A5011209
