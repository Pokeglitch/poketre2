; Note: when context is closed, will auto callback if
; {NewContext}_{ClosedContext}_Finish is defined

/*
TODO - remove concept of default macros, global macros
*/

def end equs "\tEndDefinition"

macro Context@init
    def \1#Name equs "\2"
    def \1#isPushed = \3
    def \1#isPassthrough = true
    def \1#SingleUses equs ""
endm

macro Context@SingleUses
    if _narg > 2
        foreach 1, Context@SingleUses, \#
    else
        Context@SingleUse \2, \1@\2
    endc
endm

macro Context@SingleUse
    add_to_list {Context}#SingleUses, \1
    redef \1 equs "single_use \1\nmacro \2"
endm

    __Stack Context, , 0






macro PushContext
    pushs
    Context@push \1, 1
endm

macro SetContext
    Context@push \1, 0
endm

macro CloseContext
    ; purge the single uses
    try_purge {{Context}#SingleUses}

    ; if the context was pushed, then pop
    if {Context}#isPushed
        pops
    endc

    ; Store the potential callback macro name
    redef CONTEXT_CALLBACK equs "{{{Context}#Parent}#Name}_{{Context}#Name}_Finish"

    Context@pop

    ; if the callback exists, execute it
    if def({CONTEXT_CALLBACK})
        {CONTEXT_CALLBACK}
    endc
endm

; To set the given macro names in this context to call it's default macro
macro DefineDefaultMacros
    redef CONTEXT_NAME equs "\1"
    shift
    foreach DefineDefaultMacro, \#
endm

macro DefineDefaultMacro
    def {CONTEXT_NAME}_\1 equs "_\1"
    TryDefineContextMacro \1
endm

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

macro DefineContextMacros
    foreach DefineContextMacro, \#
endm

macro DefineContextMacro
    def \1 equs "ExecuteContextMacro \1, "
endm

macro TryDefineContextMacro
    if def(\1) == 0
        DefineContextMacro \1
    endc
endm

    DefineContextMacros Team
    DefineContextMacros Warp, Sign, NPC, Battle, Pickup, WarpTo
    DefineContextMacros Delay
    DefineContextMacros Array, Flag, Flags, Index

    DefineContextMacros text, asmtext, asmdone, done, prompt, exit_text
    DefineContextMacros switch, case, asm
    DefineContextMacros overload, skip, next
