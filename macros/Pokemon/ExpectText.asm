Scope ExpectText, AutoExit
    method init
      args self, includeAutoExit, #PermitTextScripts, #TextAutoExit
        shift _nname

        if includeAutoExit
          super , \#
        else
          super
          {self}#AutoExitTriggers@push \#
        endc
    endm

    method TextEncountered
      args
        end false
        vars \@#name = getTextName()
        Text {\@#name}, {\1#TextAutoExit}, {\1#AutoExitTriggers}
    endm

    method text, textbox, ramtext, gototext, near, fartext, numtext, bcdtext, cry, sfxtext, delaytext, two_opt
      args
        TextEncountered
        shift
        _method \#
    endm

    method asm, asmtext
      args
        if \1#PermitTextScripts
            TextEncountered
            shift
            _method \#
        else
            fail "Cannot open a TextScript in this context"
        endc
    endm

    method exit
      args , #DirectExit=true
    endm
end
