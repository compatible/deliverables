#
# Makefile for compiling LaTeX document
#
livrable = RA-Nuxeo
sources =
texfiles = main.tex

PDF = $(livrable).pdf
TEX = $(texfiles)

pdf: $(PDF)

tex: $(TEX)

%.tex: %.md
	pandoc -f markdown -t latex -o $@ $<

$(livrable).pdf: master.tex $(texfiles)
	pdflatex $<
	pdflatex $<
	pdflatex $<
	mv master.pdf $@

clean:
	rm -f $(texfiles)
	rm -f *.toc *.aux *.cov *.idx *.log *.par

tidy: clean
	rm -f $(PDF)

