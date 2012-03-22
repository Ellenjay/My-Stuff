 '****************************************************************
'*  Name    : Go to Sleep                                    
'*  Author  : [Sam and Kim Bozman]                              
'*  Notice  : Copyright (c) 2009 [Sam and Kim Bozman]           
'*          : All Rights Reserved                               
'*  Date    : 02/01/2009                                        
'*  Version : 1.0                                               
'*  Notes   : Major Revision: April 6/10                                                  
'*          :                                                   
'****************************************************************
'NOTE: NOT TESTED




GoSleep:
 'Init HLVD
IPR2.2 = True             'High IRQ Priority
HLVDCON = 0x0E                 ' External trip point bits 0-3 of HLVDCON
HLVDCON.7 = False        'Direction of voltage change Bit 7 of HLVDCON
HLVDCON.4 = True          'Enable it with bit 4 of HLVDCON
PIR2.2 = 0                'Clear Previous  Interrupt Flag bit 2
While(!HLVDCON.5)          'Wait  Internal Reference Voltage Stable Flag bit = 1
PIR2bits.HLVDIF = 0         'Clear Previous IF
DelayMS(250);
PIR2bits.HLVDIF = 0         'Clear Previous IF
PIE2bits.HLVDIE = 1         'Enable IRQ

'Enable Interrupts
INTCONbits.GIEH = 1;
INTCONbits.GIEL = 1;
		GoTo GoSleep  		  'Go back to sleep
