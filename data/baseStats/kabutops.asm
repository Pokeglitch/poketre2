db 0 ; Former Pokedex ID (was never used anyway)
db 60 ; base hp
db 115 ; base attack
db 105 ; base defense
db 80 ; base speed
db 70 ; base special
db ROCK ; species type 1
db WATER ; species type 2
db 45 ; catch rate
db 201 ; base exp yield
db 0, 0, 0 ; Former Front Sprite Dimension & Pointer
db 0, 0 ; Former Back Sprite Pointer
; attacks known at lvl 0
db SCRATCH
db HARDEN
db ABSORB
db 0
db 0 ; growth rate
; learnset
	tmlearn 2,3,5,6,8
	tmlearn 9,10,11,12,13,14,15
	tmlearn 17,19,20
	tmlearn 31,32
	tmlearn 33,34,40
	tmlearn 44
	tmlearn 50,53
db 0 ; padding
