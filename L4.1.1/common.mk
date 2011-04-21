#
# Generic makefile to compile document with CompatibleOne template
#
# To use it, your Makefile must look like the following:
# 
# texmain = mainfile.tex
# texsources = any source file used for your document (images, biblio...)
#
# include <path_to>/common.mk
#
tmpldir=$(shell cd $(dir $(lastword $(MAKEFILE_LIST))) && pwd)

# Search for prerequisites in common.mk dir
VPATH=$(tmpldir)
export TEXINPUTS=$(tmpldir):

LATEX=latex
PDFLATEX=pdflatex
DVIPS=dvips
MKDIR=mkdir -p
HACHA=hacha -francais
RM=rm -f
CP=cp

# Add templates files to dependencies
texsources += CompatibleOneCoverPage.sty CompatibleOne-logo.png
texfiles = $(texmain) $(texsources)
bibfiles = $(filter %.bib,$(texsources))
bibbase = $(patsubst %.bib,%,$(bibfiles))

PS=$(texmain:.tex=.ps)
PDF=$(PS:.ps=.pdf)

all: pdf 
ps: $(PS)
pdf: $(PDF)

.suffixes: .dvi .tex .ps .pdf

%.ps: %.dvi
	$(DVIPS) -o $@ $<

%.pdf: %.tex $(texfiles)
	$(PDFLATEX) $< 
	if [ -n "$(bibfiles)" ]; then bibtex $(bibbase); fi
	$(PDFLATEX) $<

%.dvi: %.tex $(texfiles)
	$(LATEX) $<
	$(LATEX) $<

clean:
	$(RM) *~ \#*\#
	$(RM) *.log *.aux *.toc *.cov *.par
	$(RM) $(PDF) $(PS)

.PHONY: all ps pdf clean
