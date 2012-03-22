'****************************************************************
'*  Name    : Read Tag.INC                                      
'*  Author  : [Sam and Kim Bozman                    
'*  Notice  : Copyright (c) 2008 [Sam and Kim Bozman] 
'*          : All Rights Reserved                               
'*  Date    : 31/12/2008                                        
'*  Version : 1.1 Revision Oct 24/09                                              
'*  Notes   : Used with CR001B-K4 SERIES Proximity Reader Module                                                  
'*          :                                                   
'****************************************************************
Read_Tag:		
            Cls                                 
			Print At 1,1, "ATTEMPTING TO"       
			Print At 2,1, "READ TAG...."        

            
			High RFIDEnable		   	           ' Turn on RFID Reader
            Pause 10				           'Time for Reader to settle
            
            HSerIn 30000, Timeout, [Wait (0X82) ,Str TagIn]	 'Wait for header (0X82)
            'Timeout in 30 sec..............
            'HSerIn [CheckSum]                'Check Sum (NOT USED)
            HSerIn [Response]                      'End of Transmission (Footer...Should be 0X83)
		   	Low RFIDEnable		              ' Turn off RFID Reader
            If Response <> 0X83 Then  GoTo Read_Tag 'Tag Footer was not correct
        
            
  'NOTE: because of the strange way the CR001B-K4 reader module outputs it's ID number..
  'we have to do some bit manipulation to get the correct format************************
                      
 For Index = 0 To 9
   Select TagIn[Index]
        Case 0XB0 To 0XB9
            TV1 = TagIn[Index]
            ClearBit TV1 , 7
            TagIn[Index] = TV1

        Case 0X81 To 0X86 	
            TV1 = TagIn[Index]
            ClearBit TV1 , 7
            SetBit TV1, 6
             TagIn[Index] = TV1
        
    End Select
  Next Index
'*************************************************************************************************

Cls
Print "Thank You"	
 Return	

Timeout:	Low RFIDEnable		   	 ' Turn off RFID Reader ..No Tag detected for 30 sec
	
		    Cls                                
			Print At 1,1, "No Tag Detected"    
			DelayMS 2000   'EVENTUALLY WE MUST GET RID OF THE PAUSE. 
            Sleep          'EVENTUALLY WE MUST INFORM THE USER HIS TAG FAILED.
   
'................End of Read Tag Sub.......................................

