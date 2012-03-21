'
' Bubble sort demonstration for the PROTON+ Compiler version 2.1 onwards
'
' Fills an array with 256 random 8-bit values, then sorts and displays the result on the serial terminal.
' The array will be sorted lowest value first
'	
    	Include "PROTON18_20.INC"
                  
        Symbol SAMPLES_TO_TAKE = 255				' The amount of samples to take
        
        Dim SWAPTMP As Byte							' Temporary variable for swapping
        Dim INDEX As Byte							' Holds the position in the sort     
        Dim COLUMN As Byte
		Dim SWAP_OCCURED As Bit						' Indicates if the sort is complete
        Dim SAMPLE[SAMPLES_TO_TAKE + 1] As Byte 	' Create an array to hold the samples
        
        DelayMS 200									' Wait for the PICmicro to stabilise
        Clear										' Clear all memeory before we start
        COLUMN = 1                                	' Reset the column value
		Seed $3145									' Seed the random number generator
     	
        HSerOut ["Sorting. Please Wait.",13,"---------------------",13,13]
      
' Load the array with random values
		For INDEX = 0 To SAMPLES_TO_TAKE			' Create a loop for all the elements in the array
        	SAMPLE[INDEX] = Random					' Fill the array with a random 8-bit value
        Next
        GoSub BUBBLE_SORT							' Do the bubble sort
        
' Display the sorted list
        HSerOut ["Sorted List of Values.",13,"----------------------",13]
		For INDEX = 0 To SAMPLES_TO_TAKE			' Create a loop for all the elements in the array
        	HSerOut [Dec SAMPLE[INDEX]," "]			' Display the newly sorted array on the serial terminal
   			If COLUMN // 8 = 0 Then HSerOut [13]
   			Inc COLUMN
		Next
        Stop
        
'--------------------------------------------------------------------        
' This subroutine implements a technique called "bubble sort." 
' The BYTE array "SAMPLE" will be sorted in ascending order
' The length of the array is hald in the constant "SAMPLES_TO_TAKE"
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
				
