; NOTE - define_\1 macro gets run to initialize properties

; \1: Name
macro Stack
    ; Store the stack name
    redef STACK_NAME equs "\1"
    shift

    ; Give the Stack a Unique ID
    redef STACK_ID equs "\@"

    ; Bi-directionally Map the ID to the Name
    def Stack_NameToID_{STACK_NAME} equs "{STACK_ID}"
    def Stack_IDToName_{STACK_ID} equs "{STACK_NAME}"

    ; Initialize the Stack Index
    def Stack_{STACK_ID}_Index = -1

    ; define the Push and Pop Macros
    def Push_{STACK_NAME} equs "PushStack {STACK_ID},"
    def Pop_{STACK_NAME} equs "PopStack {STACK_ID},"

    ; define the accessor for the Current Instance
    def {STACK_NAME} equs "\{Stack_{STACK_ID}_\{d:Stack_{STACK_ID}_Index\}\}"

    if _NARG
        Push_{STACK_NAME} \#
    endc
endm

; \1 - Stack ID
macro PushStack
    REDEF STACK_ID EQUS "\1"
    SHIFT

    ; Increase the Stack Size
    def Stack_{STACK_ID}_Index += 1

    redef STACK_INDEX = Stack_{STACK_ID}_Index

    ; Map a new Instance ID to the Stack Index
    redef Stack_{STACK_ID}_{d:STACK_INDEX} equs "\@"

    ; define the Parent for this Instance
    if STACK_INDEX
        def PARENT_STACK_INDEX = STACK_INDEX - 1
        def {Stack_{STACK_ID}_{d:STACK_INDEX}}_Parent equs "{Stack_{STACK_ID}_{d:PARENT_STACK_INDEX}}"
    else
        def {Stack_{STACK_ID}_{d:STACK_INDEX}}_Parent equs ""
    endc

    ; Initialize Base Instance with the new ID
    Define_{Stack_IDToName_{STACK_ID}} {Stack_{STACK_ID}_{d:STACK_INDEX}}, \#
endm

; \1 - Stack ID
macro PopStack
    if Stack_\1_Index >= 0
        ; Decrease the Stack Size
        def Stack_\1_Index -= 1
    else
        fail "Cannot Pop {Stack_IDToName_\1}. Stack is empty"
    endc
endm
