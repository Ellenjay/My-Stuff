'****************************************************************
'*  Name    : KeyBuster RFID 2nd Generation                                     
'*  Author  : [Sam and Kim Bozman]                    
'*  Notice  : Copyright (c) 2008 [Sam and Kim Bozman] 
'*          : All Rights Reserved                               
'*  Date    : 31/12/2008                                        

Include "INC\Initialize.inc" 'Must be on top


 '=================   Main Program   =======================
High Green
Pause 1000
Low Green
High Red
Pause 1000
Low Red
Cls
Print "Start"
GoSub Beep
Pause 2000
GoSub Reset_Diagnostic_Logger

Pause 2000
Main:
If SD_Detect = 0 Then     ' a zero means we have detected a ground (SD card has been inserted)
    GoSub Init_SD  '************ Only do one time when SD card detected.   
        If Response <> 0 Then  'SD card was invalid or is a bad card
        GoSub High_V   'Turn off power to SD card and change voltage to 5V
             Cls
             Print "No Init"
             Pause 5000
            GoSub Error_Beep  'Error_Beep is in 'Sound'
            GoTo Bad_Card     'Bad_Card is in 'Errors"    
        End If

'****************If SD card initialized OK Then..................       
        GoSub Read_SD   'This sub  reads SD and writes information to PIC memory   
        If Response = 1 Then  'reading SD caused an error
           GoSub High_V   'Turn off power to SD card and change voltage to 5V
             Cls
             Print "SD Error"
             Pause 5000
           GoSub Error_Beep  'Error_Beep is in 'Sound'
           GoTo Bad_File     'Bad_File is in 'Errors"
        Else
            GoSub High_V
            Cls
            Print "SD read OK"
            Pause 5000
            GoTo SleepNow
        End If
End If   
'************** No SD card detected so Read RFID Tag ***************
Read_Again:
GoSub Read_Tag
If Response = 1 Then  'no tag found
            GoSub Error_Beep  'Error_Beep is in 'Sound'
            GoTo Tag_Not_Found 'Tag_Not_Found is in 'Errors"
Else Cls
     Print "Tag Read"
   Pause 1000
End If

GoSub Check_Tag
If Response = 0 Then  'tag Invalid
           GoSub Beep  'Error_Beep is in 'Sound'
           GoTo Tag_Invalid 'Invalid is in 'Errors"
Else
   Cls
   Print "Tag is good!"
   Pause 1000
   GoTo StartUnit
   
End If 



'GoTo Main        'Start again
 
 
 '------------ Includes -------------------------------------
Include "INC\Read Tag.inc"                  
Include "INC\Read SD.inc"
Include "INC\Init SD.inc"
Include "INC\Check Tag.inc"
Include "INC\Write_U_H.inc"
Include "INC\Read_Mod.inc"
Include "INC\Sound.INC" 
Include "INC\Voltage_Control.inc"
Include "INC\GoSleep.inc"
Include "INC\StartUnit.inc"
Include "INC\Write SD.inc"
Include "INC\Write_M_SD.inc"
Include "INC\Write_Users_SD.inc"
Include "INC\Errors.inc"
Include "INC\Reset_Logger.inc"
 '-------------------- Module Number ------------------------
 Org 0X9C40            'This is the Address where the Module ID number will be stored
 CData "A27B83B", 0    ' ****** This is the unique module number for this module. ******
 
