; TODO:
;
; - Each text command (when using a move in battle, so with ASM or FAR)
;     will reset the text position to the start of the textbox.
;     This shouldn't happen, it should continue where it left off
;     Resolve by converting those texts to use my new inline-string processor?
;
; FIX:
; - The Pokemon Caught and New Pokedex Data SFX doesnt get played
;   because the SFX_PRESS_AB from the text box "continue" is still active
;
; Down arrow motion freezes when sound is playing

TextBoxBorder::
	homejump TextBoxBorder_

NewTextBoxBorder::
	homejump NewTextBoxBorder_

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
	ld a, [wTextboxSettings]
	push af
	ld a, NO_WORD_WRAP
	ld [wTextboxSettings], a
	call PlaceTextboxString
	pop af
	ld [wTextboxSettings], a
	ret

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
	cp TEXT_INIT
	jr z, MoveToNextChar

	; Commands that have arguments needs to be processed in home bank
	; TODO - Make this into a table
	cp RAM_TEXT
	jp z, RAMTextCommand
	
	cp NUM_TEXT
	jp z, PrintNumberCommand
	
	cp BCD_TEXT
	jp z, PrintBCDNumberCommand

	cp TWO_OPTION_TEXT
	jp z, TwoOptionTextCommand

	cp FAR_TEXT
	jp z, FarTextCommand

	cp GOTO_TEXT
	jp z, GotoTextCommand

	cp CRY_TEXT
	jp z, CryTextCommand

	cp SFX_TEXT
	jp z, SoundFXCommand

	; Otherwise, process in different bank
	ld b, a
	ld a, BANK(HandleNextChar)
	call SetNewBank
	jp HandleNextChar

SoundFXCommand:
	inc de
	ld a, [de]
	inc de
	call PlaySound
	call WaitForSoundToFinish
	jp PlaceNextChar

CryTextCommand:
	inc de
	ld a, [de]
	inc de
	push de
	push hl
	call PlayCry
	pop hl
	pop de
	jp PlaceNextChar

; TODO - include in word wrap lookahead
; TODO - legacy code had left align enabled by default
; so the input flag should be right align?
PrintNumberCommand:
	call PrepareInlineString
	ld a, [de]

	inc de
	push de

	ld d, b
	ld e, c ; de = pointer to number

	ld c, a
	and %11000111 ; num bytes & flags
	ld b, a

	ld a, c
	and %00111000 ; num digits
	rrca
	rrca 
	rrca
	ld c, a
	call PrintNumber

	pop de
	jp PlaceNextChar

; TODO - include in word wrap lookahead
PrintBCDNumberCommand:
	call PrepareInlineString
	
	ld a, [de]
	inc de
	push de

	ld d, b
	ld e, c
	ld c, a
	call PrintBCDNumber

	pop de
	jp PlaceNextChar

ReturnAndPlaceNextChar::
	; restore the string bank
	; the bank is stored below the line start
	; import the line start into bc since de and hl cant be erased
	pop bc
	pop af
	push af
	push bc
	call SetNewBank
	;fall through

MoveToNextChar:
	inc de
	jp PlaceNextChar

TwoOptionTextCommand::
	ld a, [wLetterPrintingDelayFlags]
	push af
	res 1, a ; disable delays
	ld [wLetterPrintingDelayFlags], a

	; draw the bottom box
	push hl
	push de
	farcall DrawOptionBox

	; place the options
	pop hl
	inc hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	push hl
	push de
	call GetStartOfBottomRow
	ld bc, SCREEN_WIDTH * 2 + 1
	add hl, bc
	pop de
	push hl
	call PlaceTextboxString
	
	pop bc
	pop hl
	inc hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	push hl
	push bc
	ld hl, 9
	add hl, bc
	call PlaceTextboxString

	call Delay3
	pop de
	dec de
	farcall HandleTwoOptionBox

	; handle the selection
	ld a, d
	pop de
	inc de
	and a
	jr z, .twoOptionJump
	inc de
	inc de
	dec a
	jr z, .twoOptionJump
	
	;otherwise, b was pressed
	inc de
	inc de
	jr .finishTwoOption

.twoOptionJump
	ld h, d
	ld l, e
	ld e, [hl]
	inc hl
	ld d, [hl]
	; fall through

.finishTwoOption
	pop hl
	pop af
	ld [wLetterPrintingDelayFlags], a
	jp PlaceNextChar

GotoTextCommand::
	push hl
	inc de
	ld h, d
	ld l, e
	ld e, [hl]
	inc hl
	ld d, [hl]
	pop hl
	jp PlaceNextChar

RAMTextCommand::
	call PrepareInlineString
	push de
	call PlaceInlineString
	pop de
	jp PlaceNextChar

FarTextCommand::
	ld a, [H_LOADEDROMBANK]
	push af
	call PrepareInlineString
	ld a, [de]
	call SetNewBank
	inc de
	push de
	call PlaceInlineString
	pop de
	pop af
	call SetNewBank
	jp PlaceNextChar

PrepareInlineString:
	inc de
	ld a, [de]
	ld c, a
	inc de
	ld a, [de]
	ld b, a
	inc de
	ret

PlaceInlineString:
	ld d, b
	ld e, c
	call PlaceTextboxString
	ld h, b
	ld l, c
	ret

; TODO
ASMTextCommand:
	jp MoveToNextChar

TextCommandProcessor::
	ld a, [wLetterPrintingDelayFlags]
	push af
	ld a, [hl]
	cp TEXTBOX_DEF
	jr z, .handleText

	ld a, [hWY]
	and a
	jr nz, .notFullscreen
	
	; initialize settings
	ld a, NO_WORD_WRAP | BLACK_ON_WHITE | LINES_2
	ld [wTextboxSettings], a
	jr .resetTextbox

