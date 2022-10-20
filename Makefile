#!/bin/bash
pwd := $$(pwd)

# colors / text formatting
BACKGR=`tput setaf 0`
RED=`tput setaf 1`
GREEN=`tput setaf 10`
GREENB=`tput setab 10`
BLUE=`tput setaf 4`
BOLD=`tput bold`
RESET=`tput sgr0`

# LaTeX options to disable interruptions
TeXOptions = -lualatex \
			 -interaction=nonstopmode \
			 -halt-on-error \
			 -output-directory=build


all: presentation_light.pdf presentation_dark.pdf

light: presentation_light.pdf

dark: presentation_dark.pdf


plots_light: plots/plot.py matplotlibrc header-matplotlib.tex
	@echo "Make ${BLUE}$@${RESET}:"
	@TEXINPUTS="$$(pwd):" python plots/plot.py --theme light
	@echo

plots_dark: plots/plot.py matplotlibrc header-matplotlib.tex
	@echo "Make ${BLUE}$@${RESET}:"
	@TEXINPUTS="$$(pwd):" python plots/plot.py --theme dark
	@echo


.DELETE_ON_ERROR:
presentation_light.pdf: presentation.tex beamerthemetudo.sty plots_light | build
	@echo 0 > build/darktheme.var
	@TEXINPUTS="$$(pwd):" latexmk $(TeXOptions) presentation.tex 1> build/log || cat build/log
	mv build/presentation.pdf $@

presentation_dark.pdf: presentation.tex beamerthemetudo_dark.sty plots_dark | build
	@echo 1 > build/darktheme.var
	@TEXINPUTS="$$(pwd):" latexmk $(TeXOptions) presentation.tex 1> build/log || cat build/log
	mv build/presentation.pdf $@

FORCE:

build:
	@mkdir -p build/

clean:
	@rm -rf build
	@echo ${GREEN}${BOLD}Removing build folder${RESET}

.PHONY: FORCE all light dark clean
