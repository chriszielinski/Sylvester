Sylvester 😼
===========

<p align="center">
    <a href="https://travis-ci.org/chriszielinski/Sylvester" style="text-decoration:none" target="_blank">
		<img src="https://travis-ci.org/chriszielinski/Sylvester.svg?branch=master">
	</a>
	<a href="https://sonarcloud.io/dashboard?id=chriszielinski_Sylvester" style="text-decoration:none" target="_blank">
		<img src="https://sonarcloud.io/api/project_badges/measure?project=chriszielinski_Sylvester&metric=alert_status">
	</a>
	<a href="https://sonarcloud.io/component_measures?id=chriszielinski_Sylvester&metric=Coverage" style="text-decoration:none" target="_blank">
	  <img src="https://sonarcloud.io/api/project_badges/measure?project=chriszielinski_Sylvester&metric=coverage">
	</a>
	<a href="https://codebeat.co/projects/github-com-chriszielinski-sylvester-master" style="text-decoration:none" target="_blank">
		<img alt="codebeat badge" src="https://codebeat.co/badges/66095cd2-8a09-4662-a31d-d8f7a0e86f3f"/>
	</a>
	<a href="https://developer.apple.com/swift" style="text-decoration:none" target="_blank">
		<img alt="Swift Version" src ="https://img.shields.io/badge/language-swift%204.2-brightgreen.svg"/>
	</a>
	<a href="https://github.com/chriszielinski/Sylvester/blob/master/LICENSE" style="text-decoration:none" target="_blank">
		<img alt="GitHub license" src ="https://img.shields.io/badge/license-MIT-blue.svg"/>
	</a>
    <img alt="PRs Welcome" src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg" />
    <br>
    <img src="https://github.com/chriszielinski/Sylvester/blob/master/.readme-assets/header.png?raw=true" alt="Header">
    <br>
    <br>
    <b>A type-safe, XPC-available <a href="https://github.com/jpsim/SourceKitten"> SourceKitten</a> (SourceKit) interface with some sugar.</b>
    <br>
</p>

---

### Looking for...

- A Floating Action Button for macOS? Check out [Fab.](https://github.com/chriszielinski/Fab) 🛍️.
- An Expanding Bubble Text Field for macOS? Check out [BubbleTextField](https://github.com/chriszielinski/BubbleTextField) 💬.
- An integrated spotlight-based onboarding and help library for macOS? Check out [Enlighten](https://github.com/chriszielinski/Enlighten) 💡.


Features
========

- [x] Type-safe, no more `SourceKitRepresentable`.
- [x] Optional XPC service, sandbox-friendly.
- [x] Subclassable interface.
- [x] Comprehensive test suite.


Installation
============
`Sylvester` is available for installation using ~~CocoaPods~~ or Carthage.


### Using [Carthage](https://github.com/Carthage/Carthage)

```ruby
github "chriszielinski/Sylvester"
```

### ~~Using [CocoaPods](http://cocoapods.org/)~~

```ruby
pod "Sylvester"
```

Requirements
============

- macOS 10.12+


Modules
=======

The `Sylvester` framework has two build configurations that differ in their communications with `SourceKit`:

 - `Sylvester` — Communicates directly from within the embedding application or process. This module is not sandbox-friendly.
 - `SylvesterXPC` — Communicates through a XPC service. This module provides privilege separation, enhanced stability, and is sandbox-friendly.

 > 📌 **Note:** The XPC service itself cannot be sandboxed (due to inherent dependencies: xcrun, xcodebuild, sourcekitd), and requires an additional code signing step.


# Supported Requests

| Request | Class |
| -------------:|:------------- |
| Code Completion | [`SKCodeCompletion`](https://chriszielinski.github.io/Sylvester/Classes/SKCodeCompletion.html) |
| Code Completion Session | [`SKCodeCompletionSession`](https://chriszielinski.github.io/Sylvester/Classes/SKCodeCompletionSession.html) |
| Module Info | [`SKModule`](https://chriszielinski.github.io/Sylvester/Classes.html#/s:9Sylvester8SKModuleC)|
| Editor Open | [`SKEditorOpen`](https://chriszielinski.github.io/Sylvester/Classes/SKEditorOpen.html) |
| Swift Documentation | [`SKSwiftDocs`](https://chriszielinski.github.io/Sylvester/Classes/SKSwiftDocs.html) |
| Syntax Map | [`SKSyntaxMap`](https://chriszielinski.github.io/Sylvester/Classes/SKSyntaxMap.html) |
| Custom YAML | [`SKYAMLRequest`](https://chriszielinski.github.io/Sylvester/Classes/SKYAMLRequest.html) |


# Other Fun Things

| Type | Class |
| -------------:|:------------- |
| XCRun | [`SourceKittenInterface.shared.xcRun(arguments:)`](https://chriszielinski.github.io/Sylvester/Classes/SourceKittenInterface.html#/s:9Sylvester21SourceKittenInterfaceC5xcRun9argumentsSSSgSaySSG_tF) |
| XcodeBuild | [`SourceKittenInterface.shared.xcodeBuild(arguments:currentDirectoryPath:)`](https://chriszielinski.github.io/Sylvester/Classes/SourceKittenInterface.html#/s:9Sylvester21SourceKittenInterfaceC10xcodeBuild9arguments20currentDirectoryPathSSSgSaySSG_SStF) |
| Bash Command | [`SourceKittenInterface.shared.executeBash(command:currentDirectoryPath:)`](https://chriszielinski.github.io/Sylvester/Classes/SourceKittenInterface.html#/s:9Sylvester21SourceKittenInterfaceC11executeBash7command20currentDirectoryPathSSSgSS_AGtF) |
| Shell Command | [`SourceKittenInterface.shared.executeShell(launchPath:arguments:currentDirectoryPath:shouldPipeStandardError:)`](https://chriszielinski.github.io/Sylvester/Classes/SourceKittenInterface.html#/s:9Sylvester21SourceKittenInterfaceC12executeShell10launchPath9arguments016currentDirectoryH023shouldPipeStandardErrorSSSgSS_SaySSGAISbtF) |