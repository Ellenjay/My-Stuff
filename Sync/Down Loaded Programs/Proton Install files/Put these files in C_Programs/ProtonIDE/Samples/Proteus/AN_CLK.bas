
		Include "PROTON18_G4.INT"
        
        DECLARE STACK_SIZE = 20
        
        Dim _LINE_DEGREE as Word
        Dim _LINE_INNER_RADIUS as Byte
        Dim _LINE_OUTER_RADIUS as Byte
        Dim _LINE_FX as Byte
        Dim _LINE_FY as Byte
        Dim _LINE_TX as Byte
        Dim _LINE_TY as Byte       
        Dim _LINE_SHOW as Byte       
        Dim _LINE_SIN_CALC as Float
        Dim _LINE_COS_CALC as Float        
        Dim _LINE_FLT_DEGREE as Float
        
        
        Dim LOOP as Word
        Cls
        
        
        Circle 1,64,32,8								' Draw the clock's outer circle
 		'Circle 1,64,32,1								' Draw the clock's centre
        For LOOP = 0 to 359 step 30
            Gosub DRAW_LINE [64,32,7,8,Loop,1]		' Draw the dial markings
        Next
        While 1 = 1       
        	For LOOP = 0 to 359 step 6					' Create a loop for 60 revolutions of the second hand
            	Gosub DRAW_LINE [64,32,1,6,Loop,1]		' Draw the seconds hand of the clock
            	Delayms 100							' Wait 1 second
            	Gosub DRAW_LINE [64,32,1,6,Loop,0]		' Erase the seconds hand of the clock
        	Next
        Wend
'----------------------------------------------------------------------------------------------
'
' Draw a line at n degrees angle
' Input	: _LINE_FY = Y position of the line's start
'		  _LINE_FX = X position of the line's start
'		  _LINE_INNER_RADIUS = Inner radius of the line
'		  _LINE_OUTER_RADIUS = Outer radius of the line
'		  _LINE_DEGREE = Angle of the line (0 to 360)
'		 _LINE_SHOW = Whether the line is drawn or erased
DRAW_LINE: 
     	Pop _LINE_SHOW										' \
        Pop _LINE_DEGREE									'  \
        Pop _LINE_OUTER_RADIUS								'   
        Pop _LINE_INNER_RADIUS								'    Pull the parameters from the stack
        Pop _LINE_FY										'  /
        Pop _LINE_FX										' /
        _LINE_FLT_DEGREE = (_LINE_DEGREE * 3.14) / 180
        _LINE_SIN_CALC = sin _LINE_FLT_DEGREE
        _LINE_COS_CALC = cos _LINE_FLT_DEGREE
        
        _LINE_TX = abs (_LINE_FX + _LINE_OUTER_RADIUS * _LINE_SIN_CALC)
  		_LINE_TY = abs (_LINE_FY - _LINE_OUTER_RADIUS * _LINE_COS_CALC)
        _LINE_FX = abs (_LINE_FX + _LINE_INNER_RADIUS * _LINE_SIN_CALC)
  		_LINE_FY = abs (_LINE_FY - _LINE_INNER_RADIUS * _LINE_COS_CALC)
      
        Line _LINE_SHOW,_LINE_FX, _LINE_FY,_LINE_TX, _LINE_TY	' Draw the line
        Return


