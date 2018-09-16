#
IMAGES = entscheidungsbaum-alternativ.png \
       	 entscheidungsbaum.png \
	 ipsec-ike-datagram-options.png \
	 nat.png \
	 vpn.png \
	 vpn-mit-sonde.png \
#
DITAAOPTS = -E
#
%.png: %.ditaa; ditaa $(DITAAOPTS) $< $@ > /dev/null
%.png: %.plantuml; plantuml $<

all: $(IMAGES)

# vim:ft=make
#
