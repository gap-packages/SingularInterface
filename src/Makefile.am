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

# Change it so that make all also does a make install (to build the .so)
# and then copies it to the correct bin directory
all-local: highlevel_mappings.g highlevel_mappings_table.g
	@$(MAKE) $(AM_MAKEFLAGS) install-libLTLIBRARIES
	$(mkdir_p) $(top_srcdir)/$(BINARCHDIR)
	cp $(libdir)/libsing.so $(GAPINSTALLLIB)
	cp highlevel_mappings.g ../lib
	cp highlevel_mappings_table.g ../lib
	@echo ""
	@echo "***********************************************************************"
	@echo ""
	@echo "  SUCCESS!"
	@echo ""
	@echo "  The libsing kernel module has been successfully built and installed"
	@echo "  in $(GAPINSTALLLIB)"
	@echo ""
	@echo "  The libsing package will probably conflict with GAP's memory. To"
	@echo "  avoid conflict you should either run GAP with the -a switch, for"
	@echo "  example"
	@echo ""
	@echo "   gap -a 100M"
	@echo ""
	@echo "  or with the -m switch, for example"
	@echo ""
	@echo "   gap -m 256M"
	@echo ""
	@echo "  To test the libsing package in GAP, try"
	@echo ""
	@echo "gap> LoadPackage(\"libsing\");"
	@echo ""
	@echo ""
	@echo ""
	@echo "***********************************************************************"
	

# Change it so that make clean also does a make uninstall (to remove the .so)
# and removes it from the bin directory
clean-local: 
	@$(MAKE) $(AM_MAKEFLAGS) uninstall-libLTLIBRARIES
	rm -f $(top_srcdir)/$(BINARCHDIR)/libsing.so


lowlevel_mappings.cc lowlevel_mappings.h lowlevel_mappings_table.h: gen_lowlevel_mappings.g
	@echo "Generating lowlevel mappings..."
	$(GAPROOT)/bin/gap.sh -A -q -T < $<
	@echo "Done!"

highlevel_mappings_table.g:	gentableforGAP
	./gentableforGAP

highlevel_mappings.g:	highlevel_mappings_table.g gen_highlevel_mappings.g
	@echo "Generating highlevel mappings..."
	$(GAPROOT)/bin/gap.sh -A -q -T < gen_highlevel_mappings.g
	@echo "Done!"

