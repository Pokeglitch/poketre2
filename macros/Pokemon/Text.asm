Scope TextScript, Script
    property True, DoAutoExit

    method init
      args
        db TEXT_ASM
    endm

    method InitText
      args
        shift
        super \#
        AddTriggers finish, asmret, asmexit, asmprint, goto
    endm

    method text, textbox
      args
        ld hl, \@#Text
        shift
        super \@#Text, \#
    endm

    method goto
      args
        def \1#DoAutoExit = false
        jp \2
        end
    endm

    method asmret
      args
        def \1#DoAutoExit = false
        ret
        end
    endm

    method asmprint
      args
        call PrintText
    endm

    method asmexit
      args
        def \1#DoAutoExit = false
        end
    endm
    
    method asmdone, "end"

    method finish
      args
        if \1#DoAutoExit
          .finish
            call PrintText
        endc
        end
    endm

    method exit
      args
        if \1#DoAutoExit
          jp TextScriptEnd
        endc
    endm
end

/*
TODO - can prompt/done also extend this text scope?
- The byte values should come from a Struct (and also used in the Command Processor...)
*/
Scope Text
    property List, AutoExitTriggers
    property False, DoAutoExit
    property False, isAutoExiting

    ; \1 - AutoExit method
    ; \2+? - auto exit triggers
    method init
      args , autoexit
        shift _nname
        SetAutoExit {autoexit}
        AddTriggers \#
    endm

    method AddTriggers
      args self
        shift
        {self}#AutoExitTriggers@push \#

        rept _narg
            def Text_\1 equs "TriggerAutoExit \1,"
            shift
        endr
    endm

    method text, more
      args
        shift
        foreach db, \#
    endm

    method SetAutoExit
      args
        if _narg > 1
          if \1#DoAutoExit
              if strcmp("\2","{\1#AutoExit}")
                fail "An AutoExit has already been defined for this text: {\1#AutoExit}"
              endc
          endc

          def \1#DoAutoExit = true
          def \1#AutoExit equs "\2"
        endc
    endm

    method TriggerAutoExit
      args
        end
        shift
        exec \#
    endm

    method PurgeTriggers
      args
        for i, 2, _narg+1
            purge {\1#Name}_\<i>
        endr
    endm
    
    ; Define the textbox before writing the text
    method textbox
      args , style
        if style == NO_TEXTBOX
          db style
        else
          db TEXTBOX_DEF, style
        endc
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

    method asm, asmtext, "TextScript"
    
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
        PurgeTriggers {\1#AutoExitTriggers}
        if \1#DoAutoExit
            def \1#isAutoExiting = true
            ; execute the auto exit method
            {\1#AutoExit}
        endc
    endm
end
