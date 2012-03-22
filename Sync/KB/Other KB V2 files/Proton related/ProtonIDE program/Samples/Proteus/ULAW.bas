'
' ULaw Audio Encoder/Decoder
'
' This version is suitable for both 14 and 16-bit core devices

		Include "PROTON_4.INC"
        
		Symbol BIAS = $84   ' define the add-in bias for 16 bit samples */
		Symbol CLIP = 32635

		Dim SAMPLE as Word
  		Dim SIGN as Byte
  		Dim EXPONENT as Byte
  		Dim MANTISSA as Byte
  		Dim ULAW_BYTE as Byte
  		Dim LOOP as Word      
        Dim PBP#VAR1 as Byte SYSTEM						' Create a temporary variable that can also be used by the compiler internally
  	
    	Goto MAIN_PROGRAM_LOOP							' Jump over the subroutines

'---------------------------------------------------------------------------  	
' ULAW Encoder
' Input		: Signed 16-bit linear value held in SAMPLE
' Output	: 8-bit ulaw sample retuned in ULAW_BYTE

ULAW_ENCODER:
  		' Get the sample into sign-magnitude. 
  		SIGN = SAMPLE.Highbyte							' Extract the high byte of the SAMPLE				 
  		SIGN = SIGN & $80								' Extract the sign of the value
        If SAMPLE.15 = 1 Then SAMPLE = -SAMPLE			' Make positive 
  		If SAMPLE > CLIP Then SAMPLE = CLIP				' Clip the magnitude  
  		SAMPLE = SAMPLE + BIAS							' Add the bias
  		PBP#VAR1 = SAMPLE >> 7   						' Build the index to the 8-bit table     
        EXPONENT = Lread8 EXP_LUT[PBP#VAR1]
  		PBP#VAR1 = EXPONENT + 3
        MANTISSA = SAMPLE >> PBP#VAR1
  		MANTISSA = MANTISSA & $0F
  		PBP#VAR1 = EXPONENT << 4
        ULAW_BYTE = SIGN | PBP#VAR1
        ULAW_BYTE = ULAW_BYTE | MANTISSA
  		Return
exp_lut: 
		LDATA as Byte 	0,0,1,1,2,2,2,2,3,3,3,3,3,3,3,3,_
						4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,_
                		5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,_
                		5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,_
                		6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,_
                		6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,_
                		6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,_
                		6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,_
                		7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,_
                		7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,_
                		7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,_
                		7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,_
                		7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,_
                		7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,_
                		7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,_
                		7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7
                
'---------------------------------------------------------------------------
' ULAW Decoder
' Input		: 8-bit ulaw sample held in ULAW_BYTE
' Output	: Signed 16-bit linear sample in SAMPLE

ULAW_DECODER:
  		EXPONENT = ULAW_BYTE >> 4							' Extract the upper 4-bits of ULAW_BYTE
  		EXPONENT = EXPONENT & 7								' Remove the sign bit
  		MANTISSA = ULAW_BYTE & $0F							' Extract the lower 4-bits of ULAW_BYTE
  		PBP#VAR1 = EXPONENT * 2								' Build index to 16-bit table
        SAMPLE = Lread8 EXP_LUT2[PBP#VAR1]					' Read the sample from the table
  		EXPONENT = EXPONENT + 3
  		SAMPLE = SAMPLE + (MANTISSA << EXPONENT)
  		If ULAW_BYTE.7 = 1 Then SAMPLE = -SAMPLE			' Test the sign bit of ULAW_BYTE
  		Return  
exp_lut2: LDATA as Word 0,132,396,924,1980,4092,8316,16764		
	
'----------------------------------------------------------------------------
' Demonstration code loop starts here
' This forms a loop from 0 to 32767. Each value of the loop is first encoded and displayed
' then decoded and displayed on the LCD. The decoded value should track the loop value. 

MAIN_PROGRAM_LOOP:
        Cls
		For LOOP = 0 to 32767
        	SAMPLE = LOOP
  			Gosub ULAW_ENCODER						' Encode the value held in SAMPLE
  			Print at 1,1,SDec LOOP," : ",SDec ULAW_BYTE,"   "
  			Gosub ULAW_DECODER						' Decode the value held in ULAW_BYTE
  			Print at 2,1,SDec LOOP," : ",SDec SAMPLE,"   "
  			Delayms 100
  		Next 	
  		Stop	
	
	 		
