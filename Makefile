#!/bin/bash
pwd := $$(pwd)
translate = $1

# colors / text formatting
BACKGR=`tput setaf 0`
RED=`tput setaf 1`
GREEN=`tput setaf 10`
GREENB=`tput setab 10`
BLUE=`tput setaf 4`
BOLD=`tput bold`
RESET=`tput sgr0`

# LaTeX options to disable interruptions
TeXOptions = 	--output-directory=build \
				--interaction=nonstopmode \
				--halt-on-error \


all: presentation_light.pdf log presentation_dark.pdf

light: presentation_light.pdf

dark: presentation_dark.pdf

build:
	@mkdir -p build/

# simple workaround, else 'all' wouldn't work after 'presentation_light.pdf'
# (for whatever reason)
log:
	@mkdir -p build
	@touch build/log

clean:
	@rm -rf build
	@echo ${GREEN}${BOLD}Removing build folder${RESET}

plots_light: plots/plot.py matplotlibrc header-matplotlib.tex
	@echo "Make ${BLUE}$@${RESET}:"
	@TEXINPUTS="$(call translate,$(pwd):)" python Plots/plot.py --theme light
	@echo

plots_dark: plots/plot.py matplotlibrc header-matplotlib.tex
	@echo "Make ${BLUE}$@${RESET}:"
	@TEXINPUTS="$(call translate,$(pwd):)" python Plots/plot.py --theme dark
	@echo


.DELETE_ON_ERROR:
presentation_light.pdf: presentation.tex header.tex content/* graphics/* beamerthemetudo.sty plots_light | build
	@echo "(${RED}lualatex${RESET}) make ${BLUE}$@${RESET}"
	@TEXINPUTS="$(call translate,$(pwd):)" lualatex $(TeXOptions) presentation.tex 1> build/log || cat build/log
	@echo
	@BIBINPUTS=build: biber build/presentation.bcf|grep -i -e'biber' -e'error' -e'warn' --color=auto
	@echo
	@echo "Recompiling ${BLUE}$@${RESET} with ${RED}lualatex${RESET}..."
	@lualatex $(TeXOptions) presentation.tex 1> build/log || cat build/log
	@mv build/presentation.pdf $@
	@make clean
	@echo ${GREENB}${BACKGR}Success!${RESET}

presentation_dark.pdf: presentation.tex header.tex content/* graphics/* beamerthemetudo_dark.sty plots_dark | build
	@echo "(${RED}lualatex${RESET}) make ${BLUE}$@${RESET}"
	@TEXINPUTS="$(call translate,$(pwd):)" lualatex $(TeXOptions) "\def\darktheme{1} \input{presentation.tex}" 1> build/log || cat build/log
	@echo
	@BIBINPUTS=build: biber build/presentation.bcf|grep -i -e'biber' -e'error' -e'warn' --color=auto
	@echo
	@echo "Recompiling ${BLUE}$@${RESET} with ${RED}lualatex${RESET}..."
	@lualatex $(TeXOptions) "\def\darktheme{1} \input{presentation.tex}" 1> build/log || cat build/log
	@mv build/presentation.pdf $@
	@make clean
	@echo ${GREENB}${BACKGR}Success!${RESET}


.PHONY: all light dark build log clean