# Hanger
A HTTP Client for Swift


## Usage
```swift
var request = Request(method: .get, uri: URI(scheme: "http", host: "miketokyo.com"))

try! _ = Hanger(request: request) {
    let response = try! $0()
    print(response)
    print(response.bodyData.description)
}

Loop.defaultLoop.run()
```

## Streaming Example
Getting Ready


## Package.swift
```swift
import PackageDescription

let package = Package(
    name: "MyApp",
    dependencies: [
        .Package(url: "https://github.com/slimane-swift/Hanger.git", majorVersion: 0, minor: 1)
    ]
)
```

## Licence

Hanger is released under the MIT license. See LICENSE for details.
