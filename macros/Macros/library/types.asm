def Type equs "\tTypeDefinition"
List Types ; list of all types

macro assign_type
    try_assign \1, \2, {Types}
endm

    DefineContextMacro TypeDefinition
macro _TypeDefinition
    ; Push context so cant write to ROM
    PushContext TypeDefinition

    ; Initialize the attributes of this Type
    def \1#Property#_Count = 0
    def \1#Method#_Count = 0
    assign_type \1#Type, \2

    Types@push \1

    redef TYPE_NAME equs "\1"
    def func equs "macro \{METHOD_NAME}"

    ; define method
    redef method equs "TypeDefinition_method"
endm

    DefineContextMacro prop
macro TypeDefinition_prop
    AssignMember Property, \2, \1
endm

macro TypeDefinition_method
    redef METHOD_NAME equs "{TYPE_NAME}@\1"
    AssignMember Method, \1, {METHOD_NAME}
endm

/*
    \1 - Member Type
    \2 - Member Name
    \3 - Member Value    */
    DefineContextMacro AssignMember
macro TypeDefinition_AssignMember
    def \@#Class equs "{TYPE_NAME}"
    def \@#Type equs "\1"
    def \@#Name equs "\2"
    def \@#Index = {{TYPE_NAME}#\1#_Count}
    def \@#Value equs "\3"

    ; Map the ID to the name and index
    def {TYPE_NAME}#\1#\2 equs "\@"
    def {TYPE_NAME}#\1#{d:{TYPE_NAME}#\1#_Count} equs "\@"

    ; Increase the Member Count
    def {TYPE_NAME}#\1#_Count += 1
endm

    DefineContextMacro EndDefinition
macro TypeDefinition_EndDefinition

    DefineContextMacro {TYPE_NAME}
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

    redef \2#_Class equs "\1"

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

        redef \2@{{MEMBER}#Name} equs "ExecuteTypeMethod \1, {{\1#Method#{d:i}}#Name}, \2,"
    endr
endm

macro Super@init
    def \1#macro equs \2
endm
    __Stack Super, ""

macro find_super
    if def(\1#Type)
        ; if the parent type had the macro, set that as the super
        if def({\1#Type}@\2)
            Super@push "ExecuteTypeMethod \{\1#Type}, \2, \3,"
            redef super equs "{{Super}#macro}"
        ;otherwise, check the next parent
        else
            find_super {\1#Type}, \2, \3
        endc
    else
        Super@push ""
        try_purge super ; todo - fail message
    endc
endm

macro ExecuteTypeMethod
    find_super \1, \2, \3

    def \@#macro equs "\1@\2"
    shift 2
    {\@#macro} \#

    Super@pop

    if strcmp("{{Super}#macro}", "")
        redef super equs "{{Super}#macro}"
    else
        try_purge super ; todo - fail message
        ; is this necessary if the #macro is already a fail message?
        ; - need to make sure a fail message is pushed initially
    endc
endm

    DefineContextMacro String
macro Global_String
    if _narg == 2
        redef \1 equs "\2"
    else
        redef \1 equs ""
    endc
endm
    Types@push String

    DefineContextMacro Number
macro Global_Number
    if _narg == 2
        def \1 = \2
    else
        def \1 = 0
    endc
endm
    Types@push, Number

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

TODO
    - utilize List@push
    - add @contains method
*/
Type Array, String
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

        Array temp#PoppedList

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
    Array history

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