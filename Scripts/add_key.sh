#!/bin/sh

# Decode certificate.
openssl aes-256-cbc -K $encrypted_36c4d457c02f_key -iv $encrypted_36c4d457c02f_iv -in ./Scripts/mac_developer_cert.p12.enc -out mac_developer_cert.p12 -d

# Create a custom keychain.
security create-keychain -p travis build.keychain

# Make the custom keychain default, so xcodebuild will use it for signing.
security default-keychain -s build.keychain

# Unlock the keychain
security unlock-keychain -p travis build.keychain

# Extend the timeout to 1200s
security set-keychain-settings -lut 1200
security show-keychain-info build.keychain

# Add certificates to keychain and allow codesign to access them.
security import ./Scripts/apple.cer -k build.keychain -A
security import mac_developer_cert.p12 -k build.keychain -P $CERT_PASS -A

security set-key-partition-list -S apple-tool:,apple: -s -k travis build.keychain
