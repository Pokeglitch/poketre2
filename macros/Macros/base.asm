def false equs "0"
def true equs "1"
def _narg equs "_NARG"

macro CheckReservedName
    if strcmp("\1","end") == 0
        redef \1 equs "EndDefinition"
    endc
endm

MACRO StartsWithDigit2
    IF STRIN("\1","\2") == 1
        DEF IS_NUMBER = 1
    ENDC
ENDM

MACRO IsNumber2
    DEF IS_NUMBER = 0
    StartsWithDigit2 \1, 0
    StartsWithDigit2 \1, 1
    StartsWithDigit2 \1, 2
    StartsWithDigit2 \1, 3
    StartsWithDigit2 \1, 4
    StartsWithDigit2 \1, 5
    StartsWithDigit2 \1, 6
    StartsWithDigit2 \1, 7
    StartsWithDigit2 \1, 8
    StartsWithDigit2 \1, 9
    StartsWithDigit2 \1, -
    StartsWithDigit2 \1, $
    StartsWithDigit2 \1, &
    StartsWithDigit2 \1, %
    StartsWithDigit2 \1, `
ENDM

macro append_to_string
    if strlen("{\1}")
        redef \1 equs "{\1}, \2"
    else
        redef \1 equs "\2"
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
    IsNumber2 \1
    if IS_NUMBER
        if \1 < 0
            fail "foreach argument amount must be positive: \1"
        endc

        redef arguments equs ""
        for i, 3, 3+\1
            append_to_string arguments, \<i>
        endr

        redef \@#macro equs "\2 {arguments},"
        shift 2+\1
        foreach \@#macro, \#
    else
        for i, 2, _narg+1
            \1 \<i>
        endr
    endc
endm

/*  To print given argument(s) on own line
    \1+ - Arguments to print    */
macro msg
    if _narg == 1
        print "\1\n"
    else
        foreach msg, \#
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

macro add_to_list
    if _narg == 2
        append_to_string \1, \2
    else
        foreach 1, add_to_list, \#
    endc
endm
