/*
TODO - can prompt/done also extend this text scope?
- The byte values should come from a Struct (and also used in the Command Processor...)
*/
Scope Text, AutoExit
    ; TODO - integrate this with 'init'
    method SetID
      args , ID
        def \1#ID equs "{ID}"
    endm

    method text
      args
        shift
        foreach db, \#
    endm

    ; Define the textbox style
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
        quit
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
          quit
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

    /*
    method mart
      args
        db $FE, _narg, \#, -1
    endm
    */

    ; Just wait for a keypress before continuing
    method wait
      args
        db TEXT_WAIT
    endm

    ; End a string
    method done
      args
        db TEXT_END
        quit
    endm

    ; Prompt the player to end a text box (initiating some other event).
    method prompt
      args
	    db TEXT_PROMPT
        quit
    endm
 
    ; Exit without waiting for keypress
    method close
      args
	    db TEXT_EXIT
        quit
    endm
end
