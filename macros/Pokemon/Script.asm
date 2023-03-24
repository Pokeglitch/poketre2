Scope Script
    property Number, TextCount

    method init
      args , #ID
    endm

    method InitText
      args , method
        Text done, Delay, CheckEvent, printtext, has_item, give_item, play_sound, play_cry, set_hl, res_hl
        def \@#ID equs "{\1#ID}#Text#{d:\1#TextCount}"
        SetID {\@#ID}
        \1#TextCount@inc

        shift _nname
        pushs
        MapSec frag, {\@#ID} Text
            {\@#ID}:
                method \#
    endm

    from Text
      args
        pops
    endm

    method text
      args
        shift
        InitText text, \#
    endm

    method textbox
      args
        shift
        InitText textbox, \#
    endm

    method Delay
      args , count=1
        if count == 1
          call DelayFrame
        elif count == 3
          call Delay3
        else
          ld c, count
          call DelayFrames
        endc
    endm

    method CheckEvent
      args
        def \@#event_byte = ((\2) / 8)
        ld a, [wEventFlags + \@#event_byte]

        IF _NARG > 2
            IF ((\2) % 8) == 7
                add a
            ELSE
                REPT ((\2) % 8) + 1
                    rrca
                ENDR
            ENDC
        ELSE
            bit (\2) % 8, a
        ENDC
    endm

    method printtext
      args , name
        if def(name)
            ld hl, {name}
        endc
        call PrintText
    endm

    method has_item
      args , item
        ld b, item
        call IsItemInBag
    endm

    method give_item
      args , item, amount=1
        lb bc, item, amount
        call GiveItem
    endm

    method play_sound
      args , sound
        ld a, sound
        ; todo - when it is necessary to store into wNewSoundID??
        ld [wNewSoundID], a
        call PlaySound
    endm

    method play_cry
      args , pokemon
        ld a, pokemon
        call PlayCry
    endm

    method set_hl
      args , index, pointer
        ld hl, pointer
        set index, [hl]
    endm

    method res_hl
      args , index, pointer
        ld hl, pointer
        res index, [hl]
    endm
end
