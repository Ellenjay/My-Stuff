'****************************************************************
'*  Name    : Init SD                                     *
'*  Author  : [Sam and Kim Bozman]                              *
'*  Notice  : Copyright (c) 2009 [Sam and Kim Bozman]           *
'*          : All Rights Reserved                               *
'*  Date    : 02/01/2009                                        *
'*  Version : 1.0                                               *
'*  Notes   :                                                   *
'*          :                                                   *
'****************************************************************
  Init_SD:  'Do only once   
    
       For Index = 0 To 2   'We allow 3 tries to intialize the SD card
       
        Response = SD_Init_FS_MSSP SD_SPI_FOSC_04
         If Response = 0 Then 
            Return
        EndIf
        Next Index     'Next try to intitialize card
    
  '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   
   Cls
   Print "No Init!"     'Eventually we will flash a LED here to tell operator the Init failed
   Pause 3000
   Return
 '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 
'-----------------------------------------------------------
