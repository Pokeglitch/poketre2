db 0 ; Former Pokedex ID (was never used anyway)
db 65 ; base hp
db 90 ; base attack
db 65 ; base defense
db 100 ; base speed
db 61 ; base special
db NORMAL ; species type 1
db FLYING ; species type 2
db 90 ; catch rate
db 162 ; base exp yield
db 0, 0, 0 ; Former Front Sprite Dimension & Pointer
db 0, 0 ; Former Back Sprite Pointer
; attacks known at lvl 0
db PECK
db GROWL
db LEER
db 0
db 0 ; growth rate
; learnset
	tmlearn 2,4,6
	tmlearn 9,10,15
	tmlearn 20
	tmlearn 31,32
	tmlearn 34,39
	tmlearn 43,44
	tmlearn 50,52
db 0 ; padding
