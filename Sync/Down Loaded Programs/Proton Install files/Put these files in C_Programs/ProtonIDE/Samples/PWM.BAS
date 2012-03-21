' Adjust the brightness of an LED attached to PORTB.0 using the PWM command		

		Device 16F877					' We'll use a 16F877 for this experimemt        
        XTAL = 20					' Choose a crystal frequency of 20MHz		
		
		Dim Loop as Byte

Inf:	Loop = 0						' Start the loop at 0
		Repeat							' Beginning of the loop
			PWM PortB.0,Loop,20			' Output the value in loop for 20ms
			Inc Loop					' Increment the loop counter
        Until Loop = 255				' Loop until 255 revolutions

		Repeat							' Loop still contains 255
			PWM PortB.0,Loop,20			' Output the value in loop for 20ms
			Dec Loop					' Decrement the loop counter
        Until Loop = 0        			' Loop until 255 revolutions
		Goto Inf						' Do it forever