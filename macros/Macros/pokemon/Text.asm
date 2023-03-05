Scope Text
    ; \1 - AutoExit method
    ; \2+? - auto exit triggers
    init
        def \1#DoAutoExit = false
        def \1#isAutoExiting = false

        SetAutoExit \2

        def \@#self equs "\1"
        shift 2
        def {\@#self}#AutoExitTriggers equs "\#"
        
        rept _narg
            def Text_\1 equs "TriggerAutoExit \1,"
            shift
        endr
    endm

    lambda text, "TriggerAutoExit text,"

    method SetAutoExit
    func
        if \1#DoAutoExit
            fail "An AutoExit has already been defined for this text: {\1#AutoExit}"
        endc

        if strcmp("\2","")
            def \1#DoAutoExit = true
            String \1#AutoExit, "\2"
        endc
    endm

    method TriggerAutoExit
    func
        end
        shift
        exec \#
    endm

    method PurgeAutoExitTriggers
    func
        for i, 2, _narg+1
            purge {\1#Name}_\<i>
        endr
    endm
    
    ; Define the textbox before writing the text
    method textbox
    func
        db TEXTBOX_DEF, \2
    endm
    
    method more
    func
        shift
        foreach db, \#
    ENDM
    
    method ramtext
    func
        dbw RAM_TEXT, \2
    ENDM

    method gototext
    func
        dbw GOTO_TEXT, \2
    ENDM

    method neartext
    func
        dbw NEAR_TEXT, \2
    ENDM

    method fartext
    func
        db FAR_TEXT
        dab \2
    ENDM
    
    ; 1 - address
    ; 2 - num digits
    ; 3 - num bytes & flags
    method numtext
    func
        db NUM_TEXT
        dw \2
        db (\3 << 3) | \4
    ENDM

    method bcdtext
    func
        db BCD_TEXT
        dw \2
        db \3
    ENDM

    method crytext
    func
        db CRY_TEXT, \2
    ENDM

    method sfxtext
    func
        db SFX_TEXT, \2
    ENDM

    method asmtext
    func
        SetAutoExit asmdone
        db TEXT_ASM
    ENDM
    
    method delaytext
    func
        db DELAY_TEXT
    ENDM
    
    method two_opt
    func
        db TWO_OPTION_TEXT
        shift
        foreach dw, \#
    ENDM

    ; Scroll to the next line.
    method cont
    func
        shift
        foreach db, CONTINUE_TEXT, \#
    ENDM
    
    ; Scroll without user interaction
    method autocont
    func
        shift
        foreach db, AUTO_CONTINUE_TEXT, \#
    ENDM
    
    ; Move a line down.
    method next
    func
        shift
        foreach db, NEXT_TEXT_LINE, \#
    ENDM
    
    ; Start a new paragraph.
    method para
    func
        shift
        foreach db, PARAGRAPH, \#
    ENDM
    
    ; Start a new paragraph without user interaction
    method autopara
    func
        shift
        foreach db, AUTO_PARAGRAPH, \#
    ENDM

    ; Just wait for a keypress before continuing
    method wait
    func
        db TEXT_WAIT
    ENDM

    ; End a string
    method done
    func
        db TEXT_END
        CleanExit
    endm

    ; Prompt the player to end a text box (initiating some other event).
    method prompt
    func
	    db TEXT_PROMPT
        CleanExit
    endm

    ; Just wait for a keypress before continuing
    method asmdone
    func
	    jp TextScriptEnd
        CleanExit
    endm

    ; Exit without waiting for keypress
    method close
    func
	    db TEXT_EXIT
    endm

    method CleanExit
    func
        ; dont end again if this was called through auto-exit
        if not \1#isAutoExiting
            ; todo - test if provided method is expected AutoExit
            if \1#DoAutoExit
            endc

            def \1#DoAutoExit = false
            end
        endc
    endm

    exit
        PurgeAutoExitTriggers {\1#AutoExitTriggers}
        if \1#DoAutoExit
            def \1#isAutoExiting = true
            ; execute the auto exit method
            {\1#AutoExit}
        endc
    endm
end