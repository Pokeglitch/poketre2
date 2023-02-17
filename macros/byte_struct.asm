; validation check that all calculations are identical
macro assert_attributes
    if _narg == 4
        assert \1\3\4 == \2#\3#\4
    else
        foreach 3, assert_attributes, \#
    endc
endm

macro assert_attributes_s
    if _narg == 4
        assert strcmp("{\1\3\4}", "{\2#\3#\4}") == 0
    else
        foreach 3, assert_attributes, \#
    endc
endm

macro assert_array
    assert_attributes \1, \2, \3, BitSize, BitShift, BitMask, Size
    for i, \1\3Size
        assert_attributes_s \1, \2, \3, {d:i}
        assert_all \1\3
        assert_all_s \1\3{\1\3{d:i}}, \2#\3#{\2#\3#{d:i}}
        assert_all_s \1\3{\1\3{d:i}}Index, \2#\3#{\2#\3#{d:i}}#Index
    endr
endm

macro assert_index
    assert_all \1\3Max, \2#\3#Max
    assert_all \1\3BitShift, \2#\3#BitShift
    assert_all \1\3BitSize, \2#\3#BitSize
    assert_all \1\3BitMask, \2#\3#BitMask
endm

macro assert_flags
    assert_all \1\3BitMask, \2#\3#BitMask
	assert_all \1\3\4BitIndex, \1\4BitIndex, \2#\3#\4#BitIndex, \2#\4#BitIndex
	assert_all \1\3\4BitMask, \1\4BitMask, \2#\3#\4#BitMask, \2#\4#BitMask
	assert_all_s \1\3\4Flag, \1\4Flag, \2#\3#\4#Flag, \2#\4#Flag
	assert_all_s \1Not\3\4Flag, \1Not\4Flag, \2#\3#\4#Not#Flag, \2#\4#Not#Flag
endm

macro assert_flag
	assert_all \1\3BitIndex, \2#\3#BitIndex
	assert_all \1\3BitMask, \2#\3#BitMask
	assert_all_s \1\3Flag, \2#\3#Flag
	assert_all_s \1Not\3Flag, \2#\3#Not#Flag
endm

macro assert_flag2
	assert_all \1\3BitIndex, \2#\3#BitIndex
	assert_all \1\3BitMask, \2#\3#BitMask
    
	assert_all \1\4\3BitIndex, \2#\3#\4#BitIndex
	assert_all \1\5\3BitIndex, \2#\3#\5#BitIndex
    
	assert_all \1\4\3BitMask, \2#\3#\4#BitMask
	assert_all \1\5\3BitMask, \2#\3#\5#BitMask

	assert_all_s \1\4\3Flag, \2#\3#\4#Flag
	assert_all_s \1\5\3Flag, \2#\3#\5#Flag
endm

macro assert_final
    assert_all \1AllBitMask, \2#Flags#All#BitMask
    assert_all \1NoneBitMask, \2#Flags#None#BitMask
endm

macro AssignBitMask
    def \1 = 0
    rept \2
        def \1 = (\1 << 1) | 1
    endr

    def \1 = \1 << \3
endm

