
Scope MapScript
    init
        def \1#Map equs "\2"
        
        MapSec frag, \2 Script
            include "scripts/\2.asm"

        end
    endm

    method text
    func
        DisplayText \@#Text

        {\1#Map}#TextCount@inc
        Text done, Delay
        
        pushs
        MapSec frag, {\1#Map} Texts
            \@#Text:
                shift
                more \#
    endm

    from Text
    func
        pops
    endm

    lambda Battle, "MapScriptBattle"
end

; TODO - extend a generic 'TrainerBattle' scope
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
        Text prompt, Team
        
        pushs
        MapSec frag, \1#TeamName Texts
            ; First text is WinText, next is LoseText
            if def({\1#TeamName}WinText) == 0
                {\1#TeamName}WinText:
            else
                {\1#TeamName}LoseText:
            endc
            shift
            more \#
    endm

    from Text
    func
        pops
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
