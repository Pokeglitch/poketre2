Scope ExpectText, AutoExit
    method init
      args , #Callback, #TextAutoExit
        shift _nname
        super , \#
    endm

    method text, textbox, ramtext, gototext, near, fartext, numtext, bcdtext, cry, sfxtext, asm, asmtext, delaytext, two_opt
      args
        end
        Text {\1#TextAutoExit}, {\1#AutoExitTriggers}
        \1#Callback
        shift
        _method \#
    endm
end
