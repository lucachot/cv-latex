# This is the makefile for the Part II demonstration dissertation
#
# Note that continuation lines require ’\’ and
# that a TAB character preceeds any shell command line

# requires GNU make
SHELL=/bin/bash

.DELETE_ON_ERROR:
# Rules for building LaTeX documents (see Unix Tools course)
%.pdf %.aux %.idx: %.tex
	pdflatex --shell-escape $<
	while grep 'Rerun to get ' $*.log ; do pdflatex $< ; done

%.ind: %.idx
	makeindex $*
%.bbl: %.aux
	bibtex $*
# Rules for exporting xfig diagrams into PDF or EPS
%.pdf: %.eps
	epstopdf --outfile=$@ $<
%.eps: %.fig
	fig2dev -L eps $< $@
%.pdftex %.pdftex_t: %.fig
	fig2dev -L pdftex_t -p $*.pdftex $< $*.pdftex_t
	fig2dev -L pdftex $< $*.pdftex

help:
	@echo
	@echo "USAGE:"
	@echo
	@echo "make                display help information"
	@echo "make proposal.pdf   format the proposal as PDF"
	@echo "make thesis.pdf       format the dissertation as PDF"
	@echo "make all            make proposal.pdf and diss.pfd"
	@echo "make count          display an estimated word count"
	@echo "make pub            put demodiss.pdf onto your homepage"
	@echo "make clean          delete all intermediate files"
	@echo

thesis.pdf : thesis.bbl

makefile.txt: makefile
	expand makefile >makefile.txt

define count
	detex $1 | wc -w
endef


count:
	@$(call count, $(FILE))
	
clean:
	rm -f *.aux *.log *.err *.out
	rm -f *~ *.lof *.toc *.blg *.bbl
	rm -f makefile.txt
