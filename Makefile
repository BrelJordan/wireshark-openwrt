#
# Copyright (C) 2007-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=wireshark
PKG_VERSION:=4.4.5
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_MD5SUM:=5082fa9d60d1d9e0b55087fbc0a2b3b9
PKG_SOURCE_URL:=https://www.wireshark.org/download/src/

PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=COPYING

PKG_FIXUP:=autoreconf

CMAKE_INSTALL:=1
include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/wireshark
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=+librt +libcap +glib2 +tcpdump +libc +zlib +libgcrypt +libcares +liblua +liblz4
  URL:=http://www.wireshark.org/
  TITLE:=Network monitoring and data  tool
endef

define Build/PrepareLemon
	$(RM) -r $(PKG_BUILD_DIR)/tools/lemon/build 
	mkdir -p $(PKG_BUILD_DIR)/tools/lemon/build
	cmake -S $(PKG_BUILD_DIR)/tools/lemon -B $(PKG_BUILD_DIR)/tools/lemon/build
	$(MAKE) -C $(PKG_BUILD_DIR)/tools/lemon/build
	$(CP) $(PKG_BUILD_DIR)/tools/lemon/build/lemon $(STAGING_DIR_HOST)/bin/
endef


CMAKE_OPTIONS+= \
-Dbuild_as_dynamic=ON \
-DBUILD_wireshark=OFF \
-DBUILD_tshark=ON \
-DBUILD_captype=ON \
-DBUILD_dumpcap=ON \
-DBUILD_rawshark=ON \
-DBUILD_reordercap=ON \
-DBUILD_udpdump=ON \
-DBUILD_logray=OFF \
-DBUILD_text2pcap=OFF \
-DBUILD_mergecap=OFF \
-DBUILD_editcap=OFF \
-DBUILD_capinfos=OFF \
-DBUILD_randpkt=OFF \
-DBUILD_dftest=OFF \
-DBUILD_corbaidl2wrs=OFF \
-DBUILD_dcerpcidl2wrs=OFF \
-DBUILD_xxx2deb=OFF \
-DBUILD_androiddump=OFF \
-DBUILD_sshdump=OFF \
-DBUILD_ciscodump=OFF \
-DBUILD_dpauxmon=OFF \
-DBUILD_randpktdump=OFF \
-DBUILD_wifidump=OFF \
-DENABLE_LUA=OFF \
-DENABLE_NGHTTP2=OFF \
-DENABLE_NGHTTP3=OFF \
-DBUILD_sharkd=OFF \
-DBUILD_mmdbresolve=OFF

CMAKE_HOST_OPTIONS:=-Dbuild_as_dynamic=ON

define Build/compile
	$(call Build/PrepareLemon)
endef

define Package/wireshark/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/tshark $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/captype $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/dumpcap $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/rawshark $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/reordercap $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/wireshark/extcap/udpdump $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/lib*.so* $(1)/usr/lib
endef

$(eval $(call BuildPackage,wireshark))