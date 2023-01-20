db 0 ; Former Pokedex ID (was never used anyway)
db 65 ; base hp
db 105 ; base attack
db 60 ; base defense
db 95 ; base speed
db 60 ; base special
db FIGHTING ; species type 1
db FIGHTING ; species type 2
db 75 ; catch rate
db 149 ; base exp yield
db 0, 0, 0 ; Former Front Sprite Dimension & Pointer
db 0, 0 ; Former Back Sprite Pointer
; attacks known at lvl 0
db SCRATCH
db LEER
db KARATE_CHOP
db FURY_SWIPES
db 0 ; growth rate
; learnset
	tmlearn 1,5,6,8
	tmlearn 9,10,15,16
	tmlearn 17,18,19,20,24
	tmlearn 25,28,31,32
	tmlearn 34,35,39,40
	tmlearn 44,48
	tmlearn 50,54
db 0 ; padding
