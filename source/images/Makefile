#
IMAGES = entscheidungsbaum-alternativ.png \
       	 entscheidungsbaum.png \
	 nat.png \
	 vpn.png \
	 vpn-mit-sonde.png \
#
%.png: %.ditaa; ditaa $< $@ > /dev/null
%.png: %.plantuml; plantuml $<

all: $(IMAGES)

# vim:ft=make
#
