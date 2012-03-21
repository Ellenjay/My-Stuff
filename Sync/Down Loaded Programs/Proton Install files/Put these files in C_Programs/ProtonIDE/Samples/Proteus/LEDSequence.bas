'****************************************************************
'*              HOW TO USE THIS DEMO                            *
'*              ~~~~~~~~~~~~~~~~~~~~                            *
'*  Use the drop down menu next, to the 'Compile and Program'   *
'*  toolbar button, to select the 'Labcenter Electronics        *
'*  PROTEUS VSM...' option                                      *
'*                                                              *
'*  Next, click on the 'Compile and Program' toolbar button, or *
'*  press F10...                                                *
'****************************************************************

   device 16F877                        ' device name
   xtal = 20                            ' and clock frequency used
   
   symbol SequenceSize = 6              ' size of the sequence array
   symbol LEDPause = 500                ' LED delay
   dim Sequence[SequenceSize] as byte   ' create a sequence array [0..SequenceSize - 1]
   dim Index as byte                    ' loop counter
   dim Selection as word                ' selection variable
   
   ' set PORTD pins 0..3 to output...
   trisd = $F0

' main program loop starts here...   
MainProgram:  

   ' make a random number between 0 and 3... 
   selection = random 
   Selection = Selection & $0003
   
   ' select the 'random' LED sequence...
   select Selection
      case 0 : str sequence = $01, $02, $04, $08, $04, $02
      case 1 : str sequence = $09, $06, $09, $06, $09, $06
      case 2 : str sequence = $00, $01, $03, $07, $0F, $0F
      case 3 : str sequence = $03, $0C, $03, $0C, $03, $0C
   endselect
   
   ' now run the sequence...
   gosub DoSequence
   
   ' do it all again...
   goto mainprogram

' loop through the sequence array
DoSequence:
   for index = 0 to SequenceSize - 1
      portd = sequence[index]
      delayms LEDPause
   next
return   

