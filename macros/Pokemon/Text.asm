; todo - use args instead of \2, etc

Scope TextScript, Script
    property True, DoAutoExit

    method init
      args
        shift
        super \#
        db TEXT_ASM
    endm

    method InitText
      args
        shift
        super \#
        AddTriggers finish, asmret, asmdone, goto
    endm

    from Text
      args
        super
        ld hl, \2#ID
    endm

    method goto
      args
        jp \2
        asmexit
    endm

    method asmret
      args
        ret
        asmexit
    endm

    method asmexit
      args
        \1#DoAutoExit@negate
        end
    endm
    
    method asmdone
      args
        end
    endm

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
    Text Option Structures:
    two_opt {Left String/Ptr}, {Right String/Ptr}, {Left Text Ptr | optional}, {Right Text Ptr | optional}
          - Left Text (if ptr not provided)
          - Right Text (if ptr not provided)
*/
; TODO - why doesnt B do the same thing as selecting No?
Scope TextOption
    method init
      args , #LeftString, #RightString, #LeftAction, #RightAction
        db TWO_OPTION_TEXT

        TwoOptString Left
        TwoOptString Right

        try_exit
    endm

    method TwoOptString
      args , side
        is#String {\1#{side}String}
        if so
            pushs
            MapSec \@#{side}String
                \@#{side}String:
                    str {\1#{side}String}
            pops
            redef \1#{side}String equs "\@#{side}String"
        endc
    endm

    method TwoOptAction
      args , side
        def \1#{side}Action equs "\@#{side}Action"
        pushs
        MapSec \@#{side}Action
            \@#{side}Action:
            Text
    endm

    method try_exit
      args
        if not def(\1#LeftAction)
            TwoOptAction Left
        elif not def(\1#RightAction)
            TwoOptAction Right
        else
            end
        endc
    endm

    from Text
      args
        pops
        try_exit
    endm

    method exit
      args
          dw \1#LeftString, \1#RightString, \1#LeftAction, \1#RightAction
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
      args , #AutoExit
        shift _nname
        AddTriggers \#
    endm

    ; TODO - integrate this with the initialization
    method SetID
      args , ID
        def \1#ID equs "{ID}"
    endm

    method AddTriggers
      args self
        shift
        {self}#AutoExitTriggers@push \#

        rept _narg
            backup {self}#AutoExits, Text_\1
            def Text_\1 equs "DoAutoExit \1,"
            shift
        endr
    endm

    method text
      args
        shift
        foreach db, \#
    endm

    ; Trigger Auto Exit
    method DoAutoExit
      args
        end
        shift
        exec \#
    endm

    method PurgeTriggers
      args
        for i, 2, _narg+1
          restore \1#AutoExits, {\1#Name}_\<i>
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

    method near
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

    method cry
      args
        db CRY_TEXT, \2
    endm

    method sfxtext
      args
        db SFX_TEXT, \2
    endm

    method asm, asmtext
      args
        /* TODO - Need a better ID */
        TextScript TextScript#\@
    endm
    
    method delaytext
      args
        db DELAY_TEXT
    endm
    
    method two_opt
      args
        shift
        TextOption \#
    endm

    from TextOption, TextScript
      args
          CleanExit
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
        CleanExit
    endm

    method CleanExit
      args
        ; dont end again if this was called through auto-exit
        if not \1#isAutoExiting
            ; purge the AutoExit so it will not be called again
            try_purge \1#AutoExit
            
            end
        endc
    endm

    method exit
      args
        PurgeTriggers {\1#AutoExitTriggers}
        if def(\1#AutoExit)
            def \@#macro equs "{\1#AutoExit}"
            purge \1#AutoExit

            ; set isAutoExiting to true so the 'CleanExit' method won't call 'end' again
            \1#isAutoExiting@negate

            ; execute the auto exit method
            \@#macro
        endc
    endm
end
