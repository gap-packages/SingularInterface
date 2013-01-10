ACLOCAL_AMFLAGS = -I m4
AM_LIBTOOLFLAGS=--silent

SUBDIRS = src

EXTRA_DIST = \
	PackageInfo.g \
	init.g \
	read.g 

dist-hook:
	@echo "---------------------------------------------------------------"
	@echo ""
	@echo " Did you call dist2, not dist? If not, why not?"	
	@echo ""
	@echo "---------------------------------------------------------------"

# My own dist which sets the directory permissions to 755, not 777
dist2: distdir
	-find $(distdir) -type d -perm -777 -exec chmod 755 {} \;
	tardir=$(distdir) && $(am__tar) | GZIP=$(GZIP_ENV) gzip -c >$(distdir).tar.gz
	$(am__remove_distdir)
	
if WANT_SW
dofetchsingular:
	./fetchsingular.sw

domakesingular:
	./makesingular.sw
else
dofetchsingular:
	./fetchsingular

domakesingular:
	./makesingular
endif
