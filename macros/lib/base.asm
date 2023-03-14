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

def define equs "\tdefine#Definition"
macro define#Definition
    def \1 equs "\t\1#Definition"
    disposable func, \1#Definition
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
        section fragment "\2", romx, bank[\3]
    else
        section "\1", romx, bank[\2]
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

macro is#String
    def \@#char equs strsub("\1",1, 1)
    result strcmp("{\@#char}","\"") == 0
endm

macro backup
    for backup#i, 2, _narg+1
        def \1#backup#\<backup#i> equs "{\<backup#i>}"
    endr
endm

macro restore
    for restore#i, 2, _narg+1
        redef \<restore#i> equs "{\1#backup#\<restore#i>}"
    endr
endm





define incdir
func
    def \@#prev_base_dir equs "{base_dir}"

    redef base_dir equs "{base_dir}/\1"

    incasm \#

    redef base_dir equs "{\@#prev_base_dir}"
endm

define incdirs
func
    foreach incdir, \#
endm

define incasm
func
    rept _narg
        include "{base_dir}/\1.asm"
        shift
    endr
endm

; \1 - Directory that this library resides in
define init_lib
func
    def base_dir equs "\1"
    incdir Context, Trace
    incdir Interface, Forward, From, Method, Property
    incdir Scope, Overload, Return
    incdir Struct, ByteStruct
    incdir Type, Number, String, List, Stack
    if _narg > 1
        redef base_dir equs "\2"
    else
        redef base_dir equs "."
    endc
endm

