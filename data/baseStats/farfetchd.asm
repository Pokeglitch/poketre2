db 0 ; Former Pokedex ID (was never used anyway)
db 52 ; base hp
db 65 ; base attack
db 55 ; base defense
db 60 ; base speed
db 58 ; base special
db NORMAL ; species type 1
db FLYING ; species type 2
db 45 ; catch rate
db 94 ; base exp yield
db 0, 0, 0 ; Former Front Sprite Dimension & Pointer
db 0, 0 ; Former Back Sprite Pointer
; attacks known at lvl 0
db PECK
db SAND_ATTACK
db 0
db 0
db 0 ; growth rate
; learnset
	tmlearn 2,3,4,6,8
	tmlearn 9,10
	tmlearn 20
	tmlearn 31,32
	tmlearn 33,34,39,40
	tmlearn 44
	tmlearn 50,51,52
db 0 ; padding
