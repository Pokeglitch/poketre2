def false equs "0"
def true equs "1"
def _narg equs "_NARG"

macro req_single_chars
    def macro\@ equs "req_single_char \1, \2,"
    shift 2
    foreach macro\@, \#
endm

/*  To require a single instance of the given char
    \1 - Symbol of String
    \2 - Symbol of fail message
    \3 - Char    */
macro req_single_char
    if strin("{\1}","\3") != strrin("{\1}","\3")
        fail "Invalid syntax - multiple \3\n\t{\2}"
    elif strin("{\1}","\3") == 0
        fail "Invalid syntax - missing \3\n\t{\2}"
    endc
endm

/*
TODO - confirm the string format is valid if using = & ()?
*/
macro var
    if strin("\1","=")
        redef \@ equs strrpl("\1","=",",")
        redef \@ equs strrpl("{\@}","(",",")
        redef \@ equs strrpl("{\@}"," ","")
        shift
        redef \@ equs "{\@},\#"
        redef \@ equs strrpl("{\@}",")","")
        var {\@}
    else
        redef RETURN_VALUE equs "\1"
        redef MACRO_NAME equs "\2"
        shift 2
        {MACRO_NAME} \#
        purge RETURN_VALUE
    endc
endm

macro return
    assign_value {RETURN_VALUE}, \1
endm

/*  To send each argument to the given macro individually
    \1  - Macro Name
    \2+ - Argument(s) to pass to macro individually    */
macro foreach
    for i, 2, _NARG+1
        \1 \<i>
    endr
endm

/*  To print given argument(s) on own line
    \1+ - Arguments to print    */
macro msg
    if _NARG == 1
        print "\1\n"
    else
        foreach msg, \#
    endc
endm

/*  To purge the given arguments if they exist
    \1+ - Arguments to purge    */
macro try_purge
    if _NARG == 1
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
    redef TRY_EXEC_MACRO_NAME equs "\1"
    shift
    if def({TRY_EXEC_MACRO_NAME})
        {TRY_EXEC_MACRO_NAME} \#
    endc
endm

/*  To mark this given string macro(s) as already used
    \1+ - Symbol(s) of string(s)    */
macro single_use
    if _NARG == 1
        redef \1 equs "fail \"\1 has aready been called\"\n"
    else
        foreach single_use, \#
    endc
endm

/*  To create a unique ID and forward it (and other arguments) to given macro
    \1   - Macro to forward it to
    \2+? - Optional arguments to forward it to    */
macro unique
    redef MACRO_NAME equs "\1"
    shift
    {MACRO_NAME} \@, \#
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

macro ListToString
    redef LIST_STRING equs ""
    for i, \1#_Count
        AddToString LIST_STRING, {\1#_{d:i}}
    endr
endm

macro AddToString
    if strlen("{\1}")
        redef \1 equs "{\1}, \2"
    else
        redef \1 equs "\2"
    endc
endm

macro assign_match
    check_match \#
    def \1 = MATCH_FOUND
endm

macro check_match
    def MATCH_FOUND = 0
    redef SYMBOL equs "\1"
    redef VALUE equs "\2"
    shift 2

    for i, 1, _NARG+1
        if MATCH_FOUND == 0 && strcmp("{VALUE}", "\<i>") == 0
            def MATCH_FOUND = 1
        endc
    endr
endm

/*
NOTE: This assumes values are symbols, not numbers
    \1  - Symbol to assign to
    \2  - Value to assign
    \3+ - Valid values
*/
macro try_assign
    check_match \#
    shift 2
    if MATCH_FOUND
        assign_value {SYMBOL}, "{VALUE}"
    else
        fail "\n{SYMBOL} value is not valid.\n\tExpected one of: \#\n\tReceived: {VALUE}\n"
    endc
endm

/*
    \1  - Type
    \2+ - Strings to compare to
*/
macro match_strings
    def STRING_MATCH = 0
    def MACRO_NAME equs "match_string \1,"
    shift
    foreach MACRO_NAME, \#
endm

/*
    \1, \2 - Strings to compare
*/
macro match_string
    if strcmp("\1", "\2") == 0
        def STRING_MATCH = 1
    endc
endm




/*  To keep track of current directory path for simpler including */
    Stack Directory

macro Define_Directory
    if \1#Index > 1
        def \1Path equs "{{\1#Parent}Path}/\1"
    else
        def \1Path equs "\2"
    endc
endm

/*  To include given files in given directory
    \1  - Directory name
    \2+ - File name(s)    */
macro incDir
    Push_Directory \1
    for i, 2, _NARG+1
        include "{{Directory}Path}/\<i>.asm"
    endr
    Pop_Directory
endm
