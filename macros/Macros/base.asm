; TODO - need to make a full list of reserved names, and list of remapped names
; then, if name is in list, use remap
macro CheckReservedName
    if strcmp("\1","end") == 0
        redef \1 equs "EndDefinition"
    endc
endm

/*  To send each argument to the given macro individually

if the first argument is a number:
    \1 - Number of arguments that will be forwarded to all macro calls
    \2 - Macro name
    \3+ - First, \1 Argument(s) that will be forwarded to all calls
        - Then, Argument(s) to pass to macro individually

otherwise:
    \1  - Macro Name
    \2+ - Argument(s) to pass to macro individually    */
macro foreach
    is#Number \1
    if so
        if \1 < 0
            fail "foreach argument amount must be positive: \1"
        endc

        List temp#arguments
        for i, 3, 3+\1
            temp#arguments@push \<i>
        endr

        redef \@#macro equs "\2 {temp#arguments},"
        shift 2+\1
        foreach \@#macro, \#
    else
        for i, 2, _narg+1
            \1 \<i>
        endr
    endc
endm

/*  To purge the given arguments if they exist
    \1+ - Arguments to purge    */
macro try_purge
    if _narg == 1
        if def(\1)
            purge \1
        endc
    else
        foreach try_purge, \#
    endc
endm

/*  To call the given macro with the given arguments if it exists
    \1   - Macro name
    \2+? - Optional arguments to pass to macro    */
macro try_exec
    redef \@#macro equs "\1"
    shift
    if def({\@#macro})
        {\@#macro} \#
    endc
endm

/*  To mark this given string macro(s) as already used
    \1+ - Symbol(s) of string(s)    */
macro single_use
    if _narg == 1
        redef \1 equs "fail \"\1 has aready been called\"\n"
    else
        foreach single_use, \#
    endc
endm

/*  To assign a value to the given symbol
    \1 - Symbol
    \2 - Value    */
macro assign_value
    if strin("\2","\"") == 1
        def \1 equs \2
    else
        def \1 = \2
    endc
endm

/*
NOTE: This assumes values are symbols, not numbers
    \1  - Symbol to assign to
    \2  - Value to assign
    \3+ - Valid values
*/
macro try_assign
    def MATCH_FOUND = 0
    redef SYMBOL equs "\1"
    redef VALUE equs "\2"
    shift 2

    for i, 1, _narg+1
        if MATCH_FOUND == 0 && strcmp("{VALUE}", "\<i>") == 0
            def MATCH_FOUND = 1
        endc
    endr

    if MATCH_FOUND
        assign_value {SYMBOL}, "{VALUE}"
    else
        fail "\n{SYMBOL} value is not valid.\n\tExpected one of: \#\n\tReceived: {VALUE}\n"
    endc
endm
