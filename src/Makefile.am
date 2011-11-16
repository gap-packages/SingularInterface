# TESTS_ENVIRONMENT = SINGULARPATH='$(LIB_HOME)/share/gftables'
# TESTS_ENVIRONMENT += SINGULAR_ROOT_DIR='$(LIBSINGULARSINGULAR_HOME)' 

BINARCHDIR = bin/$(GAPARCH)
GAPINSTALLLIB = $(abs_top_srcdir)/$(BINARCHDIR)/libsing.so

lib_LTLIBRARIES = libsing.la


AM_CPPFLAGS= $(LIBSINGULAR_CFLAGS)
LDADD = $(LIBSINGULAR_LIBS)

libsing_la_SOURCES = libsing.c libsing.h cxxfuncs.cc
libsing_la_LDFLAGS = -module -avoid-version -R${abs_top_srcdir}/spielwiese/TARGET/lib -R${abs_top_srcdir}/spielwiese/TARGET/lib/singular $(LIBSINGULAR_LIBS)
# -R${abs_top_srcdir}/${SINGULARNAME}/Singular -L${abs_top_srcdir}/ -lsingular
libsing_la_LIBADD = $(LIBSINGULAR_LIBS)
libsing_la_CPPFLAGS = $(GAP_CPPFLAGS)  $(LIBSINGULAR_CFLAGS)
# -I../${SINGULARNAME}/${SINGARCHNAME}/include

# Change it so that make all also does a make install (to build the .so)
# and then copies it to the correct bin directory
all-local: 
	@$(MAKE) $(AM_MAKEFLAGS) install-libLTLIBRARIES
	$(mkdir_p) $(top_srcdir)/$(BINARCHDIR)
	cp $(libdir)/libsing.so $(GAPINSTALLLIB)
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
	@echo "  To test the libsingular package in GAP, try"
	@echo ""
	@echo "gap> LoadPackage(\"libsingular\");"
	@echo ""
	@echo ""
	@echo ""
	@echo "***********************************************************************"
	

# Change it so that make clean also does a make uninstall (to remove the .so)
# and removes it from the bin directory
clean-local: 
	@$(MAKE) $(AM_MAKEFLAGS) uninstall-libLTLIBRARIES
	rm -f $(top_srcdir)/$(BINARCHDIR)/libsing.so

