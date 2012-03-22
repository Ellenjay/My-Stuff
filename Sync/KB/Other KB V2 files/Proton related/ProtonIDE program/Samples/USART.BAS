' Read and write the hardware USART

		Device 16F877
		XTAL = 4
		Dim B1	as Byte
		
        TRISC = %10111111       		' Set TX (PortC.6) to output
        SPBRG = 25              		' Set baud rate to 2400
        RCSTA = %10010000       		' Enable serial continuous receive
        TXSTA = %00100000       		' Enable transmit asynchronous mode
        
' Echo received characters in an infinite loop
Loop:   Gosub GetChar            		' Get a character from serial input
        If B1 = 0 Then Loop     		' No character yet
        Gosub PutChar           		' Send character to serial output
        Goto Loop               		' Do it forever
        
' Get a character from the USART receiver
GetChar: B1 = 0                  		' Preset to no character received
        If PIR1.5 = 1 Then B1 = RCREG   ' If receive flag then get character
  		Return                  		' Go back to caller
  		
' Send a character to the USART transmitter
PutChar: If PIR1.4 = 0 Then PutChar     ' Wait for transmit register empty
        TXREG = B1              		' Send character to transmit register
        Return                  		' Go back to caller
