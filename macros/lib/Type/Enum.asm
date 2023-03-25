;   A Enum is a List where each value only appears once and is directly mapped to its index
Type Enum, List

    /*  To add the given values to the end of the given List
        \1  - List Symbol
        \2+ - Values to add    */
    method push
      args
        for i, 2, _narg+1
            def \1#\<i> = \1#_size
            redef \1#{d:\1#_size} equs "\<i>"
            \1@append \<i>
            \1#_size@inc
        endr
    endm

    method index
      args
        if def(\1#\2)
            return \1#\2
        else
            return -1
        endc
    endm

    method contains
      args
        if def(\1#\2)
            result true
        else
            result false
        endc
    endm
end
