db 0 ; Former Pokedex ID (was never used anyway)
db 55 ; base hp
db 70 ; base attack
db 45 ; base defense
db 60 ; base speed
db 50 ; base special
db FIRE ; species type 1
db FIRE ; species type 2
db 190 ; catch rate
db 91 ; base exp yield
db 0, 0, 0 ; Former Front Sprite Dimension & Pointer
db 0, 0 ; Former Back Sprite Pointer
; attacks known at lvl 0
db BITE
db ROAR
db 0
db 0
db 5 ; growth rate
; learnset
	tmlearn 6,8
	tmlearn 9,10
	tmlearn 20,23
	tmlearn 28,31,32
	tmlearn 33,34,38,39,40
	tmlearn 44
	tmlearn 50
db 0 ; padding
