' Demonstrate the RCIN command

		Device 16F877
        XTAL = 20        
        RSOUT_PIN = PORTB.0
        
        Dim Result as Word        
        Rsout Cls
Inf:	High PortB.1
        Delayms 2
        Result = RCIN PortB.1,High
        Rsout at 1,1,@Result,"  "
        Goto Inf