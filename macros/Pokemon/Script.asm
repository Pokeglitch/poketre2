Scope Script
    method init
      args , #Map
    endm

    method InitText
      args , method, name
        shift 3
        Text done, Delay, CheckEvent

        pushs
        MapSec frag, {name} Text
            {name}:
                method \#
    endm

    from Text
      args
        pops
    endm

    method text
      args
        shift
        InitText text, \#
    endm

    method textbox
      args
        shift
        InitText textbox, \#
    endm

    method Delay
      args , count=1
        if count == 1
          call DelayFrame
        elif count == 3
          call Delay3
        else
          ld c, count
          call DelayFrames
        endc
    endm
end
