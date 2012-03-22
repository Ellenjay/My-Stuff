' Display the result of POT

		Device 16F84
        XTAL = 4       
        RSOUT_PIN = PortB.0        

        Dim Result as Byte       

		Rsout Cls						' Clear the serial LCD
Inf:	Result = Pot PortB.1,255		' Read the potentiometer
		Rsout at 1,1,@Result,"  "		' Display the result
		Delayms 100						' A small delay
        Goto Inf						' Do it forever
        