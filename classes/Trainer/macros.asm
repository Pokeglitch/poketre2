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

Party_Battle: MACRO
    DEF PARTY_INDEX = {NAME_VALUE}PartyCount
    REDEF PARTY_NAME EQUS "{NAME_VALUE}Party{d:PARTY_INDEX}"

	SECTION FRAGMENT "{NAME_VALUE} Party Pointers", ROMX, BANK[TrainerClass]
        ; add pointer to party
        dw {PARTY_NAME}

    ; add party data
    SECTION FRAGMENT "{NAME_VALUE} Parties", ROMX, BANK[TrainerClass]
        {PARTY_NAME}:
            db {PARTY_NAME}Properties

        ; define after allocating to use final value
        DEF {PARTY_NAME}Properties = 0

    DEF {NAME_VALUE}PartyCount += 1
ENDM

Party_switch: MACRO
    ; todo - need to set a flag instead
    DEF {PARTY_NAME}Properties = -1
    
    dw \1
ENDM

Party_case: MACRO
    db \1
ENDM

Party_end: MACRO
    CloseContext
ENDM

PartyDataTerminator = -1

Party2: MACRO
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
