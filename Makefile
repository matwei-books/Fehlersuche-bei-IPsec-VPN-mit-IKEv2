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
#
DRAFTS = build/draft/einfuehrung-draft.pdf \
	 build/draft/grundlagen/index-draft.pdf \
	 build/draft/grundlagen/paketmitschnitt-draft.pdf \
	 build/draft/grundlagen/theoretisch-draft.pdf \
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

draft: draftpaths $(DRAFTS)
	
# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

