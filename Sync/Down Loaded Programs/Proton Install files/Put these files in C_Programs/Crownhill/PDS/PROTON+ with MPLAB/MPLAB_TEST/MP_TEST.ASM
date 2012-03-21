;*******************************************************
;*                 Code Produced by the                *
;*             PROTON+ Compiler. Version 3.1           *
;*           Version 2.0 Beta of the Optimiser         *
;* Copyright Rosetta Technologies/Crownhill Associates *
;*              Written by Les Johnson. 2005           *
;*******************************************************
 NOLIST
 #include "C:\PLUS_SOURCE\MPLAB_TEST\MP_TEST.PBP"
 LIST
 
        #DEFINE SYSLED PORTB,4
F1_SOF EQU $ ; MP_TEST.BAS
F1_000013 EQU $ ; IN [MP_TEST.BAS] WHILE 1 = 1      ' CREATE AN INFINITE LOOP
BC@LL1
F1_000014 EQU $ ; IN [MP_TEST.BAS] HIGH SYSLED
        BSF PORTB,4
        BCF TRISB,4
F1_000016 EQU $ ; IN [MP_TEST.BAS] LOW SYSLED
        BCF PORTB,4
        BCF TRISB,4
F1_000018 EQU $ ; IN [MP_TEST.BAS] WEND       ' DO IT FOREVER
        BRA BC@LL1
BC@LL2
F1_EOF EQU $ ; MP_TEST.BAS
        END
