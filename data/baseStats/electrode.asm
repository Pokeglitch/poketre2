db 0 ; Former Pokedex ID (was never used anyway)
db 60 ; base hp
db 50 ; base attack
db 70 ; base defense
db 140 ; base speed
db 80 ; base special
db ELECTRIC ; species type 1
db ELECTRIC ; species type 2
db 60 ; catch rate
db 150 ; base exp yield
db 0, 0, 0 ; Former Front Sprite Dimension & Pointer
db 0, 0 ; Former Back Sprite Pointer
; attacks known at lvl 0
db TACKLE
db SCREECH
db SONICBOOM
db 0
db 0 ; growth rate
; learnset
	tmlearn 6
	tmlearn 9,15
	tmlearn 20,24
	tmlearn 25,30,31,32
	tmlearn 33,34,36,39,40
	tmlearn 44,45,47
	tmlearn 50,55
db 0 ; padding
