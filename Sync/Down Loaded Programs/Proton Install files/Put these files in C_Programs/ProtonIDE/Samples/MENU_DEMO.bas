' LCD Menu System using 3 buttons

' PORTB.0 = Menu Select
' PORTB.1 = LEFT (increment value)
' PORTB.2 = RIGHT (decrement value)

	Include "PROTON_4.INC"

' ** Declare the Variables **
		Dim Temp as Byte			' Temporary storage Variable
    	Dim Items as Byte			' Main Menu Item counter
		Dim M1_Var as Byte			' Sub Menu1 main alterable Variable
		Dim M2_Var as Byte			' Sub Menu2 main alterable Variable
		Dim M3_Var as Byte			' Sub Menu3 main alterable Variable
		Dim M4_Var as Byte			' Sub Menu4 main alterable Variable
		Dim Minimum as Byte			' Minimum value for Inc or Dec
		Dim Maximum as Byte			' Maximum value for Inc or Dec

' *** Define Button assignments ***
		Symbol Menu_Sel	= PORTB.0		' Menu Select button=PortB.0
		Symbol Left_Key = PORTB.1		' Left button=PortB.1
		Symbol Right_Key = PORTB.2		' Right button=PortB.2

' ** Declare the constants **
		Symbol No_Menus	=	4			' Inform the program as to how many sub menus

		EData	50,50,50,50				' Place the initial values for Mx_VAR variables
										' into the first four eeprom address's

		Delayms 400								' Wait for Picmicro to stabilise
        TRISB = %00000111						' Set PortB Bits0-2 as Inputs ready for Button tests
		PORTB_PULLUPS = ON						' Turn On Internal Pullup Resistors
		Cls										' Clear the LCD
        Items = 0   							' Point to Item 0 in Main Menu selector 
        Goto Main								' Jump over the subroutines

'----------------------------------------------------------------------------------------
Print_it:
		Print 1,7,Dec Temp,"  "					' Display the current value held in "TEMP"
		Delayms 160								' Delay for debounce
		Return 									' Exit subroutine
        
'----------------------------------------------------------------------------------------         
' This subroutine tests the left and right buttons and increments or decrements the value 
' of TEMP until the MINIMUM or MAXIMUM amount is reached and also displays the value of TEMP.
' TEMP holds the initial value to be adjusted
Inc_or_Dec:
 		If Left_Key = 0 Then If Temp > Minimum then	' Check if left button pressed and minimum value allowed reached 
 	 		Dec Temp							' Decrement value if YES
	  		Goto Print_it						' Print value only if button pressed
 	   	Endif
 	
		If Right_Key = 0 Then If Temp < Maximum then 	' Check if right button pressed and MAXIMUM value allowed reached
	 		Inc Temp							' Increment value if Yes
	  		Goto Print_it						' Print value only if button pressed
	   	Endif 
		Return	
'----------------------------------------------------------------------------------------         
' ** MAIN PROGRAM STARTS HERE **

MAIN:
		         
' ** Menu selector **
I_LOOP: 
		If Menu_Sel = 0 Then 					' Check menu select button 
        	Items = Items + 1					' Increment menu item if pressed					
	 		Delayms 500							' Give time for debounce
	 		Cls									' Clear the LCD
		Endif
		If Items > No_Menus - 1 Then Items = 0	' If last item reached, look at first item
		Branchl Items,[Menu1,Menu2,Menu3,Menu4]	' Goto routine according to value in variable "ITEMS"
        Goto I_LOOP								' Go back to start

'------------------------------------------------------------------        
' ** Sub-Menu 1 **
Menu1:	
		Minimum = 0: Maximum = 200				' Set the max and min Values for Mx_VAR
		M1_Var = ERead Items					' Get the value of M1_VAR from the eeprom
		Print at 1,1, "Menu1  ",Dec M1_Var,"  "	' Display on LCD
SM1:	
		If Menu_Sel = 0 Then I_LOOP				' Go Back if MENU SELECT Button Pressed
		Temp = M1_Var							' Store Value in Temp
		Gosub Inc_or_Dec						' Do Inc or Dec routine for Left or Right Buttons
		If Temp <> M1_Var Then 					' If TEMP is different to Mx_VAR then
			EWrite 0,[Temp]						' Write the value in M1_Var to the eeprom only if it has changed
			' Gosub Do_Something				' Only call a subroutine if M1_VAR has changed
		Endif					
		M1_Var = Temp							' Restore Value from Temp
		Goto SM1								' Look again

'------------------------------------------------------------------ 	
' ** Sub-Menu 2 **	
Menu2:	
		Minimum = 10: Maximum = 120				' Set the max and min Values for Mx_VAR
		M2_Var = ERead Items					' Get the value of M2_VAR from the eeprom
		Print at 1,1,"Menu2  ",Dec M2_Var,"  "	' Display on LCD
SM2:	
		If Menu_Sel = 0 Then I_LOOP				' Go Back if MENU SELECT Button Pressed
		Temp = M2_Var							' Store Value in Temp
		Gosub Inc_or_Dec						' Do Inc or Dec routine for Left or Right Buttons
		If Temp <> M2_Var Then 					' If TEMP is different to Mx_VAR then
			EWrite 1,[Temp]						' Write the value in M2_Var to the eeprom only if it has changed
			' Gosub Do_Something				' Only call a subroutine if M2_VAR has changed
		Endif
		M2_Var = Temp							' Restore Value from TEMP
		Goto SM2								' Look again

'------------------------------------------------------------------ 
' ** Sub-Menu 3 **	
Menu3:	
		Minimum = 1: Maximum = 250				' Set the max and min Values for Mx_VAR
		M3_Var = ERead Items					' Get the value of M3_VAR from the eeprom
		Print at 1,1, "Menu3  ",Dec M3_Var,"  "	' Display on LCD
SM3:	
		If Menu_Sel=0 Then I_LOOP				' Go back if MENU SELECT button pressed
		Temp = M3_Var							' Store value in TEMP
		Gosub Inc_or_Dec						' Do Inc or Dec routine for Left or Right Buttons
		If Temp <> M3_Var Then 					' If TEMP is different to Mx_VAR then
			EWrite 2,[Temp]						' Write the value in M3_Var to the eeprom only if it has changed
			' Gosub Do_Something				' Only call a subroutine if M3_VAR has changed
		Endif
		M3_Var = Temp							' Restore value from TEMP
		Goto SM3								' Look again

'------------------------------------------------------------------ 
' ** Sub-Menu 4 **	
Menu4:	
		Minimum = 10: Maximum = 250				' Set the max and min Values for Mx_VAR
		M4_Var = ERead Items					' Get the value of M4_VAR from the eeprom
		Print at 1,1, "Menu4  ",Dec M4_Var,"  "	' Display on LCD
SM4:	
		If Menu_Sel = 0 Then I_LOOP				' Go back if MENU SELECT button pressed
		Temp = M4_Var							' Store value in TEMP
		Gosub Inc_or_Dec						' Do inc or dec routine for left or right buttons
		If Temp <> M4_Var Then 					' If TEMP is different to Mx_VAR then
			EWrite 3,[Temp]						' Write the value in M4_Var to the eeprom only if it has changed
			' Gosub Do_Something				' Only call a subroutine if M4_VAR has changed
		Endif
		M4_Var = Temp							' Restore value from TEMP
		Goto SM4								' Look again
    
        
 
