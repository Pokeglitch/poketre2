Scope MapScript
    property Number, TextCount

    init
        def \1#Map equs "\2"
        def \1#Bank = BANK(@)
    endm
    
    ; Open a section in the same bank as this Map
    method MapSec
    func
        def \@#Bank = \1#Bank
        shift
        sec \#, \@#Bank
    endm

    method text
    func
        redef \1#TextPointer equs "{\1#Map}ScriptText{d:\1#TextCount}"
        
        DisplayText \1#TextPointer

        \1#TextCount@inc
        InitTextContext done, text, Delay
        
        MapSec frag, {\1#Map} Texts
            {\1#TextPointer}:
                shift
                foreach db, \#
    endm

    lambda Battle, "MapScriptBattle"

    exit
        def {\1#Map}TextCount = \1#TextCount
    endm
end

Scope MapScriptBattle
    init
        pushs

        def \1#Trainer equs "\2"
        def \1#Index = \2PartyCount
        
        ; TODO - this should be a return macro attached to the Trainer instance
        def \1#TeamName equs "\2Team{d:\2PartyCount}"
        def \2PartyCount += 1
    endm

    method text
    func
        InitTextContext prompt, text, Team

        MapSec frag, \1#TeamName Texts
            ; First text is WinText, next is LoseText
            if def({\1#TeamName}WinText) == 0
                {\1#TeamName}WinText:
            else
                {\1#TeamName}LoseText:
            endc
            shift
            foreach db, \#
    endm

    method Team
    func
        ; TODO - this should be a macro attached to the Trainer instance
        ; \1#Trainer@AddPartyPointer
        sec frag, {\1#Trainer} Party Pointers, TrainerClass
            shift
            TrainerTeam \#
    endm

    from TrainerTeam, "end"

    exit
        pops
        
        if def({\1#TeamName}WinText) == 0
            fail "Win Text not defined for {\1#Trainer} Battle #{\1#Index}"
        endc

        PrepareBattle {\1#Trainer}, {\1#Index}
        ld hl, {\1#TeamName}WinText

        if def({\1#TeamName}LoseText)
            ld de, {\1#TeamName}LoseText
        else
            ld de, {\1#TeamName}WinText
        endc

        call SaveEndBattleTextPointers
        jp StartOverworldBattle
    endm
end

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
    func
        def {\1#ID}#Condition = PartyDefinition#Condition#\2
    endm

    method parse
    func
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

    lambda switch, "TeamSwitch"
    lambda asm, "TeamASM"

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

    lambda case, "TeamSwitchCase"
end

Scope TeamSwitchCase
    init
        db \2 ; write the value to compare against

        if _narg > 2
            shift 2
            TrainerTeam \#
        endc
    endm

    lambda switch, "TrainerTeam switch,"

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
    func
        end
        shift
        case \#
    endm

    exit
        ret
        pops
    endm
end
