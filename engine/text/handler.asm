; To move the printing to the next line
MoveToNextLine:
	call ResetColumnTilesRemaining

	; decrease the number of rows remaining
	ld a, [wTextboxRowParams]
	dec a
	ld [wTextboxRowParams], a

	ld bc, SCREEN_WIDTH
	add hl, bc
	ld a, [hFlags_0xFFF6]
	bit 2, a
	ret nz ; return if single space
	add hl, bc
	ret

; try to reveal the textbox when a user prompt is encountered
CheckRevealTextbox::
    ld a, [wTextboxSettings]
    bit BIT_DONT_REVEAL, a
    ret z ; return if the textbox is not set to be hidden

	ld a, [hWY]
	cp SCREEN_HEIGHT_PIXELS
	ret c ; return if its already revealed

	push de
	push hl
	farcall RevealTextbox
	
	ld a, [wTextboxSettings]
	bit BIT_NO_DELAY, a
	jr nz, .dontEnableDelay

	ld a, [wLetterPrintingDelayFlags]
	set 1, a
	ld b, a
	ldh a, [hClearLetterPrintingDelayFlags]
	xor b
	ld [wLetterPrintingDelayFlags], a

.dontEnableDelay
	pop hl
	pop de
	ret

; To handle the next character in the string
HandleNextChar:
    push hl
    ld hl, StringCommandTable

.checkCommandTableLoop
    ld a, [hli]
    cp b
    jr nz, .moveToNextRow
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop bc ; text destination now in bc
	push hl ; store pointer pointer from table as return address
	ld h, b ; move text destination back into hl
	ld l, c
	ret

.moveToNextRow
    inc hl
    inc hl
    and a
    jr nz, .checkCommandTableLoop

    ld hl, NestedStringsTable

.checkNestedTableLoop
    ld a, [hli]
    cp b
    jr z, UseNestedTextFromTable
    inc hl
    inc hl
    and a
    jr nz, .checkNestedTableLoop

    pop hl
    ld a, b
    ; fall through

    ; End of table
PlaceNextCharacter:
	ld [hli], a
	ld a, [wTextboxColsRemaining]
	dec a
	ld [wTextboxColsRemaining], a
	call PrintLetterDelay
    jp ReturnAndPlaceNextChar

UseNestedTextFromTable:
    ld c, [hl]
    inc hl
    ld b, [hl]
    pop hl
    push de
    ld d, b
    ld e, c
	; note, bc does not represent the start of the line here
	; but it doesnt matter because nested strings aren't multi-line
	; TODO - except for word wrap...

PlaceNestedString:
	call PlaceTextboxString
	ld h, b
	ld l, c
	pop de
	jp ReturnAndPlaceNextChar

StringCommandTable:
    dbw " ", SpaceCommand ; space
    dbw TEXT_WAIT, WaitCommand ; wait
	dbw DELAY_TEXT, DelayCommand ; delay
    dbw NEXT_TEXT_LINE, NextLineCommand ; next
	dbw AUTO_CONTINUE_TEXT, AutoContinueText ; autocont
	dbw CONTINUE_TEXT, ContinueText ; cont
	dbw PARAGRAPH, ParagraphCommand ; para
	dbw AUTO_PARAGRAPH, AutoParagraphCommand ; autopara
	dbw TEXT_PROMPT, TextPromptCommand ; prompt
	dbw TEXT_EXIT, TextExitCommand ; exit
	dbw MOVE_TARGET_TEXT, MoveTargetTextCommand ; TARGET
	dbw MOVE_USER_TEXT, MoveUserTextCommand ; USER
    db 00

SpaceCommand:
	inc de
    ld a, [wTextboxSettings]
    bit BIT_NO_WORD_WRAP, a
    jp z, CheckWordWrap
	; fall through

CheckWordWrapReturn:
	dec de
	jr c, HandleWordWrap

	ld a, " "
    jp PlaceNextCharacter

HandleWordWrap:
	; if there are rows remaining, move to the next line
	ld a, [wTextboxRowParams]
	and TEXTBOX_ROWS_REMAINING_MASK
	jr nz, UpdateCurrentLine

	; if there is auto scroll remaining, then auto scroll
	ld a, [wTextboxRowParams]
	and TEXTBOX_AUTOSCROLL_REMAINING_MASK
	jp nz, AutoContinueText ; auto scroll

	;otherwise, reset autoscroll count and prompt for a scroll
	ld a, [wTextboxSettings]
	and TEXT_LINES_MASK
	swap a
	ld [wTextboxRowParams], a

	jp ContinueText

