#
IMAGES = bbaet.png \
	 bbaet-bw.png \
	 entscheidungsbaum-alternativ.png \
       	 entscheidungsbaum.png \
	 create-child-sa.png \
	 create-child-sa-rekey-child.png \
	 create-child-sa-rekey-ike.png \
	 icmp.png \
	 icmp-esp.png \
	 ike-auth.png \
	 ike-sa-init.png \
	 ike-sa-init-cookie.png \
	 ike-sa-init-inv-ke.png \
	 informational.png \
	 ipsec-boundary.png \
	 ipsec-esp-datagram.png \
	 ipsec-ike-datagram-delete-payload.png \
	 ipsec-ike-datagram-notify-payload.png \
	 ipsec-ike-datagram-gph.png \
	 ipsec-ike-datagram-options.png \
	 ipsec-overview.png \
	 ipsec-sa-payload.png \
	 ipsec-sa-payload-proposal.png \
	 ipsec-sa-payload-transform.png \
	 ipsec-sa-payload-transform-attribute.png \
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
