db 0 ; Former Pokedex ID (was never used anyway)
db 80 ; base hp
db 85 ; base attack
db 95 ; base defense
db 25 ; base speed
db 30 ; base special
db GROUND ; species type 1
db ROCK ; species type 2
db 120 ; catch rate
db 135 ; base exp yield
db 0, 0, 0 ; Former Front Sprite Dimension & Pointer
db 0, 0 ; Former Back Sprite Pointer
; attacks known at lvl 0
db HORN_ATTACK
db 0
db 0
db 0
db 5 ; growth rate
; learnset
	tmlearn 6,7,8
	tmlearn 9,10
	tmlearn 20,24
	tmlearn 25,26,27,28,31,32
	tmlearn 34,38,40
	tmlearn 44,48
	tmlearn 50,54
db 0 ; padding
