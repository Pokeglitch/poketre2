Scope TrainerBattle
    from Text
      args
        pops
    endm
    
    method Team
      args
        ; TODO - this should be a macro attached to the Trainer instance
        ; \1#Trainer@AddPartyPointer
        sec frag, {\1#Trainer} Party Pointers, TrainerClass
            shift
            TrainerTeam \#
    endm

    from TrainerTeam, "end"
end
