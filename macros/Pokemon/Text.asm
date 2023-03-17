Scope TextScript, Script
  method init
    args
      vars \1#Map = getMap()
      db TEXT_ASM
  endm

  method text
    args
      ld hl, \@#Text
      shift
      super \@#Text, \#
  endm

  method finish
    args
      .finish
        call PrintText
        end
  endm

  method exit
    args
      jp TextScriptEnd
  endm
end

Scope Text
    ; \1 - AutoExit method
    ; \2+? - auto exit triggers
    method init
      args
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

    method text, "TriggerAutoExit text,"

    method SetAutoExit
      args
        if _narg > 1
          if \1#DoAutoExit
              if strcmp("\2","{\1#AutoExit}")
                fail "An AutoExit has already been defined for this text: {\1#AutoExit}"
              endc
          endc

          if strcmp("\2","")
              def \1#DoAutoExit = true
              String \1#AutoExit, "\2"
          endc
        endc
    endm

    method TriggerAutoExit
      args
        end
        shift
        exec \#
    endm

    method PurgeAutoExitTriggers
      args
        for i, 2, _narg+1
            purge {\1#Name}_\<i>
        endr
    endm
    
    ; Define the textbox before writing the text
    method textbox
      args
        db TEXTBOX_DEF, \2
    endm
    
    method more
      args
        shift
        foreach db, \#
    endm
    
    method ramtext
      args
        dbw RAM_TEXT, \2
    endm

    method gototext
      args
        dbw GOTO_TEXT, \2
        CleanExit
    endm

    method neartext
      args
        dbw NEAR_TEXT, \2
    endm

    method fartext
      args
        db FAR_TEXT
        dab \2
    endm
    
    ; 1 - address
    ; 2 - num digits
    ; 3 - num bytes & flags
    method numtext
      args
        db NUM_TEXT
        dw \2
        db (\3 << 3) | \4
    endm

    method bcdtext
      args
        db BCD_TEXT
        dw \2
        db \3
    endm

    method crytext
      args
        db CRY_TEXT, \2
    endm

    method sfxtext
      args
        db SFX_TEXT, \2
    endm

    ; todo .. how can this be cleaned up?
    ; can prompt/done also extend this text scope?
    method asmtext
      args
        ;SetAutoExit asmdone
        TextScript
    endm
    
    method delaytext
      args
        db DELAY_TEXT
    endm
    
    method two_opt
      args
        db TWO_OPTION_TEXT
        shift
        foreach dw, \#
    endm

    ; Scroll to the next line.
    method cont
      args
        shift
        foreach db, CONTINUE_TEXT, \#
    endm
    
    ; Scroll without user interaction
    method autocont
      args
        shift
        foreach db, AUTO_CONTINUE_TEXT, \#
    endm
    
    ; Move a line down.
    method next
      args
        shift
        foreach db, NEXT_TEXT_LINE, \#
    endm
    
    ; Start a new paragraph.
    method para
      args
        shift
        foreach db, PARAGRAPH, \#
    endm
    
    ; Start a new paragraph without user interaction
    method autopara
      args
        shift
        foreach db, AUTO_PARAGRAPH, \#
    endm

    ; Just wait for a keypress before continuing
    method wait
      args
        db TEXT_WAIT
    endm

    ; End a string
    method done
      args
        db TEXT_END
        CleanExit
    endm

    ; Prompt the player to end a text box (initiating some other event).
    method prompt
      args
	    db TEXT_PROMPT
        CleanExit
    endm

    ; Just wait for a keypress before continuing
    method asmdone
      args
        ; end the 'Script' context
        end
        CleanExit
    endm

    ; Exit without waiting for keypress
    method close
      args
	    db TEXT_EXIT
    endm

    method CleanExit
      args
        ; dont end again if this was called through auto-exit
        if not \1#isAutoExiting
            ; todo - test if provided method is expected AutoExit
            if \1#DoAutoExit
            endc

            def \1#DoAutoExit = false
            end
        endc
    endm

    method exit
      args
        PurgeAutoExitTriggers {\1#AutoExitTriggers}
        if \1#DoAutoExit
            def \1#isAutoExiting = true
            ; execute the auto exit method
            {\1#AutoExit}
        endc
    endm
end