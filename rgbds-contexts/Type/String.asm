Type String
    property Number, _len

    method init
      args
        if _narg == 2
            \1@redef \2
        else
            \1@redef ""
        endc

        redef \1#Initial equs "{\1}"
    endm

    method _update
      args
        \1#_len@redef strlen("{\1}")
    endm

    method redef
      args
        redef \1 equs \2
        \1@_update
    endm

    method reset
      args
        \1@redef "{\1#Initial}"
    endm

    method append
      args
        append \#
        \1@_update
    endm

    method add
      args
        if _narg == 2
            \1@redef strcat("{\1}", \2)
        else
            foreach, 1, String@add, \#
        endc
    endm
    
    method equals
      args
        String@_compare strcmp, == 0, \#
    endm

    method contains
      args
        String@_compare strin, > 0, \#
    endm

    method startswith
      args
        String@_compare strin, == 1, \#
    endm

    method endswith
      args
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
