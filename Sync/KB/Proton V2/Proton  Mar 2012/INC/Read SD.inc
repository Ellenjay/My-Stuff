'****************************************************************
'*  Name    : Read SD Card                                     
'*  Author  : [Sam and Kim Bozman]                             
'*  Notice  : Copyright (c) 2009 [Sam and Kim Bozman]           
'*          : All Rights Reserved                               
'*  Date    : 02/01/2009                                        
'*  Version : 1.1 Revision Oct 24/09                                              
'*  Notes   : Revision April 6 2010                                                  
'*          : Major Revision April 6/10 
'*          : Major Revision Mar 22/11                                                 
'****************************************************************
'NOTE: TESTED April 9/10
' Added some code June 2/10.. Not tested

Read_SD:    GoSub Low_V         'Change voltage to 3.3V and switch on SD card
'--------------- Open Module file using local Module # ----------        
GoSub Read_Mod                      'Go get Module number
SD_File_Name = Str ModNum           'Change Mod # into string
SD_File_Ext = "TXT"                 'File Ext, upper case only!  
Response = SD_Open_File             'Using the Module serial number stored within the Module at
                                    'address 0X9C40 we will try to open a file on the SD card
                                    ' with the same name as the Module serial number.
If Response = 1 Then   '      'File with Module serial number not found so we will 
  GoSub Write_Users_SD        'Write back User history to SD card and
  GoSub Write_M_SD             'Write back manager update history to SD card
  Return                      'Return to main module
EndIf

'If a file with the same name as the Module serial number was found then....
        
'-----------------------Clear any old user/tags but keep any old history----------------------------
EWrite num_Users, [0x00]        'This resets users to zero.
 '------------------- Open Input File and Write Users and Tags into User table ---------------------------   
 
 MyCount = 0           'Used to keep track of number of Users written to table
 While SD_EOF < 1      'Read SD until end of file.... 
    Response = SD_Read_Byte_From_File
    Select Response
         Case  0X40   'Char was an AT symbol - '@' 'Time before output is activated after RFID Tag is read.
            Byte_Var =  SD_Read_Byte_From_File    'Get first of 2 bytes (in character code)
            GoSub Get_Hex                          'Go to subroutine (bottom of page) to extract Hex representation of code
            Index = Byte_Var                       'Pass Hex value to byte variable Index
            
            Byte_Var =  SD_Read_Byte_From_File    'Get second of 2 bytes (in character code)
            GoSub Get_Hex                         'Go to subroutine (bottom of page)to extract Hex representation of code
            Index2 = Byte_Var                     'Pass Hex value to byte variable Index2 
            Byte_Var = (Index <<4) + Index2       'Combine 2 4 bit hex values into one 8 bit hex number.. i.e. 3F
            EWrite DBO, [Byte_Var]   'Time in seconds
            
                   
         Case 0X2A    'Char was an Asterisk '*' Time that output is activated
            Byte_Var =  SD_Read_Byte_From_File    'Get first of 2 bytes (in character code)
            GoSub Get_Hex                          'Go to subroutine (bottom of page) to extract Hex representation of code
            Index = Byte_Var                       'Pass Hex value to byte variable Index
            
            Byte_Var =  SD_Read_Byte_From_File    'Get second of 2 bytes (in character code)
            GoSub Get_Hex                         'Go to subroutine (bottom of page)to extract Hex representation of code
            Index2 = Byte_Var                     'Pass Hex value to byte variable Index2 
            Byte_Var = (Index <<4) + Index2       'Combine 2 4 bit hex values into one 8 bit hex number.. i.e. 3F
            EWrite TOP, [Byte_Var]  'Time in seconds 
         
         Case 0X2B   'Char was a Plus sign '+'          (Sound On or Off)
            Byte_Var =  SD_Read_Byte_From_File
             GoSub Get_Hex
            EWrite SOO, [Byte_Var]  ' 0 = Sound off. 1 = Sound on 
            
         Case 0X24      'Char was a Dollar sign "$"   Indicates Module runs normally (0) or is 'Open' (1) or is Closed (2) 
             Byte_Var =  SD_Read_Byte_From_File
              GoSub Get_Hex
             EWrite MOP, [Byte_Var]   '   (0 = Module normal. 1 = Module is open. 2 = Module is closed)
             
         Case  0X3A                         'If the Char was a ':' then ......    
            For Index = 0 To 9                'next 10 characters will be a User Tag #
                TagIN[Index] = SD_Read_Byte_From_File
                GoSub High_V
                Cls
                Print HEX TagIn[Index]
                Pause 2000
            Next
             Stop
            'We will write 10 digit user tags into 16 byte spots because Cwrite must write 8 or 16 bytes at a time.
            'CWrite BUA +(MyCount * 16), [TagIN[0], TagIN[1], TagIN[2], TagIN[3], TagIN[4], TagIN[5], TagIN[6], TagIN[7] ]
            'CWrite BUA +(MyCount * 16) + 8, [TagIN[8], TagIN[9], 0, 0, 0, 0, 0, 0 ]
             CWrite BUA +(MyCount * 16), [TagIN[0], TagIN[1], TagIN[2], TagIN[3], TagIN[4], TagIN[5], TagIN[6], TagIN[7] , TagIN[8], TagIN[9],0,0,0,0,0,0]
             'CWrite BUA +(Mycount * 10), [TagIN[0], TagIN[1], TagIN[2], TagIN[3], TagIN[4], TagIN[5], TagIN[6], TagIN[7],TagIN[8], TagIN[9] ]
            Inc MyCount    'Keeps track of how many Users we have added
            EWrite num_Users, [MyCount]      'Write number of users added.
           GoSub High_V
            Cls
            Print "Done one"
            Stop
         Case  0X7E                     'If the  Char was a Tilde sign '~' then ......  
                                        'write the Manager ID and date into the Manager file 
              For Index = 0 To 3                         'Get manager update code from SD card and place it in
                  M_U_Code[Index] = SD_Read_Byte_From_File      'variable array. (M_U_Code[])
              Next Index       
              Byte_Var = ERead num_MHE                  'Get number of stored Manager Update entries.. 
              For Index = 0 To 3                          'Write 4 Manager Update code into addressed spot
                  EWrite MHA + (4 * Byte_Var) + Index, [M_U_Code[Index]]
              Next Index
              Inc Byte_Var                               'Add 1 to pointer of Update code entries.
                  If Byte_Var > Max_MH Then Byte_Var = 0      'If our history file is full then start over at beginning.
              EWrite num_MHE, [Byte_Var]                  'Write number of Manager entries into PIC             
                GoSub Write_Users_SD        'Write back User history to SD card and
                GoSub Write_M_SD             'Write back manager update history to SD card
              Return                   'Return to main module
               
         Case Else                       'If the first Char was neither a '@'  or a ':' then...
             GoSub High_V
             Cls
             Print Response
             Stop
             Response = 1   'Error in reading file
             Return
      End Select      
 Wend    'Next user
 
Get_Hex:
 Select Byte_Var  
            Case 48 To 57 
                Byte_Var = Byte_Var - 48
            Case > 65 To 70 
                  Byte_Var = Byte_Var - 55
            Case Else
                 GoSub Beep
                 GoTo Bad_File
            End Select
Return
    
  
