/*
    Text Option Structures:
    two_opt {Left String/Ptr}, {Right String/Ptr}, {Left Text Ptr | optional}, {Right Text Ptr | optional}
          - Left Text (if ptr not provided)
          - Right Text (if ptr not provided)
*/
; TODO - why doesnt B do the same thing as selecting No?
Scope TextOption
    method init
      args , #LeftString, #RightString, #LeftAction, #RightAction
        db TWO_OPTION_TEXT

        TwoOptString Left
        TwoOptString Right

        try_exit
    endm

    method TwoOptString
      args , side
        is#String {\1#{side}String}
        if so
            pushs
            MapSec \@#{side}String
                \@#{side}String:
                    str {\1#{side}String}
            pops
            redef \1#{side}String equs "\@#{side}String"
        endc
    endm

    method TwoOptAction
      args , side
        def \1#{side}Action equs "\@#{side}Action#Pointer"
        Text {\1#{side}Action}
    endm

    method try_exit
      args
        if not def(\1#LeftAction)
            TwoOptAction Left
        elif not def(\1#RightAction)
            TwoOptAction Right
        else
            end
        endc
    endm

    from Text
      args
        pops
        try_exit
    endm

    method exit
      args
          dw \1#LeftString, \1#RightString, \1#LeftAction, \1#RightAction
    endm
end
