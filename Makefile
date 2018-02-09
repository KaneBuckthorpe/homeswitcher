#export THEOS = /theos/

# export THEOS_DEVICE_IP = 127.0.0.1 -p 2222
#export ARCHS = armv7 armv7s arm64
# export TARGET = iphone:clang:10.3:10.3
#export ARCHS = x86_64 i386
#export TARGET = simulator:clang::10.3

include theos/makefiles/common.mk

TWEAK_NAME = HomeSwitcher
HomeSwitcher_FILES = HomeSwitcher.xm Classes/HSCollectionView.xm Classes/HSAppCardCell.x Classes/HSHomeView.xm

include $(THEOS_MAKE_PATH)/tweak.mk

HomeSwitcher_FRAMEWORKS = UIKit CoreGraphics QuartzCore MobileCoreServices

HomeSwitcher_CFLAGS = -fobjc-arc

after-install::
	install.exec "killall -9 SpringBoard"
