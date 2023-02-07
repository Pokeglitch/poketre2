; \1 - Stack ID
macro NewStackInstance
    redef STACK_INDEX = Stack_\1_Size

    ; Map a new Instance ID to the Stack Index
    redef Stack_\1_{d:STACK_INDEX} equs "\@"

    ; define the Parent for this Instance
    if STACK_INDEX
        def PARENT_STACK_INDEX = STACK_INDEX - 1
        def {Stack_\1_{d:STACK_INDEX}}_Parent equs "{Stack_\1_{d:PARENT_STACK_INDEX}}"
    else
        def {Stack_\1_{d:STACK_INDEX}}_Parent equs ""
    endc

    ; Initialize Base Instance with the new ID
    Define_{Stack_IDToName_\1} {Stack_\1_{d:STACK_INDEX}}
endm

; \1: Name
; NOTE - define_\1 macro gets run to initialize properties
macro Stack
    ; Give the Stack a Unique ID
    redef STACK_ID equs "\@"

    ; Bi-directionally Map the ID to the Name
    def Stack_NameToID_\1 equs "{STACK_ID}"
    def Stack_IDToName_{STACK_ID} equs "\1"

    ; Initialize the Stack Size
    def Stack_{STACK_ID}_Size = 0

    NewStackInstance {STACK_ID}

    ; define the Push and Pop Macros
    def Push_\1 equs "PushStack {STACK_ID}"
    def Pop_\1 equs "PopStack {STACK_ID}"

    ; define the accessor for the Current Instance
    def \1 equs "\{Stack_{STACK_ID}_\{d:Stack_{STACK_ID}_Size\}\}"
endm

; \1 - Stack ID
macro PushStack
    ; Increase the Stack Size
    def Stack_\1_Size += 1

    ; Create a new Stack Instance
    NewStackInstance \1
endm

; \1 - Stack ID
macro PopStack
    if Stack_\1_Size
        ; Decrease the Stack Size
        def Stack_\1_Size -= 1
    else
        fail "Cannot Pop {Stack_IDToName_\1}. Stack is empty"
    endc
endm
