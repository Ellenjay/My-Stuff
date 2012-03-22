'****************************************************************
'*  Name    : UNTITLED.BAS                                      *
'*  Author  : [select VIEW...EDITOR OPTIONS]                    *
'*  Notice  : Copyright (c) 2008 [select VIEW...EDITOR OPTIONS] *
'*          : All Rights Reserved                               *
'*  Date    : 11/12/2008                                        *
'*  Version : 1.0                                               *
'*  Notes   :                                                   *
'*          :                                                   *
'****************************************************************

 @CONFIG_REQ
 @__CONFIG CONFIG1H, HS_OSC_1
 @__CONFIG CONFIG2L, BOREN_OFF_2 & PWRT_ON_2
 @__CONFIG CONFIG2H, WDT_OFF_2 & WDTPS_128_2
 @__CONFIG CONFIG3H, CCP2MX_PORTBE_3 & MCLRE_ON_3
 @__CONFIG CONFIG4L, STVR_ON_4 & LVP_OFF_4 & DEBUG_OFF_4
 @__CONFIG CONFIG6L, WRT0_ON_6 & WRT1_ON_6 & WRT2_ON_6
