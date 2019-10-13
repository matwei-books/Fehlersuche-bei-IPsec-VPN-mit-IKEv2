# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = sphinx-build
SPHINXPROJ    = FehlersuchebeiIKEv2IPsecVPN
SOURCEDIR     = source
BUILDDIR      = build

SOURCE = source/einfuehrung.rst \
	 source/grundlagen/index.rst \
	 source/grundlagen/paketmitschnitt.rst \
	 source/grundlagen/theoretisch.rst \
	 source/ikev2/ueberblick.rst \
	 source/ikev2/betriebsarten.rst \
	 source/ikev2/nachrichten.rst \
	 source/vorgehen/fragen.rst \
	 source/vorgehen/antworten.rst \
	 source/fehler/index.rst \
	 source/fehler/kategorisierung.rst \
	 source/fehler/fehlerbilder.rst \
	 source/fehler/ursachen.rst \
	 source/software/index.rst \
	 source/software/cisco-asa.rst \
	 source/software/mikrotik-router.rst \
#
DRAFTS = build/draft/einfuehrung-draft.pdf \
	 build/draft/grundlagen/index-draft.pdf \
	 build/draft/grundlagen/paketmitschnitt-draft.pdf \
	 build/draft/grundlagen/theoretisch-draft.pdf \
	 build/draft/ikev2/ueberblick-draft.pdf \
	 build/draft/ikev2/betriebsarten-draft.pdf \
	 build/draft/ikev2/nachrichten-draft.pdf \
	 build/draft/vorgehen/fragen-draft.pdf \
	 build/draft/vorgehen/antworten-draft.pdf \
	 build/draft/fehler/index-draft.pdf \
	 build/draft/fehler/kategorisierung-draft.pdf \
	 build/draft/fehler/fehlerbilder-draft.pdf \
	 build/draft/fehler/ursachen-draft.pdf \
	 build/draft/software/index-draft.pdf \
	 build/draft/software/cisco-asa-draft.pdf \
	 build/draft/software/mikrotik-router-draft.pdf \
#

build/draft/%-draft.pdf: source/%.rst; pandoc -o $@ --variable subparagraph -H pandoc/draft.tex $<

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help Makefile $(SOURCE)

epub: Makefile
	$(SPHINXBUILD) -M epub "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

latexpdf: Makefile
	$(SPHINXBUILD) -M latexpdf "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

draftpaths:
	[ -d build/draft/grundlagen ] || mkdir -p build/draft/grundlagen
	[ -d build/draft/ikev2 ] || mkdir -p build/draft/ikev2
	[ -d build/draft/vorgehen ] || mkdir -p build/draft/vorgehen
	[ -d build/draft/fehler ] || mkdir -p build/draft/fehler
	[ -d build/draft/software ] || mkdir -p build/draft/software

draft: draftpaths $(DRAFTS)
	
# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

