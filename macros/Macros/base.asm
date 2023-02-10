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
    if _NARG > 1
        foreach msg, \#
    else
        print "\1\n"
    endc
endm


/*  To purge the given arguments if they exist
    \1+ - Arguments to purge    */
macro try_purge
    if _NARG > 1
        foreach try_purge, \#
    else
        if def(\1)
            purge \1
        endc
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

/*  To mark this given string macro as already used
    \1 - String name    */
macro single_use
    redef \1 equs "fail \"\1 has aready been called\"\n"
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