/*
TODO:
    - 1: Handle passthrough for all Default level macros
    - 2: use var, return instead of var2, return2
    - 3; add way to return the output of a macro (ret_var? jump? forward?)

*/


/*
    \1  - if output is string or not
    \2+ - original arguments
*/
macro var_common
    def \@#isString = \1
    shift

    if \@#isString
        redef \@#message equs "vars \#"
    else
        redef \@#message equs "var \#"
    endc

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
        fail "Invalid syntax - multiple =\n\t{\@#message}"
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
    var_common true, \#
endm

macro var2
    var_common false, \#
endm

/*
    \1 - Symbol to store return value to
    \2 - if value is string or not
*/
Scope Return
    init
        ;def {self}#isPassthrough = true
        def {self}#Symbol equs "\1"
        def {self}#isString = \2
        if \2
            redef {self}#Value equs ""
        else
            def {self}#Value = 0
        endc
    endm

    local return2
    func
        if {self}#isString
            ; can return multiple values if string
            redef {self}#Value equs "\#"
        else
            def {self}#Value = \1
        endc
    endm

    final
        if {self}#isString
            redef {{self}#Symbol} equs "{{self}#Value}"
        else
            def {{self}#Symbol} = {self}#Value
        endc
    endm
end

macro test
    return2 _\1_
endm

macro mult
    if \2-1
        var2 x = mult(\1, \2-1)
        return2 \1+x
    else
        return2 \1
    endc
endm
    
    vars joe = test(curly)
    msg {joe}

    var2 product = mult(5, 4)
    msg {d:product}