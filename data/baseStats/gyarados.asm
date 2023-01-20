db 0 ; Former Pokedex ID (was never used anyway)
db 95 ; base hp
db 125 ; base attack
db 79 ; base defense
db 81 ; base speed
db 100 ; base special
db WATER ; species type 1
db FLYING ; species type 2
db 45 ; catch rate
db 214 ; base exp yield
db 0, 0, 0 ; Former Front Sprite Dimension & Pointer
db 0, 0 ; Former Back Sprite Pointer
; attacks known at lvl 0
db BITE
db DRAGON_RAGE
db LEER
db HYDRO_PUMP
db 5 ; growth rate
; learnset
	tmlearn 6,8
	tmlearn 9,10,11,12,13,14,15
	tmlearn 20,23,24
	tmlearn 25,31,32
	tmlearn 33,34,38,40
	tmlearn 44
	tmlearn 50,53,54
db 0 ; padding
