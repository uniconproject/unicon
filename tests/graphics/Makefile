#
# Graphics tests that check pixels rather than look at a screen: drawing,
# colors, events, and image file round trips.  The other programs here
# (gpxtest.icn and friends) are run by hand; see README.
#
# SDL graphics runs on SDL's offscreen video driver, so these need no
# display; X11 needs one ($DISPLAY).  Other window systems are skipped.
#

include ../Makedefs

GFXTESTS = gfxbasic imgrw

UCFEAT := $(shell $(UC) -features 2>/dev/null)

ifneq ($(findstring SDL graphics,$(UCFEAT)),)
TARGETS = $(GFXTESTS)
TEST_ENV = SDL_VIDEODRIVER=offscreen
else
ifneq ($(and $(findstring X Windows,$(UCFEAT)),$(DISPLAY)),)
TARGETS = $(GFXTESTS)
else
skip:
	@echo ""
	@echo "Graphics tests need SDL graphics, or X11 with a display."
	@echo "SKIP: graphics tests"

TARGETS = skip
endif
endif

# Test must be the first goal so `make -C graphics` runs the suite.
Test: DoTest

include ../Makefile.test
