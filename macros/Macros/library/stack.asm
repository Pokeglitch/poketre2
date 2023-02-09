; NOTE - Define_\1 macro gets run to initialize properties

; \1 - Stack Name
; \2+? - Optional arguments to initialize
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
    def Stack_{STACK_ID}_Index = 0
    ; map a unique id to the index
    def Stack_{STACK_ID}_{d:Stack_{STACK_ID}_Index} equs "\@"
    ; map the index to the id
    def {Stack_{STACK_ID}_{d:Stack_{STACK_ID}_Index}}_Index = 0

    ; define the Push and Pop Macros
    def Push_{STACK_NAME} equs "PushStack {STACK_ID},"
    def Pop_{STACK_NAME} equs "PopStack {STACK_ID},"

    ; define the accessor for the Current Instance
    def {STACK_NAME} equs "\{Stack_{STACK_ID}_\{d:Stack_{STACK_ID}_Index\}\}"

    ; initialize if arguments were provided
    if _NARG
        Push_{STACK_NAME} \#
    endc
endm

; \1 - Stack ID
macro PushStack
    redef STACK_ID equs "\1"
    shift

    ; Increase the Stack Index
    def Stack_{STACK_ID}_Index += 1

    redef STACK_INDEX = Stack_{STACK_ID}_Index

    ; Map a new Instance ID to the Stack Index
    redef Stack_{STACK_ID}_{d:STACK_INDEX} equs "\@"

    ; map the index to the instance
    def {Stack_{STACK_ID}_{d:Stack_{STACK_ID}_Index}}_Index = STACK_INDEX

    ; define the Parent for this Instance
    def PARENT_STACK_INDEX = STACK_INDEX - 1
    def {Stack_{STACK_ID}_{d:STACK_INDEX}}_Parent equs "{Stack_{STACK_ID}_{d:PARENT_STACK_INDEX}}"

    ; Initialize Base Instance with the new ID
    Define_{Stack_IDToName_{STACK_ID}} {Stack_{STACK_ID}_{d:STACK_INDEX}}, \#
endm

; \1 - Stack ID
macro PopStack
    redef STACK_ID equs "\1"
    
    if Stack_{STACK_ID}_Index > 0
        ; Decrease the Stack Index
        def Stack_{STACK_ID}_Index -= 1
    else
        fail "Cannot Pop {Stack_IDToName_{STACK_ID}}. Stack is empty"
    endc
endm
