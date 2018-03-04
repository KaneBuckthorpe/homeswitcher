include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = HomeSwitcher
HomeSwitcher_FILES = HSRootListController.xm HSInstructionsController.xm PSStepperCell.m HSSliderCell.m
HomeSwitcher_INSTALL_PATH = /Library/PreferenceBundles
HomeSwitcher_FRAMEWORKS = UIKit CoreGraphics Foundation
HomeSwitcher_PRIVATE_FRAMEWORKS = Preferences

TWEAKNAMEPREFS_LIBRARIES = colorpicker

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/HomeSwitcher.plist$(ECHO_END)
