'****************************************************************
'*  Name    : Init SD                                     
'*  Author  : [Sam and Kim Bozman]                              
'*  Notice  : Copyright (c) 2009 [Sam and Kim Bozman]           
'*          : All Rights Reserved                               
'*  Date    : 02/01/2009                                        
'*  Version : 1.0                                               
'*  Notes   : Major Revision: April 6/10                                                  
'*          :                                                   
'****************************************************************

'NOTE: TESTED OK April 9/10

  Init_SD:  'Do only once    
  GoSub Low_V         'Change voltage to 3.3V and switch on SD card
  For Index = 0 To 2   'We allow 3 tries to intialize the SD card
        Response = SD_Init_FS_MSSP SD_SPI_FOSC_04
        If Response = 0 Then  'Init was OK   
             Return   'Init was good. Return to calling routine
        EndIf
        Next Index     'Next try to intitialize card
   Return    'Init was not good. Response <> 0. Return to calling routine
 '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 
'-----------------------------------------------------------
