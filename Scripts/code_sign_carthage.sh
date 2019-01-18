# Code signs the nested frameworks and XPC service.

SYLVESTER_ROOT_PATH="$SRCROOT/Carthage/Build/Mac/SylvesterXPC.framework/Versions/A"
SYLVESTER_XPC_PATH="$SYLVESTER_ROOT_PATH/XPCServices/SylvesterXPCService.xpc"
SYLVESTER_COMMON_PATH="$SYLVESTER_ROOT_PATH/Frameworks/SylvesterCommon.framework"

echo "Using Identity: '$CODE_SIGN_IDENTITY' ($EXPANDED_CODE_SIGN_IDENTITY)"

echo "Signing '$SYLVESTER_XPC_PATH'"
codesign --force --sign $EXPANDED_CODE_SIGN_IDENTITY --preserve-metadata=identifier,entitlements --timestamp=none "$SYLVESTER_XPC_PATH"

echo "Signing '$SYLVESTER_COMMON_PATH'"
codesign --force --sign $EXPANDED_CODE_SIGN_IDENTITY --preserve-metadata=identifier,entitlements --timestamp=none "$SYLVESTER_COMMON_PATH"
