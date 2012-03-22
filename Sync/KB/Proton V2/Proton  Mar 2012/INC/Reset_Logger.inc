
Reset_Diagnostic_Logger:
;data Logger to help diagnose random resets - J Hanley (Captainslarty) 2012 -

;Counter at eeprom 0XBF (159) data from 160 for up to 50 resets (counter stops if > 50
;Our variables and constant
'Dim bBoot_Cnt   As Byte ; our restart counter
'Dim bReset_Type As Byte ; our type of reset deduced from PCON 
'Symbol eBoot_Cnt_Location = $BF ;(159 Dec)

;Start of boot looger with type of bootup / reset    
               bBoot_Cnt = ERead eBoot_Cnt_Location             ; read existing count value in eeprom
               If bBoot_Cnt = 255 Then                           ; if 255 then eeprom clear (Just programmed and first time powered on!)
Reset_Count:       bBoot_Cnt = 1                                ; so set it to 1 
                   EWrite eBoot_Cnt_Location,[bBoot_Cnt]        ; store the counter at location 0X10 
                   GoTo Write_PCON_Data                              ; Just programmed, first time on
               EndIf    
    If bBoot_Cnt > 10 Then GoTo Reset_Count         ; max count reached so start over at spot 1
    Inc bBoot_Cnt                                    ; otherwise increment the count                                                      
    EWrite eBoot_Cnt_Location,[bBoot_Cnt]            ; store the new count at location 159

Write_PCON_Data:    
    ;Condition PCON  for the following
    Select RCON
        Case 12,13 ; POR Normal Reset
            bReset_Type = 1
        Case 7     ; MCLR Reset
            bReset_Type = 2
        Case 15    ; WDT  Reset
            bReset_Type = 3
        Case 14    ; BOR  Reset
            bReset_Type = 4
        Case 11    ; RESET Instruction Reset
            bReset_Type = 5
        Case 143   ; Stack Overflow    Reset
            bReset_Type = 6
        Case 79    ; Stack Underflow   Reset
            bReset_Type = 7
        Case Else  ; Unaccounted for reset so store raw PCON data for analysis 
            bReset_Type = RCON
    End Select
    
    EWrite eBoot_Cnt_Location + bBoot_Cnt,[bReset_Type]  ; now store the conditioned PCON result in EEprom from 0X17  onwards to Max 10 enties                                                 
Over_Boot_Logger:                                        
    RCON = 001111                                     ; Reset PCON settings to known reset OFF states 
';bit 1 POR: Power-on Reset Status bit
';1 = No Power-on Reset occurred
';0 = A Power-on Reset occurred (must be set in software after a Power-on Reset occurs)
'    if pcon.1 = 0 then set pcon.1
';bit 0 BOR: Brown-out Reset Status bit
';1 = No Brown-out Reset occurred
';0 = A Brown-out Reset occurred (must be set in software after a Power-on Reset or Brown-out Reset occurs)
'    if pcon.0 = 0 then set pcon.0



;test of reset boot logger states - fuses for stack, wdt, bor ON !!! 
;declare Watchdog ON in code prior to logger !!!
;Test WDT
'while 1 = 1 ; this will trigger a WDT reset every second
'wend
;test Stack overflow  
'while 1 = 1
'Test:
'delayms 500
'gosub Stack_OF
'wend
'Stack_OF: ; no return ! 
'goto test
;test Stack Underflow  
'While 1 = 1
'DelayMS 500
'return
'Wend
;test RESET instruction reset 
'delayms 2000
'reset
'end
;test BOR - use PSU !
;test MCLR - use MCLR pull down

Return
;*******************************************************************************************************
