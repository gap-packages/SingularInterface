BINARCHDIR = bin/$(GAPARCH)
GAPINSTALLLIB = $(abs_top_srcdir)/$(BINARCHDIR)/libsing.so
SINGULARNAME = Singular-`cat ../SINGULARVERSION`
SINGARCHNAME = `cat ../SINGARCHNAME`

lib_LTLIBRARIES = libsing.la
bin_PROGRAMS = gentableforGAP

gentableforGAP_SOURCES = gentableforGAP.cc
gentableforGAP_CPPFLAGS = -I../${SINGULARNAME} -I../${SINGULARNAME}/Singular
gentableforGAP_LDFLAGS = -R${abs_top_srcdir}/${SINGULARNAME}/Singular -L${abs_top_srcdir}/${SINGULARNAME}/Singular -R${abs_top_srcdir}/${SINGULARNAME}/${SINGARCHNAME}/lib -lsingular -lpthread

libsing_la_SOURCES = libsing.c libsing.h cxxfuncs.cc
libsing_la_LDFLAGS = -module -avoid-version -R${abs_top_srcdir}/${SINGULARNAME}/Singular -L${abs_top_srcdir}/${SINGULARNAME}/Singular -R${abs_top_srcdir}/${SINGULARNAME}/${SINGARCHNAME}/lib -lsingular -lpthread
libsing_la_LIBADD = 
libsing_la_CPPFLAGS = $(GAP_CPPFLAGS) -I../${SINGULARNAME}/${SINGARCHNAME}/include
libsing_la_CXXFLAGS = -Wall
libsing_la_CFLAGS = -Wall

# Change it so that make all also does a make install (to build the .so)
# and then copies it to the correct bin directory
all-local: highlevel_mappings.g highlevel_mappings_table.g
	@$(MAKE) $(AM_MAKEFLAGS) install-libLTLIBRARIES
	$(mkdir_p) $(top_srcdir)/$(BINARCHDIR)
	cp $(libdir)/libsing.so $(GAPINSTALLLIB)
	cp highlevel_mappings.g ../lib
	cp highlevel_mappings_table.g ../lib
	@echo "***********************************************************************"
	@echo ""
	@echo "  SUCCESS!"
	@echo ""
	@echo "***********************************************************************"
	

# Change it so that make clean also does a make uninstall (to remove the .so)
# and removes it from the bin directory
clean-local: 
	@$(MAKE) $(AM_MAKEFLAGS) uninstall-libLTLIBRARIES
	rm -f $(top_srcdir)/$(BINARCHDIR)/libsing.so

# Apply C++ preprocessor to lowlevel_mappings_src.h to strip out
# comments and unwanted macros.
# We cannot use cpp directly, as language selection (via -x) is broken
# there on recent Mac OS X versions :-(/
lowlevel_mappings_src.h: lowlevel_mappings_src.h.in
	c++ -E -P -DPINLINE0= -DPINLINE2= -Dinline= -x c++ $< > $@

lowlevel_mappings_src.g: gen_lowlevel_input.g gen_lowlevel_common.g
	@echo "Generating lowlevel mappings input..."
	$(GAPROOT)/bin/gap.sh -A -q -T < $< > $@
	@echo "Done!"

lowlevel_mappings.cc lowlevel_mappings.h lowlevel_mappings_table.h: gen_lowlevel_mappings.g gen_lowlevel_common.g lowlevel_mappings_src.g lowlevel_mappings_src.h
	@echo "Generating lowlevel mappings..."
	$(GAPROOT)/bin/gap.sh -A -q -T < $<
	@echo "Done!"

highlevel_mappings_table.g:	gentableforGAP
	./gentableforGAP

highlevel_mappings.g:	highlevel_mappings_table.g gen_highlevel_mappings.g
	@echo "Generating highlevel mappings..."
	$(GAPROOT)/bin/gap.sh -A -q -T < gen_highlevel_mappings.g
	@echo "Done!"

