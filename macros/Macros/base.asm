def _narg equs "_NARG"
def end equs "\tEnd#Definition"

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
        redef \1 equs "fail \"\1 has aready been called\"\n"
        shift
    endr
endm

def define equs "\tdefine#Definition"
macro define#Definition
    def \1 equs "\t\1#Definition"
    disposable func, \1#Definition
endm

def base_dir equs "macros/Macros"
define incdir
func
    def \@#prev_base_dir equs "{base_dir}"

    redef base_dir equs "{base_dir}/\1"

    rept _narg
        include "{base_dir}/\1.asm"
        shift
    endr

    redef base_dir equs "{\@#prev_base_dir}"
endm





; TODO - need to make a full list of reserved names, and list of remapped names
; then, if name is in list, use remap
macro CheckReservedName
    if strcmp("\1","end") == 0
        redef \1 equs "End#Definition"
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
    for i, 2, _narg+1
        \1 \<i>
    endr
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
        redef \@#macro equs "\1"
        shift
        \@#macro \#
    endc
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

/*  To print given argument(s) on own line
    \1+ - Arguments to print    */
macro msg
    if _narg == 1
        print "\1\n"
    else
        foreach msg, \#
    endc
endm
