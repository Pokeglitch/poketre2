REDEF MAP_SCRIPT_MACROS EQUS ""
DefineMapScriptMacros: MACRO
    AccumulateArgs
    REDEF MAP_SCRIPT_MACROS EQUS "{ARGS_STR}"
ENDM
    DefineMapScriptMacros text, Delay
    DefineDefaultMacros MapScript, Delay

MapScript_text: MACRO
    REDEF PTR_NAME EQUS "{MAP_NAME}ScriptText{d:{MAP_NAME}TextCount}"

    InitTextContext done, {MAP_SCRIPT_MACROS}
    SECTION FRAGMENT "{MAP_NAME} Texts", ROMX, BANK[CUR_BANK]
        {PTR_NAME}:
            ForwardTo Default_text
    
    DEF {MAP_NAME}TextCount = {MAP_NAME}TextCount + 1
ENDM

MapScript_Text_Finish: MACRO
    DisplayText PTR_NAME
ENDM

; 1 = trainer instance
MapScript_Battle: MACRO
    PushContext MapScriptBattle
    InitializeBattle \1
ENDM

MapScript_MapScriptBattle_Finish: MACRO
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

MapScriptBattle_text: MACRO
    InitTextContext prompt, text, Team
    SECTION FRAGMENT "{MAP_NAME} Texts", ROMX, BANK[CUR_BANK]
        IF DEF({BATTLE_TEAM_NAME}WinText) == 0
            {BATTLE_TEAM_NAME}WinText:
        ELSE
            {BATTLE_TEAM_NAME}LoseText:
        ENDC
    
        ForwardTo Default_text
ENDM

; store the pointer to the trainer table
MapScriptBattle_Team: MACRO
	SECTION FRAGMENT "{BATTLE_TRAINER_NAME} Party Pointers", ROMX, BANK[TrainerClass]
    ForwardTo InitializeTeam
ENDM

; When returning to battle from the team, close the battle context
MapScriptBattle_Team_Finish: MACRO
    CloseContext
ENDM



MapScript_switch: MACRO
ENDM

MapScript_case: MACRO
ENDM

MapScript_end: MACRO
ENDM