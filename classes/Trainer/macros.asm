    ByteStruct PartyData
        Index -o, Level, 100
        Index MoveIndex, 3
        Flag Special

    ByteStruct PartyDefinition
        Array Condition, Standard, RAMValue, RoutineValue, RoutineDefinition
        Flag Levels, Explicit, Scaled
        Flag Type, Flag, Value
        Array -o, ValueMethod, Equal, GreaterThanEqual, GreaterThan, LessThanEqual, LessThan
        Array -o, FlagMethod, z, nz, c, nz
        Index FlagIndex, 7
        done

PartyDataTerminator = -1

ParseTeamData: MACRO
    DEF SPECIAL_MASK = 0
    
    ; If there is a third argument, and it is a number, then it is special
    IF _NARG > 2
        REDEF ARG3 EQUS "\3"
        IsNumber {ARG3}

        IF IS_NUMBER == 1
            DEF SPECIAL_MASK = PartyDataSpecialBitMask
        ENDC
    ENDC

    db SPECIAL_MASK | \1, \2
    SHIFT 2

    IF SPECIAL_MASK != 0
        REPT _NARG/2
            DEF SPECIAL_MASK = PartyDataSpecialBitMask

            ; TODO - this DEF check is unncessary once the Move Table is added
            IF DEF(\2Table)
                IF STRCMP("{\2Table}","Pokemon") == 0
                    DEF SPECIAL_MASK = 0
                ENDC
            ENDC
            
            db SPECIAL_MASK | \1, \2
            SHIFT 2
        ENDR
    ELSE
        REPT _NARG
            db \1
            SHIFT
        ENDR
    ENDC

    db PartyDataTerminator
    CloseParty
ENDM

Party: MACRO
    DEF PARTY_INDEX = {NAME_VALUE}PartyCount
    REDEF PARTY_POINTER EQUS "{NAME_VALUE}Party{d:PARTY_INDEX}"

	SECTION FRAGMENT "{NAME_VALUE} Party Pointers", ROMX, BANK[TrainerClass]
        ; add pointer to party
        dw {PARTY_POINTER}

    ; add party data
    SECTION FRAGMENT "{NAME_VALUE} Parties", ROMX, BANK[TrainerClass]
        {PARTY_POINTER}:
            db 0 ; TODO - empty property byte for now
            DEF SPECIAL_MASK = 0
            
            ; If there is a third argument, and it is a number, then it is special
            IF _NARG > 2
                REDEF ARG3 EQUS "\3"
                IsNumber {ARG3}

                IF IS_NUMBER == 1
                    DEF SPECIAL_MASK = PartyDataSpecialBitMask
                ENDC
            ENDC

            db SPECIAL_MASK | \1, \2
            SHIFT 2

            IF SPECIAL_MASK != 0
                REPT _NARG/2
                    DEF SPECIAL_MASK = PartyDataSpecialBitMask

                    ; TODO - this DEF check is unncessary once the Move Table is added
                    IF DEF(\2Table)
                        IF STRCMP("{\2Table}","Pokemon") == 0
                            DEF SPECIAL_MASK = 0
                        ENDC
                    ENDC
                    
                    db SPECIAL_MASK | \1, \2
                    SHIFT 2
                ENDR
            ELSE
                REPT _NARG
                    db \1
                    SHIFT
                ENDR
            ENDC

            db PartyDataTerminator

    DEF {NAME_VALUE}PartyCount += 1
ENDM

Trainer: MACRO
	ConvertName \1
	Prop Name, String, {NAME_STRING}
	Prop Front, Sprite
	Prop Money, Byte, \2
	Prop Parties, Pointer, {NAME_VALUE}Parties
	Prop Traits, Flags, Gender, \3, Morality, \4, Boss, \5, Rival, \6

	; Default AI Values
	REDEF AI_ROUTINE EQUS "0"
	
	IF \7 != 0
		REDEF AI_ROUTINE EQUS "{NAME_VALUE}AI"
	ENDC
	
	Prop AIUses, Byte, \7
	Prop AIRoutine, Pointer, AI_ROUTINE
	Prop MoveSelection, Flags, Ailment, \8, SideEffects, \9, TypeAdvantage, \<10>

    ; Initialize the party count
    DEF {NAME_VALUE}PartyCount = 0

    PushContext Party
	SECTION FRAGMENT "{NAME_VALUE} Party Pointers", ROMX, BANK[TrainerClass]
		{NAME_VALUE}Parties:
			INCLUDE "classes/Trainer/Parties/{NAME_VALUE}.asm"
    CloseContext
ENDM

REDEF PartyName EQUS ""
DEF PartyNameCount = 0
InitializeTeam: MACRO
    ; store the previous Party Name and update with unique name
    REDEF PartyName{d:PartyNameCount} EQUS "{PartyName}"
    REDEF PartyName EQUS "Party_\@"

    ; increase the Party Name count
    DEF PartyNameCount += 1

    ; write the pointer to the party
    dw {PartyName}

    ; enter the team context
    PushContext Team

    ; initialize the party data
    SECTION "{PartyName} Party", ROMX, BANK[TrainerClass]
    {PartyName}:
        db {PartyName}Properties

    ; define properties after allocating so it will use final value
    DEF {PartyName}Properties = 0
    
    ; handle the arguments
    IF _NARG
        ; if the first argument is a number, then its a party definition
        IsNumber \1
        IF IS_NUMBER
            ForwardTo ParseTeamData
        ; otherwise, assume it is a macro and execute it
        ELSE            
            REDEF MACRO_NAME EQUS "\1"
            SHIFT
            ForwardTo {MACRO_NAME}
        ENDC
    ENDC
ENDM

CloseParty: MACRO
    ; decrease the Party Name count
    DEF PartyNameCount -= 1
    ; restore the previous Party Name
    REDEF PartyName EQUS "{PartyName{d:PartyNameCount}}"

    CloseContext ; close the team context
ENDM

; 1 = Trainer
InitializeBattle: MACRO
	ConvertName \1
    REDEF BATTLE_TRAINER_NAME EQUS "{NAME_VALUE}"

    DEF BATTLE_PARTY_INDEX = {BATTLE_TRAINER_NAME}PartyCount
    DEF {BATTLE_TRAINER_NAME}PartyCount += 1

    REDEF BATTLE_TEAM_NAME EQUS "{BATTLE_TRAINER_NAME}Team{d:PARTY_INDEX}"
ENDM

Team_switch: MACRO
    ; todo - need to set a flag instead
    DEF {PartyName}Properties = -1
    
    dw \1

    SetContext TeamSwitchValue
ENDM

; When a team switch value is finished, also close the party
Team_TeamSwitchValue_Finish: MACRO
    CloseParty
ENDM

TeamSwitchValue_end: MACRO
    CloseContext ; close the switch context
ENDM

TeamSwitchValue_case: MACRO
    db \1 ; write the value to compare against

    SetContext TeamSwitchValueCase

    ; if more than 1 arg, then the team is also defined
    IF _NARG > 1
        SHIFT
        ForwardTo Team
    ENDC
ENDM

; Implicitly open the Team context
TeamSwitchValueCase_switch: MACRO
    Team
    ForwardTo switch
ENDM

; Initialize the team
TeamSwitchValueCase_Team: MACRO
    ForwardTo InitializeTeam
ENDM

; When a team finishes, also close the case context
TeamSwitchValueCase_Team_Finish: MACRO
    CloseContext
ENDM