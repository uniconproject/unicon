#
# Graphics tests that check pixels rather than look at a screen: drawing,
# colors, events, image file round trips, and 3D.  The other programs here
# (gpxtest.icn and friends) are run by hand; see README.
#
# SDL graphics runs on SDL's offscreen video driver, so these need no
# display; X11 needs one ($DISPLAY), and runs the 2D tests only (gl3d
# uses hidden 3D windows).  Other window systems are skipped.
#

include ../Makedefs

GFXTESTS = gfxbasic imgrw

UCFEAT := $(shell $(UC) -features 2>/dev/null)

ifneq ($(findstring SDL graphics,$(UCFEAT)),)
TARGETS = $(GFXTESTS)
TEST_ENV = SDL_VIDEODRIVER=offscreen
# 3D on the offscreen driver needs EGL, as on Linux
ifneq ($(findstring 3D graphics,$(UCFEAT)),)
ifneq ($(TOS),Darwin)
ifneq ($(TOS),Windows)
TARGETS += gl3d
endif
endif
endif
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
