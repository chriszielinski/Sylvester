Sylvester 😼
===========

<p align="center">
    <a href="https://github.com/Carthage/Carthage" style="text-decoration:none" target="_blank">
        <img alt="Carthage compatible" src ="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat"/>
    </a>
    <a href="https://cocoapods.org/pods/Sylvester" style="text-decoration:none" target="_blank">
        <img alt="Pod Version" src ="https://img.shields.io/cocoapods/v/Sylvester.svg?style=flat"/>
    </a>
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
	   <img alt="codebeat badge" src="https://codebeat.co/badges/94e83fa7-6299-4c3c-a364-5c3aa958cf8e" />
   </a>
	<a href="https://developer.apple.com/swift" style="text-decoration:none" target="_blank">
		<img alt="Swift Version" src ="https://img.shields.io/badge/language-swift%204.2-brightgreen.svg"/>
	</a>
	<a href="https://github.com/chriszielinski/Sylvester/blob/master/LICENSE" style="text-decoration:none" target="_blank">
		<img alt="GitHub license" src ="https://img.shields.io/badge/license-MIT-blue.svg"/>
	</a>
    <img alt="PRs Welcome" src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg" />
    <br>
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

- [x] Type-safe, no more dictionaries and `SourceKitRepresentable`s.
- [x] Optional XPC service, sandbox-friendly.
- [x] Subclassable interface.
- [x] Comprehensive test suite.


Requirements
============

- macOS 10.12+


Modules
=======

