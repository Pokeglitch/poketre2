
; TODO - make 'static'?
def TeamDataTerminator = -1
Scope TrainerTeam
    init
        def \1#ID equs "Party#\@"

        ; write the pointer to the party
        dw {\1#ID}
    
        pushs

        ; initialize the party data
        SetCondition Standard
    
        sec {\1#ID} Party, TrainerClass
            {\1#ID}:
                db {\1#ID}#Properties
        
        ; handle the arguments
        shift
        if _narg
            ; if the first argument is a number, then its a party definition
            is#Number \1
            if so
                parse \#
            ; otherwise, it must be a macro, so execute it
            else            
                exec \#
            endc
        endc
    endm

    method SetCondition
      args
        def {\1#ID}#Condition = PartyDefinition#Condition#\2
    endm

    method parse
      args
        shift

        def \@#SpecialMask = 0
        
        ; If there is a third argument, and it is a number, then it is special
        if _narg > 2
            is#Number \3
            if so
                def \@#SpecialMask = PartyData#Special#BitMask
            endc
        endc

        db \@#SpecialMask | \1, \2
        shift 2

        if \@#SpecialMask
            rept _narg/2
                def \@#SpecialMask = PartyData#Special#BitMask

                ; TODO - this def check is unncessary once the Move Table is added
                if def(\2Table)
                    if strcmp("{\2Table}","Pokemon") == 0
                        def \@#SpecialMask = 0
                    endc
                endc
                
                db \@#SpecialMask | \1, \2
                shift 2
            endr
        else
            foreach db, \#
        endc

        db TeamDataTerminator
        end
    endm

    method switch, "TeamSwitch"
    method asm, "TeamASM"

    from TeamSwitch, TeamASM, "end"

    exit    
        ; Build the properties byte
        ; todo - macro based on ByteStruct definition?
        def {\1#ID}#Properties = {\1#ID}#Condition

        pops
    endm
end

Scope TeamASM
    init
        SetCondition RoutineDefinition

        dba \@#Routine

        pushs
        MapSec \@ Routine
            \@#Routine:
    endm

    exit
        ret
        pops
    endm
end

Scope TeamSwitch
    init
        shift
        ; If an argument was provided, then it is a ram value
        if _narg
            SetCondition RAMValue
            dw \1
        ; Otherwise, it is a routine
        else
            TeamSwitchRoutine
        endc
    endm

    method case, "TeamSwitchCase"
end

Scope TeamSwitchCase
    init
        db \2 ; write the value to compare against

        if _narg > 2
            shift 2
            TrainerTeam \#
        endc
    endm

    method switch, "TrainerTeam switch,"

    from TrainerTeam, "end"
end

Scope TeamSwitchRoutine
    init
        SetCondition RoutineValue
        dba \@#SwitchRoutine
        pushs
        MapSec \@# Switch Routine
            \@#SwitchRoutine:
    endm

    method case
      args
        end
        shift
        case \#
    endm

    exit
        ret
        pops
    endm
end
