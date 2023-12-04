# swift-property-name

[![Build](https://github.com/CuriositySoftware/swift-property-name/actions/workflows/build-and-test.yml/badge.svg)](https://github.com/CuriositySoftware/swift-property-name/actions/workflows/build-and-test.yml)
![Swift Package Manager](https://img.shields.io/badge/swift%20package%20manager-compatible-brightgreen.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

This Swift macro simplifies the process of obtaining property names as strings in Swift. By annotating a struct or class with `@PropertyNameAccessible`, it automatically generates extensions and methods that provide access to property names as strings.

## Quick start

To get started, import: `import PropertyName`, annotate your struct or class  with `@PropertyNameAccessible`:

```swift
import PropertyName

@PropertyNameAccessible
struct Person {
    let name: String
    let age: Int
    let email: String
    let isEmployee: Bool
}
```

This will automatically generate an extension with a `propertyName(for:)` function.

```swift
extension Person {
    static func propertyName(for keyPath: PartialKeyPath<Self>) -> String {
        switch keyPath {
        case \.name:
            return "name"
        case \.age:
            return "age"
　　　　　case \.email:
            return "email"
        case \.isEmployee:
            return "isEmployee"
        default:
            fatalError()
        }
    }
}
```

Usage examples are as follows:

```swift
print(Person.propertyName(for: \.name)) // => "name"
print(Person.propertyName(for: \.age)) // => "age"
print(Person.propertyName(for: \.email)) // => "email"
print(Person.propertyName(for: \.isEmployee)) // => "isEmployee"
```

## Installation

### For Xcode

If you are using [GUI to set up Package Dependencies in Xcode](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app), add the URL in Package Dependencies.

```
https://github.com/CuriositySoftware/swift-property-name
```

### For Package.swift

If you are using Package.swift add:

```swift
.package(
    url: "https://github.com/CuriositySoftware/swift-property-name/",
    .upToNextMajor(from: "0.1.0")
)
```

and then add the product to any target that needs access to the macro:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(
            name: "PropertyName",
            package: "swift-property-name"
        )
    ]
)
```

