macro Interface@forward
    for i, 2, _narg+1
        ; Add the method to the list of forwards
        Interface@forward#define \1, \<i>
    endr
endm

macro Interface@forward#inherit
    for i, 2, _narg+1
        ; Add the method to the list of forwards if not already there
        if not def(\1#Forwards#\<i>)
            Interface@forward#define \1, \<i>
        endc
    endr
endm

macro Interface@forward#define
    ; Add the method to the list of forwards
    def \1#Forwards#\2 = true
    append \1#Forwards, \2
endm

macro Interface@forward#assign
    for i, 2, _narg+1
        def \1#Forwards#\<i> = true
    endr
endm
