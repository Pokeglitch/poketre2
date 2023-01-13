db DEX_CATERPIE ; pokedex id
db 45 ; base hp
db 30 ; base attack
db 35 ; base defense
db 45 ; base speed
db 20 ; base special
db BUG ; species type 1
db BUG ; species type 2
db 255 ; catch rate
db 53 ; base exp yield
db 0, 0, 0, ; Former Front Sprite Dimension & Pointer
dw CaterpiePicBack
; attacks known at lvl 0
db TACKLE
db STRING_SHOT
db 0
db 0
db 0 ; growth rate
; learnset
	tmlearn 0
	tmlearn 0
	tmlearn 0
	tmlearn 0
	tmlearn 0
	tmlearn 0
	tmlearn 0
db 0 ; padding
