db 0 ; Former Pokedex ID (was never used anyway)
db 40 ; base hp
db 45 ; base attack
db 35 ; base defense
db 55 ; base speed
db 40 ; base special
db POISON ; species type 1
db FLYING ; species type 2
db 255 ; catch rate
db 54 ; base exp yield
db 0, 0, 0 ; Former Front Sprite Dimension & Pointer
db 0, 0 ; Former Back Sprite Pointer
; attacks known at lvl 0
db LEECH_LIFE
db 0
db 0
db 0
db 0 ; growth rate
; learnset
	tmlearn 2,4,6
	tmlearn 9,10
	tmlearn 20,21
	tmlearn 31,32
	tmlearn 34,39
	tmlearn 44
	tmlearn 50
db 0 ; padding