Struct ByteStruct3
    init
        def \1#Symbol equs "\2"
        def \1#Shift = 0
        def \2#Flags#All#BitMask = 0
    endm

    method overload
    func
        enter Overload, \1#Shift
    endm

    /*
        \1 - Index Name
        \2 - Max Index Value
    */
    method Index
    func
        def \@#name equs "{\1#Symbol}#\2#"

        def {\@#name}Max = \3
        def {\@#name}BitShift = \1#Shift
        def {\@#name}BitSize = STRLEN("{b:{\@#name}Max}")

        AssignBitMask {\@#name}BitMask, {\@#name}BitSize, \1#Shift
        def \1#Shift += {\@#name}BitSize
    endm

    method Array
    func
        def \@#name equs "{\1#Symbol}#\2#"

        def \@#start = 3

        ; TODO - use when/Return
        IsNumber2 \3
        if IS_NUMBER
            def {\@#name}BitSize = \3
            def \@#start += 1
        endc
        
        def {\@#name}BitShift = \1#Shift
        
        redef {\@#name}Size = -1

        for i, \@#start, _narg+1
            def {\1#Symbol}#\2#Size += 1
            def {\1#Symbol}#\2#\<{d:i}> = {\1#Symbol}#\2#Size << \1#Shift
            def {\1#Symbol}#\2#\<{d:i}>#Index = {\1#Symbol}#\2#Size
            def {\1#Symbol}#\2#{d:{\1#Symbol}#\2#Size} equs "\<{d:i}>"
        endr

        def \@#bitsize = STRLEN("{b:{\@#name}Size}")

        def {\@#name}Size += 1

        if def({\@#name}BitSize)
            if {\@#name}BitSize < \@#bitsize
                fail "Explicit bit size of {d:{\@#name}BitSize} is less than requried bit size of {d:\@#bitsize}"
            endc
        else
            def {\@#name}BitSize = \@#bitsize
        endc

        AssignBitMask {\@#name}BitMask, {\@#name}BitSize, \1#Shift
        def \1#Shift += {\@#name}BitSize
    endm

    method Flag
    func
        def \@#name equs "{\1#Symbol}#\2#"
        def \@#z_index = 3

        if _narg > 2
            ; todo - use when/Return
            IsNumber2 \3
            if IS_NUMBER
                def \1#Shift += \3
                def \@#z_index += 1
            endc
        endc

        def {\@#name}BitIndex = \1#Shift
        def {\@#name}BitMask = 1 << \1#Shift

        if _narg >= \@#z_index
            def \@#nz_index = \@#z_index+1

            def {\@#name}\<{d:\@#z_index}>#BitIndex = \1#Shift
            def {\@#name}\<{d:\@#nz_index}>#BitIndex = \1#Shift
            
            def {\@#name}\<{d:\@#z_index}>#BitMask = 1 << \1#Shift
            def {\@#name}\<{d:\@#nz_index}>#BitMask = 1 << \1#Shift

            def {\@#name}\<{d:\@#z_index}>#Flag equs "z"
            def {\@#name}\<{d:\@#z_index}>#Not#Flag equs "nz"

            def {\@#name}\<{d:\@#nz_index}>#Flag equs "nz"
            def {\@#name}\<{d:\@#nz_index}>#Not#Flag equs "z"
        else
            def {\@#name}Not#Flag equs "z"
            def {\@#name}Flag equs "nz"
        endc
        
        def \1#Shift += 1
        def {\1#Symbol}#Flags#All#BitMask |= {\@#name}BitMask
    endm

    method Flags
    func
        def \@#name equs "{\1#Symbol}#\2#"
        def {\@#name}BitMask = 0

        for temp#flags#i, 3, _narg+1
            def {\1#Symbol}#\2#BitMask += 1 << \1#Shift

            overload
                Flag \2#\<{d:temp#flags#i}>
            next
                Flag \<{d:temp#flags#i}>
            end
        endr
    endm

    exit
        if \1#Shift > 8
            fail "Byte Struct exceeded 8 bits"
        endc
        def {\1#Symbol}#Flags#None#BitMask = %11111111 ^ {\1#Symbol}#Flags#All#BitMask
    endm
end

    ByteStruct3 PartyByteStruct
        Index Size, 2
        Array Numbers, zero, one, two, three
        overload
            Flag Emotion, Happy, Sad
        next
            Flag HasFriends
        end
        Flags Direction, Up, Down
    end

MACRO ByteStruct
    SetContext ByteStruct
    REDEF BYTE_STRUCT_NAME EQUS "\1"
    DEF BYTE_STRUCT_SHIFT = 0
    DEF {BYTE_STRUCT_NAME}AllBitMask = 0
ENDM

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
