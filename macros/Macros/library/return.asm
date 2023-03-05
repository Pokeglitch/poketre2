; to use if/so with macros that utilize 'return'
define does
func
    var_common false, "does \#", \@=\#
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

    Return {\@#symbol}, \@#isString
        {\@#macro} {\@#inside}
    end
endm

macro vars
    var_common true, "vars \#", \#
endm

macro var
    var_common false, "var \#", \#
endm
