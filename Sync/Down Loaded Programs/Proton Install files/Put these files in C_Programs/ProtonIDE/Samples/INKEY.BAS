' Demonstrate the INKEY command

	Include "PROTON_4.INC"
    REMINDERS = OFF   
	Cls
	While 1 = 1
		PRINT at 1,1,@ Lookup INKEY,[1,2,3,15,4,5,6,14,7,8,9,13,10,0,11,12,255] , "  "
 	PRINT at 2,1,Lookup INKEY,["123F456E789DA0BC "]
 	Wend



