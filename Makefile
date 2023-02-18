objs := main.o text.o wram.o

.SUFFIXES:
.SECONDEXPANSION:
.PRECIOUS:
.PHONY: rom clean tools

roms := poketre2.gbc

rom: $(roms)

clean:
	rm -f $(roms) $(objs) $(roms:.gbc=.sym)
	find . \( -iname '*.1bpp' -o -iname '*.2bpp' -o -iname '*.pce' \) -exec rm {} +
	$(MAKE) clean -C tools/

tools:
	$(MAKE) -C tools/

# Build tools when building the rom.
# This has to happen before the rules are processed, since that's when scan_includes is run.
ifeq (,$(filter clean tools,$(MAKECMDGOALS)))
$(info $(shell $(MAKE) -C tools))
endif

%.asm: ;

# Note, this will rebuild all objects when a .pce or .2bpp is required to be built, not simply main.o
%.o: dep = $(shell tools/scan_includes $(@D)/$*.asm) $(shell ls pce/*/*.png | sed "s|.png|.pce|g") $(shell ls tiles/*/*.png | sed "s|.png|.2bpp|g")
$(objs): %.o: %.asm $$(dep)
	rgbasm -l -h -r 128 -o $@ $*.asm

opts  = -jsv -k 01 -l 0x33 -m 0x13 -p 0 -r 03 -t "POKEMON TRE2"

%.gbc: $$(objs)
	rgblink -d -n $*.sym -l poketre2.link -o $@ $^
	rgbfix $(opts) $@
	sort $*.sym -o $*.sym

gfx/intro_meowth_1.2bpp: rgbgfx += -h
gfx/intro_meowth_2.2bpp: rgbgfx += -h
gfx/intro_meowth_3.2bpp: rgbgfx += -h

gfx/game_boy.2bpp: tools/gfx += --remove-duplicates
gfx/theend.2bpp: tools/gfx += --interleave --png=$<
gfx/tilesets/%.2bpp: tools/gfx += --trim-whitespace
gfx/titlescreen/team_rocket_edition_bg.2bpp: tools/gfx += --trim-whitespace
gfx/titlescreen/team_rocket_edition_text.2bpp: tools/gfx += --trim-whitespace

%.png: ;

%.2bpp: %.png
	rgbgfx $(rgbgfx) -o $@ $<
	$(if $(tools/gfx),\
		tools/gfx $(tools/gfx) -o $@ $@)

%.1bpp: %.png
	rgbgfx -d1 $(rgbgfx) -o $@ $<
	$(if $(tools/gfx),\
		tools/gfx $(tools/gfx) -d1 -o $@ $@)

%.pce: %.png
	-node tools/pce.js $< $@