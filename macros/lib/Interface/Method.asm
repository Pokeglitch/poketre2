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
        for i, 3, _narg+1
            def \2@\<i> equs "Interface@method#execute \2@\<i>, {temp@name},"
            append \2#Functions, \<i>
        endr
    endc
endm

/*  If the name starts with a #, then assign as a property

TODO:
- If the default starts with #, then it is a property
if default contains (), then execute return macro
    -- will run into issues with args#i, etc
*/
macro Interface@method#args
    redef args#trace equs "\1"
    redef args#context equs "\2"
    shift 2

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

            ; if it starts with a #, then assign as a property
            def \@#hash_index = strin("{\@#name}","#")
            if \@#hash_index == 1
                redef \@#name equs strsub("{\@#name}", 2)

                ; if a corresponding input was provided, then define
                if args#i < \1#num_inputs
                    def \@#input_index = args#i + 2
                    def \@#value equs "\<\@#input_index>"
                ; otherwise, if a default was provided, use that
                elif def(\@#default)
                    def \@#value equs "{\@#default}"
                endc

                ; if a value is to be assigned, then do so
                if def(\@#value)
                    def \@#continue equs "Interface@method#args#property {\@#value},"
                    Interface@continue {args#context}@property, \@#continue, {args#trace}, {\@#name}
                endc
            else
                def \@#append = true

                ; if the name is defined, then store the backup & purge
                if def({\@#name})
                    def \1#{\@#name} equs "{{\@#name}}"
                    purge {\@#name}
                endc

                ; if a corresponding input was provided, then define
                if args#i < \1#num_inputs
                    def \@#input_index = args#i + 2
                    def \@#value equs "\<\@#input_index>"
                ; otherwise, if a default was provided, use that
                elif def(\@#default)
                    def \@#value equs "{\@#default}"
                endc

                if def(\@#value)
                    if strcmp("{\@#name}","{\@#value}")
                        def {\@#name} equs "{\@#value}"
                    ; if the value is the same as the name, then use the prior value
                    else
                        if def(\1#{\@#name})
                            def {\@#name} equs "{\1#{\@#name}}"
                        ; if previously undefined, then leave purged and dont restore after
                        else
                            def \@#append = false
                        endc
                    endc
                endc

                if \@#append
                    ; add the name to the list of names
                    append \1#Names, {\@#name}
                endc
            endc
        endc
    endr
endm

macro Interface@method#args#property
    def \2 equs "\1"
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
    \3 - Trace
    \4 - Context Name
    \5 - Interface Name
    \6 - Method Name
    \7+? - Arguments to forward to Method
*/
macro Interface@method#execute
    backup \@, super, _nname

    redef \@#super equs "\1#Super"
    redef \@#macro equs "try_exec \2,"
    shift 2
    redef super equs "\@#super \1, \2, \3, \4,"

    redef define_args equs "dispose define_args\n\tInterface@method#args \1, \2, \@, \\#, \@,"
    redef _nname equs "\@#num_names"

    if def(\2@handle)
        Interface@continue \2@handle, \@#macro, \#
    else
        shift 4
        \@#macro \#
    endc

    Interface@method#args#restore \@, {\@#Names}

    restore \@, super, _nname
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
    for method#i, 5, _narg+1
        redef \<method#i> equs "{\3@\4} \1, \2, 3, \4,"
    endr
endm
