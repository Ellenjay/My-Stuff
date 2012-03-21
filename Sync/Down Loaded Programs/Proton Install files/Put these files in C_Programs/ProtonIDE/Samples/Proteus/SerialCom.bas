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

   include "PROTON_4.INC"
   
   symbol SerialDelay = 500
   dim Index as byte
   dim Column as byte

   seed 10
   column = 1

' main program loop starts here...   
ProgramStart:
   
   ' generate a random number and output...
   index = random 
   hserout ["[$", hex2 index, "] "]
   
   ' wrap numbers, if required...
   if column // 8 = 0 then
      hserout [13]
   endif
   inc column   
   
   ' pause, then do it all again... 
   delayms SerialDelay
   goto ProgramStart   

