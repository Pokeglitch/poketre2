macro Super@init
    def \1#macro equs \2
endm
    Stack Super, ""

macro find_super
    if def(\1#Type)
        ; if the parent type had the macro, set that as the super
        if def({\1#Type}@\2)
            Super@push "ExecuteTypeMethod \{\1#Type}, \2, \3,"
            redef super equs "{{Super}#macro}"
        ;otherwise, check the next parent
        else
            find_super {\1#Type}, \2, \3
        endc
    else
        Super@push ""
        try_purge super ; todo - fail message
    endc
endm

macro ExecuteTypeMethod
    find_super \1, \2, \3

    def \@#macro equs "\1@\2"
    shift 2
    {\@#macro} \#

    Super@pop

    if strcmp("{{Super}#macro}", "")
        redef super equs "{{Super}#macro}"
    else
        try_purge super ; todo - fail message
        ; is this necessary if the #macro is already a fail message?
        ; - need to make sure a fail message is pushed initially
    endc
endm
