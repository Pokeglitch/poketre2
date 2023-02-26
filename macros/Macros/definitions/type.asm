    List Types
    Types@push Number, String, List

Definition Type
    init
        if _narg < 2
            fail "Missing Base Type for \1"
        endc

        Types@contains \2
        if not
            fail "\2 is not a valid Type"
        endc

        ; Declare the Base Type for this Type
        def \1#Base equs "\2"
    endm

    exit
        ; store as new type
        Types@push \1
    endm

    open
        def \1#Symbol equs "\5"
        def \1#Type equs "\3"

        ; define the macro to init the Base Type
        def \@#base equs "\3#Base \5,"

        ; remove Symbol from forward to Instance Init
        def \@#args equs "\1, \2, \3, \4"
        shift 5

        def \@#continue equs "{continue}"
        ; Initialize the base type
        ; NOTE - this will overwrite continue, so needs to be backed up
        \@#base \#

        \@#continue {\@#args}, \#

        ; auto close the context
        end
    endm

    method
        continue {\1#Symbol}@\2
    endm

    property
        continue {\1#Symbol}#\2
    endm

    handle
        def \@#context equs "\1"
        shift 4

        continue {{\@#context}#Symbol}, \#
    endm
end


Type Int, Number
    init
        def \1#Initial = \1
    endm

    method inc
    func
        def \1 += 1
    endm

    method dec
    func
        def \1 -= 1
    endm

    method reset
    func
        def \1 = \1#Initial
    endm

    method set
    func
        def \1 = \2
    endm

    method add
    func
        def \1 += \2
    endm

    method sub
    func
        def \1 -= \2
    endm
end

/*
NOTE:if directly changing elements, the string value will not match
    - Use the 'set' macro

TODO
    - utilize List@push
    - add @contains method
*/
Type Array2, String
    property Int, size
    
    method _in_range
    func
        def index\@ = \2
        if def(\1#{d:index\@}) == 0
            fail "Index out of range: \1#{d:index\@}"
        endc
    endm

    method _to_index
    func
        if \2 < 0
            return \1#size + \2
        else
            return \2
        endc
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

        if index == \1#size
            \1#size@inc
        else
            \1@_in_range index
        endc

        redef \1#{d:index} equs "\3"
        \1@_compile
    endm

    method insert
    func
        var start = \1@_to_index(\2)

        if start != \1#size
            \1@_in_range start
        endc

        def amount = _narg-2

        ; shift the elements after the insertion index upwards
        for i, \1#size-1, start-1, -1
            def index = i+amount
            redef \1#{d:index} equs "{\1#{d:i}}"
        endr

        ; add the new elements
        for i, 3, _narg+1
            redef \1#{d:start} equs "\<i>"
            def start += 1
        endr

        ; Update the size and recompile
        \1#size@add amount
        \1@_compile
    endm

    method push
    func
        if _narg > 2
            redef method\@ equs "\1@push"
            shift
            foreach method\@, \#
        else
            if _narg > 1
                if \1#size
                    redef \1 equs "{\1}, \2"
                else
                    redef \1 equs "\2"
                endc
                redef \1#{d:\1#size} equs "\2"
            else
                if \1#size
                    redef \1 equs "{\1},"
                endc
                redef \1#{d:\1#size} equs ""
            endc
            \1#size@inc
        endc
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

        Array2 temp#PoppedList

        for i, start, start+amount
            \1@_in_range {i}
            temp#PoppedList@push {\1#{d:i}}
            purge \1#{d:i}
        endr
        \1@_compile

        return {temp#PoppedList}
    endm

    method reset
    func
        redef \1 equs ""
        \1#size@reset
    endm

    method _compile
    func
        def size = \1#size
        \1@reset

        for i, size
            if def(\1#{d:i})
                \1@push {\1#{d:i}}
            endc
        endr
    endm
end

Type Stack, String
    Array2 history

    method push
    func
        \1#history@push {\1}
        redef \1 equs \2
    endm

    method pop
    func
        vars \1 = \1#history@pop()
    endm
end

Type Path, Stack
    method push
    func
        if \1#history#size
            super "\1/\2"
        else
            super "\2"
        endc
    endm

    method import
    func
        \1@push \2

        for i, 3, _narg+1
            include "{\1}/\<i>.asm"
        endr

        Directory@pop
    endm
end

    Path Directory
