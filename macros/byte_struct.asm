Struct ByteStruct
    init
        Int \1#Shift
        def \1#Symbol equs "\2"
        Int \2#Shift
        def \2#Symbol equs "\2"
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
        def \1#\2#Max = \3
        def \1#\2#BitShift = \1#Shift
        def \1#\2#BitSize = STRLEN("{b:\1#\2#Max}")

        var \1#\2#BitMask = BitMask(\1#\2#BitSize, \1#Shift)
        
        \1#Shift@add \1#\2#BitSize
    endm

    method Array
    func
        def \@#start = 3

        is Number@test(\3)
        if so
            def \1#\2#BitSize = \3
            def \@#start += 1
        endc
        
        def \1#\2#BitShift = \1#Shift
        
        redef \1#\2#Size = -1

        for i, \@#start, _narg+1
            def \1#\2#Size += 1
            def \1#\2#\<{d:i}> = \1#\2#Size << \1#Shift
            def \1#\2#\<{d:i}>#Index = \1#\2#Size
            def \1#\2#{d:\1#\2#Size} equs "\<{d:i}>"
        endr

        def \@#bitsize = STRLEN("{b:\1#\2#Size}")

        def \1#\2#Size += 1

        if def(\1#\2#BitSize)
            if \1#\2#BitSize < \@#bitsize
                fail "Explicit bit size of {d:\1#\2#BitSize} is less than requried bit size of {d:\@#bitsize}"
            endc
        else
            def \1#\2#BitSize = \@#bitsize
        endc

        var \1#\2#BitMask = BitMask(\1#\2#BitSize, \1#Shift)
        \1#Shift@add \1#\2#BitSize
    endm

    method Flag
    func
        def \@#z_index = 3

        if _narg > 2
            is Number@test(\3)
            if so
                \1#Shift@add \3
                def \@#z_index += 1
            endc
        endc

        def \1#\2#BitIndex = \1#Shift
        def \1#\2#BitMask = 1 << \1#Shift

        if _narg >= \@#z_index
            def \@#nz_index = \@#z_index+1

            def \1#\2#\<{d:\@#z_index}>#BitIndex = \1#Shift
            def \1#\2#\<{d:\@#nz_index}>#BitIndex = \1#Shift
            
            def \1#\2#\<{d:\@#z_index}>#BitMask = 1 << \1#Shift
            def \1#\2#\<{d:\@#nz_index}>#BitMask = 1 << \1#Shift

            def \1#\2#\<{d:\@#z_index}>#Flag equs "z"
            def \1#\2#\<{d:\@#z_index}>#Not#Flag equs "nz"

            def \1#\2#\<{d:\@#nz_index}>#Flag equs "nz"
            def \1#\2#\<{d:\@#nz_index}>#Not#Flag equs "z"
        else
            def \1#\2#Not#Flag equs "z"
            def \1#\2#Flag equs "nz"
        endc
        
        \1#Shift@inc
        def \1#Flags#All#BitMask |= \1#\2#BitMask
    endm

    method Flags
    func
        def \1#\2#BitMask = 0

        for temp#flags#i, 3, _narg+1
            def \1#\2#BitMask += 1 << \1#Shift

            overload
                Flag \2#\<{d:temp#flags#i}>
            next
                Flag \<{d:temp#flags#i}>
            end
        endr
    endm

    exit
        if \1#Shift > 8
            fail "ByteStruct {\1#Symbol} exceeded 8 bits"
        endc
        def {\1#Symbol}#Flags#None#BitMask = %11111111 ^ {\1#Symbol}#Flags#All#BitMask
    endm
end
