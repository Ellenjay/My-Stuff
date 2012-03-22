'****************************************************************
'*  Name    : UNTITLED.BAS                                      *
'*  Author  : [Sam and Kim Bozman]                              *
'*  Notice  : Copyright (c) 2011 Copyright (c) 2010 All rights  *
'*          : All Rights Reserved                               *
'*  Date    : 3/22/2011                                         *
'*  Version : 1.0                                               *
'*  Notes   : Various sound routines                                                
'****************************************************************
'Sound SP1,[110,10,118,10]
'DelayMS 2000

'Sound SP1,[110,20,118,20]
'DelayMS 2000

'Sound SP1,[110,30,118,30]
'DelayMS 2000

'Sound SP1,[110,40,118,40]
'DelayMS 2000
'****************************
Beep:
    GoSub High_V         'Switch off SD card and change voltage to 5V
    Sound SP1, [110,50]
Return
'****************************
Error_Beep:
    GoSub High_V         'Switch off SD card and change voltage to 5V       
    Sound SP1,[110,30,118,30]
Return
'****************************
