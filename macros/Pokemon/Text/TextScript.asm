Scope TextScript, Script
    property True, DoAutoExit

    method init
      args
        shift
        super \#
        db TEXT_ASM
    endm

    method InitText
      args
        shift
        super \#
        AddTriggers finish, asmret, asmdone, goto
    endm

    from Text
      args
        super
        ld hl, \2#ID
    endm

    method goto
      args
        jp \2
        asmexit
    endm

    method asmret
      args
        ret
        asmexit
    endm

    method asmexit
      args
        \1#DoAutoExit@negate
        end
    endm
    
    method asmdone
      args
        end
    endm

    method finish
      args
        if \1#DoAutoExit
          .finish
            call PrintText
        endc
        end
    endm

    method exit
      args
        if \1#DoAutoExit
          jp TextScriptEnd
        endc
    endm
end
