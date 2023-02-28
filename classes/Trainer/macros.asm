    ByteStruct PartyData
        overload
            Index Level, 100
        next
            Index MoveIndex, 3
        end
        Flag Special
    end

    ByteStruct PartyDefinition
        Array Condition, Standard, RAMValue, RoutineValue, RoutineDefinition
        Flag Levels, Explicit, Scaled
        Flag Type, Flag, Value
        overload
            Array ValueMethod, Equal, GreaterThanEqual, GreaterThan, LessThanEqual, LessThan
        next
            Array FlagMethod, z, c, zc
        next
            Index FlagIndex, 7
        end
    end

PartyDataTerminator = -1

MACRO ParseTeamData
    DEF SPECIAL_MASK = 0
    
    ; If there is a third argument, and it is a number, then it is special
    IF _NARG > 2
        REDEF ARG3 EQUS "\3"
        is#Number {ARG3}

        IF so
            DEF SPECIAL_MASK = PartyData#Special#BitMask
        ENDC
    ENDC

    db SPECIAL_MASK | \1, \2
    SHIFT 2

    IF SPECIAL_MASK != 0
        REPT _NARG/2
            DEF SPECIAL_MASK = PartyData#Special#BitMask

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

MACRO Party
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
                is#Number {ARG3}

                IF so
                    DEF SPECIAL_MASK = PartyData#Special#BitMask
                ENDC
            ENDC

            db SPECIAL_MASK | \1, \2
            SHIFT 2

            IF SPECIAL_MASK != 0
                REPT _NARG/2
                    DEF SPECIAL_MASK = PartyData#Special#BitMask

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

MACRO Trainer
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

    Context@Push Party
	SECTION FRAGMENT "{NAME_VALUE} Party Pointers", ROMX, BANK[TrainerClass]
		{NAME_VALUE}Parties:
			INCLUDE "classes/Trainer/Parties/{NAME_VALUE}.asm"
    Context@Close
ENDM

REDEF PartyName EQUS ""
DEF PartyNameCount = 0
MACRO InitializeTeam
    ; store the previous Party Name and update with unique name
    REDEF PartyName{d:PartyNameCount} EQUS "{PartyName}"
    REDEF PartyName EQUS "Party_\@"

    ; increase the Party Name count
    DEF PartyNameCount += 1

    ; write the pointer to the party
    dw {PartyName}

    ; enter the team context
    Context@Push Team

    ; initialize the party data
    SetTeamCondition Standard

    SECTION "{PartyName} Party", ROMX, BANK[TrainerClass]
    {PartyName}:
        db {PartyName}Properties
    
    ; handle the arguments
    IF _NARG
        ; if the first argument is a number, then its a party definition
        is#Number \1
        IF so
            ParseTeamData \#
        ; otherwise, assume it is a macro and execute it
        ELSE            
            REDEF MACRO_NAME EQUS "\1"
            SHIFT
            {MACRO_NAME} \#
        ENDC
    ENDC
ENDM

MACRO CloseParty
    ; Build the properties byte
    ; todo - macro based on ByteStruct definition?
    DEF {PartyName}Properties = {PartyName}Condition

    ; decrease the Party Name count
    DEF PartyNameCount -= 1
    ; restore the previous Party Name
    REDEF PartyName EQUS "{PartyName{d:PartyNameCount}}"

    Context@Close ; close the team context
ENDM

; 1 = Trainer
MACRO InitializeBattle
	ConvertName \1
    REDEF BATTLE_TRAINER_NAME EQUS "{NAME_VALUE}"

    DEF BATTLE_PARTY_INDEX = {BATTLE_TRAINER_NAME}PartyCount
    DEF {BATTLE_TRAINER_NAME}PartyCount += 1

    REDEF BATTLE_TEAM_NAME EQUS "{BATTLE_TRAINER_NAME}Team{d:PARTY_INDEX}"
ENDM

MACRO SetTeamCondition
    SetTeamProperty Condition, \1
ENDM

; 1 = Property Name
; 2 = Property Value
MACRO SetTeamProperty
    DEF {PartyName}\1 = PartyDefinition#\1#\2
ENDM

MACRO Team_asm
    SetTeamCondition RoutineDefinition

    dba {PartyName}Routine

    Context@Push TeamASM
    SECTION "{PartyName} Routine", ROMX, BANK[CUR_BANK]
        {PartyName}Routine:
ENDM

; close the team asm context
MACRO TeamASM_End#Definition
    Context@Close
ENDM

; close the team context
MACRO Team_TeamASM_Finish
    CloseParty
ENDM

MACRO Team_switch
    Context@Set TeamSwitch

    ; If an argument was provided, then it is a ram value
    IF _NARG
        SetTeamCondition RAMValue
        dw \1
    ; Otherwise, it is a routine
    ELSE
        SetTeamCondition RoutineValue

        dba {PartyName}SwitchRoutine

        Context@Push TeamSwitchRoutine
        SECTION "{PartyName} Switch Routine", ROMX, BANK[CUR_BANK]
            {PartyName}SwitchRoutine:
    ENDC
ENDM

MACRO TeamSwitchRoutine_case
    Context@Close
    case \#
ENDM

; When a team switch value is finished, also close the party
MACRO Team_TeamSwitch_Finish
    CloseParty
ENDM

MACRO TeamSwitch_End#Definition
    Context@Close ; close the switch context
ENDM

MACRO TeamSwitch_case
    db \1 ; write the value to compare against

    Context@Set TeamSwitchCase

    ; if more than 1 arg, then the team is also defined
    IF _NARG > 1
        SHIFT
        Team \#
    ENDC
ENDM

; Implicitly open the Team context
MACRO TeamSwitchCase_switch
    Team
    switch \#
ENDM

; Initialize the team
MACRO TeamSwitchCase_Team
    InitializeTeam \#
ENDM

; When a team finishes, also close the case context
MACRO TeamSwitchCase_Team_Finish
    Context@Close
ENDM