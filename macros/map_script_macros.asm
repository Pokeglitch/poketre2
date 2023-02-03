; 1 = trainer instance
MapScript_Battle: MACRO
	ConvertName \1

    PushContext MapScriptBattle
    Party_Battle
ENDM

; TODO - make this a callback for when the context gets closed...
MapScript_Battle_Finish: MACRO
    PopContext ; return to the map script context

    IF DEF({NAME_VALUE}{d:PARTY_INDEX}WinText) == 0
        PRINT "\naaa\n"
    ENDC

    PrepareBattle {NAME_VALUE}, {PARTY_INDEX}
	ld hl, {NAME_VALUE}{d:PARTY_INDEX}WinText

    IF DEF({NAME_VALUE}{d:PARTY_INDEX}LoseText)
	    ld de, {NAME_VALUE}{d:PARTY_INDEX}LoseText
    ELSE
        ld de, {NAME_VALUE}{d:PARTY_INDEX}WinText
    ENDC

	call SaveEndBattleTextPointers
	jp StartOverworldBattle
ENDM

MapScriptBattle_Text: MACRO
    PushContext MapScriptBattleText
    SECTION FRAGMENT "\1 Texts", ROMX, BANK[CUR_BANK]
        IF DEF({NAME_VALUE}{d:PARTY_INDEX}WinText) == 0
            {NAME_VALUE}{d:PARTY_INDEX}WinText:
        ELSE
            {NAME_VALUE}{d:PARTY_INDEX}LoseText:
        ENDC
    
        REPT _NARG
            db \1   
            SHIFT
        ENDR
ENDM

MapScriptBattleText_Done: MACRO
    done
    PopContext
ENDM

MapScriptBattleText_Prompt: MACRO
    prompt
    PopContext
ENDM

MapScriptBattle_Team: MACRO
    ; Accumulate the args to send to macro
    REDEF ARGS_STR EQUS ""
    REPT _NARG
        IF STRCMP("{ARGS_STR}", "") != 0
            REDEF ARGS_STR EQUS STRCAT("{ARGS_STR}", ", ")
        ENDC
        
        REDEF ARGS_STR EQUS STRCAT("{ARGS_STR}", "\1")
        SHIFT
    ENDR
    Party2 {ARGS_STR}
    MapScript_Battle_Finish
ENDM

MapScriptBattle_switch: MACRO
    SetContext MapScriptBattleSwitch
    Party_switch \1
ENDM

MapScriptBattleSwitch_case: MACRO
    Party_case \1
    IF _NARG == 1
        SetContext MapScriptBattleSwitchCase
    ELSE
        SHIFT
        REDEF ARGS_STR EQUS ""
        REPT _NARG
            IF STRCMP("{ARGS_STR}", "") != 0
                REDEF ARGS_STR EQUS STRCAT("{ARGS_STR}", ", ")
            ENDC
            
            REDEF ARGS_STR EQUS STRCAT("{ARGS_STR}", "\1")
            SHIFT
        ENDR
        Party2 {ARGS_STR}
    ENDC
ENDM

MapScriptBattleSwitchCase_Team: MACRO
    ; Accumulate the args to send to macro
    REDEF ARGS_STR EQUS ""
    REPT _NARG
        IF STRCMP("{ARGS_STR}", "") != 0
            REDEF ARGS_STR EQUS STRCAT("{ARGS_STR}", ", ")
        ENDC
        
        REDEF ARGS_STR EQUS STRCAT("{ARGS_STR}", "\1")
        SHIFT
    ENDR
    Party2 {ARGS_STR}
    CloseContext ; close out of the Case context
ENDM

MapScriptBattleSwitch_end: MACRO
    CloseContext ; close out of the Switch context
    MapScript_Battle_Finish
ENDM

MapScript_switch: MACRO
ENDM

MapScript_case: MACRO
ENDM

MapScript_end: MACRO
ENDM