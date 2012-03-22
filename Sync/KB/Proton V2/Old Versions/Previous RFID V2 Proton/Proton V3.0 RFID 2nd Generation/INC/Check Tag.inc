'****************************************************************
'*  Name    : Check Tag                                    
'*  Author  : [Sam and Kim Bozman]                              
'*  Notice  : Copyright (c) 2009 [Sam and Kim Bozman]           
'*          : All Rights Reserved                               
'*  Date    : 02/01/2009                                        
'*  Version : 1.0                                               
'*  Notes   : Major Revision: April 6/10                                                  
'*          :                                                   
'****************************************************************
'NOTE: NOT TESTED


'==================Check for Existing Tag Sub==============================

 
Check_Tag:	   Response = 0  	 		  'Process will set Response to 1 if Tag is found.
			   If ERead (num_Users) = 0 Then 	  'there are no User entries in the table
			         Cls
			         Print "No Users"
			         Pause 2000
                     Return
			   EndIf			  
			   
               MyCount = 0          'Used to count how many tags we have checked
               Word_Var = BUA 		' Start search in first user memory spot
               Repeat
                    Index = 0 
				    Response = 0  			'Process will set Flag to 1 if Tag is found
                    Repeat   			'Repeat until all Tag digits are checked
				        Byte_Var = CRead Word_Var + Index   
                        If Byte_Var = TagIn[Index] Then 
				  	         Response = 1 		   'Digits Match
				  	         Inc Index 		   'Check Next Digit
				        Else
				  	         Response = 0		   'Digit does not match, therefore
					           Index = 10		'we are finished with this Tag  
				        EndIf
				    Until Index > 9
                    If Response = 1 Then  Return    'We have a match  
                    Word_Var = Word_Var + 10
                    Inc MyCount       
               Until Mycount > ERead (num_Users) 'If # User checked > num_Users in memory then we are finished...
               		Return     'Response is still zero
                       
                       	 

