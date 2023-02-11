def Type equs "\tTypeDefinition"

    TryDefineContextMacro TypeDefinition
macro _TypeDefinition
    ; Push context so cant write to ROM
    PushContext TypeDefinition

    redef TYPE_NAME equs "\1"

    def \1#Property#_Count = 0
    def \1#Method#_Count = 0

    assign_type \1#Type, \2
    assign_match \1#isString, \2, String

    def func equs "macro \{METHOD_NAME}"
endm

    TryDefineContextMacro Property
macro TypeDefinition_Property
    unique AssignMember, Property, \1, \2
endm

    TryDefineContextMacro Method
macro TypeDefinition_Method
    def METHOD_NAME equs "{TYPE_NAME}@\1"
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
    ; define the macro to create a new instance
    def {TYPE_NAME} equs "InstantiateType {TYPE_NAME},"
    CloseContext
    try_purge func
endm

macro InstantiateType
    if \1#isString
        if _NARG == 3
            def \2 equs "\3"
        else
            def \2 equs ""
        endc
    else
        if _NARG == 3
            def \2 = \3
        else
            def \2 = 0
        endc
    endc

    def \2#_Class equs "\1"
    InitializeProperties \1, \2
    InitializeMethods \1, \2
endm

macro InitializeProperties
    for i, \1#Property#_Count
        redef MEMBER equs "{\1#Property#{d:i}}"
        assign_value \2#{{MEMBER}#Name}, {{MEMBER}#Value}
    endr
endm

macro InitializeMethods
    for i, \1#Method#_Count
        redef MEMBER equs "{\1#Method#{d:i}}"
        def \2@{{MEMBER}#Name} equs "{{MEMBER}#Value} \2,"
    endr
endm

/*
    \1 - Type Name
    \2 - Instance Name
    \3 - Member Type
    \4 - Divider    */
macro InitializeMembers
    for i, \1#\3#_Count
        redef MEMBER equs "{\1#\3#{d:i}}"
        assign_value \2\4{{MEMBER}#Name}, {{MEMBER}#Value}
    endr
endm

Type ListString, String
    Property Size, 0

    Method Add
    func
        if _NARG > 2
            redef METHOD_NAME equs "\1@Add"
            shift
            foreach {METHOD_NAME}, \#
        else
            if \1#Size
                redef \1 equs "{\1}, \2"
            else
                redef \1 equs "\2"
            endc
            def \1#Size += 1
        endc
    endm
end
