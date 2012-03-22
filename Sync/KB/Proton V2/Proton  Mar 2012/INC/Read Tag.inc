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

Read_Tag:     GoSub High_V    'Change voltage from 3.3V to 5V
              High Green  'Yellow LED while we attempt to read RFID tag.
 			  High RED
             		
           
            Cls                                 
			Print At 1,1, "ATTEMPTING TO"       
			Print At 2,1, "READ TAG...."        

			High RFIDEnable		   	           ' Turn on RFID Reader
            Pause 10				           'Time for Reader to settle
            
            HSerIn 30000, Timeout, [Wait (0X82) ,Str TagIn]	 'Wait for header (0X82)  
            'Timeout in 30 sec..............
            HSerIn [CheckSum]                'Check Sum
            HSerIn [ETX]                      'End of Transmission (Footer...Should be 0X83)
		   	Low RFIDEnable		              ' Turn off RFID Reader
            If ETX <> 0X83 Then  GoTo Read_Tag 'Tag Footer was not correct
            
            For Index = 0 To 9              'Here we remove MSB from 8 bit Hex
                Byte_Var = Tagin[Index]
                Byte_Var.7 = 0
                TagIn[Index] = Byte_Var
            Next Index
            CWrite BUA, [TagIN[0], TagIN[1], TagIN[2], TagIN[3], TagIN[4], TagIN[5], TagIN[6], TagIN[7],TagIN[8], TagIN[9] ]
            For Index = 0 To 9
            Select TagIn[Index]
                   Case 48 To 57 
                   TagByte[Index] = TagIn[Index]-48
                   Case > 65 To 70 
                   TagByte[Index] = TagIn[Index]-55
                 
             End Select
             Next Index
             
            
           Mycount = (TagByte[4] << 4) + TagByte[5]
           Cls
           Print HEX MyCount 
             Stop
  
  Low Red
  High Green
Cls
Print "Thank You"	
Pause 1000
Response = 0
Low RFIDenable
Cls

Print At 1,1, HEX TagByte[0], HEX TagByte[1], HEX TagByte[2], HEX TagByte[3], HEX TagByte[4]


Print At 3,1, HEX CheckSum
Print At 4,1, HEX ETX
Stop
 Return	

Timeout:	Low RFIDEnable		   	 ' Turn off RFID Reader ..No Tag detected for 30 sec
	        
		    Cls                                
			Print At 1,1, "No Tag Detected"    
			DelayMS 2000    
            Response = 1
            Return
'................End of Read Tag Sub.......................................
