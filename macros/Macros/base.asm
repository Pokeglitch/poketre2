def _narg equs "_NARG"
def end equs "\tEnd#Definition"
def false equs "0"
def true equs "1"
def not equs "!"

/*  To generate a unique id and assign to global 'id' symbol, and optionally, the provided argument
    \1? - Symbol to assign to    */
    macro uuid
    redef id equs "\@"
    if _narg == 1
        redef \1 equs "\@"
    endc
endm

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





def base_dir equs "macros/Macros"
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

incdirs Context, Pokemon

Scope Func
    method myFuncA
      args
        msg Func.myFuncA | "\#"
    endm
    
    method myFuncB
      args
        msg Func.myFuncB | "\#"
    endm

    method myFuncC, myFuncD, "msg Func.myFuncCD | "
end

Scope Func2, Func
end

Scope Func3, Func2
    method myFuncA, myFuncB
      args
        super A3
        msg Func3.myFunc | "\#"
        super B3
    endm

    method myFuncC
      args
        super C3
        msg Func3.myFuncC | "\#"
        super D3
    endm
end

Scope Func4, Func3
    method myFuncA, myFuncB
      args
        super A4
        msg Func4.myFunc | "\#"
        super B4
    endm

    method myFuncC
      args
        super C4
        msg Func4.myFuncC | "\#"
        super D4
    endm
end

Scope Func5, Func4
end

Scope XFunc
end

Func5
    myFuncA Ayyyy
    myFuncB Beeee
    XFunc
        myFuncA Ayyyy
        myFuncB Beeee
        myFuncC Seeee
        myFuncD Deeee
    end
end



Scope Test0
    method init
      args
        msg Init Test0 | "\#"
    endm
    from TestX2, TestX7, "msg Test0 From TestX2 | "
    method exit
      args
        msg Exit Test0
    endm
end
Scope Test1, Test0
    method reset
      args
        msg Test1 | "\#"
    endm
    method say, "msg "
end
Scope Test2, Test1
end
Scope Test3, Test2
    method reset
      args
        super
        msg Test3 | "\#"
        super
    endm
end
Scope Test4, Test3
end
Scope Test5, Test4
    method reset
      args
        super
        msg Test5 | "\#"
        super
    endm
    from TestX7, TestX2
      args
        super
        msg Test5 From TestX2 | "\#"
    endm
end
Scope Test6, Test5
    method reset
      args
        super
        msg Test6 | "\#"
        super
    endm
end
Scope Test7, Test6
    from TestX7, TestX2, TestX1
      args
        super
        msg Test7 From TestX2 | "\#"
        super
    endm
end
Scope Test8, Test7
    method init
      args
        super
        msg Init Test8 | "\#"
        super
    endm
    

    method argTest
      args , name
        msg Test8.argTest | {name}
    endm
end
Scope Test9, Test8

    method argTest
      args self, name
        msg VOID | "\#"
        super {name}_NEXT
        msg Test9.argTest | {name}
        super {name}_NEXT2
        msg Test9.argTest | {name}
    endm

end

Scope TestX
    method init
      args
        def \1#Isolate = true
    endm

    forward reset, say, argTest
end

Scope TestX2, TestX
end

    Test9 test
        TestX2
            reset
            say hi
            argTest fred
        end
    end






Type Type1
    method reset
      args
        msg Type1 | "\#"
    endm
end
Type Type2, Type1
end
Type Type3, Type2
    method reset
      args
        super
        msg Type3 | "\#"
        super
    endm
end
Type Type4, Type3
    method init
      args
        msg Init Type4 | "\#"
    endm
end
Type Type5, Type4
    method reset
      args
        super
        msg Type5 | "\#"
        super
    endm
end
Type Type6, Type5
    method reset
      args
        super
        msg Type6.reset | "\#"
        super
    endm
end
Type Type7, Type6
end
Type Type8, Type7
    method init
      args
        super
        msg Init Type8 | "\#"
        super
    endm
end
Type Type9, Type8
end

    ;Type9 test2
    ;test2@reset
