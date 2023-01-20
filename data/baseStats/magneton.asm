db 0 ; Former Pokedex ID (was never used anyway)
db 50 ; base hp
db 60 ; base attack
db 95 ; base defense
db 70 ; base speed
db 120 ; base special
db ELECTRIC ; species type 1
db ELECTRIC ; species type 2
db 60 ; catch rate
db 161 ; base exp yield
db 0, 0, 0 ; Former Front Sprite Dimension & Pointer
db 0, 0 ; Former Back Sprite Pointer
; attacks known at lvl 0
db TACKLE
db SONICBOOM
db THUNDERSHOCK
db 0
db 0 ; growth rate
; learnset
	tmlearn 6
	tmlearn 9,10,15
	tmlearn 20,24
	tmlearn 25,30,31,32
	tmlearn 33,34,39
	tmlearn 44,45
	tmlearn 50,55
db 0 ; padding
