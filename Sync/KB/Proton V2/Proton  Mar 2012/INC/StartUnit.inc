'============= StartUnit==================================================
StartUnit:	
			Cls
			Print At 1,1, "Unit can now"
			Print At 2,1, "be started!"
			Pause 2000
		    GoSub Write_UH    'Write current user into User history
			Byte_Var = ERead DBO  'Get 'Delay Before Operate' time in seconds
			Low Green             'Turn on Red Led
			High Red
			DelayMS Byte_Var      'Delay operate for # of seconds stored in DBO 9Max 255 seconds)
            High StartEnable				'Turn On Start Relay
			Low Red
            High Green
			Byte_Var = ERead TOP
			DelayMS Byte_Var		'Leave start relay on for time stored in TOP (Max 255 seconds)
			Low StartEnable					'Shut off Start Relay
			Low Green						'Shut off the Green Led
		
			   
GoTo SleepNow
		
		

'Timeout2:	High RFIDEnable		   	 ' Turn off RFID Reader ..No Tag detected for 30 sec
			'Here we will flash LED red fast
'			Low Green
'			For Index = 0 To 10
'			Toggle Red
'			DelayMS 300  
'			Next Index
'			Low Red
'		   		  GoTo GoSleep
			  
			   
