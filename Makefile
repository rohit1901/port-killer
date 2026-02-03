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
	make icon

icon:
	mkdir -p $(ICONSET)
	sips -z 16 16     $(SOURCE_ICON) --setProperty format png --out $(ICONSET)/icon_16x16.png
	sips -z 32 32     $(SOURCE_ICON) --setProperty format png --out $(ICONSET)/icon_16x16@2x.png
	sips -z 32 32     $(SOURCE_ICON) --setProperty format png --out $(ICONSET)/icon_32x32.png
	sips -z 64 64     $(SOURCE_ICON) --setProperty format png --out $(ICONSET)/icon_32x32@2x.png
	sips -z 128 128   $(SOURCE_ICON) --setProperty format png --out $(ICONSET)/icon_128x128.png
	sips -z 256 256   $(SOURCE_ICON) --setProperty format png --out $(ICONSET)/icon_128x128@2x.png
	sips -z 256 256   $(SOURCE_ICON) --setProperty format png --out $(ICONSET)/icon_256x256.png
	sips -z 512 512   $(SOURCE_ICON) --setProperty format png --out $(ICONSET)/icon_256x256@2x.png
	sips -z 512 512   $(SOURCE_ICON) --setProperty format png --out $(ICONSET)/icon_512x512.png
	sips -z 1024 1024 $(SOURCE_ICON) --setProperty format png --out $(ICONSET)/icon_512x512@2x.png
	iconutil -c icns $(ICONSET)
	cp $(APP_NAME).icns $(RESOURCES)/AppIcon.icns
	
	# Generate Menu Bar Icon
	sips -z 22 22 $(SOURCE_ICON) --setProperty format png --out $(RESOURCES)/MenuBarIcon.png
	sips -z 44 44 $(SOURCE_ICON) --setProperty format png --out $(RESOURCES)/MenuBarIcon@2x.png
	
	rm -rf $(ICONSET) $(APP_NAME).icns
	codesign --force --deep -s - $(APP_BUNDLE)
	xattr -cr $(APP_BUNDLE)

clean:
	rm -rf $(APP_BUNDLE)
	swift package clean
