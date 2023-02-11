MACRO ByteStruct
    SetContext ByteStruct
    REDEF BYTE_STRUCT_NAME EQUS "\1"
    DEF BYTE_STRUCT_SHIFT = 0
    DEF {BYTE_STRUCT_NAME}AllBitMask = 0
ENDM

redef ByteStruct#LocalMacros equs "Index, Array, Flag, Flags"

macro ByteStruct_overload
    redef _self equs "{self}"
    enter Overload, BYTE_STRUCT_SHIFT
endm

MACRO ByteStruct_EndDefinition
    IF BYTE_STRUCT_SHIFT > 8
        FAIL "Byte Struct exceeded 8 bits"
    ENDC
    DEF {BYTE_STRUCT_NAME}NoneBitMask = %11111111 ^ {BYTE_STRUCT_NAME}AllBitMask
    CloseContext
ENDM

MACRO ByteStruct_Index
	REDEF INDEX_NAME EQUS "{BYTE_STRUCT_NAME}\1"

    DEF {INDEX_NAME}Max = \2
    DEF {INDEX_NAME}BitShift = BYTE_STRUCT_SHIFT
    DEF {INDEX_NAME}BitSize = STRLEN("{b:{INDEX_NAME}Max}")

    BitMask {INDEX_NAME}BitSize, BYTE_STRUCT_SHIFT
    DEF {INDEX_NAME}BitMask = BIT_MASK
    DEF BYTE_STRUCT_SHIFT += {INDEX_NAME}BitSize
ENDM

; optional number to explicitly define bit length, otherwise will calc on own
MACRO ByteStruct_Array
	REDEF ARRAY_NAME EQUS "{BYTE_STRUCT_NAME}\1"
	SHIFT

	IsNumber \1
	IF IS_NUMBER
        DEF {ARRAY_NAME}BitSize = \1
		SHIFT
	ELSE
        DEF {ARRAY_NAME}BitSize = 0
	ENDC
	
    DEF {ARRAY_NAME}BitShift = BYTE_STRUCT_SHIFT
    DEF ARRAY_INDEX = -1

	REPT _NARG
        DEF ARRAY_INDEX = ARRAY_INDEX + 1
        DEF {ARRAY_NAME}\1 = ARRAY_INDEX << BYTE_STRUCT_SHIFT
		DEF {ARRAY_NAME}\1Index = ARRAY_INDEX
        DEF {ARRAY_NAME}{d:ARRAY_INDEX} EQUS "\1"
		SHIFT
	ENDR

    DEF {ARRAY_NAME}Size = ARRAY_INDEX+1

    DEF BIT_SIZE = STRLEN("{b:ARRAY_INDEX}")

    IF {ARRAY_NAME}BitSize
        IF {ARRAY_NAME}BitSize < BIT_SIZE
            FAIL "Explicit bit size of {d:{ARRAY_NAME}BitSize} is less than requried bit size of {d:BIT_SIZE}"
        ENDC
    ELSE
        DEF {ARRAY_NAME}BitSize = BIT_SIZE
    ENDC

    BitMask {ARRAY_NAME}BitSize, BYTE_STRUCT_SHIFT
    DEF {ARRAY_NAME}BitMask = BIT_MASK
    DEF BYTE_STRUCT_SHIFT += {ARRAY_NAME}BitSize
ENDM

MACRO ByteStruct_Flag
    REDEF FLAG_NAME EQUS "\1"
    SHIFT

    IF _NARG
        IsNumber \1
        IF IS_NUMBER
            DEF BYTE_STRUCT_SHIFT += \1
            SHIFT
        ENDC
    ENDC

    DEF {BYTE_STRUCT_NAME}{FLAG_NAME}BitIndex = BYTE_STRUCT_SHIFT
    DEF {BYTE_STRUCT_NAME}{FLAG_NAME}BitMask = 1 << BYTE_STRUCT_SHIFT

    IF _NARG
        DEF {BYTE_STRUCT_NAME}\1{FLAG_NAME}BitIndex = BYTE_STRUCT_SHIFT
        DEF {BYTE_STRUCT_NAME}\2{FLAG_NAME}BitIndex = BYTE_STRUCT_SHIFT
        
        DEF {BYTE_STRUCT_NAME}\1{FLAG_NAME}BitMask = 1 << BYTE_STRUCT_SHIFT
        DEF {BYTE_STRUCT_NAME}\2{FLAG_NAME}BitMask = 1 << BYTE_STRUCT_SHIFT

        DEF {BYTE_STRUCT_NAME}\1{FLAG_NAME}Flag EQUS "z"
        DEF {BYTE_STRUCT_NAME}\2{FLAG_NAME}Flag EQUS "nz"
    ELSE
        DEF {BYTE_STRUCT_NAME}Not{FLAG_NAME}Flag EQUS "z"
        DEF {BYTE_STRUCT_NAME}{FLAG_NAME}Flag EQUS "nz"
    ENDC
    
    DEF BYTE_STRUCT_SHIFT += 1
    
    DEF {BYTE_STRUCT_NAME}AllBitMask |= {BYTE_STRUCT_NAME}{FLAG_NAME}BitMask
ENDM

MACRO ByteStruct_Flags
    DEF ALL_MASK_VALUE = 0
    REDEF FLAGS_GROUP_NAME EQUS "\1"
    SHIFT
    REPT _NARG
        DEF ALL_MASK_VALUE += 1 << BYTE_STRUCT_SHIFT
        overload
            Flag {FLAGS_GROUP_NAME}\1
        next
            Flag \1
        end
        SHIFT
    ENDR
    DEF {BYTE_STRUCT_NAME}{FLAGS_GROUP_NAME}BitMask = ALL_MASK_VALUE
ENDM
