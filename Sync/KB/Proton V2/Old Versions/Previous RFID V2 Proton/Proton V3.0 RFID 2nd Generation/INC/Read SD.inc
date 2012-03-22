'****************************************************************
'*  Name    : Read SD.INC                                      
'*  Author  : [Sam and Kim Bozman]                             
'*  Notice  : Copyright (c) 2009 [Sam and Kim Bozman]           
'*          : All Rights Reserved                               
'*  Date    : 02/01/2009                                        
'*  Version : 1.1 Revision Oct 24/09                                              
'*  Notes   : Revision April 6 2010                                                  
'*          : Major Revision April 6/10                                                  
'****************************************************************
'NOTE: NOT TESTED

Read_SD: 
        MyCount = 0
'--------------- Open Module file using local Module # ----------        
GoSub Read_Mod                      'Go get Module number
SD_File_Name = Str ModNum           'Change Mod # into string
SD_File_Ext = "TXT"                 'File Ext, upper case only!  
Response = SD_Open_File             'Using the Module serial number stored within the Module at
                                    'address 0X9C40 we will try to open a file on the SD card
                                    ' with the same name as the Module serial number.
If Response = 1 Then
    Cls
    Print "File not found"          'File with Module serial number not found.
    'EVENTUALLY WE WILL FLASH A LED HERE TO TELL OPERATOR THE FILE WAS NOT FOUND OR WHATEVER
    Sleep
EndIf

'If a file with the same name as the Module serial number was found then....
        
'-----------------------Clear any old user/tags but keep any old history----------------------------
EWrite num_Users, [0x00]        'This resets users to zero.
 '------------------- Open Input File and Write Users and Tags into User table ---------------------------   
 While SD_EOF < 1      'Read SD until end of file.... 
    Response = SD_Read_Byte_From_File
    Select Response
         Case  0X3A                         'If the Char was a ':' then ......    
            For Index = 0 To 9                'next 10 characters will be the User Tag #
                TagIN[Index] = SD_Read_Byte_From_File
            Next
 
            For Index = 0 To 9   
                CWrite BUA + Index, [TagIN[Index]]    'Here we are writing the 10 byte Tag to the program memory                                            
            Next          
            Inc MyCount    'Keeps track of how many Users we have added
            EWrite num_Users, [MyCount]      'Write number of users added.
            
         Case  0X40                     'If the  Char was a '@' then ......  
                                        'write the Manager ID and date into the Manager file 
               GoTo Write_Manager       'Located in 'Write_M_SD' module
               Return                   'Return to main module
               
         Case Else                       'If the first Char was neither a '@'  or a ':' then...
               Cls
                  Print At 1,1, "No 5E (^)"
                  Print At 2,1, "Stopped!"
                  Pause 3000
                  SD_Close_File    
                Sleep    'EVENTUALLY WE NEED TO HAVE A WAY TO TELL THE USER THERE WAS A PROBLEM.
      End Select      
 Wend    'Next user
 
      
     
    
    
  
