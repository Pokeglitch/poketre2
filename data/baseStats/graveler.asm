db 0 ; Former Pokedex ID (was never used anyway)
db 55 ; base hp
db 95 ; base attack
db 115 ; base defense
db 35 ; base speed
db 45 ; base special
db ROCK ; species type 1
db GROUND ; species type 2
db 120 ; catch rate
db 134 ; base exp yield
db 0, 0, 0 ; Former Front Sprite Dimension & Pointer
db 0, 0 ; Former Back Sprite Pointer
; attacks known at lvl 0
db TACKLE
db DEFENSE_CURL
db 0
db 0
db 3 ; growth rate
; learnset
	tmlearn 1,6,8
	tmlearn 9,10
	tmlearn 17,18,19,20
	tmlearn 26,27,28,31,32
	tmlearn 34,35,36,38
	tmlearn 44,47,48
	tmlearn 50,54
db 0 ; padding
