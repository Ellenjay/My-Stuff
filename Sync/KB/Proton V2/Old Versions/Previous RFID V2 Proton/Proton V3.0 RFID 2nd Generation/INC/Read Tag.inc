'****************************************************************
'*  Name    : Read Tag.INC                                      
'*  Author  : [Sam and Kim Bozman                    
'*  Notice  : Copyright (c) 2008 [Sam and Kim Bozman] 
'*          : All Rights Reserved                               
'*  Date    : 31/12/2008                                        
'*  Version : 1.1 Revision Oct 24/09                                              
'*  Notes   : Used with CR001B-K4 SERIES Proximity Reader Module                                                  
'*          :  Major Revision: April 6/10                                                 
'****************************************************************
'NOTE:NOT TESTED

Read_Tag:		
            Cls                                 
			Print At 1,1, "ATTEMPTING TO"       
			Print At 2,1, "READ TAG...."        

            
			High RFIDEnable		   	           ' Turn on RFID Reader
            Pause 10				           'Time for Reader to settle
            
            HSerIn 30000, Timeout, [Wait (0X82) ,Str TagIn]	 'Wait for header (0X82)
            HSerIn [Response]                      'End of Transmission (Footer...Should be 0X83)
		   	Low RFIDEnable		              ' Turn off RFID Reader
            If Response <> 0X83 Then  GoTo Read_Tag 'Tag Footer was not correct
        
            
  'NOTE: because of the strange way the CR001B-K4 reader module outputs it's ID number..
  'we have to do some bit manipulation to get the correct format************************
                      
 For Index = 0 To 9
   Select TagIn[Index]
        Case 0XB0 To 0XB9
            Byte_Var = TagIn[Index]
            ClearBit Byte_Var , 7
            TagIn[Index] = Byte_Var

        Case 0X81 To 0X86 	
            Byte_Var = TagIn[Index]
            ClearBit Byte_Var , 7
            SetBit Byte_Var, 6
             TagIn[Index] = Byte_Var
        
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