.notFullscreen
	; Just reset if the window is already on screen
	cp SCREEN_HEIGHT_PIXELS
	jr c, .resetTextbox

	ld a, NO_WORD_WRAP | BLACK_ON_WHITE | LINES_2
	call InitializeTextbox
	jr .handleText

.resetTextbox
	push hl
	push bc
	farcall ResetTextbox
	pop bc
	pop hl

.handleText
	call TextCommandProcessor_NoInit
	pop af
	ld [wLetterPrintingDelayFlags], a
	ret

TextCommandProcessor_NoInit::
	ld a, c
	ld [wTextDest], a
	ld a, b
	ld [wTextDest + 1], a
	push bc
	;fall through

NextTextCommand::
	ld a, [hli]
	cp TEXT_END ; terminator
	jr nz, .doTextCommand
	pop bc
	ret
.doTextCommand
	push hl
	cp $17
	jp z, TextCommand17
	cp TEXTBOX_DEF
	jp z, TextboxDefinitionCommand
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

; execute asm inline
; 08{code}
TextCommand08::
	pop hl
	ld de, NextTextCommand
	push de ; return address
	jp hl

TextboxDefinitionCommand:
	pop hl
	ld a, [hli]
	call InitializeTextbox
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
	call TextCommandProcessor_NoInit
	pop hl
	pop af
	call SetNewBank
	jp NextTextCommand

TextCommandJumpTable::
	dw TextCommand00
	dw TextCommand01
	dw $0000
	dw TextCommand03
	dw TextCommand04
	dw $0000
	dw $0000
	dw $0000
	dw TextCommand08
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

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
	; unless its TEXT_INIT, which we just ignore
	ld a, b
	cp TEXT_INIT
	jr z, .dontInc
	inc c
.dontInc
	jr .readNextCharLoop

.fixedLengthChar
	ld a, [hl]
	add c
	ld c, a
	jr .readNextCharLoop

JumpToTablePointer:
    ld a, [hli]
    ld h, [hl]
    ld l, a
    jp hl

; TODO - double check when all new commands are implemented
EndOfWordChars:
	db " ", PARAGRAPH, AUTO_PARAGRAPH
	db TEXT_END, TEXT_ASM, TEXTBOX_DEF
	db TWO_OPTION_TEXT, TEXT_WAIT
	db AUTO_CONTINUE_TEXT, CONTINUE_TEXT
	db NEXT_TEXT_LINE, NEXT_TEXT_LINE_2
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
	ld a, [de]
	ld c, a
	inc de
	ld a, [de]
	ld b, a
	inc de
	ld a, [de]
	call SetNewBank
	ld d, b
	ld e, c
	jp CountNextWordLength

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
	endtext

GetTextboxSize:
	ld a, [wTextboxSettings]
	and TEXT_LINES_MASK
	add a
	inc a ; a = size of textbox interior
	ret

GetStartOfBottomRow:
	coord hl, 1, 13
	ld a, [hWY]
	and a
	jr z, .continue
	coord hl, 1, 0
.continue
	call GetTextboxSize
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

ResetRowsAndColumnTilesRemaining:
	call ResetRowsRemaining
	; fall through

ResetColumnTilesRemaining:
	ld a, SCREEN_WIDTH - 2
	ld [wTextboxColsRemaining], a
	ret

InitializeWindowReveal:
	;clear sprites hidden by window
	xor a
	ld hl, wSpritesHiddenByTextbox
	ld [hli], a
	ld [hl], a
	; set window to bottom of screen
	ld a, SCREEN_HEIGHT_PIXELS
	ld [hWY], a
	ret

FullyRevealWindow::
	call InitializeWindowReveal
	; fall through

ScrollTextboxUp:
	ld c, -1
	call AdjustAndStoreTextboxScrollSpeed
	
.scrollLoop
	farcall UpdateTextboxPositionAndCheckSpritesToHide
	call DelayFrame
	ld a, [wTextboxScrollCyclesRemaining]
	and a
	jr nz, .scrollLoop

	ret

ScrollTextboxDown:
	ld c, 1
	call AdjustAndStoreTextboxScrollSpeed
	
.scrollLoop
	farcall UpdateTextboxPositionAndCheckSpritesToReveal
	call DelayFrame
	ld a, [wTextboxScrollCyclesRemaining]
	and a
	jr nz, .scrollLoop

	ret

; To adjust the textbox scroll speed based on the player options
; a = total height
; c = direction
AdjustAndStoreTextboxScrollSpeed:
	ld b, a ; number of frames
	
	; If scrolling past middle of screen, then double the speed
	cp SCREEN_HEIGHT_PIXELS/2
	jr c, .doneWithInitialAdjustment

	srl b ; divide frames by 2
	sla c ; double delta

.doneWithInitialAdjustment
	ld a, [wOptions]
	and $f ; keep the frame delay

	cp 5
	jr z, .storeScrollData

	srl b ; divide frames by 2
	sla c ; double delta

	cp 3
	jr z, .storeScrollData

	srl b ; divide frames by 2
	sla c ; double delta
	
.storeScrollData
	ld hl, wTextboxScrollCyclesRemaining
	ld [hl], b
	inc hl
	ld [hl], c
	ret

ClearTextboxAndDelay:
	call GetTextBoxStartCoordsHL
	call GetTextboxSize
	ld b, a
	ld c, 18
	call ClearScreenArea
	ld c, 20
	jp DelayFrames

YesText:
	str "Yes"

NoText:
	str "No"

HealText:
	str "Heal"

CancelText:
	str "Cancel"