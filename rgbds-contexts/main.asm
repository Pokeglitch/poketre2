/*
TODO:
    - vars can be combined with var by investigating if the return value starts with "
    -- also, have var work without function call as well (just to assign to a variable....purge first to be able to change from equs to =)
    --- also, allow code to exist before/after the function call...
*/

def _narg equs "_NARG"
def end equs "\tEnd#Definition"
def false equs "0"
def true equs "1"
def not equs "!"

/*  To define a macro string (to define another macro) which can only be used one
    After it gets use, it will 'dispose' itself (redefine itself to fail the next it gets used)
    \1 - Symbol to assign macro string to
    \2 - Symbol of macro it will define    */
macro disposable
    rept _narg/2
        redef \1 equs "\tdispose \1\nmacro \2"
        shift 2
    endr
endm

macro dispose
    rept _narg
        redef \1 equs "fail \"\1 is not available\"\n"
        shift
    endr
endm

def method equs "\tmethod#Definition"
macro method#Definition
    def \1 equs "\t\1#Definition"
    disposable args, \1#Definition
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
    for i, 2, _narg+1
        \1 \<i>
    endr
endm

macro sec
    if strcmp("\1","frag") == 0
        if \3
            section fragment "\2", romx, bank[\3]
        else
            section fragment "\2", rom0
        endc
    else
        if \2
            section "\1", romx, bank[\2]
        else
            section "\1", rom0
        endc
    endc
endm

/*  To purge the given arguments if they exist
    \1+ - Arguments to purge    */
macro try_purge
    rept _narg
        if def(\1)
            purge \1
        endc
        shift
    endr
endm

/*  To call the given macro with the given arguments if it exists
    \1   - Macro name
    \2+? - Optional arguments to pass to macro    */
macro try_exec
    if def(\1)
        exec \#
    endc
endm

macro exec
    redef \@#macro equs "\1"
    shift
    \@#macro \#
endm

macro append
    for i, 2, _narg+1
        if strlen("{\1}") == 0
            redef \1 equs "\<i>"
        else
            redef \1 equs "{\1},\<i>"
        endc
    endr
endm

macro result
    def so = (\1)
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

macro detuple
    if def(\1)
        if strin("{\1}","(") == 1 && strin("{\1}",")") == strlen("{\1}")
            redef \1 equs strsub("{\1}",2,strlen("{\1}")-2)
        endc
    else
        def \1 equs ""
    endc
endm

macro is#String
    def \@#char equs strsub("\1",1, 1)
    result strcmp("{\@#char}","\"") == 0
endm

macro backup
    for backup#i, 2, _narg+1
        if def(\<backup#i>)
            def \1#backup#\<backup#i> equs "{\<backup#i>}"
            purge \<backup#i>
        else
            def \1#backup#\<backup#i> equs "fail \"\<backup#i> is not defined\""
        endc
    endr
endm

macro restore
    for restore#i, 2, _narg+1
        redef \<restore#i> equs "{\1#backup#\<restore#i>}"
    endr
endm

/*
To include the given files in the given directory
    \1 - The directory
    \2+ - The names of file within that directory to include
        - If \2 is empty, then it will include a file within that directory with the same name as the directory
*/
method incdir
  args
    def \@#prev_base_dir equs "{base_dir}"

    redef base_dir equs "{base_dir}/\1"

    def \@#slash = strrin("\1","/")
    def \@#backslash = strrin("\1","\\")

    ; if 2nd argument is empty, then import the dirname
    if not strlen("\2")
        if \@#slash || \@#backslash
            if \@#slash > \@#backslash
                def \@#dirname equs strsub("\1",\@#slash+1)
            else
                def \@#dirname equs strsub("\1",\@#backslash+1)
            endc
        else
            def \@#dirname equs "\1"
        endc
        ; add a comma at the end
        redef \@#dirname equs "{\@#dirname},"
        shift ; need to shift twice to remove the empty string
    else
        ; othersize, set as empty string
        def \@#dirname equs ""
    endc

    shift
    incasm {\@#dirname} \#

    redef base_dir equs "{\@#prev_base_dir}"
endm

method incdirs
  args
    foreach incdir, \#
endm

method incasm
  args
    rept _narg
        include "{base_dir}/\1.asm"
        shift
    endr
endm

; to use if/so with macros that utilize 'return'
method does
args
    var_common false, "does \#", \@=\#
    result {\@}
endm

def base_dir equs "./rgbds-contexts"
incdir Context,, Trace
incdir Interface,, Forward, From, Method, Property
incdir Scope,, Overload, Return
incdir Struct,, ByteStruct
incdir Type,, Bool, Number, String, List, Enum, Stack
incdir Class,,
redef base_dir equs "."
