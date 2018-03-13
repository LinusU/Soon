.PHONY: run build debug clean

SOURCES := $(shell find Sources -name '*.swift')

Cartfile.resolved: Cartfile
	carthage update --cache-builds

Soon.xcodeproj: project.yml Cartfile.resolved
	mint run yonaskolb/xcodegen

build/Debug-iphoneos/Soon.app: Soon.xcodeproj $(SOURCES)
	xcodebuild -configuration Debug -arch arm64 -quiet

build: build/Debug-iphoneos/Soon.app

clean:
	rm -r build Carthage Soon.xcodeproj
	touch Cartfile

run: build/Debug-iphoneos/Soon.app
	ios-deploy --bundle build/Debug-iphoneos/Soon.app --justlaunch

debug: build/Debug-iphoneos/Soon.app
	ios-deploy --bundle build/Debug-iphoneos/Soon.app --debug
