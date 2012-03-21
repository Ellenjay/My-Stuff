' Manchester ENCODE and DECODE, as well as CRC calculator

		Include "PROTON_G4.INT"				' Use an INTERNAL FONT
        
        Dim ENCODER_LOOP as Byte
        Dim CRC_LOOP as ENCODER_LOOP
        Dim TempVar as Byte
        Dim EncodedWord as Word
        Dim ERROR_FLAG as Bit       
        Dim CRC_OUT as Word
 		Dim CRC_IN as Byte
        
        Dim Y as Byte
		      
        Symbol CRCPolynomial = $1021 		' CRC-CCIT
        
        TempVar = %10001001
        Cls

        For Y = 0 to 255
            TempVar = Y
        	Print at 1,1,"TEMPVAR ", bin8 Tempvar
            Gosub Encode					' MANCHESTER ENCODE the value held in TEMPVAR. Result in ENCODEDWORD
        	Print at 2,1,"ENC ", bin16 ENCODEDWORD
        	Gosub Decode					' MANCHESTER DECODE the value held in ENCODEDWORD. Result in TEMPVAR
			Print at 5,1,"ERROR ",DEC ERROR_FLAG
        	CRC_IN = TempVar

            Gosub Calc_CRC					' Calculate a CRC of variable X. Result in CRC.HIGHBYTE
        	Print at 3,1,"CRC " , bin8 CRC_OUT
            
            CRC_IN = CRC_OUT.highbyte
        	Gosub Calc_CRC					' Calculate the CRC of variable X. Result in CRC.Lowbyte
        	
            Print at 4,1,"RESULT " , @CRC_OUT.lowbyte
        	Delayms 400
        Next
        Stop
'--------------------------------------------------------------------------------------------------
' Manchester Encode The byte value in TEMPVAR, and place the result in WORD variable ENCODEDWORD
' Note that:
' 1. TEMPVAR is the byte we want to encode
' 2. We will encode it into a 16 bit word, the low byte will contain the lower nibble of the encoded
' variable; ' the high byte will contain the upper nibble of the encoded variable
' 3. A “0” will be equated to a 0-1 transition
' 4. A “1” will be equated to 1-0 transition
' 5. The below subroutine will encode each 8-bit byte to a 16-bit word with an equal number of 1’s and 0’s.
' Run length is 1. The upside is that this is perfect for DC balancing the receiver’s bit slicer. The
' downside is that this results in doubling the bandwidth.

Encode:
        EncodedWord = 0
        Clear ENCODER_LOOP
        Repeat
			EncodedWord = EncodedWord << 2
            EncodedWord.0 = 1				' Default to Bit = 1
			EncodedWord.1 = 0
            If TempVar.0 = 0 Then 			
                EncodedWord.0 = 0			' Bit = 0
				EncodedWord.1 = 1					
			Endif	
            TempVar = TempVar >> 1
        	Inc ENCODER_LOOP
        Until ENCODER_LOOP > 7
        Return
'--------------------------------------------------------------------------------------------------
' Note that:
' 1. We will decode ENCODEDWORD (lower byte) as the lower nibble of TEMPVAR
' 2. ENCODEDWORD ( high byte) as the upper nibble of TEMPVAR
' 3. ERROR_FLAG will return SET is an invalid value was found i.e. 1-1 or 0-0 together

Decode:
        Clear ENCODER_LOOP
        Clear ERROR_FLAG
        Repeat
			TempVar = TempVar << 1
            If EncodedWord.0 = 0 Then If EncodedWord.1 = 1 Then	TempVar.0 = 0	' bit = 0
			If EncodedWord.0 = 1 Then If EncodedWord.1 = 0 Then	TempVar.0 = 1	' bit = 1
        	If EncodedWord.0 = 0 Then If EncodedWord.1 = 0 Then	Set ERROR_FLAG	' error in bit decode
            If EncodedWord.0 = 1 Then If EncodedWord.1 = 1 Then	Set ERROR_FLAG	' error in bit decode
            EncodedWord = EncodedWord >> 2
            Inc ENCODER_LOOP
        Until ENCODER_LOOP > 7
        Return
'--------------------------------------------------------------------------------------------------
' Calculate BYTE CRC; 16 bit crc based on CCIT polynomial
' Note:
' 1. The CRC polynomial was given in the Constant definition. Note that there is a plethora of material
' available on the internet about CRC calculations and the various polynomials used.
' 2. Caveat here: At the end of the CRC calculation on the transmitted data, the sum of the decoded CRC
' must equal to “0”. If the resulting CRC calculation is NOT 0 then there was a transmission error. Pay
' attention to the order in which you calculate the CRC when you transmit AND the order in which you
' calculate the CRC when you receive. Also when you transmit the CRC byte, remember to transmit
' High byte first. For further information, look at the below code.

Calc_CRC: 
		CRC_OUT = (CRC_IN * 256) ^ CRC_OUT
		Clear CRC_LOOP
        Repeat			
            ROL CRC_OUT , CLEAR           
            If STATUS.0 = 1 then 
                CRC_OUT = CRC_OUT ^ CRCPolynomial                
            Endif
            Inc CRC_LOOP
        Until CRC_LOOP > 7
		Return

        Include "FONT.INC"
        
