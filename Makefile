# Generated by Mirage (Fri, 5 Dec 2014 08:51:50 GMT).

LIBS   = -pkgs lwt.syntax,cstruct,cstruct.syntax,mirage-console.xen,mirage-net-xen,mirage-types.lwt,re,re.str,tcpip.ethif,tcpip.stack-direct,tcpip.tcpv4,tcpip.udpv4
PKGS   = cstruct mirage-console mirage-net-xen mirage-xen re tcpip xen-evtchn xen-gnt xenstore
SYNTAX = -tags "syntax(camlp4o),annot,bin_annot,strict_sequence,principal"

FLAGS  = -cflag -g -lflags -g,-linkpkg,-dontlink,unix

XENLIB = $(shell ocamlfind query mirage-xen)

BUILD  = ocamlbuild -classic-display -use-ocamlfind $(LIBS) $(SYNTAX) $(FLAGS)
OPAM   = opam

export PKG_CONFIG_PATH=$(shell opam config var prefix)/lib/pkgconfig

export OPAMVERBOSE=1
export OPAMYES=1

.PHONY: all depend clean build main.native
all: build

depend:
	$(OPAM) install $(PKGS) --verbose

main.native:
	$(BUILD) main.native

main.native.o:
	$(BUILD) main.native.o

build: main.native.o
	pkg-config --print-errors --exists openlibm 'libminios-xen >= 0.2'
	ld -d -static -nostdlib --start-group \
	  $$(pkg-config --static --libs openlibm 'libminios-xen >= 0.2') \
	  _build/main.native.o $(XENLIB)/libocaml.a \
	  $(XENLIB)/libxencaml.a --end-group \
	  -L/usr/lib/ocaml \
	  -lbigarray \
	  -L/home/magnus/.opam/system/lib/cstruct \
	  -lcstruct_stubs \
	  -L/home/magnus/.opam/system/lib/shared-memory-ring \
	  -lshared_memory_ring_stubs \
	  -L/home/magnus/.opam/system/lib/tcpip \
	  -ltcpip_stubs \
	  $(shell gcc -print-libgcc-file-name) \
	  -o mir-unikernel.xen

run: build
	@echo unikernel.xl has been created. Edit it to add VIFs or VBDs
	@echo Then do something similar to: xl create -c unikernel.xl

clean:
	ocamlbuild -clean
