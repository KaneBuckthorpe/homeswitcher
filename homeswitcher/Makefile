THEOS_DEVICE_IP = 192.168.1.77
ARCHS := armv7 armv7s arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = HomeSwitcher
HomeSwitcher_FILES = HomeSwitcher.xm Classes/HSSetup.m Classes/HSWindow.m Classes/HSCollectionView.x Classes/HSAppCardCell.xm Classes/HSHomeView.m

HomeSwitcher_FRAMEWORKS =  UIKit CoreGraphics QuartzCore MobileCoreServices Foundation

HomeSwitcher_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += HomeSwitcherPrefs
include $(THEOS_MAKE_PATH)/aggregate.mk
