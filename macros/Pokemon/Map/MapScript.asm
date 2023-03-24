Scope MapScript, Script
    method init
      args , map
        super {map}
        
        MapSec frag, {map} Script
            include "scripts/\2.asm"

        end
    endm

    from Text
      args
        super
        DisplayText \2#ID
    endm

    method Battle, "MapScriptBattle"

    method pre
      args
        {\1#ID}PreScript:
    endm

    method post
      args
        {\1#ID}PostScript:
    endm

    method script
      args , name
        AddMapScriptPointer name
    endm

    ; todo - have it be a name, and have Scripts be an enum
    method set_script
      args , index
        ld a, index
        ld [w{\1#ID}CurScript], a
    endm
end

Scope MapScriptBattle, TrainerBattle
    method init
      args
        pushs

        def \1#Trainer equs "\2"
        def \1#Index = \2PartyCount
        
        ; TODO - this should be a return macro attached to the Trainer instance
        def \1#TeamName equs "\2Team{d:\2PartyCount}"
        def \2PartyCount += 1
    endm

    method text
      args
        Text prompt, Team
        
        pushs
        MapSec frag, \1#TeamName Texts
            ; First text is WinText, next is LoseText
            if not def({\1#TeamName}WinText)
                {\1#TeamName}WinText:
            else
                {\1#TeamName}LoseText:
            endc
            shift
            text \#
    endm

    method exit
      args
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
