def super equs "fail \"super does not exist for this context\"\n"
def self equs "fail \"self does not exist for this context\"\n"

/*  To generate a unique id and assign to global 'id' symbol, and optionally, the provided argument
    \1? - Symbol to assign to    */
macro uuid
    redef id equs "\@"
    if _narg == 1
        redef \1 equs "\@"
    endc
endm

Context Type
    init
        if _narg == 2
            def \1#Parent equs "\2"
        endc

        def \@#inherits equs "\1#Inherits"
        shift
        def  {\@#inherits} equs "\#"
    endm

    exit
        ; assign the supers from the parent
        if def(\1#Parent)
            Type@AssignParentMethods \1, {\1#Parent}, {{\1#Parent}#Methods}
        endc
        
        ; assign any missing supers to fail
        Type@InitializeSupers \1, {\1#Methods}
    endm

    open
        def \1#Symbol equs "\5"
        def \1#Type equs "\3"

        ; initialize the parents will overwrite continue, so store
        def \@#continue equs "{continue}"

        ; Initialize the parent
        if def(\3#Parent)
            {\3#Parent} \5
        endc

        ; remove Symbol from forward to Instance Init
        def \@#args equs "\1, \2, \3, \4"
        shift 5
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
        def \@#prev_self equs "{self}"
        def \@#prev_super equs "{super}"
        redef super equs "Type@Super \3, \4, {\1#Symbol},"

        def \@#continue equs "{continue}"

        def \@#context equs "\1"
        shift 4
        \@#continue {{\@#context}#Symbol}, \#

        redef super equs "{\@#prev_super}"
        redef self equs "{\@#prev_self}"
    endm
end

/*  \1 - Type Name
    \2 - Method Name
    \3 - Instance symbol    */
macro Type@Super
    def \@#prev_super equs "{super}"

    ; no need to handle case where no parent, because \@#macro will fail
    if def(\1#Parent)
        redef super equs "Type@Super {\1#Parent}, \2, \3,"
    endc

    def \@#macro equs "\1@\2#Super \3,"
    shift 3
    \@#macro \#

    redef super equs "{\@#prev_super}"
endm

/*  For all methods that dont have a super, assign the super to fail
    \1 - Type name    */
macro Type@InitializeSupers
    for i, 2, _narg+1
        if not def(\1@\<i>#Super)
            def \1@\<i>#Super equs "fail \"super does not exist for this context\"\n"
        endc
    endr
endm

/*  \1 - Type name
    \2 - Parent type name
    \3 - Parent methods    */
macro Type@AssignParentMethods
    for i, 3, _narg+1
        ; if not defined in this type, pull from parent
        if not def(\1@\<i>)
            def \1@\<i> equs "\2@\<i>"
            def \1@\<i>#Super equs "\2@\<i>#Super"
            append \1#Methods, \<i>
        else
            ; otherwise, the super is the parent
            def \1@\<i>#Super equs "\2@\<i>"
        endc
    endr
endm
