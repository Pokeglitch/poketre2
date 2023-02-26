def String equs "\tString#Definition"

macro String#Definition
    redef \1@set equs "\tString@set \1, "

    if _narg == 2
        \1@set \2
    else
        \1@set ""
    endc

    redef \1#Initial equs "{\1}"

    redef \1@reset equs "\tString@reset \1"
    redef \1@add equs "\tString@add \1, "
    redef \1@equals equs "\tString@equals \{\1}, "
    redef \1@contains equs "\tString@contains \{\1}, "
    redef \1@startswith equs "\tString@startswith \{\1}, "
    redef \1@endswith equs "\tString@endswith \{\1}, "
endm

macro String@set
    redef \1 equs \2
    Number \1#_len, strlen("{\1}")
endm

macro String@reset
    \1@set "{\1#Initial}"
endm

macro String@add
    if _narg == 2
        \1@set strcat("{\1}", \2)
    else
        foreach, 1, String@add, \#
    endc
endm

; NOTE - Comparison arguments should not be strings (i.e. wrapped in ")
macro String@equals
    result false
    for i, 2, _narg+1
        if strcmp("\1","\<{d:i}>") == 0
            result true
            break
        endc
    endr
endm

; NOTE - Comparison arguments should not be strings (i.e. wrapped in ")
macro String@contains
    result false
    for i, 2, _narg+1
        if strin("\1","\<{d:i}>") > 0
            result true
            break
        endc
    endr
endm


; NOTE - Comparison arguments should not be strings (i.e. wrapped in ")
macro String@startswith
    result false
    for i, 2, _narg+1
        if strin("\1","\<{d:i}>") == 1
            result true
            break
        endc
    endr
endm

; NOTE - Comparison arguments should not be strings (i.e. wrapped in ")
macro String@endswith
    result false
    for i, 2, _narg+1
        if strin("\1","\<{d:i}>") == strlen("\1") - strlen("\<{d:i}>") + 1
            result true
            break
        endc
    endr
endm
