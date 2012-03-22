'****************************************************************
'*  Name    : Read SD.INC                                      *
'*  Author  : [Sam and Kim Bozman]                              *
'*  Notice  : Copyright (c) 2009 [Sam and Kim Bozman]           *
'*          : All Rights Reserved                               *
'*  Date    : 02/01/2009                                        *
'*  Version : 1.1 Revision Oct 24/09                                              *
'*  Notes   :                                                   *
'*          :                                                   *
'****************************************************************
Read_SD: 
        MyCount = 0
'--------------- Open Module file using local Module # ----------        
        GoSub Read_Mod        'Go get Module number

        SD_File_Name = Str ModNum          'Change Mod # into string
        SD_File_Ext = "TXT"                'File Ext, upper case only!  
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
User_Pointer = BUA                   '...we write the low and ..
    EWrite UPA_L, [User_Pointer.LowByte]  '...high bytes of the base user address (0X9C500...
    EWrite UPA_H, [User_Pointer.HighByte]  '...into the EEProm Pointer storage spot (0X000 and 0X001)
Pause 2000    'EVENTUALLY DELETE THIS PAUSE
 '------------------- Open Input File and Write Users and Tags into User table ---------------------------   
    While SD_EOF < 1      'Read SD until end of file.... 
                   
            Response = SD_Read_Byte_From_File
            
            If Response <> 0X5E Then       'first character for each user should be "^"
                 If Response = 0X40 Then   ' if the first char is not '^' then is it a '@'?
                    'If it is a '@' then we are finished with tags and users and are ready to write 
                        'the Manager ID and date into the Manager file          
                    EWrite NOU, [MyCount]     'Write total # of Users to EEProm 
                    GoTo Write_Manager     'Located in 'Write_M_SD' module
                    Return                  'Return to main module
                 EndIf
            'If the first Char was not a '^' or a '@' then we have a problem.
                  Cls
                  Print At 1,1, "No 5E (^)"
                  Print At 2,1, "Stopped!"
                  Pause 3000
                  SD_Close_File    
                    Stop  
                Sleep    'EVENTUALLY WE NEED TO HAVE A WAY TO TELL THE USER THERE WAS A PROBLEM.
            
            EndIf
            
          'If the first Char was a '^' then ...... 
       
         For Index = 0 To 3                'next 4 characters will be the User ID number
           UTag[Index] = SD_Read_Byte_From_File
         Next
 
            Response = SD_Read_Byte_From_File
 
            If Response <> 0X3A Then       'first character for each Tag should be ":"
                Cls
                Print At 1,1, "No 3A (:).."      '*******Eventually will flash LED *************
                  Print At 2,1, "Stopped!"
                  Pause 3000
                SD_Close_File 
                Sleep    'EVENTUALLY WE NEED TO HAVE A WAY TO TELL THE USER THERE WAS A PROBLEM.
            EndIf
            'First char before Tag # was ":" so .....
         For Index = 4 To 13                'next 9 characters will be the User Tag number
           UTag[Index] = SD_Read_Byte_From_File
         Next
 '--------- I found it easier to READ my test data in the programmer in 16 byte chunks so...
 ' I am padding an extra 2 bytes to the end of my 14 byte data stream.
 
         UTag[14] = 0XFF   'Dummy byte
         UTag[15] = 0XFF   'Dummy byte
         For Index = 0 To 15   
           CWrite User_Pointer + Index, [UTag[Index]]    'Here we are writing the 16 byte chunk to the program memory 
                                                        '(Must be written in 8 or 16 byte chunks)
         Next
            User_Pointer = User_Pointer + 16      'Here we will update the user pointer to reflect..
            EWrite UPA_L, [User_Pointer.LowByte]   'our progress so far. If a problem arises then we have not lost all
            EWrite UPA_H, [User_Pointer.HighByte]  'UPA_L and UPA_H hold the start of the next empty user spot.
     Inc MyCount    'Keeps track of how many Users we have added
      'HERE WE EVENTUALLY NEED A WAY TO INFORM THE SD CARD OF OUR PROGRESS IN CASE OF A PROBLEM.
     Wend    'Next user
 
      
     
    
    
  
