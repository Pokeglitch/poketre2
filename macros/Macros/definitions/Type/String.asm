Type2 String
    property Number, _len

    init
        if _narg == 2
            \1@redef \2
        else
            \1@redef ""
        endc

        redef \1#Initial equs "{\1}"
    endm

    method _update
    func
        \1#_len@redef strlen("{\1}")
    endm

    method redef
    func
        redef \1 equs \2
        \1@_update
    endm

    method reset
    func
        \1@redef "{\1#Initial}"
    endm

    method append
    func
        append \#
        \1@_update
    endm

    method add
    func
        if _narg == 2
            \1@redef strcat("{\1}", \2)
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
; TODO - make 'static' for String
macro String@_compare
    result false
    for i, 4, _narg+1
        if \1("{\3}","\<{d:i}>") \2
            result true
            break
        endc
    endr
endm

macro is#String
    def \@#char equs strsub("\1",1, 1)
    result strcmp("{\@#char}","\"") == 0
endm
