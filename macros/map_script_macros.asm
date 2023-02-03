; 1 = trainer instance
MapScript_Battle: MACRO
	ConvertName \1

    PushContext MapScriptBattle, MapScript_Battle_Finish
    Party_Battle
ENDM

MapScript_Battle_Finish: MACRO
    IF DEF({NAME_VALUE}{d:PARTY_INDEX}WinText) == 0
        ;todo - error
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

MapScript_text: MACRO
    REDEF PTR_NAME EQUS "{MAP_NAME}ScriptText{d:{MAP_NAME}TextCount}"

    PushContext Text, MapScript_Text_Finish
    SECTION FRAGMENT "{MAP_NAME} Texts", ROMX, BANK[CUR_BANK]
        {PTR_NAME}:
            ForwardTo Default_text
    
    DEF {MAP_NAME}TextCount = {MAP_NAME}TextCount + 1
ENDM

MapScript_Text_Finish: MACRO
    ld hl, PTR_NAME
	call DisplayTextInTextbox
ENDM

MapScriptBattle_text: MACRO
    PushContext Text
    SECTION FRAGMENT "{MAP_NAME} Texts", ROMX, BANK[CUR_BANK]
        IF DEF({NAME_VALUE}{d:PARTY_INDEX}WinText) == 0
            {NAME_VALUE}{d:PARTY_INDEX}WinText:
        ELSE
            {NAME_VALUE}{d:PARTY_INDEX}LoseText:
        ENDC
    
        ForwardTo Default_text
ENDM

MapScriptBattle_Team: MACRO
    ForwardTo Party2
    CloseContext ; return to the map script context
ENDM

MapScriptBattle_switch: MACRO
    SetContext MapScriptBattleSwitch
    Party_switch \1
ENDM

; team can optionally be combined with the case
MapScriptBattleSwitch_case: MACRO
    Party_case \1
    IF _NARG == 1
        SetContext MapScriptBattleSwitchCase
    ELSE
        SHIFT
        ForwardTo Party2
    ENDC
ENDM

MapScriptBattleSwitchCase_Team: MACRO
    ForwardTo Party2
    CloseContext ; close out of the Case context
ENDM

MapScriptBattleSwitch_end: MACRO
    CloseContext 2 ; close out of the Switch and battle context
ENDM

MapScript_switch: MACRO
ENDM

MapScript_case: MACRO
ENDM

MapScript_end: MACRO
ENDM