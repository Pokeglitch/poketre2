db 0 ; Former Pokedex ID (was never used anyway)
db 20 ; base hp
db 10 ; base attack
db 55 ; base defense
db 80 ; base speed
db 20 ; base special
db WATER ; species type 1
db WATER ; species type 2
db 255 ; catch rate
db 20 ; base exp yield
db 0, 0, 0 ; Former Front Sprite Dimension & Pointer
db 0, 0 ; Former Back Sprite Pointer
; attacks known at lvl 0
db SPLASH
db 0
db 0
db 0
db 5 ; growth rate
; learnset
	tmlearn 0
	tmlearn 0
	tmlearn 0
	tmlearn 0
	tmlearn 0
	tmlearn 0
	tmlearn 0
db 0 ; padding
