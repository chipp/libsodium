.PHONY: clean build

RESULT_PATH=build/Build/Products
FRAMEWORK=libsodium

clean: 
	rm -rf "build"

build: clean
	xcodebuild -scheme libsodium -project libsodium.xcodeproj -configuration ReleasePhone -derivedDataPath "build" -sdk "iphoneos" build | bundle exec xcpretty
	xcodebuild -scheme libsodium -project libsodium.xcodeproj -configuration ReleaseSimulator -derivedDataPath "build" -sdk "iphonesimulator" build | bundle exec xcpretty
	rsync -rtvu --delete "$(RESULT_PATH)/ReleasePhone-iphoneos/$(FRAMEWORK).framework/" "build/$(FRAMEWORK).framework/"
	lipo -create -output "build/$(FRAMEWORK).framework/$(FRAMEWORK)" "$(RESULT_PATH)/ReleasePhone-iphoneos/$(FRAMEWORK).framework/$(FRAMEWORK)" "$(RESULT_PATH)/ReleaseSimulator-iphonesimulator/$(FRAMEWORK).framework/$(FRAMEWORK)"
	rsync -av build/$(FRAMEWORK).framework release
