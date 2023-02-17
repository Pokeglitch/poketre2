/* 
    A Stack is a nestable collection of data that can be pushed/popped
    
    A Stack can be initialized via the following macro call:
        Stack <StackName>

    The current Stack Instance can be accessed via the following symbol interpolation:
        {<StackName>}

    Every Stack Instance will have th following attributes:
        {<StackName>}#Index
            - The Index of the Current Instance
            - Also represents the Size of the Stack
            - When the Stack is empty, this will return 0
                - Trying to access any other attribute from an empty stack will result in an error
        {<StackName>}#Parent
            - The symbol for prior Instance in the Stack
            - This symbol must be interpolated to access the Parent Instance's attributes
                - For Example: {{<StackName>}#Parent}#Index will provide a value 1 less than the Current Instance's Index

    To create a new Stack Instance, call the macro:
        Push_<StackName>

    This will add the Instance to the Stack and automatically call the macro titled:
        Define_<StackName>
            - This macro is defined by the user
            - The first argument represents the ID of the current stack instance
                - So attributes can be added via the following:
                    def \1_Name equs "\2"
            - All additional arguments are forwarded from Push_<StackName>

    To close the Current Stack Instance and move to the Parent, call the macro:
        Pop_<StackName>
*/


/*  To define a Stack with the given name
    and optionally initialize it with provided arguments

    \1 - Stack Name
    \2+? - Optional arguments to initialize    */
macro __Stack
    def \1#size = 0
    def \1@push equs "__PushStack \1,"
    def \1@pop equs "__PopStack \1,"
    
    def Push_\1 equs "__PushStack \1,"
    def Pop_\1 equs "__PopStack \1,"

    def \1#0 equs ""
    def \1 equs "\{\1#\{d:\1#size}}"

    ; initialize if provided arguments
    if _narg > 1
        def \@#name equs "\1"
        shift
        {\@#name}@push \#
    endc
endm

macro __PushStack
    def temp#prev_size = \1#size

    ; increase the size
    def \1#size += 1
    ; create a unique id for the new stack
    redef \1#{d:\1#size} equs "\@"

    ; map the parent and index
    redef \@#Parent equs "{\1#{d:temp#prev_size}}"
    redef \@#Index = \1#size
    redef \@#ID equs "\@"

    redef temp#name equs "\1"
    shift
    {temp#name}@init \@, \#
endm

macro __PopStack
    if \1#size
        def \1#size -= 1
    else
        fail "\1 is empty"
    endc
endm
