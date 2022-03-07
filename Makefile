SHELL=/bin/sh

PROGRAM = acetylene
VERSION = 1.0

CXXFILES = main.cpp Frame.cpp menu.cpp FrameWindow.cpp Desktop.cpp hotkeys.cpp

MANPAGE = 1

################################################################

OBJECTS = $(CXXFILES:.cpp=.o)

all:	makeinclude $(PROGRAM)

$(PROGRAM) : $(OBJECTS)
	$(CXX) $(LDFLAGS) -o $(PROGRAM) $(OBJECTS) $(LIBS)

configure: configure.in
	autoconf

makeinclude: configure makeinclude.in
	./configure
include makeinclude

.SUFFIXES : .fl .do .cpp .c .h

.cpp.o :
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $<
.cpp :
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $<
.fl.cpp :
	-fluid -c $<
.fl.h :
	-fluid -c $<

clean :
	-@ rm -f *.o $(PROGRAM) $(CLEAN) core *~ makedepend
	@touch makedepend

depend:
	$(MAKEDEPEND) -I.. $(CXXFLAGS) $(CXXFILES) $(CFILES) > makedepend
makedepend:
	touch makedepend
include makedepend

install: $(PROGRAM)
	$(INSTALL) -s $(PROGRAM) $(bindir)/$(PROGRAM)

uninstall:
	-@ rm -f $(bindir)/$(PROGRAM)

dist:
	cat /dev/null > makedepend
	-@mkdir $(PROGRAM)-$(VERSION)
	-@ln README Makefile configure install-sh makedepend *.cpp *.h *.in *.fl flwm_wmconfig $(PROGRAM)-$(VERSION)
	tar -cvzf $(PROGRAM)-$(VERSION).tgz $(PROGRAM)-$(VERSION)
	-@rm -r $(PROGRAM)-$(VERSION)

exedist:
	-@mkdir $(PROGRAM)-$(VERSION)-x86
	-@ln README $(PROGRAM) flwm_wmconfig $(PROGRAM)-$(VERSION)-x86
	tar -cvzf $(PROGRAM)-$(VERSION)-x86.tgz $(PROGRAM)-$(VERSION)-x86
	-@rm -r $(PROGRAM)-$(VERSION)-x86

################################################################

PROGRAM_D = $(PROGRAM)_d

debug: $(PROGRAM_D)

OBJECTS_D = $(CXXFILES:.cpp=.do) $(CFILES:.c=.do)

.cpp.do :
	$(CXX) -I.. $(CXXFLAGS) -DDEBUG -c -o $@ $<
.c.do :
	$(CC) -I.. $(CFLAGS) -DDEBUG -o $@ $<

$(PROGRAM_D) : $(OBJECTS_D)
	$(CXX) $(LDFLAGS) -o $(PROGRAM_D) $(OBJECTS_D) $(LIBS)
