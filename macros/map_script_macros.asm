REDEF MAP_SCRIPT_MACROS EQUS ""
MACRO DefineMapScriptMacros
    REDEF MAP_SCRIPT_MACROS EQUS "\#"
ENDM
    DefineMapScriptMacros text, Delay
    DefineDefaultMacros MapScript, Delay

MACRO MapScript_text
    REDEF PTR_NAME EQUS "{MAP_NAME}ScriptText{d:{MAP_NAME}TextCount}"
    InitTextContext done, {MAP_SCRIPT_MACROS}
    
    SECTION FRAGMENT "{MAP_NAME} Texts", ROMX, BANK[CUR_BANK]
        {PTR_NAME}:
            foreach db, \#
    
    DEF {MAP_NAME}TextCount = {MAP_NAME}TextCount + 1
ENDM

MACRO MapScript_Text_Finish
    DisplayText PTR_NAME
ENDM

; 1 = trainer instance
MACRO MapScript_Battle
    PushContext MapScriptBattle
    InitializeBattle \1
ENDM

MACRO MapScript_MapScriptBattle_Finish
    IF DEF({BATTLE_TEAM_NAME}WinText) == 0
        ;todo - error
    ENDC

    PrepareBattle {BATTLE_TRAINER_NAME}, {BATTLE_PARTY_INDEX}
	ld hl, {BATTLE_TEAM_NAME}WinText

    IF DEF({BATTLE_TEAM_NAME}LoseText)
	    ld de, {BATTLE_TEAM_NAME}LoseText
    ELSE
        ld de, {BATTLE_TEAM_NAME}WinText
    ENDC

	call SaveEndBattleTextPointers
	jp StartOverworldBattle
ENDM

MACRO MapScriptBattle_text
    InitTextContext prompt, text, Team
    SECTION FRAGMENT "{MAP_NAME} Texts", ROMX, BANK[CUR_BANK]
        IF DEF({BATTLE_TEAM_NAME}WinText) == 0
            {BATTLE_TEAM_NAME}WinText:
        ELSE
            {BATTLE_TEAM_NAME}LoseText:
        ENDC
    
        foreach db, \#
ENDM

; store the pointer to the trainer table
MACRO MapScriptBattle_Team
	SECTION FRAGMENT "{BATTLE_TRAINER_NAME} Party Pointers", ROMX, BANK[TrainerClass]
        InitializeTeam \#
ENDM

; When returning to battle from the team, close the battle context
MACRO MapScriptBattle_Team_Finish
    CloseContext
ENDM



MACRO MapScript_switch
ENDM

MACRO MapScript_case
ENDM

MACRO MapScript_EndDefinition
ENDM