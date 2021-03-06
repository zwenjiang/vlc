# lame

LAME_VERSION := 3.99.5
LAME_URL := $(SF)/lame/lame-$(LAME_VERSION).tar.gz

$(TARBALLS)/lame-$(LAME_VERSION).tar.gz:
	$(call download_pkg,$(LAME_URL),lame)

.sum-lame: lame-$(LAME_VERSION).tar.gz

lame: lame-$(LAME_VERSION).tar.gz .sum-lame
	$(UNPACK)
	$(APPLY) $(SRC)/lame/lame-forceinline.patch
	$(APPLY) $(SRC)/lame/sse.patch
	$(APPLY) $(SRC)/lame/lame-outdated-autotools.patch
	# Avoid relying on iconv.m4 from gettext, when reconfiguring.
	# This is only used by the frontend which we disable.
	cd $(UNPACK_DIR) && sed -i.orig 's/^AM_ICONV/#&/' configure.in
	$(UPDATE_AUTOCONFIG)
	$(MOVE)

.lame: lame
	$(RECONF)
	cd $< && $(HOSTVARS) ./configure $(HOSTCONF) --disable-analyzer-hooks --disable-decoder --disable-gtktest --disable-frontend
	cd $< && $(MAKE) install
	touch $@
