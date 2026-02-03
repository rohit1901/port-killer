APP_NAME = PortKiller
BUILD_DIR = .build/release
APP_BUNDLE = $(APP_NAME).app
CONTENTS = $(APP_BUNDLE)/Contents
MACOS = $(CONTENTS)/MacOS
RESOURCES = $(CONTENTS)/Resources
ICONSET = $(APP_NAME).iconset
SOURCE_ICON = port-killer.png

.PHONY: all build bundle icon clean

all: bundle

build:
	swift build -c release

bundle: build
	mkdir -p $(MACOS) $(RESOURCES)
	cp $(BUILD_DIR)/PortKillerApp $(MACOS)/$(APP_NAME)
	cp Sources/App/Info.plist $(CONTENTS)/Info.plist
	cp Sources/App/Resources/port-killer.icns $(RESOURCES)/port-killer.icns
	# Copy resource bundle if it exists (for modern SwiftPM)
	cp -r $(BUILD_DIR)/PortKiller_App.bundle $(RESOURCES)/ 2>/dev/null || true
	codesign --force --deep -s - $(APP_BUNDLE)
	xattr -cr $(APP_BUNDLE)

icon:
	sips -s format png Sources/App/Resources/port-killer.icns --out Sources/App/Resources/port-killer.png


clean:
	rm -rf $(APP_BUNDLE)
	swift package clean