NextLineCommand:
	ld a, [wTextboxSettings]
	bit BIT_NO_WORD_WRAP, a
	jr z, HandleWordWrap

	; If No Delay is on, use the HandleWordWrap logic
	; This is because the Para command will simply call autocont when no delay is on
	; so there will be no more space in the textbox
	bit BIT_NO_DELAY, a
	jr nz, HandleWordWrap

	; otherwise, fall through

UpdateCurrentLine:
	pop hl
	call MoveToNextLine
	push hl
	jp ReturnAndPlaceNextChar

ContinueText::
	push de
	call Delay3
	call CheckRevealTextbox
	call ManualTextScroll
	pop de
	jr ScrollCommon


AutoContinueText::
	; decrease the auto scroll count
	ld a, [wTextboxRowParams]
	swap a
	dec a
	swap a
	ld [wTextboxRowParams], a
	;fall through

ScrollCommon:
	push de
	call ScrollTextUpOneLine
	call ScrollTextUpOneLine
	call ResetColumnTilesRemaining
	call GetStartOfBottomRow
	pop de
	jp ReturnAndPlaceNextChar


; move both rows of text in the normal text box up one row
; always called twice in a row
; first time, copy the two rows of text to the "in between" rows that are usually emtpy
; second time, copy the bottom row of text into the top row of text
ScrollTextUpOneLine::
	coord hl, 0, 15 ; top row of text
	coord de, 0, 14 ; empty line above text
	ld a, [hWY]
	and a
	jr z, .continue ; if window is fullscreen, continue

	coord hl, 0, 2 ; top row of text
	coord de, 0, 1 ; empty line above text

.continue
	call GetTextboxSize
	dec a
	jr z, .eraseLastRow

	ld b, a
	xor a

.sizeLoop
	add SCREEN_WIDTH
	dec b
	jr nz, .sizeLoop
	ld b, a

.copyText
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .copyText

.eraseLastRow
	call GetStartOfBottomRow
	ld a, " "
	ld b, SCREEN_WIDTH - 2
.clearText
	ld [hli], a
	dec b
	jr nz, .clearText

	; wait five frames
	ld b, 5
.WaitFrame
	call DelayFrame
	dec b
	jr nz, .WaitFrame
	ret

AutoParagraphCommand:: ; autopara
	push de
	call Delay3
	jr ParagraphCommandCommon

ParagraphCommand:: ; para
	push de
	call Delay3
	call CheckRevealTextbox
	call ManualTextScroll

ParagraphCommandCommon::
	ld a, [wTextboxSettings]
	bit BIT_NO_DELAY, a
	jr nz, .noDelay
	call ClearTextboxAndDelay
	pop de
	pop hl
	call ResetRowsRemaining
	call ResetColumnTilesRemaining
	call GetTextBoxStartCoordsHL
	push hl
	jp ReturnAndPlaceNextChar

; if no delay is on, then autocont instead
.noDelay
	; reset the autoscroll count to the full size
	and TEXT_LINES_MASK
	inc a
	swap a
	ld [wTextboxRowParams], a

	pop de
	jp AutoContinueText

WaitCommand:: ; wait
	push de
	call ManualTextScroll
	pop de
	jp ReturnAndPlaceNextChar

TextPromptCommand:: ; prompt
	call Delay3
	call CheckRevealTextbox
	call ManualTextScroll
	ld b, h
	ld c, l
	pop hl ; hl = start of line
	jp HomeBankswitchReturn

TextExitCommand:: ; exit
	ld a, 1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld b, h
	ld c, l
	pop hl ; hl = start of line
	jp HomeBankswitchReturn

; depending on whose turn it is, print
; enemy active monster’s name, prefixed with “Enemy ”
; or
; player active monster’s name
MoveTargetTextCommand::
	ld a, [H_WHOSETURN]
	xor 1
	jr MonsterNameCharsCommon

; depending on whose turn it is, print
; player active monster’s name
; or
; enemy active monster’s name, prefixed with “Enemy ”
MoveUserTextCommand::
	ld a, [H_WHOSETURN]
MonsterNameCharsCommon::
	push de
	ld de, wBattleMonNick ; player active monster name
	and a
	jr z, .playerTurn

	ld de, EnemyMonText ; enemy monster name

.playerTurn
	jp PlaceNestedString

EnemyMonText::
	db "Enemy "
	ramtext wEnemyMonNick
	db "@"

NestedStringsTable:
	dbw PLAYER_NAME_TEXT, wPlayerName ; player
	dbw RIVAL_NAME_TEXT, wRivalName ; rival
	dbw POKE_TEXT, PokeText ; POKé
	dbw PC_TEXT, PCText ; PC
	dbw ROCKET_TEXT, RocketText ; ROCKET
	dbw TM_TEXT, TMText ; TM
	dbw TRAINER_TEXT, TrainerString ; TRAINER
	dbw DOTS_TEXT, DotsText ; 6 dots
	dbw PKMN_TEXT, PKMNText ; PKMN
    db 00

