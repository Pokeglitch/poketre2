/*
TODO - remove concept of global macros
*/

/*  A context is a way to have certain macros behave in a particular manner
    When a "context macro" is called, it will execute the macro that belongs to the current context
    If there is no macro in the current context, it will check the parent, and so on
    - Optionally, the context can be restricted to fail if the macro is not defined in the current context, rather than check the parent

    Note: when context is closed, will auto callback if following macro is defined:
    - {NewContext}_{ClosedContext}_Finish

    Context@Push will push the current section, and then change to the next context
    Context@Set will simply change context without pushing the section
    Context@Close will close the current section, and (if pushed) will pop the section
*/
def end equs "\tEndDefinition"

; Initialize the list of context macros
List Context#Macros

macro Context@init
    def \1#Name equs "\2"
    def \1#isPushed = \3
    def \1#isPassthrough = true
    List \1#SingleUses
endm

macro Context@SingleUses
    if _narg > 2
        foreach 1, Context@SingleUses, \#
    else
        Context@SingleUse \2, \1@\2
    endc
endm

macro Context@SingleUse
    {Context}#SingleUses@push \1
    redef \1 equs "single_use \1\nmacro \2"
endm

macro Context@Push
    pushs
    Context@push \1, true
endm

macro Context@Set
    Context@push \1, false
endm

macro Context@Close
    ; purge the single uses
    try_purge {{Context}#SingleUses}

    ; if the context was pushed, then pop
    if {Context}#isPushed
        pops
    endc

    ; Store the potential callback macro name
    redef \@#callback equs "{{{Context}#Parent}#Name}_{{Context}#Name}_Finish"

    Context@pop

    ; if the callback exists, execute it
    if def({\@#callback})
        {\@#callback}
    endc
endm

    __Stack Context, , 0

macro ExecuteContextMacro
    find_context_macro {Context}, \#
endm

macro find_context_macro
    if def({\1#Name}_\2)
        def \@#macro equs "{\1#Name}_\2"
        shift 2
        {\@#macro} \#
    elif \1#isPassthrough && {\1#Index} > 1
        def \@#parent equs "{\1#Parent}"
        shift
        find_context_macro {\@#parent}, \#
    elif def(Global_\2)
        def \@#macro equs "Global_\2"
        shift 2
        {\@#macro} \#
    else
        fail "\2 is not defined in current context"
    endc
endm

macro DefineContextMacro
    if _narg > 1
        foreach DefineContextMacro, \#
    else
        if def(\1) == 0
            Context#Macros@push \1
            def \1 equs "ExecuteContextMacro \1, "
        else
            Context#Macros@contains \1
            if not
                fail "Cannot set \1 as a Context Macro because is already defined"
            endc
        endc
    endc
endm

    DefineContextMacro Team
    DefineContextMacro Warp, Sign, NPC, Battle, Pickup, WarpTo
    DefineContextMacro Delay
    DefineContextMacro Array, Flag, Flags, Index

    DefineContextMacro text, asmtext, asmdone, done, prompt, exit_text
    DefineContextMacro switch, case, asm
    DefineContextMacro overload, skip, next