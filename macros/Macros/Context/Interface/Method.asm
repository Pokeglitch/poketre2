macro Interface@method
    is#String \<_NARG>
    if so
        for i, 3, _narg
            def \2@\<i> equs "Interface@method#lambda \<_NARG>,"
            append \2#Functions, \<i>
        endr
    else
        redef temp@name equs "\2@\@"
        Interface@args \1, \2, {temp@name}
        redef args equs "{args}\n\tdefine_args"
        for i, 3, _narg+1
            def \2@\<i> equs "Interface@method#execute \2@\<i>, {temp@name},"
            append \2#Functions, \<i>
        endr
    endc
endm

macro Interface@method#args
    ; find the end of the inputs list
    for args#i, 2, _narg+1
        if strcmp("\<args#i>","\1") == 0
            break
        endc
    endr

    def \1#num_inputs = args#i-2
    def \1#num_names = _narg-args#i
    def \1#Names equs ""

    for args#i, \1#num_names
        def \@#name_index = args#i + \1#num_inputs + 3
        def \@#name equs "\<{d:\@#name_index}>"

        ; if name is not empty:
        if strcmp("{\@#name}","")
            ; if there is an '=', then split and re-assign name, default
            def \@#equal_index = strin("{\@#name}","=")
            if \@#equal_index
                redef \@#default equs strsub("{\@#name}", \@#equal_index+1)
                redef \@#name equs strsub("{\@#name}", 1, \@#equal_index-1)
            endc

            ; if the name is defined, then store the backup & purge
            if def({\@#name})
                def \1#{\@#name} equs "{{\@#name}}"
                purge {\@#name}
            endc

            ; if a corresponding input was provided, then define
            if args#i < \1#num_inputs
                def \@#input_index = args#i + 2
                def {\@#name} equs "\<\@#input_index>"
            ; otherwise, if a default was provided, use that
            elif def(\@#default)
                def {\@#name} equs "{\@#default}"
            endc

            ; add the name to the list of names
            append \1#Names, {\@#name}
        endc
    endr
endm

macro Interface@method#args#restore
    for args#i, 2, _narg+1
        try_purge \<args#i>
        ; if the symbol was backed-up, then restore
        if def(\1#\<args#i>)
            redef \<args#i> equs "{\1#\<args#i>}"
        endc
    endr
endm

/*
    \1 - Symbol to get super from
    \2 - Method to execute
    \3 - Context
    \4 - Type Name
    \5 - Interface Name
    \6 - Method Name
    \7+? - Arguments to forward to Method
*/
macro Interface@method#execute
    backup \@, super, shift_args

    redef \@#super equs "\1#Super"
    redef \@#macro equs "try_exec \2,"
    shift 2
    redef super equs "\@#super \1, \2, \3, \4,"

    redef define_args equs "dispose define_args\n\tInterface@method#args \@, \\#, \@,"
    redef shift_args equs "dispose shift_args\n\tshift \@#num_names"

    if def(\2@handle)
        Interface@continue \2@handle, \@#macro, \#
    else
        shift 4
        \@#macro \#
    endc

    ; todo - where does this occur?
    if def(\@#Names)
        Interface@method#args#restore \@, {\@#Names}
    else
        def \@#define_args = def(define_args)
        msg AAAAAA | {\@#define_args} | {\@#macro} | "\#"
    endc

    restore \@, super, shift_args
endm

macro Interface@method#lambda
    def \@#macro equs \1
    shift 5
    \@#macro \#
endm

macro Interface@method#inherit
    for i, 4, _narg+1
        ; if not defined in this type, pull from parent
        if not def(\2@\<i>)
            redef \2@\<i> equs "{\3@\<i>}"
            redef \2@\<i>#Super equs "{\3@\<i>#Super}"
            append \2#Functions, \<i>
        ; otherwise, the super is the parent
        else
            redef \2@\<i>#Super equs "{\3@\<i>}"
        endc
    endr
endm

/*  For all methods that dont have a super, assign the super to fail
    \1 - Type name    */
macro Interface@method#inherit#fail
    for i, 2, _narg+1
        if not def(\1@\<i>#Super)
            redef \1@\<i>#Super equs "fail \"super does not exist for this context\","
            redef \1@\<i>#isSuper = false
        endc
    endr
endm

macro Interface@method#assign
    if def(\2@method)
        for i, 4, _narg+1
            def \@#continue equs "Interface@method#assign#final \1, \2, \3, \<i>,"
            Interface@continue \2@method, \@#continue, \1, \<i>
        endr
    endc
endm

macro Interface@method#assign#final
    redef \5 equs "{\3@\4} \1, \2, 3, \4,"
endm
