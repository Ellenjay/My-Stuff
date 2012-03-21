'
		Include "PROTON18_G4.INT"
        
        REMINDERS = OFF
       
        Cls
		Goto MAIN_PROGRAM

'----------------------------------------------------------------------------------------------
'
' Draw a line at a given angle (in degrees 0-360)
'
' Create some variables for the subroutine to use
'
	Dim _LINE_DEGREE as Word
    Dim _LINE_INNER_RADIUS as Byte
    Dim _LINE_OUTER_RADIUS as Byte
   	Dim _LINE_FX as Byte
  	Dim _LINE_FY as Byte
	Dim _LINE_TX as Byte
	Dim _LINE_TY as Byte       
  	Dim _LINE_SHOW as Bit       
  	Dim _LINE_SIN_CALC as Float
   	Dim _LINE_COS_CALC as Float
'
' Create a macro in order to incorporate the line draw subroutine as a pseudo command
' Syntax: -
' DEGREE_LINE XPOS_START , YPOS_START, INNER RADIUS START or LINE , OUTER RADIUS of LINE , DEGREE of LINE (0 -360) , DRAW or ERASE LINE (0- 1)
'
DEGREE_LINE MACRO X1_P,Y1_P,IN_R,OUT_R,L_R,L_P
			#if(PRM_COUNT != 6)
            	#Error "Incorrect amount of parameters in DEGREE_LINE macro. Requires 6 parameters"
            #endif
            
            #if((PRM_1 == NUM8) || (PRM_1 == NUM16) || (PRM_1 == NUM32))
            	NUM_BYTE	X1_P,_LINE_FX
            #endif
            #if((PRM_1 == BYTE) || (PRM_1 == WORD) || (PRM_1 == DWORD))
            	BYTE_BYTE	X1_P,_LINE_FX
            #endif
            
            #if((PRM_2 == NUM8) || (PRM_2 == NUM16) || (PRM_2 == NUM32))
            	NUM_BYTE	Y1_P,_LINE_FY
            #endif
            #if((PRM_2 == BYTE) || (PRM_2 == WORD) || (PRM_2 == DWORD))
            	BYTE_BYTE	Y1_P,_LINE_FY
            #endif
            
           	#if((PRM_3 == NUM8) || (PRM_3 == NUM16) || (PRM_3 == NUM32))
            	NUM_BYTE	IN_R,_LINE_INNER_RADIUS
            #endif
            #if((PRM_3 == BYTE) || (PRM_3 == WORD) || (PRM_3 == DWORD))
            	BYTE_BYTE	IN_R,_LINE_INNER_RADIUS
            #endif
            
            #if((PRM_4 == NUM8) || (PRM_4 == NUM16) || (PRM_4 == NUM32))
            	NUM_BYTE	OUT_R,_LINE_OUTER_RADIUS
            #endif
            #if((PRM_4 == BYTE) || (PRM_4 == WORD) || (PRM_4 == DWORD))
            	BYTE_BYTE	OUT_R,_LINE_OUTER_RADIUS
            #endif
            
            #if((PRM_5 == NUM8) || (PRM_5 == NUM16) || (PRM_5 == NUM32))
            	NUM_WORD	L_R,_LINE_DEGREE
            #endif
            #if(PRM_5 == BYTE)
            	BYTE_WORD	L_R,_LINE_DEGREE
            #endif
            #if((PRM_5 == WORD) || (PRM_5 == DWORD))
            	WORD_WORD	L_R,_LINE_DEGREE
            #endif
            
            #if((PRM_6 == NUM8) || (PRM_6 == NUM16) || (PRM_6 == NUM32))
            	NUM_BIT	L_P,_LINE_SHOW
            #endif
            #if((PRM_6 == BYTE) || (PRM_6 == WORD) || (PRM_6 == DWORD))
            	BYTE_BIT	L_P,_LINE_SHOW
            #endif
           	#if(PRM_6 == BIT)
            	BIT_BIT 	L_P,PRM_5_BIT,_LINE_SHOW
            #endif
            Gosub DRAW_DEG_LINE	 
		ENDM 
        
' Input	: _LINE_FY = Y position of the line's start
'		  _LINE_FX = X position of the line's start
'		  _LINE_INNER_RADIUS = Inner radius of the line
'		  _LINE_OUTER_RADIUS = Outer radius of the line
'		  _LINE_DEGREE = Angle of the line (0 to 360)
'		 _LINE_SHOW = Whether the line is drawn or erased       
DRAW_DEG_LINE:
        _LINE_SIN_CALC = sin ((_LINE_DEGREE * 3.14) / 180.0) 
        _LINE_COS_CALC = cos ((_LINE_DEGREE * 3.14) / 180.0)
        _LINE_TX = abs (_LINE_FX + _LINE_OUTER_RADIUS * _LINE_SIN_CALC)		'
  		_LINE_TY = abs (_LINE_FY - _LINE_OUTER_RADIUS * _LINE_COS_CALC)		' Calculate OUTER Radius of line
        _LINE_FX = abs (_LINE_FX + _LINE_INNER_RADIUS * _LINE_SIN_CALC)		'
  		_LINE_FY = abs (_LINE_FY - _LINE_INNER_RADIUS * _LINE_COS_CALC)		' Calculate INNER Radius of line
      
        Line _LINE_SHOW,_LINE_FX, _LINE_FY,_LINE_TX, _LINE_TY				' Draw the line
        Return
'------------------------------------------------------------------------------
MAIN_PROGRAM:        
        
        DEGREE_LINE [64,32,10,30,100,1]
        Stop


