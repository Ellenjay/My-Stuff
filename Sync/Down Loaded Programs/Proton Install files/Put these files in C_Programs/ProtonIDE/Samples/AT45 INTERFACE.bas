
' Interface with Atmel AT45321 4MB eeprom.
' Using the PROTON+ compiler Version 2.1
'
' This program provides a virtually continuous write operation
' using 1 buffer of the Atmel AT45DB321 to program all pages.
'
' 8-bit serial output on SI and 8-bit serial input on SO uses SHIN and SHOUT commands.
'
'
' Don't forget that the AT45321 is a 3.3 to 3.6V device
' 
' A simple voltage adapter from 5 Volts to approx 3.6 Volts is shown below
'
' 
' 5 Volts in ______|\|____|\|____ Approx 3.6 Volts out
'               |  |/|    |/|  |
'               |              |
'              ---            ---
'              ---            ---
'               |              |
'               |              |
'              Gnd            Gnd
'
' Diodes are 1N4148 types, and capacitors are 100nF
' Each diode drops at least 0.7 of a Volt. Multiply that by two
' and there is a 1.4 Volt drop accross both diodes.
' 5 Volts - 1.4 Volts gives 3.6 Volts
' Voltages may vary due to diode characteristics
'
' The PICmicro will readily accept a 3 Volt input from the eeprom's SO line
' But an arrangement similar to the above circuit
' may be required for the SI line from the PICmicro

		Include "PROTON_20.INC"
        
        Symbol CS = PORTB.0								' To Eeprom CS line						
		Symbol CLK = PORTB.1							' To Eeprom CLK line
		Symbol SI = PORTB.2								' To Eeprom SI line
		Symbol SO = PORTB.3								' To Eeprom SO line

		Symbol B1_Write = %10000100						' Definition of AT45DB321 commands
		Symbol B1_Read = %11010100						' See the datasheet for details
		Symbol B2_Write = %10000111						' Downloadable from www.atmel.com
		Symbol B1ToMemWrite = %10000011
		Symbol B2ToMemWrite = %10000110
		Symbol Mem_Read = %11010010
        Symbol StatusRegOC = %11010111
        Symbol DCARE = %00000000						' Don't Care value

        Dim AT_ADDRESS as Word							' address within buffer
        Dim AT_DATA_BYTE as Byte 						' Byte read and written to eeprom      
        Dim AT_BADDRESS as Word							' Address within page
  		Dim AT_PAGE_ADDRESS as Word						' Page of interest                   
		Dim AT_STAT as Byte								' Used in CHECKSTATUS subroutine
'----------------------------------------------------------------------- 
       
        Delayms 500										' Wait for the PICmicro to stabilise
        Goto Main										' Jump over the subroutines
        
'----[CHECK BUSY STATUS]------------------------------------------------
' Read the STATUS bit of the eeprom
' Loop until ready for next opcode or operation
CHECKSTATUS:
  		'Output CS										' Ensure CS line is an output
        Set CS											' Bring CS High
  		Low CLK											' Make sure CLK is low
  		Low SI											' Bring SI low
  		Clear CS										' Bring CS Low to initiate
  		ShOut SI,CLK,MSBFIRST,[StatusRegOC\8]		    ' Send the STATUS command
  		Repeat											' Create a loop
    		Shin SO,CLK, MSBPRE,[AT_STAT\8]			    ' Read status register byte
  		Until AT_STAT.7 = 1								' Loop until eeprom is ready
  		Set CS											' Bring CS High
		Return 
                
'-----[WRITE BUFFER]-----------------------------------------------------
' Write the contents of "AT_DATA_BYTE" into buffer 1
' AT_ADDRESS holds the address within the buffer	
WRITEBUFFER:        
  		Output CS										' Ensure CS line is an output
  		Set CS											' Bring CS High
  		Low CLK											' Make sure CLK is low
  		Low SI											' Bring SI low
  		Clear CS										' Bring CS Low to initiate
  		Shout SI,CLK,MSBFIRST,[B1_Write\8,_			    ' Write the byte to buffer 1
        						  DCARE\8,_
        						  AT_ADDRESS.Highbyte & %00000011\8,_
                                  AT_ADDRESS.Lowbyte\8,_
                                  AT_DATA_BYTE\8]
  		Set CS											' End session
		Return
        
