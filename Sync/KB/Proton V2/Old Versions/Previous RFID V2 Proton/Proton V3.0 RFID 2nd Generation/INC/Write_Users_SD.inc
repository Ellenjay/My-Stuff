'****************************************************************
'*  Name    : Write_Users_SD.inc                                
'*  Author  : [select VIEW...EDITOR OPTIONS]                    
'*  Notice  : Copyright (c) 2009 [select VIEW...EDITOR OPTIONS] 
'*          : All Rights Reserved                               
'*  Date    : 3/20/2009                                         
'*  Version : 1.0                                               
'*  Notes   :  Used to write User file back to SD Card          
'*          :   when no update file was on SD card 
'*          : Major Revision April 8/10            
'****************************************************************

'NOTE: NOT TESTED
 
 Write_Users_SD:	
 				GoSub Read_Mod 'Get the Module # from chip
				SD_File_Name = Str ModNum          'File Name, upper case only
				SD_File_Name = SD_File_Name + "R"
				SD_File_Ext = "TXT"  
				              'File Ext, upper case only! 		   
			   
 			    SD_Delete_File          'If it does exist then delete it..
    		  
'If file does not exist or we have deleted it then create a NEW file.
 		 	  SD_New_File 
			   
			  Byte_Var = ERead num_Users       'Get total number of Users
              If Byte_Var = 0 Then              'there are no User entries in the table	  
				   Cls
				   Print "No Users"
                   Pause 2000
                  SD_IO_String = "No Users have been assigned to this Module!"   
     			  SD_Write_String_To_File 
  				  SD_CLOSE_FILE
				  Return          'Return to calling function
			   EndIf
               
               'If there are existing users then.....
			   MyCount = 0		  
			   Word_Var = BUA 		' Start in first user memory spot			 
	  Repeat	
				 For Index = 0 To 9  			'Repeat until all Tag digits are checked
				  Response = CRead Word_Var + (Byte_Var -1) * 10   + Index  
           		  SD_Write_Byte_To_File Response 'append to file.
			     Next Index
				 SD_Write_Byte_To_File ":"
			  
			  Dec Byte_Var
			  Print Dec Byte_Var
	  Until Byte_Var = 0
			  	  
		
			  Cls
			  Print "Done Users"
			  Pause 2000
			  SD_CLOSE_FILE
			  Return
