'****************************************************************
'*  Name    : Enable.INC                                      
'*  Author  : [Sam and Kim Bozman                    
'*  Notice  : Copyright (c) 2008 [Sam and Kim Bozman] 
'*          : All Rights Reserved                               
'*  Date    : 31/12/2008                                        
'*  Version : 1.1 Revision Oct 24/09                                              
'*  Notes   : Used with CR001B-K4 SERIES Proximity Reader Module                                                  
'*          :  Major Revision: June 3/10                                                
'****************************************************************
'NOTE:NOT TESTED
Enable_unit:	' The LV Detect has been completed and the RFID tag has been authorized and recorded.

		   Byte_Var = ERead DBO    'Get # of seconds to delay before operate 
		   If Byte_Var > 0 Then  'If delay before operate is greater than 0 seconds then...
		      
              For MyCount = 1 To Byte_var    'Count from 1 to # of seconds to delay before operate
		          High green   'Turn on Green LED
		          DelayMS 500  'Wait 1/2 sec
		          Low Green    'Turn Off Green LED
		          DelayMS 500   'Wait 1/2 sec
		      Next MyCount     'If we are not finished then repeat....
            EndIf   'Byte_var > 0
           'Now the delay before operate is done so we now enable the unit for time specified...........
           
           High Green        'Turn on Green LED
		   High RFIDEnable   'Enable Unit
		   
		   Byte_Var = ERead TOP
		   If Byte_Var < 2 Then Byte_Var = 2
		   
		   
