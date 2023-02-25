; Macros used in debugging process

/*  To check if all provided values are equal
    \1+ - Values to compare    */
macro assert_all
	if _narg == 2
		assert \1 == \2
	else
		foreach 1, assert_all, \#
	endc
endm

/*  To check if all provided string symbols are equal
    \1+ - Symbols of values to compare    */
macro assert_all_s
	if _narg == 2
		assert strcmp("{\1}","{\2}") == 0
	else
		foreach 1, assert_all_s, \#
	endc
endm

/*  To print given argument(s) on own line
    \1+ - Arguments to print    */
macro msg
    if _narg == 1
        print "\1\n"
    else
        foreach msg, \#
    endc
endm
