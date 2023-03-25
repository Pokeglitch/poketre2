Scope MapScriptBattle, TrainerBattle
    method init
      args
        pushs

        def \1#Trainer equs "\2"
        def \1#Index = \2PartyCount
        
        ; TODO - this should be a return macro attached to the Trainer instance
        def \1#TeamName equs "\2Team{d:\2PartyCount}"
        def \2PartyCount += 1

        ExpectBattleText
    endm

    method ExpectBattleText
      args
        ExpectText true, true, InitBattleText, prompt, Team
    endm

    from Text
      args
        super
        if not def({\1#TeamName}LoseText)
            ExpectBattleText
        endc
    endm

    method InitBattleText
      args
        pushs
        MapSec frag, \1#TeamName Texts
            ; First text is WinText, next is LoseText
            if not def({\1#TeamName}WinText)
                {\1#TeamName}WinText:
            else
                {\1#TeamName}LoseText:
            endc
    endm

    method exit
      args
        pops
        
        if def({\1#TeamName}WinText) == 0
            fail "Win Text not defined for {\1#Trainer} Battle #{d:\1#Index}"
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
