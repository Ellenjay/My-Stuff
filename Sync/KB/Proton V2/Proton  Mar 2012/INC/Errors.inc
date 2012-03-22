'****************************************************************
'*  Name    : UNTITLED.BAS                                      
'*  Author  : [Sam and Kim Bozman]                             
'*  Notice  : Copyright (c) 2011 Copyright (c) 2010 All rights  
'*          : All Rights Reserved                               
'*  Date    : 3/22/2011                                         
'*  Version : 1.0                                               
'*  Notes   :  These are the flash and sound codes for                                                 
'*          :  the various errors and/or user messages                                                 
'****************************************************************
'********* Tag Invalid **************
Tag_Invalid:
Cls
Print "Unauthorized"
    For Index = 1 To 5
        High Red
        DelayMS 200
        Low RED
        High Green
        DelayMS 200
    Next Index
Cls
Print "Sleeping Now"
GoTo SleepNow
Return
'********* No tag found **************
Tag_Not_Found:
Cls
Print "No Tag"
DelayMS 1000
    For Index = 1 To 5
        High Red
        DelayMS 1000
        Low RED
        DelayMS 500
    Next Index
Cls
Print "Sleeping Now"
DelayMS 1000    
GoTo SleepNow    
Return
'**********Bad Card*****************
Bad_Card:
GoSub High_V
Cls
Print "Bad Card"
DelayMS 1000
Repeat  'Repeat this flash unitl SD card has been removed then 'Sleep'
        For Index = 1 To 5
            High Red
            DelayMS 200
            Low Red
            DelayMS 200 
        Next Index
    DelayMS 2000
Until SD_Detect = 1
Cls
Print "Sleeping Now"
DelayMS 1000
GoTo SleepNow
'**********Bad File*****************
Bad_File:
GoSub High_V
Cls
Print "Bad File"
DelayMS 1000
Repeat  'Repeat this flash unitl SD card has been removed then 'Sleep'
        For Index = 1 To 5
            High Red
            DelayMS 200
            Low Red
            DelayMS 200 
        Next Index
    DelayMS 2000
Until SD_Detect = 1
Cls
Print "Sleeping Now"
DelayMS 1000
GoTo SleepNow