PokeText::
	str "Poké"

PCText::
	str "PC"

RocketText::
	str "ROCKET"

TMText::
	str "TM"

TrainerString::
	str "TRAINER"

DotsText::
	str ".."

PKMNText::
	db $E1,$E2,"@" ; PKMN

DelayCommand: ; delay
	push de
	call Joypad
	ld a, [hJoyHeld]
	and A_BUTTON | B_BUTTON
	jr nz, .skipDelay
	ld c, 30
	call DelayFrames
.skipDelay
	pop de
	jp ReturnAndPlaceNextChar

DrawOptionBox:
	call GetStartOfBottomRow
	ld de, SCREEN_WIDTH * 2 - 1
	add hl, de
	ld a, [wTextboxSettings]
	bit BIT_NO_BORDER, a
	jr z, .drawBorder

	;if no border, just clear screen area
	lb bc, 2, SCREEN_WIDTH 
	jp ClearScreenArea

.drawBorder
	ld c, SCREEN_WIDTH - 2
	ld [hl], $7A
	inc hl
	ld a, " "
	call NPlaceChar
	ld a, $7B
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld c, SCREEN_WIDTH - 2
	call NPlaceChar
	inc a
	ld [hl], a
	ret

UpdateTwoOptionRadios:
	lb bc, "▶", "▷"
	and a
	jr z, .dontSwap
	lb bc, "▷", "▶"
.dontSwap
	ld [hl], b
	ld de, 9
	add hl, de
	ld [hl], c
	ret

HandleTwoOptionMenuInputs_DrawInitialRadios:
	xor a
	push de
	push af
	ld h, d
	ld l, e
	call UpdateTwoOptionRadios
	jr HandleTwoOptionMenuInputsCommon

HandleTwoOptionMenuInputs:
	xor a
	push de
	push af
	;fall through

HandleTwoOptionMenuInputsCommon:
.keypressLoop
	call JoypadLowSensitivity
	ld a, [hJoy5]

	bit BIT_A_BUTTON, a
	jr nz, .aPressed

	bit BIT_B_BUTTON, a
	jr nz, .bPressed

	and D_LEFT | D_RIGHT
	jr z, .keypressLoop
	
	pop af
	pop hl
	push hl
	xor 1
	push af
	call UpdateTwoOptionRadios
	jr .keypressLoop

.bPressed
	pop af
	ld a, -1
	jr .finish

.aPressed
	pop af

.finish
	ld d, a
	ld a, SFX_PRESS_AB
	call PlaySound
	pop af
	ret


; Inputs: de = address of left option
; Outputs: d = 0 for 1st opt, 1 for 2nd opt, -1 for B
; also, wCurrentMenuItem, wChosenMenuItem, and wMenuExitMethod
HandleTwoOptionBox:
	push de
	ld h, d
	ld l, e
	; Initialize the radios
	xor a
	call UpdateTwoOptionRadios

	ld a, 2 * PIXELS_PER_TILE
	call ScrollTextboxUp

.doneScrollingUp
	pop de
	call HandleTwoOptionMenuInputs

	push de
	ld a, 2 * PIXELS_PER_TILE
	call ScrollTextboxDown

.doneScrollingDown
	pop de

	ld b, CHOSE_MENU_ITEM
	ld a, d
	and a
	jr z,  .storeResult
	
	; first option was not selected
	cp 1
	jr z, .storeResult
	
	; b was pressed
	ld a, 1 ; set the chosen menu item to be the second item even if B was pressed
	ld b, CANCELLED_MENU

.storeResult
	ld [wCurrentMenuItem], a
	ld [wChosenMenuItem], a
	ld a, b
	ld [wMenuExitMethod], a
	ret

HealCancelTextboxOption_:
	ld de, HealText
	ld hl, CancelText
	jr TextboxOptionCommon

YesNoTextboxOption_:
	ld de, YesText
	ld hl, NoText
	;fall through

TextboxOptionCommon:
	ld a, [wLetterPrintingDelayFlags]
	push af
	push hl
	push de
	res 1, a ; disable delays
	ld [wLetterPrintingDelayFlags], a
	call DrawOptionBox
	;place the options
	call GetStartOfBottomRow
	ld bc, SCREEN_WIDTH * 2 + 1
	add hl, bc
	pop de
	push hl
	; bc != start of line, but doesnt matter because option is single line
	call PlaceTextboxString
	pop hl
	pop de
	push hl
	ld bc, 9
	add hl, bc
	; bc != start of line, but doesnt matter because option is single line
	call PlaceTextboxString
	call Delay3
	pop de
	dec de
	call HandleTwoOptionBox
	pop af
	ld [wLetterPrintingDelayFlags], a
	ret
