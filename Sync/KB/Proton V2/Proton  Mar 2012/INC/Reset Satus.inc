'****************************************************************
'*  Name    : Reset Status                                      *
'*  Author  : [Sam and Kim Bozman]                              *
'*  Notice  : Copyright (c) 2010 Copyright (c) 2010 All rights  *
'*          : All Rights Reserved                               *
'*  Date    : 6/1/2010                                          *
'*  Version : 1.0                                               *
'*  Notes   :                                                   *
'*          :                                                   *
'****************************************************************

Check Reset_Status:

If RCON.4 = true Then Reset_Cause = "Software Reset"
If RCON.3 = True Then Reset_Cause = "Software Reset"


