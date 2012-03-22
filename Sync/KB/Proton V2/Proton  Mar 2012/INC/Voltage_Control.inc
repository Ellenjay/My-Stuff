'****************************************************************
'*  Name    : Voltage and SD control subroutines                                    
'*  Author  : [Sam and Kim Bozman]                              
'*  Notice  : Copyright (c) 2009 [Sam and Kim Bozman]           
'*          : All Rights Reserved                               
'*  Date    : March 16/2011                                        
'*  Version : 1.0                                               
'*  Notes   :                                                 
'*          :                                                   
'****************************************************************
Low_V:  
    Input VC  'Set Voltage control pin High Impedance (3.5V)
    Low SDC  'Turn power ON to SD card
 Return
   
High_V:
    High SDC 'Turn power off to SD card
    Low VC   'Set Voltage control pin Low (5V)
Return