The `Sylvester` framework has two build configurations that differ in their method of communicating with `SourceKit`:

 - `Sylvester` — Communicates directly from within the embedding application or process. This module is not sandbox-friendly.
 - `SylvesterXPC` — Communicates through a XPC service. This module provides privilege separation, enhanced stability, and is sandbox-friendly.

 > 📌 **Note:** The XPC service itself cannot be sandboxed (due to inherent dependencies: xcrun, xcodebuild, sourcekitd), and requires an additional [code signing step](#code-signing).


Installation
============
`Sylvester` is available for installation using Carthage or CocoaPods.

Using [CocoaPods](http://cocoapods.org/)
----------------------------------------

> 🐞 **Bug:** Requires CocoaPods version >= _1.6.0_ (Current pre-release, _1.6.0.rc.2_)

> 📣 **Important:** The XPC service (and/or the `SylvesterXPC` module) is currently unavailable for CocoaPods installations.

```ruby
pod "Sylvester"
```

Using [Carthage](https://github.com/Carthage/Carthage)
------------------------------------------------------

```ruby
github "chriszielinski/Sylvester"
```


### Dependencies

`Sylvester`/`SylvesterXPC` depends on the following frameworks/libraries, so ensure they are also embedded in the _Embed Frameworks_ phase:

 - `SylvesterCommon.framework`
 - `SourceKittenFramework.framework`
 - `SWXMLHash.framework`
 - `Yams.framework`

 <p align="center">
     <img src="https://github.com/chriszielinski/Sylvester/blob/master/.readme-assets/embed-frameworks.png?raw=true" alt="Embed Frameworks Phase">
 </p>

 
### Code Signing

If you decide to use the `SylvesterXPC` module, you will need to add a _Run Script_ phase before embedding the _SylvesterXPC.framework_ (i.e. before the _Embed Frameworks_ phase). Ensure the shell launch path is `/bin/sh` (default). Then for Carthage installations, execute the `code_sign_carthage.sh` shell script in the repository's _Scripts_ directory.

```shell
"$SRCROOT/Carthage/Checkouts/Sylvester/Scripts/code_sign_carthage.sh"
```

<p align="center">
     <img src="https://github.com/chriszielinski/Sylvester/blob/master/.readme-assets/code-sign.png?raw=true" alt="Code Sign Phase">
 </p>

For other installations, modify the script's paths as neccessary.


Supported Requests
==================

| Request | Class |
| -------------:|:------------- |
| Code Completion | [`SKCodeCompletion`](https://chriszielinski.github.io/Sylvester/Classes/SKCodeCompletion.html) |
| Code Completion Session | [`SKCodeCompletionSession`](https://chriszielinski.github.io/Sylvester/Classes/SKCodeCompletionSession.html) |
| Documentation Info | [`SKDocInfo`](https://chriszielinski.github.io/Sylvester/Classes.html#/s:12SylvesterXPC9SKDocInfoC) |
| Editor Open | [`SKEditorOpen`](https://chriszielinski.github.io/Sylvester/Classes.html#/s:12SylvesterXPC12SKEditorOpenC) |
| Module Info | [`SKModule`](https://chriszielinski.github.io/Sylvester/Classes.html#/s:12SylvesterXPC8SKModuleC)|
| Swift Documentation | [`SKSwiftDocs`](https://chriszielinski.github.io/Sylvester/Classes.html#/s:12SylvesterXPC11SKSwiftDocsC) |
| Syntax Map | [`SKSyntaxMap`](https://chriszielinski.github.io/Sylvester/Classes/SKSyntaxMap.html) |
| Custom YAML | [`SKYAMLRequest`](https://chriszielinski.github.io/Sylvester/Classes/SKYAMLRequest.html) |


Other Fun Things
================

| Type | Method |
| -------------:|:------------- |
| XCRun | [`SylvesterInterface.shared.xcRun(arguments:)`](https://chriszielinski.github.io/Sylvester/Classes/SylvesterInterface.html#/s:12SylvesterXPC0A9InterfaceC5xcRun9argumentsSSSgSaySSG_tF) |
| XcodeBuild | [`SylvesterInterface.shared.xcodeBuild(arguments:currentDirectoryURL:)`](https://chriszielinski.github.io/Sylvester/Classes/SylvesterInterface.html#/s:12SylvesterXPC0A9InterfaceC10xcodeBuild9arguments19currentDirectoryURLSSSgSaySSG_10Foundation0I0VtF) |
| Bash Command | [`SylvesterInterface.shared.executeBash(command:currentDirectoryURL:)`](https://chriszielinski.github.io/Sylvester/Classes/SylvesterInterface.html#/s:12SylvesterXPC0A9InterfaceC11executeBash7command19currentDirectoryURLSSSgSS_10Foundation0I0VSgtF) |
| Launch Subprocess | [`SylvesterInterface.shared.launch(subprocess:)`](https://chriszielinski.github.io/Sylvester/Classes/SylvesterInterface.html#/s:12SylvesterXPC0A9InterfaceC6launch10subprocessSSSg0A6Common12SKSubprocessV_tKF) |


Subclassing
===========

Most of the standard requests are concrete subclasses of  ~~beautiful~~ generic classes. Fancy your own subclass? No problem, it _might_ be possible. 


`SKSubstructure`, `SKEntity`
----------------------------

Also known as `SKBaseSubstructure` (or `SKBaseEntity`), a common culprit. 

> 📌 **Note:** Subclassing `SKBaseEntity` uses similar syntax.

```swift
final class BetterSubstructureSubclass: SKBaseSubstructure, SKFinalSubclass {

    var iAmAnImportantProperty: String = "🚶‍♂️"

    public override func decodeChildren(from container: DecodingContainer) throws -> [SKBaseSubstructure]? {
        return try decodeChildren(BetterSubstructureSubclass.self, from: container)
    }

    /// The default iterator for `SKChildren` does a pre-order (NLR) depth-first search (DFS) traversal; however, if you want something else, for instance:
    class FunctionSubstructureIterator<Substructure: BetterSubstructureSubclass>: SKPreOrderDFSIterator<Substructure> {

        override func next() -> Substructure? {
            guard let nextSubstructure = super.next()
                else { return nil }

            if nextSubstructure.isFunction {
                return nextSubstructure
            } else {
                return next()
            }
        }

    }

    override class func iteratorClass<Substructure: BetterSubstructureSubclass>() -> SKPreOrderDFSIterator<Substructure>.Type {
        return FunctionSubstructureIterator.self
    }

}
```


`SKEditorOpen`, `SKSwiftDocs`
-----------------------------

An example of a `SKSwiftDocs` subclass utilizing the `BetterSubstructureSubclass` declared above:

> 📌 **Note:** Subclassing `SKEditorOpen` uses identical syntax, except it inherits from `SKGenericEditorOpen`.

```swift
class BetterSwiftDocs: SKGenericSwiftDocs<BetterSubstructureSubclass> {

    var mySuperCoolProperty: String = "😎"

}
```


`SKModule`
----------

An example of a `SKModule` subclass utilizing the `BetterSwiftDocs` and `BetterSubstructureSubclass` classes declared above:

```swift
class BetterModule: SKGenericModule<BetterSubstructureSubclass, BetterSwiftDocs> {}
```


Documentation
=============

You can explore the docs [here](http://chriszielinski.github.io/Sylvester/).


// ToDo:
========

- [ ] Add support for other requests.


Community
=========

- Found a bug? Open an [issue](https://github.com/chriszielinski/sylvester/issues).
- Feature idea? ~~Open an [issue](https://github.com/chriszielinski/sylvester/issues).~~ Do it yourself & PR when done 😅 (or you can open an issue 🙄).
- Want to contribute? Submit a [pull request](https://github.com/chriszielinski/sylvester/pulls).


Contributors
============

- [Chris Zielinski](https://github.com/chriszielinski) — Original author.


Frameworks & Libraries
======================

`Sylvester` depends on the wonderful contributions of the Swift community, namely:

* **[jpsim/SourceKitten](https://github.com/jpsim/SourceKitten)** — An adorable little framework and command line tool for interacting with SourceKit.
* **[macmade/AtomicKit](https://github.com/macmade/AtomicKit)** — Concurrency made simple in Swift.
* **[groue/GRMustache.swift](https://github.com/groue/GRMustache.swift)** — Flexible Mustache templates for Swift.
* **[realm/jazzy](https://github.com/realm/jazzy)** — Soulful docs for Swift & Objective-C.
* **[realm/SwiftLint](https://github.com/realm/SwiftLint)** — A tool to enforce Swift style and conventions.


License
=======

`Sylvester` is available under the MIT license, see the [LICENSE](https://github.com/chriszielinski/sylvester/blob/master/LICENSE) file for more information.