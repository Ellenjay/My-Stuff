' PROTON+ Program to identify characters: case, digit, punctuation, operand or parenthasis.
'
' To use the program, open the serial terminal program and set it up for 9600 baud
' Follow the on-screen prompt and type a character
'
		Include "PROTON_4.INC"									' Use the PROTON Development board for demo   

		Dim CHARACTER as Byte
		
        Delayms 200												' Wait for PICmicro to stabilise
        
		Hrsout Cstr ENTER_CHAR									' Display message "Enter a character: "

		While 1 = 1												' Create an infinite loop

    		Hrsin CHARACTER										' Get a character from the serial port

  			Select CHARACTER									' Check conditions based on variable CHARACTER

    			Case "A" TO "Z"									' Is it A to Z ?
      				Hrsout Cstr CHAR_IS, Cstr UP_CASE			' Yes.. So display message "Character is an Upper case Letter"

    			Case "a" TO "z"									' Is it a to z ?
      				Hrsout Cstr CHAR_IS, Cstr LW_CASE			' Yes.. So display message "Character is a Lower case Letter"

    			Case "0" TO "9"									' Is it 0 to 9 ?
      				Hrsout Cstr CHAR_IS, Cstr DIGIT				' Yes.. So display message "Character is a Digit"

    			Case "!", "?", ".", ","							' Is it one of these four characters ?
      				Hrsout Cstr CHAR_IS, Cstr PUNCT				' Yes.. So display message "Character is a Punctuation"
	
    			Case "$", "%", "&", "|","~","^","-","+","*","/" ' Is it one of these ten characters ?
      				Hrsout Cstr CHAR_IS, Cstr OPERAND			' Yes.. So display message "Character is an Operand"
    
    			Case "(", ")", "{", "}", "[", "]"				' Is it one of these six characters ?
      				Hrsout Cstr CHAR_IS, Cstr PAREN				' Yes.. So display message "Character is a Parenthasis"
      
    			Case Else
      				Hrsout Cstr CHAR_IS, Cstr UNKNOWN			' Default to displaying message "Character is not known. Try a different one."

  			Endselect

  			Hrsout Cstr ANOTHER									' Display the message "Enter another character"

		Wend													' Look for another character from the serial port
      
' Message texts held in code memory
CHAR_IS:	CDATA CR, "Character is ",0  
ENTER_CHAR:	CDATA "Enter a character: ", CR,0
UP_CASE:	CDATA "an Upper case Letter", CR,0
LW_CASE:	CDATA "a Lower case Letter", CR,0
DIGIT:		CDATA "a Digit", CR,0
PUNCT:		CDATA "a Punctuation", CR,0
OPERAND:	CDATA "an Operand", CR,0
PAREN:		CDATA "a Parenthasis", CR,0
UNKNOWN:	CDATA "not known. Try a different one.",CR,0
ANOTHER:	CDATA CR,"Enter another character", CR,0

