def Number equs "\tNumber#Definition"

macro Number#Definition
    if _narg == 2
        def \1 = \2
    else
        def \1 = 0
    endc

    def \1#Initial = \1

    redef \1@add equs "def \1 += "
    redef \1@inc equs "def \1 += 1"
    redef \1@sub equs "def \1 -= "
    redef \1@dec equs "def \1 -= 1"
    redef \1@set equs "def \1 = "
    redef \1@reset equs "def \1 = \1#Initial"
endm
