'****************************************************************
'*  Name    : Write_Users_SD.inc                                *
'*  Author  : [select VIEW...EDITOR OPTIONS]                    *
'*  Notice  : Copyright (c) 2009 [select VIEW...EDITOR OPTIONS] *
'*          : All Rights Reserved                               *
'*  Date    : 3/20/2009                                         *
'*  Version : 1.0                                               *
'*  Notes   :  Used to write User file back to SD Card          *
'*          :   when no update file was on SD card              *
'****************************************************************

 
 Write_Users_SD:	
 				GoSub Read_Mod 'Get the Module # from chip
				SD_File_Name = Str ModNum          'File Name, upper case only
				SD_File_Name = SD_File_Name + "R"
				SD_File_Ext = "TXT"  
				              'File Ext, upper case only! 		   
			   
 			    SD_Delete_File          'If it does exist then delete it..
    		  
'If file does not exist or we have deleted it then create a NEW file.
 		 	  SD_New_File 
			   
			   If User_Pointer = BUA Then 	  'there are no User entries in the table
				   Cls
				   Print "No Users"
                   Pause 2000
                  SD_IO_String = "No Users Exist"   
     			  SD_Write_String_To_File 
  				  SD_CLOSE_FILE
				  Return
			   EndIf
  
  
			   Index2 = ERead NOU    'Read number of users into Index2	 
			   MyCount = 0		  
			   Word_Var = BUA 		' Start in first user memory spot			 
	  Repeat	
				 For Index = 0 To 3  			'Repeat until all Tag digits are checked
				  TV1 = CRead Word_Var + Index  
           		  SD_Write_Byte_To_File TV1 'append to file.
			     Next Index
				 SD_Write_Byte_To_File ":"
			  Word_Var = Word_Var + 16
			  Inc MyCount
			  Print MyCount
	  Until MyCount = Index2
			  	  
		
			  Cls
			  Print "Done Users"
			  Pause 2000
			  SD_CLOSE_FILE
			  Return
