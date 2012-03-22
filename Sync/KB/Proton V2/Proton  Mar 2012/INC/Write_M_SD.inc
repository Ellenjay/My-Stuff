'****************************************************************
'*  Name    : Write Manager Update codes back to SD card                                    
'*  Author  : [select VIEW...EDITOR OPTIONS]                    
'*  Notice  : Copyright (c) 2009 [select VIEW...EDITOR OPTIONS] 
'*          : All Rights Reserved                               
'*  Date    : 3/20/2009                                         
'*  Version : 1.0                                               
'*  Notes   :Major Revision: April 8/10                                                   
'*          :                                                   
'****************************************************************
'NOTE: NOT TESTED

Write_M_SD:
GoSub Read_Mod      'Get module #

SD_File_Name = Str ModNum          'File Name, upper case only
SD_File_Name = SD_File_Name +"M"    'M is for "Manager" file
SD_File_Ext = "TXT"                'File Ext, upper case only! 

SD_Delete_File          'If file already exists then delete it..If the file does not exist then..
                          'SD_Delete_File will do nothing
'create a NEW file.
 SD_New_File 
 Byte_Var = ERead num_MHE   'Load number of Manager History entries into Index2
 'Response = Str$(Dec,Byte_Var) 'Change number into a string to send to SD card
  If Byte_Var = 0 Then  'If there is no Manager History then..
         SD_IO_String = "No Manager Update History exists for this Module!"   
         SD_Write_String_To_File 
         SD_CLOSE_FILE
         Return
  EndIf
    SD_IO_String = Response   'Write number of Mangager History entries to SD
    SD_Write_String_To_File    
    SD_Write_Byte_To_File "|"  ' Add a Separator 
  
 MyCount = 0
 Repeat	                                'Repeat until all Manager codes are processed
    For Index = 0 To 4  			
        Response = CRead Word_Var + (Byte_Var -1) * 10   + Index  
        SD_Write_Byte_To_File Response 'append to file.
    Next Index
    SD_Write_Byte_To_File ":"
    Dec Byte_Var
    'Print Dec Byte_Var
 Until Byte_Var = 0
 SD_CLOSE_FILE
 Return
