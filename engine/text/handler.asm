; To most the printing to the next line
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

HandleNextChar:
    ld a, [wNextChar]
    cp $4E ; next
	jr z, .handleNext

	cp $4F ; line
	jr nz, .next3

.handleNext
	pop hl
	call MoveToNextLine
	push hl
	jp ReturnAndPlaceNextChar

.next3 ; Check against a dictionary
dict: macro
if \1 == 0
	and a
else
	cp \1
endc
	jp z, \2
endm

	dict $00, Char00 ; error
	dict $4C, Char4C ; autocont
	dict $4B, Char4B ; cont
	dict $51, Char51 ; para
	dict $49, Char49 ; page
	dict $52, Char52 ; player
	dict $53, Char53 ; rival
	dict $54, Char54 ; POKé
	dict $5B, Char5B ; PC
	dict $5E, Char5E ; ROCKET
	dict $5C, Char5C ; TM
	dict $5D, Char5D ; TRAINER
	dict $56, Char56 ; 6 dots
	dict $57, Char57 ; done
	dict $58, Char58 ; prompt
	dict $4A, Char4A ; PKMN
	dict $5F, Char5F ; dex
	dict $59, Char59 ; TARGET
	dict $5A, Char5A ; USER

	cp " "
	jr nz, PlaceNextCharacter

	inc de
	jp CheckWordWrap

CheckWordWrapReturn:
	dec de
	jr nc, .placeSpaceChar

	;handle word wrap
	
	; if there are rows remaining, move to the next line
	ld a, [wTextboxRowParams]
	and TEXTBOX_ROWS_REMAINING_MASK
	jr nz, .rowsRemaining 

	; if there is auto scroll remaining, then auto scroll
	ld a, [wTextboxRowParams]
	and TEXTBOX_AUTOSCROLL_REMAINING_MASK
	jp nz, Char4C ; auto scroll

	;otherwise, reset autoscroll count and prompt for a scroll
	ld a, [wTextboxSettings]
	and TEXT_LINES_MASK
	swap a
	ld [wTextboxRowParams], a

	jp Char4B


.rowsRemaining
	pop hl
	call MoveToNextLine
	push hl 
	jp ReturnAndPlaceNextChar

.placeSpaceChar
	ld a, " "

PlaceNextCharacter:
	ld [hli], a
	ld a, [wTextboxColsRemaining]
	dec a
	ld [wTextboxColsRemaining], a
	call PrintLetterDelay
    jp ReturnAndPlaceNextChar

Char00::
	ld b, h
	ld c, l
	pop hl
	ld de, Char00Text
	dec de
	ret

Char00Text:: ; “%d ERROR.”
	TX_FAR _Char00Text
	db "@"

Char52:: ; player’s name
	push de
	ld de, wPlayerName
	jr FinishDTE

Char53:: ; rival’s name
	push de
	ld de, wRivalName
	jr FinishDTE

Char5D:: ; TRAINER
	push de
	ld de, Char5DText
	jr FinishDTE

Char5C:: ; TM
	push de
	ld de, Char5CText
	jr FinishDTE

Char5B:: ; PC
	push de
	ld de, Char5BText
	jr FinishDTE

Char5E:: ; ROCKET
	push de
	ld de, Char5EText
	jr FinishDTE

Char54:: ; POKé
	push de
	ld de, Char54Text
	jr FinishDTE

Char56:: ; ……
	push de
	ld de, Char56Text
	jr FinishDTE

Char4A:: ; PKMN
	push de
	ld de, Char4AText
	jr FinishDTE

Char59::
; depending on whose turn it is, print
; enemy active monster’s name, prefixed with “Enemy ”
; or
; player active monster’s name
; (like Char5A but flipped)
	ld a, [H_WHOSETURN]
	xor 1
	jr MonsterNameCharsCommon

Char5A::
; depending on whose turn it is, print
; player active monster’s name
; or
; enemy active monster’s name, prefixed with “Enemy ”
	ld a, [H_WHOSETURN]
MonsterNameCharsCommon::
	push de
	and a
	jr nz, .Enemy
	ld de, wBattleMonNick ; player active monster name
	jr FinishDTE

.Enemy
	; print “Enemy ”
	ld de, Char5AText

FinishDTE::
	call PlaceString
	ld h, b
	ld l, c
	pop de
	jp ReturnAndPlaceNextChar

Char5CText::
	db "TM@"
Char5DText::
	db "TRAINER@"
Char5BText::
	db "PC@"
Char5EText::
	db "ROCKET@"
Char54Text::
	db "Poké@"
Char56Text::
	db "……@"
Char5AText::
	db "Enemy "
	TX_RAM wEnemyMonNick
	db "@"
Char4AText::
	db $E1,$E2,"@" ; PKMN


; try to reveal the textbox
CheckRevealTextbox::
	ld a, [hWY]
	cp SCREEN_HEIGHT_PIXELS
	ret c ; return if its already revealed

	push de
	push hl
	farcall RevealTextbox
	
	ld a, [wTextboxSettings]
	bit BIT_NO_DELAY, a
	jr nz, .dontEnableDelay

	ld hl, wLetterPrintingDelayFlags
	set 1, [hl] ; enable letter delay

.dontEnableDelay
	pop hl
	pop de
	ret

Char5F::
; ends a Pokédex entry
	ld [hl], "."
	jp ReturnFromPlaceNextChar

Char58:: ; prompt
	call GetEndOfBottomRow
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jp z, .ok
	ld [hl], "▼"
.ok
	call ProtectedDelay3
	call CheckRevealTextbox
	call ManualTextScroll
	ld [hl], " "

Char57:: ; done
	ld de, Char58Text-1
	jp ReturnFromPlaceNextChar

Char51:: ; para
	push de
	call GetEndOfBottomRow
	push af
	ld [hl], "▼"
	call ProtectedDelay3
	call CheckRevealTextbox
	call ManualTextScroll
	coord hl, 1, 1
	pop af
	ld b, a
	ld c, 18
	call ClearScreenArea
	ld c, 20
	call DelayFrames
	pop de
	pop hl
	call ResetRowsRemaining
	call ResetColumnTilesRemaining
	coord hl, 1, 1
	push hl
	jp ReturnAndPlaceNextChar

; Pokedex Page
Char49::
	push de
	ld a, "▼"
	Coorda 18, 16
	call ProtectedDelay3
	call ManualTextScroll
	coord hl, 1, 10
	lb bc, 7, 18
	call ClearScreenArea
	ld c, 20
	call DelayFrames
	pop de
	pop hl
	coord hl, 1, 11
	push hl
	jp ReturnAndPlaceNextChar

Char4B::
	push de
	call GetEndOfBottomRow
	ld [hl], "▼"
	push hl
	call ProtectedDelay3
	call CheckRevealTextbox
	call ManualTextScroll
	pop hl
	pop de
	ld [hl], " "
	jr ScrollCommon

Char4C::
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
	coord hl, 0, 2 ; top row of text
	coord de, 0, 1 ; empty line above text
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

ProtectedDelay3::
	push bc
	call Delay3
	pop bc
	ret
