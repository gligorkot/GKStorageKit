# GKStorageKit

[![CI](https://github.com/gligorkot/GKStorageKit/actions/workflows/ci.yml/badge.svg)](https://github.com/gligorkot/GKStorageKit/actions/workflows/ci.yml)

Storage package adding default implementations for three types of storages:

1. File storage - defaults to the document directory for the app
1. Object storage - defaults to user defaults
1. Secure storage - defaults to keychain with "when unlocked" accessibility

All of the storage implementations use protocols so they can easily be overwritten by conforming to the protocols within the package.

Supports Swift Package Manager and Cocoapods.

## Installation instructions

### Swift Package Manager

Add one the following to the `dependencies` array in your "Package.swift" file:

- If using http add:

```swift
.package(url: "https://github.com/gligorkot/GKStorageKit.git", from: Version("2.0.0"))
```

- If using ssh add:

```swift
.package(url: "git@github.com:gligorkot/GKStorageKit.git", from: Version("2.0.0"))
```

Or by adding `https://github.com/gligorkot/GKStorageKit.git`, version 2.0.0 or later, to the list of Swift packages for any project in Xcode.

### CocoaPods

Add the following to your "Podfile":

```ruby
pod 'GKStorageKit', '~> 2.x'
```
