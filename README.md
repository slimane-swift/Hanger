# Hanger
A HTTP Client for Swift


## Getting Started
### Ubuntu

```sh
# Install build tools and libssl-dev
sudo apt-get upgrade
sudo apt-get install build-essential libtool libssl-dev
sudo apt-get install automake clang

# build and install libuv
git clone https://github.com/libuv/libuv.git && cd libuv
sh autogen.sh
./configure
make
make install
```

### Mac OS X

#### brew

```sh
brew install libuv
brew link libuv --force
```

And then, add
```swift
.Package(url: "https://github.com/slimane-swift/Hanger.git", majorVersion: 0, minor: 1)
```
in to your Package.swift


## Usage
```swift
import Hanger

let request = Request(method: .get, uri: URI(scheme: "http", host: "miketokyo.com"))

try! _ = Hanger(request: request) {
    let response = try! $0()
    print(response)
}

// Once need to run uv_loop
// But if you use Hanger in a Slimane/Skelton Project doesn't need here.
Loop.defaultLoop.run()
```

## Reusable Connection
You can reuse connection for the host to pass `ClientConnection` instance to the initializer.

Note: You need to manage connection life time on your own.
The `ClientConnection` should be released/closed with `close` method.

Here is an example.


```swift
import Hanger

// Make a request with Connection: Keep-Alive header
let request = Request(method: .get, uri: URI(scheme: "http", host: "miketokyo.com", headers: ["Connection": "Keep-Alive"]))

// Initialize a connection
let con = ClientConnection(uri: request.uri)

try! _ = Hanger(connection: con, request: request) {
    let response = try! $0()
    print(response)
}

try! _ = Hanger(connection: con, request: request) {
    let response = try! $0()
    print(response)
}

let t = Timer(tick: 1000)
t.start {
  t.end()
  con.close() // Close connection
}

Loop.defaultLoop.run()
```

## Streaming Request with Raw Connection
Getting Ready


# API Reference

## ClientConnection

#### Public Members
---

* closed: Bool
* host: String
* port: Int

#### Public Methods
---

##### initializer
`init(loop: Loop = Loop.defaultLoop, uri: URI)`

##### open
`func(timingOut deadline: Double = .never, completion: (Void throws -> AsyncConnection) -> Void) throws`

Open a connection for the host

##### send
`func send(_ data: Data, timingOut deadline: Double = .never, completion result: (Void throws -> Void) -> Void = { _ in})`

Send data to the Stream


##### receive
`func receive(upTo byteCount: Int = 2048 /* ignored */, timingOut deadline: Double = .never, completion result: (Void throws -> Data) -> Void)`

Receive data from the Stream


##### close
`func close() throws`

Close the Stream handle

## Hanger

#### Public Methods
---

##### initializer
`init(connection: ClientConnection, request: Request, completion: (Void throws -> Response) -> Void) throws`


##### initializer
`init(request: Request, completion: (Void throws -> Response) -> Void) throws`

## Request
Request is Open-swift's S4.Request

Visit https://github.com/open-swift/S4 for more detail

## Response
Response is Open-swift's S4.Response

Visit https://github.com/open-swift/S4 for more detail


## Package.swift
```swift
import PackageDescription

let package = Package(
    name: "MyApp",
    dependencies: [
        .Package(url: "https://github.com/slimane-swift/Hanger.git", majorVersion: 0, minor: 2)
    ]
)
```

## Licence

Hanger is released under the MIT license. See LICENSE for details.
