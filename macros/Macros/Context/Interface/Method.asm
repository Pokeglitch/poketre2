; define a method for this Interface
macro Interface@method#define
    CheckReservedName \3

    ; Add the method to the list of methods
    append \2#Methods, \3

    def \2@\3#isLambda = false

    Interface@func \1, \2, \2@\3
endm

macro Interface@method#assign
    if def(\2@method)
        if _narg == 3
            def \@#macro equs "Interface@method#assign \#,"
            foreach \@#macro, {\3#Methods}
        else
            def \@#continue equs "Interface@method#assign#final \#,"
            Interface@continue \2@method, \@#continue, \1, \4
        endc
    endc
endm

macro Interface@method#assign#final
    if \3@\4#isSuper
        {\3@\4} \5, \1
    else
        redef \5 equs "Interface@method#execute \1, \2, \3, \4,"
    endc
endm

/*
    To run the Context method
        \1 - Context
        \2 - Type Name
        \3 - Interface Name
        \4 - Method Name
        \5+? - Arguments to forward to Method
*/
macro Interface@method#execute
    def \@#prev_super equs "{super}"

    {\3@\4#Super} super, \1

    def \@#macro equs "try_exec \3@\4,"

    if def(\2@handle)
        Interface@continue \2@handle, \@#macro, \#
    else
        shift 4
        \@#macro \#
    endc
    redef super equs "{\@#prev_super}"
endm
