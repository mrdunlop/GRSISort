SUBDIRS = src libraries
ALLDIRS = $(SUBDIRS)

PLATFORM = $(shell uname)

export PLATFORM:= $(PLATFORM)

export CFLAGS = -std=c++0x -O2 -I$(PWD)/include `root-config --cflags`

ifeq ($(PLATFORM),Darwin)
export __APPLE__ = 1
export CFLAGS += -DOS_DARWIN -std=c++11 -DHAVE_ZLIB -lz
export LFLAGS = -dynamiclib -single_module -undefined dynamic_lookup 
export SHAREDSWITCH = -install_name # ENDING SPACE
export CPP = xcrun clang++
else
export __LINUX__ = 1	
export SHAREDSWITCH = -shared -Wl,-soname,#NO ENDING SPACE
export CPP = g++
endif
export COMPILESHARED   = $(CPP) $(LFLAGS) $(SHAREDSWITCH)#NO ENDING SPACE

export BASE:= $(CURDIR)

export CAT=cat

export ECHO=echo -e
export OK_STRING="[OK]"
export ERROR_STRING="[ERROR]"
export WARN_STRING="[WARNING]"
export COMP_STRING="Now Compiling "

export COM_COLOR=\033[0;34m
export OBJ_COLOR=\033[0;36m
export DICT_COLOR=\033[0;36m
export OK_COLOR=\033[0;32m
export ERROR_COLOR=\033[0;31m
export WARN_COLOR=\033[0;33m
export NO_COLOR=\033[m

MAKE=make --no-print-directory 

.PHONY: all subdirs $(ALLDIRS) clean

all: print subdirs grsisort

print:
	echo $(PLATFORM)

subdirs: $(SUBDIRS)

src: libraries

$(ALLDIRS):
	@$(MAKE) -C $@

grsisort: src
	@mv $</$@ bin/$@
	@echo -e " \033[0;33m Compliation Success. woohoo! \033[m"

bin:
	@mkdir $@

clean:
	@$(RM) *~
	$(RM) ./bin/grsisort
	@for dir in $(ALLDIRS); do \
		$(MAKE) -C $$dir $@; \
	done




