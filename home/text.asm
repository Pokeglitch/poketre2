TextBoxBorder::
	homecall TextBoxBorder_
	ret

NewTextBoxBorder::
	homecall NewTextBoxBorder_
	ret

NPlaceChar::
; Place char a c times.
	ld d, c
.loop
	ld [hli], a
	dec d
	jr nz, .loop
	ret

; Places a string from given bank (b)
PlaceFarString:
	ld a, [H_LOADEDROMBANK]
	push af
	ld a, b
	call SetNewBank
	call PlaceString
	jp HomeBankswitchReturn

PlaceString::
	ld a, NO_WORD_WRAP
	ld [wTextboxSettings], a

PlaceTextboxString:
	ld a, [H_LOADEDROMBANK]
	push af
	push hl

PlaceNextChar::
	ld a, [de]
	cp TEXT_END
	jr nz, .notEnd
	ld b, h
	ld c, l
	pop hl
	pop af
	ret

.notEnd
	; Commands that have arguments needs to be processed in home bank
	cp RAM_TEXT
	jp z, RAMTextCommand

	; Otherwise, process in different bank
	ld [wNextChar], a
	ld a, BANK(HandleNextChar)
	call SetNewBank
	jp HandleNextChar

ReturnAndPlaceNextChar::
	; restore the string bank
	; the bank is stored below the line start
	; import the line start into bc since de and hl cant be erased
	pop bc
	pop af
	push af
	push bc
	call SetNewBank

	inc de
	jr PlaceNextChar

RAMTextCommand::
	inc de
	ld a, [de]
	inc de
	ld b, a
	ld a, [de]
	push de
	ld e, b
	ld d, a
	call PlaceTextboxString
	ld h, b
	ld l, c
	pop de
	inc de
	jr PlaceNextChar

TextCommandProcessor::
	; Initialize the word-wrap registers
	call ResetRowsRemaining
	call ResetColumnTilesRemaining

TextCommandProcessor_NoReset::
	ld a, [wLetterPrintingDelayFlags]
	push af
	
	push hl
	res 1, a ; disable delays
	ld hl, wTextboxSettings
	bit BIT_DONT_REVEAL, [hl]
	jr nz, .dontEnableDelay

	bit BIT_NO_DELAY, [hl]
	jr nz, .dontEnableDelay

	set 1, a ; enable delays

.dontEnableDelay
	ld [wLetterPrintingDelayFlags], a
	pop hl

	ld a, c
	ld [wTextDest], a
	ld a, b
	ld [wTextDest + 1], a
	push bc

NextTextCommand::
	ld a, [hli]
	cp TEXT_END ; terminator
	jr nz, .doTextCommand
	pop bc
	pop af
	ld [wLetterPrintingDelayFlags], a
	ret
.doTextCommand
	push hl
	cp $17
	jp z, TextCommand17
	cp $0e
	jp nc, TextCommand0B ; if a != 0x17 and a >= 0xE, go to command 0xB
; if a < 0xE, use a jump table
	ld hl, TextCommandJumpTable
	push bc
	add a
	ld b, 0
	ld c, a
	add hl, bc
	pop bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

; draw box
; 04AAAABBCC
; AAAA = address of upper left corner
; BB = height
; CC = width
TextCommand04::
	pop hl
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	push hl
	ld h, d
	ld l, e
	call TextBoxBorder
	pop hl
	jr NextTextCommand

; place string inline
; 00{string}
TextCommand00::
	pop hl
	ld d, h
	ld e, l
	ld h, b
	ld l, c
	call PlaceTextboxString
	ld h, d
	ld l, e
	inc hl
	jr NextTextCommand

; place string from RAM
; 01AAAA
; AAAA = address of string
TextCommand01::
	pop hl
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	push hl
	ld h, b
	ld l, c
	call PlaceTextboxString
	pop hl
	jr NextTextCommand

; print BCD number
; 02AAAABB
; AAAA = address of BCD number
; BB
; bits 0-4 = length in bytes
; bits 5-7 = unknown flags
TextCommand02::
	pop hl
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	push hl
	ld h, b
	ld l, c
	ld c, a
	call PrintBCDNumber
	ld b, h
	ld c, l
	pop hl
	jr NextTextCommand

; repoint destination address
; 03AAAA
; AAAA = new destination address
TextCommand03::
	pop hl
	ld a, [hli]
	ld [wTextDest], a
	ld c, a
	ld a, [hli]
	ld [wTextDest + 1], a
	ld b, a
	jp NextTextCommand

; repoint destination to next line of text box
; 05
; (no arguments)
TextCommand05::
	pop hl
	pop bc
	push hl
	
	ld hl, 2 * SCREEN_WIDTH
	ld a, [hFlags_0xFFF6]
	bit 2, a
	jr z, .ok
	ld bc, SCREEN_WIDTH
