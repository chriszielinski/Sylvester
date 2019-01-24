# Build `SylvesterCommon` using inherited configuration settings.
# This is necessary for Carthage-compatibility.

xcodebuild \
    -project "$SRCROOT/Sylvester.xcodeproj" \
    -target "SylvesterCommon" \
    -configuration "$CONFIGURATION" \
    -sdk "${SDK_NAME}" \
    BUILD_DIR="${BUILD_DIR}" \
    BUILD_ROOT="${BUILD_ROOT}" \
    CONFIGURATION_BUILD_DIR="${CONFIGURATION_BUILD_DIR}" \
    SYMROOT="${SYMROOT}" \
    SWIFT_ACTIVE_COMPILATION_CONDITIONS="$SWIFT_ACTIVE_COMPILATION_CONDITIONS" \
    LD_RUNPATH_SEARCH_PATHS="$LD_RUNPATH_SEARCH_PATHS"

if [ "$CONFIGURATION" == "Debug" ]
then
    xcodebuild \
        -project "$SRCROOT/Sylvester.xcodeproj" \
        -target "SylvesterXPCService" \
        -configuration "$CONFIGURATION" \
        -sdk "${SDK_NAME}" \
        BUILD_DIR="${BUILD_DIR}" \
        BUILD_ROOT="${BUILD_ROOT}" \
        CONFIGURATION_BUILD_DIR="${CONFIGURATION_BUILD_DIR}" \
        SYMROOT="${SYMROOT}" \
        SWIFT_ACTIVE_COMPILATION_CONDITIONS="$SWIFT_ACTIVE_COMPILATION_CONDITIONS" \
        LD_RUNPATH_SEARCH_PATHS="$LD_RUNPATH_SEARCH_PATHS"
else
    xcodebuild \
        -project "$SRCROOT/Sylvester.xcodeproj" \
        -target "SylvesterXPCService" \
        -configuration "$CONFIGURATION" \
        -sdk "${SDK_NAME}" \
        BUILD_DIR="${BUILD_DIR}" \
        BUILD_ROOT="${BUILD_ROOT}" \
        CONFIGURATION_BUILD_DIR="${CONFIGURATION_BUILD_DIR}" \
        SYMROOT="${SYMROOT}" \
        SWIFT_ACTIVE_COMPILATION_CONDITIONS="$SWIFT_ACTIVE_COMPILATION_CONDITIONS"
fi
