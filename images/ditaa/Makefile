#
# Makefile
# Mathias Weidner, 2018-09-16
#
include Makefile.images

DITAAOPTS = -E

%.png: %.ditaa Makefile; ditaa $(DITAAOPTS) $< $@ > /dev/null

all: $(IMAGES)

clean:
	rm $(IMAGES)

# vim:ft=make
