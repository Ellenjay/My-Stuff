'****************************************************************
'*  Name    : UNTITLED.BAS                                      *
'*  Author  : [select VIEW...EDITOR OPTIONS]                    *
'*  Notice  : Copyright (c) 2009 [select VIEW...EDITOR OPTIONS] *
'*          : All Rights Reserved                               *
'*  Date    : 3/20/2009                                         *
'*  Version : 1.0                                               *
'*  Notes   :                                                   *
'*          :                                                   *
'****************************************************************
WriteH:
        For Index = num_UH To 0 Step -1          'Here we move all old history down one notch to ready 1st place for new entry
            For Index2 = 0 To 3
            TV1 = ERead (Index * 4) + Index2 + UHA
            EWrite (Index * 4) + Index2 + 4 + UHA,[TV1]
            WOrd_Var = (Index * 4) + Index2 + 4 + UHA
            Next Index2
        Next Index
        
       Cls
 		
             For Index = 0 To 3	 		  	   		   'Write User # to History
				TV1 = UserIn[Index]
				EWrite UHA + Index, [TV1]
 			Next 'Index  
 		TV1 = ERead num_UHE
         If TV1 < num_UH Then
            Inc TV1
            EWrite num_UHE, [TV1]
         EndIf	
        Return
        
        
     'Not TESTED 
