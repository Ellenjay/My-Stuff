
' Bubble sort demonstration for the PROTON+ Compiler version 2.1 onwards
	
    	Include "PROTON18_4.INC"
                   
        Symbol SAMPLES_TO_TAKE = 6				' The amount of samples to take
        
        Dim SWAPTMP As Byte						' Temporary variable for swapping
        Dim INDEX As Byte						' Holds the position in the sort     
        Dim SWAP_OCCURED As Bit					' Indicates if the sort is complete
        Dim SAMPLE[SAMPLES_TO_TAKE + 1] As Byte ' Create an array to hold the samples
        
'       Delayms 200								' Wait for the PICmicro to stabilise
'        Clear									' Clear all memeory before we start
'        Cls										' Clear the LCD
'        STR SAMPLE = 149, 150, 1, 151, 150, 0, 150 ' Load the array with values

        GoSub BUBBLE_SORT						' Do the bubble sort
        ' Display the sorted list
'        Print at 1,1,Dec SAMPLE[0],":",Dec SAMPLE[1],":",Dec SAMPLE[2],":",Dec SAMPLE[3]
'        Print at 2,1,Dec SAMPLE[4],":",Dec SAMPLE[5],":",Dec SAMPLE[6]
        Stop
        
'--------------------------------------------------------------------        
' This subroutine implements  a technique called "bubble sort."  
BUBBLE_SORT: 
  		Repeat
        	SWAP_OCCURED = 0								' Clear flag that indicates swap. 								
  			INDEX = 0
            Repeat											' For each cell of the array...
            	If SAMPLE[INDEX] > SAMPLE[INDEX + 1] Then  	' Move larger values up. 
    				SWAPTMP = SAMPLE[INDEX]					' ..by swapping them. 
    				SAMPLE[INDEX] = SAMPLE[INDEX + 1]
    				SAMPLE[INDEX + 1] = SWAPTMP
    				SWAP_OCCURED = 1						' Set bit if swap occurred.  
				EndIf
				Inc INDEX
            Until INDEX = SAMPLES_TO_TAKE					' Check next cell of the array. 
		Until SWAP_OCCURED = 0								' Keep sorting until no more swaps. 
		Return					
