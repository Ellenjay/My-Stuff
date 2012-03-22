'============= StartUnit==================================================
StartUnit:	'Here we will turn on Orange LED
			High Green
 			High RED
			
			GoSub ReadAgain   	  ' Go Read Tag
		  	GoSub CheckTag
			IF Flag = 0 then		  'Tag is not in table
			   CLS
			   Print AT 1,1, "Tag not found"
			   'Here we will flash LED red fast
			   
			   Low Green
			   For Index = 0 to 10
			   	   Toggle Red
			   	   DELAYMS 300  
			   Next 'Index = 0 to 10
			   Low Red
		   		Goto GoSleep
			
		 ENDIF 'Flag = 0
			
			CLS
			Print AT 1,1, "Unit can now"
			Print AT 2,1, "be started!"
			For Index = 0 to 2	 	       			   'Get User # that is starting Unit
			  CE[Index] = EREAD INDEX2 + INDEX
			Next 'Index
			
			Gosub WriteH   	 	   		  'Go write the User into the history file
			HIGH StartEnable				'Turn On Start Relay
			
			'We now flash Green Led 10 twice and then on steady.
			Low Red
			Low Green
			For Index = 0 to 5
			Toggle Green
			DELAYMS 300  
			Next Index		
			High Green
			
			DelayMS 60000		'Leave start relay on for 60 sec
			LOW StartEnable					'Shut off Start Relay
			Low Green						'Shut off the Green Led
			CLS
			   
		   		  Goto GoSleep					'Sleep Forever
		
		

Timeout2:	High RFIDEnable		   	 ' Turn off RFID Reader ..No Tag detected for 30 sec
			'Here we will flash LED red fast
			Low Green
			For Index = 0 to 10
			Toggle Red
			DELAYMS 300  
			Next Index
			Low Red
		   		  Goto GoSleep
			  
			   