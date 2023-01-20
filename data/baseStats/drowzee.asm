db 0 ; Former Pokedex ID (was never used anyway)
db 60 ; base hp
db 48 ; base attack
db 45 ; base defense
db 42 ; base speed
db 90 ; base special
db PSYCHIC ; species type 1
db PSYCHIC ; species type 2
db 190 ; catch rate
db 102 ; base exp yield
db 0, 0, 0 ; Former Front Sprite Dimension & Pointer
db 0, 0 ; Former Back Sprite Pointer
; attacks known at lvl 0
db POUND
db HYPNOSIS
db 0
db 0
db 0 ; growth rate
; learnset
	tmlearn 1,5,6,8
	tmlearn 9,10
	tmlearn 17,18,19,20
	tmlearn 29,30,31,32
	tmlearn 33,34,35,40
	tmlearn 42,44,45,46
	tmlearn 49,50,55
db 0 ; padding
