'
' Test ADPCM encoder and decoder CODE using only BASIC commands
' Suitable for both 14 and 16-bit core devices

		Include "PROTON18_4.INC"
		
        
		Dim PREV_SAMPLE as Word         					' Previous Predicted sample
		Dim PREV_INDEX as Byte          					' Previous index into step size table
		Dim DIFFERENCE as Word          					' Difference between sample and predicted sample
		Dim Q_STEP as Word              					' Quantizer step size
		Dim PRED_SAMPLE as Word         					' Signed 16-bit Output of ADPCM Decoder
		Dim Q_DIFF as Word              					' Dequantized predicted difference
		Dim STEP_INDEX as Byte          					' Index into step size table
		Dim PCM_CODE as Byte            					' Signed 4-bit ADPCM output value
		Dim SAMPLE as Word 									' Signed 16-bit value to encode	
		Dim TEMP_ADDRESS_01 as Byte							' Temporary variable for calculations
		
        Dim TEST_LOOP as Word								' Used for Demonstration loop
        
    	Goto MAIN_PROGRAM_LOOP								' Jump over the subroutines

'------------------------------------------------------------------------------------------------
' ADPCM Encoder
' Input		: Signed 16-bit linear value in SAMPLE
' Output	: Signed magnitude 4-bit result in PCM_CODE                          
ADPCM_ENCODE:

    	PRED_SAMPLE = PREV_SAMPLE
		STEP_INDEX = PREV_INDEX
	
    	Q_STEP = Lread16 StepSizeTable[STEP_INDEX]

' Compute the difference between the actual sample (SAMPLE) and the predicted sample (PRED_SAMPLE)
		DIFFERENCE = SAMPLE - PRED_SAMPLE
		PCM_CODE = 0										' Default to a value of 0 for PCM_CODE
        If DIFFERENCE.15 = 1 Then							' Is the difference less than 0 ?
			PCM_CODE = 8									' Yes. So set PCM_CODE to 8
			DIFFERENCE = -DIFFERENCE						' Make positive the negative value. i.e. ABS
		Endif

' Quantize the difference into the 4-bit ADPCM PCM_CODE using the quantizer Q_STEP size
' Inverse quantize the ADPCM PCM_CODE into a predicted difference using the quantizer Q_STEP size
		Q_DIFF = Q_STEP >> 3
		If DIFFERENCE >= Q_STEP Then
			PCM_CODE = PCM_CODE | 4
			DIFFERENCE = DIFFERENCE - Q_STEP
			Q_DIFF = Q_DIFF + Q_STEP
		Endif
    
		Q_STEP = Q_STEP >> 1
		If DIFFERENCE >= Q_STEP Then
			PCM_CODE = PCM_CODE | 2
			DIFFERENCE = DIFFERENCE - Q_STEP
			Q_DIFF = Q_DIFF + Q_STEP
		Endif
    	
		Q_STEP = Q_STEP >> 1
		If DIFFERENCE >= Q_STEP Then
			PCM_CODE = PCM_CODE | 1
			Q_DIFF = Q_DIFF + Q_STEP
		Endif

' Fixed predictor computes new predicted sample by adding the old predicted sample to predicted difference
		If PCM_CODE.3 = 1 Then
        	PRED_SAMPLE = PRED_SAMPLE - Q_DIFF
		Else
			PRED_SAMPLE = PRED_SAMPLE + Q_DIFF
		Endif

' Find new quantizer stepsize index by adding the old index to a table lookup using the ADPCM PCM_CODE
		TEMP_ADDRESS_01 = Lread8 IndexTable[PCM_CODE]
		STEP_INDEX = STEP_INDEX + TEMP_ADDRESS_01

' Check for overflow of the new quantizer Q_STEP size index
		If STEP_INDEX.7 = 1 Then STEP_INDEX = 0			' Check for less than 0
		If STEP_INDEX > 88 Then STEP_INDEX = 88

' Save the predicted sample and quantizer Q_STEP size index for next iteration
		PREV_SAMPLE = PRED_SAMPLE
		PREV_INDEX = STEP_INDEX

		PCM_CODE = PCM_CODE & $0F   
    	Return
        
