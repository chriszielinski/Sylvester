XCODEFLAGS=-project Sylvester.xcodeproj \
	-destination 'platform=macOS'
TRAVIS_ENV_VARIABLES=TEST_FIXTURES_PATH=`pwd`/Tests/Fixtures
BUILD_SETTINGS='SWIFT_ACTIVE_COMPILATION_CONDITIONS=XCODEBUILD'
XPC_BUILD_SETTINGS='SWIFT_ACTIVE_COMPILATION_CONDITIONS=XPC XCODEBUILD'
TRAVIS_BUILD_SETTINGS='SWIFT_ACTIVE_COMPILATION_CONDITIONS=XCODEBUILD TRAVIS'
TRAVIS_XPC_BUILD_SETTINGS='SWIFT_ACTIVE_COMPILATION_CONDITIONS=XPC XCODEBUILD TRAVIS'
MAKE_PRETTY=| xcpretty && exit ${PIPESTATUS[0]}
MAKE_PRETTY_FOR_TRAVIS=| xcpretty -f `xcpretty-travis-formatter` && exit ${PIPESTATUS[0]}

.PHONY: all travis travis-pr carthage build build-normal build-xpc build-sandbox travis-build-pr travis-build travis-build-normal travis-build-xpc travis-build-sandbox test test-normal test-xpc test-sandbox travis-test-pr travis-test travis-test-normal travis-test-xpc travis-test-sandbox generate-boilerplate swiftlint jazzy convert-xccov-to-sonarqube clean


###################
##### General #####
###################

all: carthage build
travis: carthage travis-build
travis-pr: carthage travis-build-pr


####################
##### Carthage #####
####################

carthage:
	carthage update --platform macOS


#################
##### Build #####
#################

build: build-normal build-xpc build-sandbox

build-normal:
	xcodebuild $(XCODEFLAGS) -scheme Sylvester $(MAKE_PRETTY)

build-xpc:
	xcodebuild $(XCODEFLAGS) -scheme SylvesterXPC $(MAKE_PRETTY)

build-sandbox:
	xcodebuild $(XCODEFLAGS) -scheme Sandbox $(MAKE_PRETTY)


########################
##### Travis Build #####
########################

travis-build-pr: travis-build-normal travis-build-xpc
travis-build: travis-build-pr travis-build-sandbox

travis-build-normal:
	xcodebuild $(XCODEFLAGS) -scheme Sylvester $(MAKE_PRETTY_FOR_TRAVIS)

travis-build-xpc:
	xcodebuild $(XCODEFLAGS) -scheme SylvesterXPC $(MAKE_PRETTY_FOR_TRAVIS)

travis-build-sandbox:
	xcodebuild $(XCODEFLAGS) -scheme Sandbox $(MAKE_PRETTY_FOR_TRAVIS)


################
##### Test #####
################

test: test-normal test-xpc test-sandbox

test-normal:
	xcodebuild test $(XCODEFLAGS) -scheme Sylvester $(BUILD_SETTINGS) $(MAKE_PRETTY)

test-xpc:
	xcodebuild test $(XCODEFLAGS) -scheme SylvesterXPC $(XPC_BUILD_SETTINGS) $(MAKE_PRETTY)

test-sandbox:
	xcodebuild test $(XCODEFLAGS) -scheme Sandbox $(XPC_BUILD_SETTINGS) $(MAKE_PRETTY)


#######################
##### Travis Test #####
#######################

travis-test-pr: clean travis-test-normal travis-test-xpc convert-xccov-to-sonarqube
travis-test: travis-test-pr travis-test-sandbox

travis-test-normal:
	xcodebuild test $(XCODEFLAGS) -scheme Sylvester -configuration Debug $(TRAVIS_BUILD_SETTINGS) $(MAKE_PRETTY_FOR_TRAVIS)

travis-test-xpc:
	xcodebuild test $(XCODEFLAGS) -scheme SylvesterXPC -configuration Debug -resultBundlePath .test-results $(TRAVIS_XPC_BUILD_SETTINGS) $(MAKE_PRETTY_FOR_TRAVIS)

travis-test-sandbox:
	$(TRAVIS_ENV_VARIABLES) xcodebuild test $(XCODEFLAGS) -scheme Sandbox $(TRAVIS_XPC_BUILD_SETTINGS) $(MAKE_PRETTY_FOR_TRAVIS)


#################
##### Other #####
#################

generate-boilerplate:
	cd Source/Enumerations/Generated; \
	./GenerateBoilerplate.swift

swiftlint:
	swiftlint lint --reporter json > .test-results/swiftlint.json

jazzy:
	jazzy --clean --xcodebuild-arguments -scheme,SylvesterXPC
	jazzy --xcodebuild-arguments -scheme,SylvesterCommon,-configuration,Debug --output docs/SylvesterCommon
	./Scripts/generate_docs.swift `pwd`/docs

convert-xccov-to-sonarqube:
	./Scripts/xccov_to_sonarqube_generic.sh .test-results/1_Test/action.xccovarchive/ > .test-results/sonarqube-generic-coverage.xml

clean:
	rm -rf ./.test-results