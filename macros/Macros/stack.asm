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
macro Stack
    ; Store the stack name
    redef STACK_NAME equs "\1"
    shift

    ; Give the Stack a Unique ID
    redef STACK_ID equs "\@"

    ; Bi-directionally Map the ID and the Name
    def Stack_NameToID_{STACK_NAME} equs "{STACK_ID}"
    def Stack_IDToName_{STACK_ID} equs "{STACK_NAME}"

    ; Initialize the Stack Index
    def Stack_{STACK_ID}#Index = 0
    ; map a unique id to the index
    def Stack_{STACK_ID}_{d:Stack_{STACK_ID}#Index} equs "\@"
    ; map the index to the id
    def {Stack_{STACK_ID}_{d:Stack_{STACK_ID}#Index}}#Index = 0

    ; define the Push and Pop Macros
    def Push_{STACK_NAME} equs "PushStack {STACK_ID},"
    def Pop_{STACK_NAME} equs "PopStack {STACK_ID},"

    ; define the accessor for the Current Instance
    def {STACK_NAME} equs "\{Stack_{STACK_ID}_\{d:Stack_{STACK_ID}#Index\}\}"

    ; initialize if arguments were provided
    if _NARG
        Push_{STACK_NAME} \#
    endc
endm

/*  To create a new Instance and add it to the Stack
    \1 - Stack ID    */
macro PushStack
    redef STACK_ID equs "\1"
    shift

    ; Increase the Stack Index
    def Stack_{STACK_ID}#Index += 1

    redef STACK_INDEX = Stack_{STACK_ID}#Index

    ; Map a new Instance ID to the Stack Index
    redef Stack_{STACK_ID}_{d:STACK_INDEX} equs "\@"

    ; map the index to the instance
    def {Stack_{STACK_ID}_{d:Stack_{STACK_ID}#Index}}#Index = STACK_INDEX

    ; define the Parent for this Instance
    def PARENT_STACK_INDEX = STACK_INDEX - 1
    def {Stack_{STACK_ID}_{d:STACK_INDEX}}#Parent equs "{Stack_{STACK_ID}_{d:PARENT_STACK_INDEX}}"

    ; Initialize Base Instance with the new ID
    Define_{Stack_IDToName_{STACK_ID}} {Stack_{STACK_ID}_{d:STACK_INDEX}}, \#
endm

/*  To shift to the Parent Instance in the Stack
    \1 - Stack ID    */
macro PopStack
    redef STACK_ID equs "\1"
    
    if Stack_{STACK_ID}#Index > 0
        ; Decrease the Stack Index
        def Stack_{STACK_ID}#Index -= 1
    else
        fail "Cannot Pop {Stack_IDToName_{STACK_ID}}. Stack is empty"
    endc
endm
