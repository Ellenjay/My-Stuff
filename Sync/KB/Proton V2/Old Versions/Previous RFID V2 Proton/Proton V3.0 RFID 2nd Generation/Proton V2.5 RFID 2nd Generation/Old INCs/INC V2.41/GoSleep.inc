GoSleep:	'(For Interupt on PortB.0 read about SLEEP in help)
			
		Cls
		Print At 1,1, "Going to sleep.."
		Pause 2000
		INTCON.4 = 1	'Allow a the pulse on PortB.0 to wake program from sleep
		INTCON.1 = 0 	'Clear the interrupt flag for PortB.0
		'Low Red	   		'Turn off the Tri-Led
		'Low Green		'Turn off the Tri-Led
		Sleep  		'Chip goes into low power until it is triggered by a High to Low pulse on PortB.0
		INTCON.4 = 0	'Stop any pulse from waking up program cause we just woke up			
		Cls
		Print At 1,1, "I just woke up!!"
		' here we know that a jumpstart woke up this program since the AND gate is the
		'only thing that would wake it. Therefore we will write a '000000' to history and
		'then wait 60 seconds before going back to sleep.

		Pause 2000
		'CE[0] = 0
		'CE[1] = 0
		'CE[2] = 0
		 
		'GoSub WriteH  		  'Here we will go write "000000" into the history file
		
		'DelayMS 60000 		  'Wait until unit has been started
		GoTo GoSleep  		  'Go back to sleep
