Proto String
    property Number, _len

    init
        if _narg == 2
            \1@set \2
        else
            \1@set ""
        endc

        redef \1#Initial equs "{\1}"
    endm

    method set
    func
        redef \1 equs \2
        \1#_len@set strlen("{\1}")
    endm

    method reset
    func
        \1@set "{\1#Initial}"
    endm

    method append
    func
        append \#
    endm

    method add
    func
        if _narg == 2
            \1@set strcat("{\1}", \2)
        else
            foreach, 1, String@add, \#
        endc
    endm
    
    method equals
    func
        String@_compare strcmp, == 0, \#
    endm

    method contains
    func
        String@_compare strin, > 0, \#
    endm

    method startswith
    func
        String@_compare strin, == 1, \#
    endm

    method endswith
    func
        def \@#comparison equs "== strlen(\"\\3\") - strlen(\"\\<\{d:i}>\") + 1"
        String@_compare strin, \@#comparison, \#
    endm

end

/*  
    \1 = comparison macro
    \2 = comparison method
    \3 = string to compare against
    \4+ = arguments to compare with
        NOTE - Comparison arguments should not be strings (i.e. wrapped in ")
*/
macro String@_compare
    result false
    for i, 4, _narg+1
        if \1("{\3}","\<{d:i}>") \2
            result true
            break
        endc
    endr
endm
