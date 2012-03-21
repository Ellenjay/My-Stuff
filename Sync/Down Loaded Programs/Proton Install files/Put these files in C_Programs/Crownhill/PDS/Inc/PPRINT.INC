
 NOLIST       
; Decide which version of PPRINT to load
       if(_CORE == 14)							; Is it a 14-bit core device ?
       		ifdef INTERNAL@FONT					; Is the INTERNAL@FONT define on the PBP file ?
            	if(INTERNAL@FONT == 1)			; Do we need the internal font version ?
                	LIST
                	#include "PPRINT_14I.INC"	; Yes. So load the internal font version of PPRINT for a 14-bit core device
                	NOLIST
                else
                	LIST
                	#include "PPRINT_14E.INC"	; Otherwise load the external font version of PPRINT for a 14-bit core device
                	NOLIST
                endif
       		else
            	LIST
            	#include "PPRINT_14I.INC"		; Load (by default) the internal font version of PPRINT for a 14-bit core device
            	NOLIST
            endif
       else										; Must be a 16-bit core device
       		ifdef INTERNAL@FONT					; Is the INTERNAL@FONT define on the PBP file ?
            	if(INTERNAL@FONT == 1)			; Do we need the internal font version ?
                	LIST
                	#include "PPRINT_16I.INC"	; Yes. So load the internal font version of PPRINT for a 16-bit core device
                	NOLIST
                else
                	LIST
                	#include "PPRINT_16E.INC"	; Otherwise load the external font version of PPRINT for a 16-bit core device
                	NOLIST
                endif
       		else
            	LIST
            	#include "PPRINT_16I.INC"		; Load (by default) the internal font version of PPRINT for a 16-bit core device
            	NOLIST
            endif
       endif
 LIST
       