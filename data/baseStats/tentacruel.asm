db 0 ; Former Pokedex ID (was never used anyway)
db 80 ; base hp
db 70 ; base attack
db 65 ; base defense
db 100 ; base speed
db 120 ; base special
db WATER ; species type 1
db POISON ; species type 2
db 60 ; catch rate
db 205 ; base exp yield
db 0, 0, 0 ; Former Front Sprite Dimension & Pointer
db 0, 0 ; Former Back Sprite Pointer
; attacks known at lvl 0
db ACID
db SUPERSONIC
db WRAP
db 0
db 5 ; growth rate
; learnset
	tmlearn 3,6
	tmlearn 9,10,11,12,13,14,15
	tmlearn 20,21
	tmlearn 31,32
	tmlearn 33,34,40
	tmlearn 44
	tmlearn 50,51,53
db 0 ; padding