'------[BUFFER TO MEMORY]--------------------------------------------------
' Transfer buffer 1 to memory, (with erase)
' AT_PAGE_ADDRESS holds the page of interest
BUFFERTOMEM:
		'Output CS										' Ensure CS line is an output
  		Set CS											' Bring CS High
  		Low CLK											' Make sure CLK is low
  		Low SI											' Bring SI low
  		Clear CS										' Bring CS Low to initiate
  		Shout SI,CLK,MSBFIRST,[B1ToMemWrite\8,_	    	' Transfer the buffer to memory
        						 DCARE\1,_
        					     (AT_PAGE_ADDRESS.Highbyte & %00011111) << 3\5,_
                                 AT_PAGE_ADDRESS.Lowbyte\8,_
                                 DCARE\10]             
  		Set CS											' End session
  		Gosub CheckStatus								' Monitor RDY/BUSY
		Return
         
'----[READ MEM PAGE]----------------------------------------------------
' AT_PAGE_ADDRESS holds the page of interest
' AT_BADDRESS holds the address within a page
' Return data in "AT_DATA_BYTE"
READMEMPAGE:
		Output CS										' Ensure CS line is an output  
  		Set CS											' Bring CS High
  		Low CLK											' Make sure CLK is low
  		Low SI											' Bring MOSI low
  		Clear CS										' Bring CS Low to initiate
  		ShOut SI, CLK, MSBFIRST,[Mem_Read\8,_		    ' Read the byte from eeprom
        						    DCARE\1,_
                                    (AT_PAGE_ADDRESS.Highbyte & %00011111) << 3\5,_
                                    AT_PAGE_ADDRESS.Lowbyte\8,_
                                    (AT_BADDRESS.Highbyte & %00000011) << 6\2,_
                                    AT_BADDRESS.Lowbyte\8,_
                                    DCARE\16,_
                                    DCARE\16]
  		ShIn SO, CLK, MSBPRE,[AT_DATA_BYTE\8]		    ' Read data byte
  		Set CS 											' Bring CS High to end session
		Return 
                     
'----[MAIN PROGRAM LOOP STARTS HERE]------------------------------------ 
' Fill all 8192 pages with data
' Then read them all back and display serially on the Serial Terminal       
MAIN:  		
        AT_PAGE_ADDRESS = 0
        Repeat											' Create a loop for all the pages
    		AT_BADDRESS = 0
            Repeat										' Create a loop for the bytes in the buffer					
      			AT_DATA_BYTE = AT_BADDRESS 				' Load the byte to write with some data	
                AT_ADDRESS = AT_BADDRESS				' Point to address within page
                Gosub WRITEBUFFER 						' Write the byte to buffer 1
    			Inc AT_BADDRESS
            Until AT_BADDRESS > 527						' Loop until all bytes are written to buffer

    		Gosub CHECKSTATUS							' Monitor RDY/BUSY of eeprom
            Gosub BUFFERTOMEM							' Transfer data from Buffer 1 to Memory
			HRsout "WRITING PAGE : " , DEC AT_PAGE_ADDRESS,13
        	Inc AT_PAGE_ADDRESS
        Until AT_PAGE_ADDRESS > 8 '191					' Finish when all pages are full

' Read all the pages back, and display serially				
    	AT_PAGE_ADDRESS = 0
        Repeat											' Create a loop for all the pages
        	HRsout 1 : Delayms 10
            HRsout 13,"READING PAGE : " ,DEC AT_PAGE_ADDRESS,13
            AT_BADDRESS = 0
            Repeat										' Create a loop for the bytes in a page
      			Gosub READMEMPAGE						' Read a byte from a PAGE
                HRsout HEX2 AT_DATA_BYTE				' Display the byte read as HEX
      			If (AT_BADDRESS + 1) // 20 <> 0 Then	' Display 20 values to a line
        			HRsout " "							' Output a space character
      			Else
        			HRsout 13							' Output a newline character
      			EndIf
                Inc AT_BADDRESS
            Until AT_BADDRESS > 527						' Loop until all bytes read from page
    		HRsout 13,1
  			Delayms 10
            Inc AT_PAGE_ADDRESS
        Until AT_PAGE_ADDRESS > 8191					' Loop until all pages displayed
       
 		Stop 
              
