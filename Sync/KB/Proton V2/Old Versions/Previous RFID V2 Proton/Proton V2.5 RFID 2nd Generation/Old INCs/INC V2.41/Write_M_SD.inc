'****************************************************************
'*  Name    : UNTITLED.BAS                                      *
'*  Author  : [select VIEW...EDITOR OPTIONS]                    *
'*  Notice  : Copyright (c) 2009 [select VIEW...EDITOR OPTIONS] *
'*          : All Rights Reserved                               *
'*  Date    : 3/20/2009                                         *
'*  Version : 1.0                                               *
'*  Notes   :                                                   *
'*          :                                                   *
'****************************************************************
 'Tested..OK
Write_M_SD:
GoSub Read_Mod      'Get module #

SD_File_Name = Str ModNum          'File Name, upper case only
SD_File_Name = SD_File_Name +"M"    'M is for "Manager" file
SD_File_Ext = "TXT"                'File Ext, upper case only! 

SD_Delete_File          'If file already exists then delete it..If the file does not exist then..
                          'SD_Delete_File will do nothing
'create a NEW file.
 SD_New_File 
 Index2 = ERead num_MHE   'Load number of Manager History entries into Index2
 MyNum = Str$ (Dec,Index2) 'Change number into a string to send to SD card
  If Index2 = 0 Then  'If there is no Manager History then..
  '??? If INDEX2 = $FF
         SD_IO_String = "No Manager History"   
         SD_Write_String_To_File 
         SD_CLOSE_FILE
         Return
  EndIf
    SD_IO_String = MyNum   'Write number of Mangager History entries to SD
    SD_Write_String_To_File    
    SD_Write_Byte_To_File "|"  ' Add a Separator 
  
 MyCount = 0
 Repeat
    For Index = 0 To 1    'Here we write the 2 hex digits for each manager history  entry
    TV1 = ERead MHA + MyCount * 8 + Index   
    SD_Write_Byte_To_File TV1  
    Next Index
    SD_Write_Byte_To_File ":"  ' Add a Separator 
    For Index = 2 To 7          ' Here we write the 6 date digits for each manager history entry
    TV1 = ERead MHA + MyCount * 8 + Index   
    SD_Write_Byte_To_File TV1  
    Next Index
    SD_Write_Byte_To_File "/"  ' Add a Separator 
    Inc MyCount   
 Until MyCount = Index2
  SD_CLOSE_FILE
  Return
