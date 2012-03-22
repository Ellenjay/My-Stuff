'=================Read Tag Subroutine========================================

  Read_Tag:  Cls                                 
			Print At 1,1, "ATTEMPTING TO"       
			Print At 2,1, "READ TAG...."  
  
             High Red		
             

            
Readagain:		      Low RFIDEnable		   	           ' Turn on RFID Reader
            Pause 10				           'Time for Reader to settle
            
            HSerIn 30000, Timeout, [Wait (0x0A) ,Str TagIn]	 'Wait for header (0X82)
            'Timeout in 30 sec..............
            HSerIn [CheckSum]                'Check Sum
            HSerIn [ETX]                      'End of Transmission (Footer...Should be 0X83)
		   	Low RFIDEnable		              ' Turn off RFID Reader
            If ETX <> 0X83 Then  
              Cls                                
			Print At 1,1, "footer Bad" 
            GoTo Readagain 'Tag Footer was not correct
            End If


  Low Red
  High Green
Cls
Print "Thank You"	
Pause 1000
 Return	

Timeout:	Low RFIDEnable		   	 ' Turn off RFID Reader ..No Tag detected for 30 sec
	
		    Cls                                
			Print At 1,1, "No Tag Detected"    
			DelayMS 2000    
            Sleep
   
   