.ok
	add hl, bc
	ld b, h
	ld c, l
	pop hl
	push bc
	jp NextTextCommand

; blink arrow and wait for A or B to be pressed
; 06
; (no arguments)
TextCommand06::
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jp z, TextCommand0D
	push bc
	call ManualTextScroll ; blink arrow and wait for A or B to be pressed
	pop bc
	pop hl
	jp NextTextCommand

; scroll text up one line
; 07
; (no arguments)
TextCommand07::
	call ScrollTextUpOneLine
	call ScrollTextUpOneLine
	pop hl
	pop bc
	push hl
	call GetStartOfBottomRow
	ld b, h
	ld c, l
	pop hl
	push bc
	jp NextTextCommand

; execute asm inline
; 08{code}
TextCommand08::
	pop hl
	ld de, NextTextCommand
	push de ; return address
	jp hl

; print decimal number (converted from binary number)
; 09AAAABB
; AAAA = address of number
; BB
; bits 0-3 = how many digits to display
; bits 4-7 = how long the number is in bytes
TextCommand09::
	pop hl
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	push hl
	ld h, b
	ld l, c
	ld b, a
	and $0f
	ld c, a
	ld a, b
	and $f0
	swap a
	set BIT_LEFT_ALIGN,a
	ld b, a
	call PrintNumber
	ld b, h
	ld c, l
	pop hl
	jp NextTextCommand

; wait half a second if the user doesn't hold A or B
; 0A
; (no arguments)
TextCommand0A::
	push bc
	call Joypad
	ld a, [hJoyHeld]
	and A_BUTTON | B_BUTTON
	jr nz, .skipDelay
	ld c, 30
	call DelayFrames
.skipDelay
	pop bc
	pop hl
	jp NextTextCommand

; plays sounds
; this actually handles various command ID's, not just 0B
; (no arguments)
TextCommand0B::
	pop hl
	push bc
	dec hl
	ld a, [hli]
	ld b, a ; b = command number that got us here
	push hl
	ld hl, TextCommandSounds
.loop
	ld a, [hli]
	cp b
	jr z, .matchFound
	inc hl
	jr .loop
.matchFound
	cp $14
	jr z, .pokemonCry
	cp $15
	jr z, .pokemonCry
	cp $16
	jr z, .pokemonCry
	ld a, [hl]
	call PlaySound
	call WaitForSoundToFinish
	pop hl
	pop bc
	jp NextTextCommand
.pokemonCry
	push de
	ld a, [hl]
	call PlayCry
	pop de
	pop hl
	pop bc
	jp NextTextCommand

; format: text command ID, sound ID or cry ID
TextCommandSounds::
	db $0B, SFX_GET_ITEM_1 ; actually plays SFX_LEVEL_UP when the battle music engine is loaded
	db $12, SFX_CAUGHT_MON
	db $0E, SFX_POKEDEX_RATING ; unused?
	db $0F, SFX_GET_ITEM_1 ; unused?
	db $10, SFX_GET_ITEM_2
	db $11, SFX_GET_KEY_ITEM
	db $13, SFX_DEX_PAGE_ADDED
	db $14, NIDORINA ; used in OakSpeech
	db $15, PIDGEOT  ; used in SaffronCityText12
	db $16, DEWGONG  ; unused?

; draw ellipses
; 0CAA
; AA = number of ellipses to draw
TextCommand0C::
	pop hl
	ld a, [hli]
	ld d, a
	push hl
	ld h, b
	ld l, c
.loop
	ld a, "…"
	ld [hli], a
	push de
	call Joypad
	pop de
	ld a, [hJoyHeld] ; joypad state
	and A_BUTTON | B_BUTTON
	jr nz, .skipDelay ; if so, skip the delay
	ld c, 10
	call DelayFrames
.skipDelay
	dec d
	jr nz, .loop
	ld b, h
	ld c, l
	pop hl
	jp NextTextCommand

; wait for A or B to be pressed
; 0D
; (no arguments)
TextCommand0D::
	push bc
	call ManualTextScroll ; wait for A or B to be pressed
	pop bc
	pop hl
	jp NextTextCommand

; process text commands in another ROM bank
; 17AAAABB
; AAAA = address of text commands
; BB = bank
TextCommand17::
	pop hl
	ld a, [H_LOADEDROMBANK]
	push af
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	call SetNewBank
	push hl
	ld l, e
	ld h, d
	call TextCommandProcessor_NoReset
	pop hl
	pop af
	call SetNewBank
	jp NextTextCommand

