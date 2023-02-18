def is equs "\tIsDefinition"

; works with 'return'
macro IsDefinition
    var_common false, "is \#", \@=\#
    result {\@}
endm


/*
    \1  - if output is string or not
    \2  - fail message
    \3+ - original arguments
*/
macro var_common
    def \@#isString = \1
    shift

    redef \@#message equs "\1"
    shift

    if _narg == 0
        fail "Invalid syntax - missing definition\n\t{\@#message}"
    elif _narg != 1
        fail "Invalid syntax - unexpected ,\n\t{\@#message}"
    endc

    ; get everything before the first (
    def \@#open_index = strin("\1", "(")
    if \@#open_index == 0
        fail "Invalid syntax - missing (\n\t{\@#message}"
    endc

    def \@#outside equs strsub("\1", 1, \@#open_index-1)
    def \@#inside equs strsub("\1", \@#open_index+1)

    ; strip spaces from everything outside
    redef \@#outside equs strrpl("{\@#outside}"," ","")

    ; validate the =
    def \@#equal_index = strin("{\@#outside}", "=")
    if \@#equal_index == 0
        fail "Invalid syntax - missing =\n\t{\@#message}"
    elif \@#equal_index == 1
        fail "Invalid syntax - missing assignment symbol\n\t{\@#message}"
    elif \@#equal_index != strrin("{\@#outside}", "=")
        fail "Invalid syntax - too many =\n\t{\@#message}"
    elif \@#equal_index == strlen("{\@#outside}")
        fail "Invalid syntax - missing macro name\n\t{\@#message}"
    endc

    ; extract the symbol name
    redef \@#symbol equs strsub("{\@#outside}",1,\@#equal_index-1)
    ; extract the macro name
    redef \@#macro equs strsub("{\@#outside}",\@#equal_index+1)

    ; get everything between the parenthesis
    def \@#close_index = strin("{\@#inside}",")")
    def \@#string_length = strlen("{\@#inside}")
    if \@#close_index == 0 || \@#close_index != \@#string_length
        fail "Invalid syntax - must end with )\n\t{\@#message}"
    endc

    ; remove the end )
    redef \@#inside equs strsub("{\@#inside}", 1, \@#string_length-1)

    enter Return, {\@#symbol}, \@#isString
        {\@#macro} {\@#inside}
    end
endm

macro vars
    var_common true, "vars \#", \#
endm

macro var
    var_common false, "var \#", \#
endm

/*
    \1 - Symbol to store return value to
    \2 - if value is string or not
*/
Scope Return
    init
        def \1#ReturnUsed = false
        def \1#Symbol equs "\2"
        def \1#isString = \3
        if \3
            redef \1#Value equs ""
        else
            def \1#Value = 0
        endc
    endm

    local return
    func
        if \1#ReturnUsed
            fail "Already designated a return value"
        endc

        def \1#ReturnUsed = true

        if _narg > 1
            def \@#self equs "\1"

            ; if there is only 1 argument,
            ; and there is a ( that isnt at the beginning, then its macro call
            if _narg == 2 && strin("\2","(") > 1
                shift
                var_common {\@#self}#isString, "return \#", {\@#self}#Value=\#
            elif \1#isString
                shift
                ; can return multiple values if string
                redef {\@#self}#Value equs "\#"
            else
                def \1#Value = \2
            endc
        endc
    endm

    final
        if \1#isString
            redef {\1#Symbol} equs "{\1#Value}"
        else
            def {\1#Symbol} = \1#Value
        endc
    endm
end
