'****************************************************************
'*  Name    : Read SD.INC                                      *
'*  Author  : [Sam and Kim Bozman]                              *
'*  Notice  : Copyright (c) 2009 [Sam and Kim Bozman]           *
'*          : All Rights Reserved                               *
'*  Date    : 02/01/2009                                        *
'*  Version : 1.0                                               *
'*  Notes   :                                                   *
'*          :                                                   *
'****************************************************************
Read_SD: 
        MyCount = 0
'--------------- Read Module number from memory into Variable (ModNum)----------        
        For Index = 0 To 7
            ModNum[Index] = CRead 0X9C40 + Index    'Read the Module number into Variable
        Next

        SD_File_Name = Str ModNum          'File Name, upper case only
        SD_File_Ext = "TXT"                'File Ext, upper case only!  
        Response = SD_Open_File
        If Response = 1 Then
            Cls
            Print "File not found"    
            'Eventually we will flash a LED here to tell operator the file was not found or mwhatever
            Sleep
        EndIf

'-----------------------Clear any old user/tag and history----------------------------
User_Pointer = BUA                   '...we write the low and ..
    EWrite UPA_L, [User_Pointer.LowByte]  '...high bytes of the base user address (0X9C500...
    EWrite UPA_H, [User_Pointer.HighByte]  '...into the EEProm Pointer storage spot (0X000 and 0X001)
    'EWrite UHP, [0X00]                          ' Start off with the first history address OFFSET (0)
Pause 2000
 '------------------- Open Input File and Write Users and Tags into User table ---------------------------   
    While SD_EOF < 1       
                   
            Response = SD_Read_Byte_From_File
            
            If Response <> 0X5E Then       'first character for each user should be "^"
                 If Response = 0X40 Then 
                               
                    EWrite NOU, [MyCount]     'Write total # of Users to EEProm 
                    GoTo Write_Manager     'We are finished with the User table
                    Return
                 EndIf
                  Cls
                  Print At 1,1, "No 5E (^)"
                  Print At 2,1, "Stopped!"
                  Pause 3000
                  SD_Close_File    
                    Stop  
                Sleep
               
                Cls
                Print Response,"^ Problem.."      '*******Eventually will flash LED *************
                SD_Close_File 
                Pause 4000
                Sleep
            EndIf
            
           
       
         For Index = 0 To 3                'next 3 characters will be the User ID number
           UTag[Index] = SD_Read_Byte_From_File
         Next
 
            Response = SD_Read_Byte_From_File
 
            If Response <> 0X3A Then       'first character for each tag should be ":"
                Cls
                Print At 1,1, "No 3A (:).."      '*******Eventually will flash LED *************
                  Print At 2,1, "Stopped!"
                  Pause 3000
                SD_Close_File 
                Sleep
            EndIf
            
         For Index = 4 To 13                'next 9 characters will be the User Tag number
           UTag[Index] = SD_Read_Byte_From_File
         Next
 '--------- I found it easier to read my test data in 16 byte chunks so I am padding an extra 2 bytes to the end of my 14 byte data stream
         UTag[14] = 0XFF   'Dummy byte
         UTag[15] = 0XFF   'Dummy byte
         For Index = 0 To 15
           CWrite User_Pointer + Index, [UTag[Index]]    'Here we are writing 16 byte chunk to the program memory (Must be written in 8 or 16 byte chunks)
         Next
            User_Pointer = User_Pointer + 16      'Here we will update the user pointer to reflect..
            EWrite UPA_L, [User_Pointer.LowByte]   'our progress so far. If a problem arises then we have not lost all
            EWrite UPA_H, [User_Pointer.HighByte]
     Inc MyCount    'Keeps track of how many Users we have added
    
     Wend   
 

     
    
    
  