TextCommandJumpTable::
	dw TextCommand00
	dw TextCommand01
	dw TextCommand02
	dw TextCommand03
	dw TextCommand04
	dw TextCommand05
	dw TextCommand06
	dw TextCommand07
	dw TextCommand08
	dw TextCommand09
	dw TextCommand0A
	dw TextCommand0B
	dw TextCommand0C
	dw TextCommand0D

; Check if the next word should be wrapped
; no carry = print
; carry = word wrap or scroll
CheckWordWrap:
	; restore the text bank
	pop bc
	pop af
	push af
	push bc
	
	call SetNewBank

	push de
	push hl
	
	call CountNextWordLength
	ld a, [wTextboxColsRemaining]
	cp c

	ld a, BANK(CheckWordWrapReturn)
	call SetNewBank

	pop hl
	pop de
	jp CheckWordWrapReturn

; Count next word length
CountNextWordLength:
	ld c, 1 ; c = word length, including the space

.readNextCharLoop
	; get next character
	ld a, [de]
	inc de
	ld b, a ; b = next char

	; see if it an end of word char
	ld hl, EndOfWordChars

.checkEndOfWordLoop
	ld a, [hli]
	cp b
	ret z ; return if end of word
	and a
	jr nz, .checkEndOfWordLoop

	; see if the character has a known length
	ld hl, FixedLengthChars

.checkFixedLengthChars
	ld a, [hli]
	cp b
	jr z, .fixedLengthChar
	inc hl
	and a
	jr nz, .checkFixedLengthChars

	;see if the character has unknown length
	ld hl, VariableLengthChars

.checkVariableLengthChars
	ld a, [hli]
	cp b
	jp z, JumpToTablePointer
	inc hl
	inc hl
	and a
	jr nz, .checkVariableLengthChars

	; if it not any of these, then its a normal character
	inc c
	jr .readNextCharLoop

.fixedLengthChar
	ld a, [hl]
	add c
	ld c, a
	jr .readNextCharLoop

JumpToTablePointer
    ld a, [hli]
    ld h, [hl]
    ld l, a
    jp hl

EndOfWordChars:
	db " ", PARAGRAPH
	db AUTO_CONTINUE_TEXT, CONTINUE_TEXT
	db NEXT_TEXT_LINE, NEXT_TEXT_LINE+1
	db TEXT_DONE, TEXT_PROMPT
	db DEX_PAGE, DEX_END
	db 0

FixedLengthChars:
	db PKMN_TEXT, 2 ; PkMn
	db POKE_TEXT, 4 ; POKé
	db PC_TEXT, 2 ; PC
	db ROCKET_TEXT, 6 ; ROCKET
	db TM_TEXT, 2 ; TM
	db TRAINER_TEXT, 7 ; TRAINER
	db DOTS_TEXT, 2 ; 6 dots
	db 0

; These are all assumed to not be combined with other characters
VariableLengthChars:
	dbw RAM_TEXT, LengthRAM
	dbw PLAYER_NAME_TEXT, LengthPlayerName
	dbw RIVAL_NAME_TEXT, LengthRivalName
	dbw FAR_TEXT, LengthFarString
	dbw MOVE_USER_TEXT, LengthUser
	dbw MOVE_TARGET_TEXT, LengthTarget
	db 0

LengthRAM:
	ld a, [de]
	ld b, a
	inc de
	ld a, [de]
	ld d, a
	ld e, b
	jp CountNextWordLength

LengthFarString:
	;TODO

LengthPlayerName:
	ld de, wPlayerName
	jp CountNextWordLength

LengthRivalName:
	ld de, wRivalName
	jp CountNextWordLength

LengthUser:
	ld a, [H_WHOSETURN]
	xor 1
	jr LengthBattleCommon

LengthTarget:
	ld a, [H_WHOSETURN]

LengthBattleCommon:
	and a
	jr z, .notEnemy
	ld c, 5 ; length of "Enemy"
	ret

.notEnemy
	ld de, wBattleMonNick
	jp CountNextWordLength

TextEndCharText::
	db TEXT_END

GetTextboxSize:
	ld a, [wTextboxSettings]
	and TEXT_LINES_MASK
	add a
	inc a ; a = size of textbox interior
	ret

GetStartOfBottomRow:
	call GetTextboxSize
	coord hl, 1, 0
	push af
	ld de, SCREEN_WIDTH
.loop
	add hl, de
	dec a
	jr nz, .loop
	pop af
	ret

; initialize the rows remaining based on the number of lines
; the autoscroll count is initialized to zero
ResetRowsRemaining:
	ld a, [wTextboxSettings]
	and TEXT_LINES_MASK
	ld [wTextboxRowParams], a
	ret

ResetColumnTilesRemaining:
	ld a, SCREEN_WIDTH - 2
	ld [wTextboxColsRemaining], a
	ret
