db 0 ; Former Pokedex ID (was never used anyway)
db 106 ; base hp
db 110 ; base attack
db 90 ; base defense
db 130 ; base speed
db 154 ; base special
db PSYCHIC ; species type 1
db PSYCHIC ; species type 2
db 3 ; catch rate
db 220 ; base exp yield
db 0, 0, 0 ; Former Front Sprite Dimension & Pointer
db 0, 0 ; Former Back Sprite Pointer
; attacks known at lvl 0
db CONFUSION
db DISABLE
db SWIFT
db PSYCHIC_M
db 5 ; growth rate
; learnset
	tmlearn 1,5,6,8
	tmlearn 9,10,11,12,13,14,15,16
	tmlearn 17,18,19,20,22,24
	tmlearn 25,29,30,31,32
	tmlearn 33,34,35,36,38,40
	tmlearn 44,45,46
	tmlearn 49,50,54,55
db 0 ; padding
