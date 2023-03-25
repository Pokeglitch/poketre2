Scope AutoExit
    property List, AutoExitTriggers
    property False, isAutoExiting

    ; \1 - AutoExit method
    ; \2+? - Auto Exit triggers
    method init
      args , #AutoExit
        shift _nname
        AddTriggers \#
    endm

    method AddTriggers
      args self
        shift
        {self}#AutoExitTriggers@push \#

        rept _narg
            backup {self}#AutoExits, {{self}#Name}_\1
            def {{self}#Name}_\1 equs "Trigger \1,"
            shift
        endr
    endm

    method Trigger
      args
        end
        shift
        exec \#
    endm
    
    method PurgeTriggers
      args
        for i, 2, _narg+1
          restore \1#AutoExits, {\1#Name}_\<i>
        endr
    endm
    
    method quit
      args
        ; dont end again if this was called through auto-exit
        if not \1#isAutoExiting
            ; purge the AutoExit so it will not be called again
            try_purge \1#AutoExit
            end
        endc
    endm

    method exit
      args
        PurgeTriggers {\1#AutoExitTriggers}
        if def(\1#AutoExit)
            def \@#macro equs "{\1#AutoExit}"
            purge \1#AutoExit

            ; set isAutoExiting to true so the 'quit' method won't call 'end' again
            \1#isAutoExiting@negate

            ; execute the auto exit method
            \@#macro
        endc
    endm
end