'---------------------------------------------------------------------------------------
' Experimental ADPCM decoder
' Input		: Signed magnitude 4-bit value in lower bits of PCM_CODE
' Output	: Signed 16-bit linear value in PREDSAMPLE

ADPCM_DECODE:

' Restore previous values of predicted sample and quantizer Q_STEP size index
    	PRED_SAMPLE = PREV_SAMPLE
		STEP_INDEX = PREV_INDEX

' Find quantizer Q_STEP size from lookup table using index

    	Q_STEP = Lread16 StepSizeTable[STEP_INDEX]
        
' Inverse quantize the ADPCM PCM_CODE into a difference using the quantizer Q_STEP size

		Q_DIFF = Q_STEP >> 3
		If PCM_CODE.2 = 1 Then Q_DIFF = Q_DIFF + Q_STEP
		If PCM_CODE.1 = 1 Then Q_DIFF = Q_DIFF + (Q_STEP >> 1)
		If PCM_CODE.0 = 1 Then Q_DIFF = Q_DIFF + (Q_STEP >> 2)

' Add the difference to the predicted sample
		If PCM_CODE.3 = 1 Then
			PRED_SAMPLE = PRED_SAMPLE - Q_DIFF
		Else
			PRED_SAMPLE = PRED_SAMPLE + Q_DIFF
		Endif
	
' Find new quantizer Q_STEP size by adding the old index and a table lookup using the ADPCM PCM_CODE
		TEMP_ADDRESS_01 = Lread8 IndexTable[PCM_CODE]
		STEP_INDEX = STEP_INDEX + TEMP_ADDRESS_01
        
' Check for overflow of the new quantizer Q_STEP size index
		If STEP_INDEX.7 = 1 Then STEP_INDEX = 0			' Check for less than 0
		If STEP_INDEX > 88 Then STEP_INDEX = 88


' Save predicted sample and quantizer Q_STEP size index for next iteration
		PREV_SAMPLE = PRED_SAMPLE
		PREV_INDEX = STEP_INDEX
    	Return
 
' Create two tables for both the encoder and decoder to use       
IndexTable:	
		LDATA as Byte $FF, $FF, $FF, $FF, 2, 4, 6, 8,$FF, $FF, $FF, $FF, 2, 4, 6, 8
StepSizeTable: 
		LDATA as Word 7, 8, 9, 10, 11, 12, 13, 14, 16, 17,_
    				  19, 21, 23, 25, 28, 31, 34, 37, 41, 45,_
    				  50, 55, 60, 66, 73, 80, 88, 97, 107, 118,_
    				  130, 143, 157, 173, 190, 209, 230, 253, 279, 307,_
    				  337, 371, 408, 449, 494, 544, 598, 658, 724, 796,_
    				  876, 963, 1060, 1166, 1282, 1411, 1552, 1707, 1878, 2066,_
    				  2272, 2499, 2749, 3024, 3327, 3660, 4026, 4428, 4871, 5358,_
    				  5894, 6484, 7132, 7845, 8630, 9493, 10442, 11487, 12635, 13899,_
    				  15289, 16818, 18500, 20350, 22385, 24623, 27086, 29794, 32767 
                         
'----------------------------------------------------------------------------------------    
' Demonstration code loop starts here
' This forms a loop from 0 to 32767. Each value of the loop is first encoded and displayed
' then decoded and displayed on the LCD. The decoded value should track the loop value.   
MAIN_PROGRAM_LOOP:

		Cls
        PREV_SAMPLE = 0								' Reset PREV_SAMPLE
        PREV_INDEX = 0								' Reset PREV_INDEX
        TEST_LOOP = 0
        Repeat										' Create a loop
            SAMPLE = TEST_LOOP						' Place the sample to encode into SAMPLE
        	Gosub ADPCM_ENCODE						' Encode the value
        	Print at 1,1,SDec TEST_LOOP , ":" ,Dec PCM_CODE, "    " ' Display the loop and the encoded value
            Gosub ADPCM_DECODE						' Decode the value held in PCM_CODE
            Print at 2,1,SDec TEST_LOOP , ":" ,SDec PRED_SAMPLE, "    " ' Display the loop and the decoded value
            TEST_LOOP = TEST_LOOP + 5
            Delayms 200								' Slow things down so we can see the values on the LCD
        Until TEST_LOOP > 32767
        Stop

