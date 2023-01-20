db 0 ; Former Pokedex ID (was never used anyway)
db 35 ; base hp
db 85 ; base attack
db 45 ; base defense
db 75 ; base speed
db 35 ; base special
db NORMAL ; species type 1
db FLYING ; species type 2
db 190 ; catch rate
db 96 ; base exp yield
db 0, 0, 0 ; Former Front Sprite Dimension & Pointer
db 0, 0 ; Former Back Sprite Pointer
; attacks known at lvl 0
db PECK
db 0
db 0
db 0
db 0 ; growth rate
; learnset
	tmlearn 4,6,8
	tmlearn 9,10
	tmlearn 20
	tmlearn 31,32
	tmlearn 33,34,40
	tmlearn 43,44
	tmlearn 49,50,52
db 0 ; padding
