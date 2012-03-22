'****************************************************************
'*  Name    : Write SD.inc                                      *
'*  Author  : [Sam and Kim Bozman]                              *
'*  Notice  : Copyright (c) 2009 [Sam and Kim Bozman]           *
'*          : All Rights Reserved                               *
'*  Date    : 02/01/2009                                        *
'*  Version : 1.0                                               *
'*  Notes   :                                                   *
'*          :                                                   *
'****************************************************************

 'Not TESTED, not revised and maybe not to be used

Write_SD: 
'---------------- Create Write-Back Output file -----------------------------------------

    SD_File_Name = Str ModNum + "W"      'Module File Name with 'W' appended to differeniate from Input file, upper case only!
    SD_File_Ext = "TXT"                  'File Ext, upper case only!  
    Response = SD_Check_For_File         'Check if file exists already
    If Response = 0 Then
        SD_Delete_File               ' If file exists then delete it........   
    EndIf         
        SD_New_File     'Create new file
        SD_Close_File   'Close file now that is has been created... Only one file at a time can be opened

  SD_File_Name = Str ModNum + "W"      'Module File Name with 'W' appended to differeniate from Input file, upper case only!
        SD_File_Ext = "TXT"                'File Ext, upper case only!  
        Response = SD_Append_File     'Here we are going to 'Append' the Output file with data so far
                If Response = 1 Then
                    Cls
                    Print "File not found"    
                    'Eventually we will flash a LED here to tell operator the file was not found or mwhatever
                    Sleep
                EndIf 
 'Here we will write the user file back to SD
'-----------------------------------------------------------

Close_File:

    SD_Close_File                                           'Close file
    Return



