.PHONY: run build debug

SOURCES := $(shell find Sources -name '*.swift')

Soon.xcodeproj: project.yml
	mint run yonaskolb/xcodegen

build/Debug-iphoneos/Soon.app: Soon.xcodeproj $(SOURCES)
	xcodebuild -configuration Debug -arch arm64 -quiet

build: build/Debug-iphoneos/Soon.app

run: build/Debug-iphoneos/Soon.app
	ios-deploy --bundle build/Debug-iphoneos/Soon.app --justlaunch

debug: build/Debug-iphoneos/Soon.app
	ios-deploy --bundle build/Debug-iphoneos/Soon.app --debug
