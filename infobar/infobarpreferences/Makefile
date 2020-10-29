ARCHS = armv7 arm64 arm64e
TARGET := iphone:clang:latest:7.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = infobarpreferences

infobarpreferences_FILES = IBPRootListController.m
infobarpreferences_FRAMEWORKS = UIKit
infobarpreferences_PRIVATE_FRAMEWORKS = Preferences
infobarpreferences_INSTALL_PATH = /Library/PreferenceBundles
infobarpreferences_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
