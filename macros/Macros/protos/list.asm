;   A List is a string of comma separated values
Proto List, String
    property Number, _size
    init
        List@push \#
    endm

    method _to_index
    func
        if \2 < 0
            return \1#_size + \2
        else
            return \2
        endc
    endm

    method _in_range
    func
        def \@#index = \2
        if def(\1#{d:\@#index}) == 0
            fail "Index out of range: \1#{d:\@#index}"
        endc
    endm
    
    method _compile
    func
        def \@#size = \1#_size
        \1@reset

        for i, \@#size
            if def(\1#{d:i})
                \1@push {\1#{d:i}}
            endc
        endr
    endm

    method get
    func
        var index = \1@_to_index(\2)
        \1@_in_range index
        return {\1#{d:index}}
    endm

    method set
    func
        var index = \1@_to_index(\2)

        if index == \1#_size
            \1#_size@inc
        else
            \1@_in_range index
        endc

        redef \1#{d:index} equs "\3"
        \1@_compile
    endm
    
    ; TODO - use super to reset the string value
    method reset
    func
        redef \1 equs ""
        \1#_size@reset
    endm

    method insert
    func
        var start = \1@_to_index(\2)

        if start != \1#_size
            \1@_in_range start
        endc

        def amount = _narg-2

        ; shift the elements after the insertion index upwards
        for i, \1#_size-1, start-1, -1
            def index = i+amount
            redef \1#{d:index} equs "{\1#{d:i}}"
        endr

        ; add the new elements
        for i, 3, _narg+1
            redef \1#{d:start} equs "\<i>"
            def start += 1
        endr

        ; Update the size and recompile
        \1#_size@add amount
        \1@_compile
    endm

    /*  To add the given values to the end of the given List
        \1  - List Symbol
        \2+ - Values to add    */
    method push
    func
        for i, 2, _narg+1
            redef \1#{d:\1#_size} equs "\<i>"
            \1@append \<i>
            \1#_size@inc
        endr
    endm

    /*
        - if no arguments, will pop last element
        - if 1 argument, will pop element at that index (can go negative)
        - if 2 arguments, 2nd argument is amount of elements to pop
    */
    method pop
    func
        def amount = 1

        if _narg > 1
            var start = \1@_to_index(\2)

            if _narg == 3
                def amount = \3
            endc
        else
            var start = \1@_to_index(-1)
        endc

        List pop#list

        for pop#i, start, start+amount
            \1@_in_range {pop#i}
            pop#list@push {\1#{d:pop#i}}
            purge \1#{d:pop#i}
        endr
        \1@_compile

        return {pop#list}
    endm

    method contains
    func
        result false
        for i, \1#_size
            if strcmp("{\1#{d:i}}","\2") == 0
                result true
                break
            endc
        endr
    endm
end
