db 0 ; Former Pokedex ID (was never used anyway)
db 50 ; base hp
db 52 ; base attack
db 48 ; base defense
db 55 ; base speed
db 50 ; base special
db WATER ; species type 1
db WATER ; species type 2
db 190 ; catch rate
db 80 ; base exp yield
db 0, 0, 0 ; Former Front Sprite Dimension & Pointer
db 0, 0 ; Former Back Sprite Pointer
; attacks known at lvl 0
db SCRATCH
db 0
db 0
db 0
db 0 ; growth rate
; learnset
	tmlearn 1,5,6,8
	tmlearn 9,10,11,12,13,14,16
	tmlearn 17,18,19,20
	tmlearn 28,31,32
	tmlearn 34,39,40
	tmlearn 44
	tmlearn 50,53,54
db 0 ; padding
