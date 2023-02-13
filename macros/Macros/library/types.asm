def Type equs "\tTypeDefinition"
def Type#_Count = 0

macro assign_type
    ListToString Type
    try_assign \1, \2, {LIST_STRING}
endm

macro add_to_list
    if _narg == 2
        def \1#_{d:\1#_Count} equs "\2"
        def \1#_Count += 1
    else
        redef MACRO_NAME equs "add_to_list \1,"
        shift
        foreach MACRO_NAME, \#
    endc
endm

    TryDefineContextMacro TypeDefinition
macro _TypeDefinition
    ; Push context so cant write to ROM
    PushContext TypeDefinition

    ; Initialize the attributes of this Type
    def \1#Property#_Count = 0
    def \1#Method#_Count = 0
    assign_type \1#Type, \2

    add_to_list Type, \1

    redef TYPE_NAME equs "\1"
    def func equs "macro \{METHOD_NAME}"
endm

    TryDefineContextMacro prop
macro TypeDefinition_prop
    unique AssignMember, Property, \2, \1
endm

    TryDefineContextMacro method
macro TypeDefinition_method
    redef METHOD_NAME equs "{TYPE_NAME}@\1"
    unique AssignMember, Method, \1, {METHOD_NAME}
endm

/*
    \1 - Unique ID
    \2 - Member Type
    \3 - Member Name
    \4 - Member Value    */
    TryDefineContextMacro AssignMember
macro TypeDefinition_AssignMember
    def \1#Class equs "{TYPE_NAME}"
    def \1#Type equs "\2"
    def \1#Name equs "\3"
    def \1#Index = {{TYPE_NAME}#\2#_Count}
    def \1#Value equs "\4"

    ; Map the ID to the name and index
    def {TYPE_NAME}#\2#\3 equs "\1"
    def {TYPE_NAME}#\2#{d:{TYPE_NAME}#\2#_Count} equs "\1"

    ; Increase the Member Count
    def {TYPE_NAME}#\2#_Count += 1
endm

    TryDefineContextMacro EndDefinition
macro TypeDefinition_EndDefinition

    TryDefineContextMacro {TYPE_NAME}
    ; define the macro to create a new instance
    def Global_{TYPE_NAME} equs "InstantiateType {TYPE_NAME},"
    def TypeDefinition_{TYPE_NAME} equs "prop {TYPE_NAME},"

    CloseContext
    try_purge func
endm

macro InstantiateType
    if _narg == 3
        Global_{\1#Type} \2, \3
    else
        Global_{\1#Type} \2
    endc

    def \2#_Class equs "\1"
    InitializeProperties \1, \2
    InitializeMethods \1, \2
endm

macro InitializeProperties
    for i, \1#Property#_Count
        redef MEMBER equs "{\1#Property#{d:i}}"
        {{MEMBER}#Value} \2#{{MEMBER}#Name}
    endr
endm

macro InitializeMethods
    for i, \1#Method#_Count
        redef MEMBER equs "{\1#Method#{d:i}}"
        def \2@{{MEMBER}#Name} equs "{{MEMBER}#Value} \2,"
    endr
endm





    TryDefineContextMacro String
macro Global_String
    if _narg == 2
        redef \1 equs "\2"
    else
        redef \1 equs ""
    endc
endm
    add_to_list Type, String

    TryDefineContextMacro Number
macro Global_Number
    if _narg == 2
        def \1 = \2
    else
        def \1 = 0
    endc
endm
    add_to_list Type, Number

Type Int, Number
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
        def \1 = 0
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

TODO - add @contains method
*/
Type List, String
    Int size
    
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
            msg \t{start}: \<i>
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
            if \1#size
                redef \1 equs "{\1}, \2"
            else
                redef \1 equs "\2"
            endc

            redef \1#{d:\1#size} equs "\2"
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

        for i, start, start+amount
            \1@_in_range {i}
            purge \1#{d:i}
        endr
        \1@_compile
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
