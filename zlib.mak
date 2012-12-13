#
# Build zlib
# 

ZLIB_ARCHIVE=$(PKGDIR)\zlib-$(ZLIB_VERSION).zip
ZLIB_SRCDIR=$(LIBBUILDDIR)\zlib-$(ZLIB_VERSION)
ZLIB_BINDIR=$(LIBBUILDDIR)\zlib-$(ZLIB_VERSION)-bin

$(ZLIB_ARCHIVE): $(WGET)
	@IF NOT EXIST $(PKGDIR) md $(PKGDIR)
	$(WGET) -q -O $(ZLIB_ARCHIVE) $(ZLIB_URL)
	
$(LIBBUILDDIR):
	IF NOT EXIST $(LIBBUILDDIR) md $(LIBBUILDDIR)
	
# Because timestamps will be preserved from the archive, use a 
# marker file to track it.
$(ZLIB_SRCDIR)\unpack-stamp: $(ZLIB_ARCHIVE) $(TOUCH) $(LIBBUILDDIR)
	"$(7ZIP)" x -o$(LIBBUILDDIR) -bd -y $(ZLIB_ARCHIVE)
	@$(TOUCH) $(ZLIB_SRCDIR)\unpack-stamp

$(ZLIB_SRCDIR)\zlib1.dll: $(ZLIB_SRCDIR)\unpack-stamp
	cd $(ZLIB_SRCDIR)
	$(MAKE) /f win32\Makefile.msc clean
	$(MAKE) /f win32\Makefile.msc

ZLIB_OBJS=$(ZLIB_BINDIR)\include\zlib.h $(ZLIB_BINDIR)\include\zconf.h $(ZLIB_BINDIR)\bin\zlib1.dll $(ZLIB_BINDIR)\bin\zlib1.pdb $(ZLIB_BINDIR)\lib\zdll.exp $(ZLIB_BINDIR)\lib\zdll.lib 

$(ZLIB_BINDIR)\include\zlib.h: $(ZLIB_SRCDIR)\zlib1.dll
	@IF NOT EXIST $(ZLIB_BINDIR)\include md $(ZLIB_BINDIR)\include
	copy /Y /B $(ZLIB_SRCDIR)\zlib.h $(ZLIB_BINDIR)\include\zlib.h >NUL
	@$(TOUCH) $(ZLIB_BINDIR)\include\zlib.h
	
$(ZLIB_BINDIR)\include\zconf.h: $(ZLIB_SRCDIR)\zlib1.dll
	@IF NOT EXIST $(ZLIB_BINDIR)\include md $(ZLIB_BINDIR)\include
	copy /Y /B  $(ZLIB_SRCDIR)\zconf.h   $(ZLIB_BINDIR)\include\zconf.h >NUL
	@$(TOUCH) $(ZLIB_BINDIR)\include\zconf.h
	
$(ZLIB_BINDIR)\bin\zlib1.dll: $(ZLIB_SRCDIR)\zlib1.dll
	@IF NOT EXIST $(ZLIB_BINDIR)\bin md $(ZLIB_BINDIR)\bin
	copy /Y /B  $(ZLIB_SRCDIR)\zlib1.dll $(ZLIB_BINDIR)\bin\zlib1.dll >NUL
	
$(ZLIB_BINDIR)\bin\zlib1.pdb: $(ZLIB_SRCDIR)\zlib1.dll
	@IF NOT EXIST $(ZLIB_BINDIR)\bin md $(ZLIB_BINDIR)\bin
	copy /Y /B  $(ZLIB_SRCDIR)\zlib1.pdb $(ZLIB_BINDIR)\bin\zlib1.pdb >NUL
	
$(ZLIB_BINDIR)\lib\zdll.exp: $(ZLIB_SRCDIR)\zlib1.dll
	@IF NOT EXIST $(ZLIB_BINDIR)\lib md $(ZLIB_BINDIR)\lib
	copy /Y /B  $(ZLIB_SRCDIR)\zdll.exp  $(ZLIB_BINDIR)\lib\zdll.exp >NUL
	@$(TOUCH) $(ZLIB_BINDIR)\lib\zdll.exp
	
$(ZLIB_BINDIR)\lib\zdll.lib: $(ZLIB_SRCDIR)\zlib1.dll
	@IF NOT EXIST $(ZLIB_BINDIR)\lib md $(ZLIB_BINDIR)\lib
	copy /Y /B  $(ZLIB_SRCDIR)\zdll.lib  $(ZLIB_BINDIR)\lib\zdll.lib >NUL
	@$(TOUCH) $(ZLIB_BINDIR)\lib\zdll.lib
