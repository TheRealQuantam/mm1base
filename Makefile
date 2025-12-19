.PHONY: clean dir us japan

SRCDIR := $(CURDIR)
CFG_FILE := mm1dasm.cfg
ASM_FILES := $(wildcard $(SRCDIR)/*.s)

USBUILDDIR := build/us
US_STEM := mm1base

JBUILDDIR := build/japan
J_STEM := rm1base

COMMON_CA65_OPTS := -g

ifneq ($(DISABLE_SCORE),)
COMMON_CA65_OPTS += -DDISABLE_SCORE
USBUILDDIR := $(USBUILDDIR)noscore
US_STEM := $(US_STEM)noscore
JBUILDDIR := $(JBUILDDIR)noscore
J_STEM := $(J_STEM)noscore
endif

US_O_FILES := $(patsubst $(SRCDIR)/%.s,$(USBUILDDIR)/%.o,$(ASM_FILES))
J_O_FILES := $(patsubst $(SRCDIR)/%.s,$(JBUILDDIR)/%.o,$(ASM_FILES))

#all: us japan

dir:
	-@mkdir -p build
	-@mkdir -p "$(USBUILDDIR)"
	-@mkdir -p "$(JBUILDDIR)"

clean:
	-@rm -rf build
	-@rm -f $(US_STEM).nes
	-@rm -f $(US_STEM).dbg
	-@rm -f $(US_STEM).bps
	-@rm -f $(J_STEM).nes
	-@rm -f $(J_STEM).dbg
	-@rm -f $(J_STEM).bps

us: dir $(US_STEM).nes $(US_STEM).bps

japan: dir $(J_STEM).nes $(J_STEM).bps

$(US_STEM).nes: $(CFG_FILE) $(US_O_FILES)
	ld65 -vm -m $(USBUILDDIR)/map.txt -Ln $(USBUILDDIR)/labels.txt --dbgfile $(US_STEM).dbg -o $@ -C $^

$(USBUILDDIR)/%.o: $(SRCDIR)/%.s globals.inc
	$(file > $(USBUILDDIR)/build.inc,.define SRC_ROM "$(BASE_ROM)")
	ca65 $(COMMON_CA65_OPTS) -I $(USBUILDDIR) -o $@ $<
	
$(US_STEM).bps: $(US_STEM).nes
#	Requires flips from https://www.romhacking.net/utilities/1040/
	flips --create --bps-delta-moremem --exact "$(BASE_ROM)" $< $@

$(J_STEM).nes: $(CFG_FILE) $(J_O_FILES)
	ld65 -vm -m $(JBUILDDIR)/map.txt -Ln $(JBUILDDIR)/labels.txt --dbgfile $(J_STEM).dbg -o $@ -C $^

$(JBUILDDIR)/%.o: $(SRCDIR)/%.s globals.inc
	$(file > $(JBUILDDIR)/build.inc,.define SRC_ROM "$(BASE_ROM)")
	ca65 $(COMMON_CA65_OPTS) -DJ_VERSION -I $(JBUILDDIR) -o $@ $<

$(J_STEM).bps: $(J_STEM).nes
#	Requires flips from https://www.romhacking.net/utilities/1040/
	flips --create --bps-delta-moremem --exact "$(BASE_ROM)" $< $@
