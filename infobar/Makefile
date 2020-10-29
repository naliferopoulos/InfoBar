ARCHS = armv7 arm64 arm64e
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = infobar

infobar_FILES = Tweak.x
infobar_CFLAGS = -fobjc-arc
infobar_PRIVATE_FRAMEWORKS = UIKitCore


include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += infobarpreferences
include $(THEOS_MAKE_PATH)/aggregate.mk
