db 0 ; Former Pokedex ID (was never used anyway)
db 75 ; base hp
db 100 ; base attack
db 95 ; base defense
db 110 ; base speed
db 70 ; base special
db NORMAL ; species type 1
db NORMAL ; species type 2
db 45 ; catch rate
db 211 ; base exp yield
db 0, 0, 0 ; Former Front Sprite Dimension & Pointer
db 0, 0 ; Former Back Sprite Pointer
; attacks known at lvl 0
db TACKLE
db 0
db 0
db 0
db 5 ; growth rate
; learnset
	tmlearn 6,7,8
	tmlearn 9,10,13,14,15
	tmlearn 20,24
	tmlearn 25,26,27,31,32
	tmlearn 34,38,40
	tmlearn 44
	tmlearn 50,54
db 0 ; padding
