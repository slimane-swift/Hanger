//
//  Hanger.swift
//  Hanger
//
//  Created by Yuki Takei on 5/2/16.
//
//

@_exported import C7
@_exported import S4
@_exported import HTTP
@_exported import HTTPParser
@_exported import URI
@_exported import Suv
@_exported import CLibUv

public enum ClientConnectionState {
    case Disconnected
    case Connected
    case Closed
}

public final class ClientConnection: AsyncConnection {
    var _stream: TCP?
    
    var stream: TCP {
        return _stream!
    }
    
    public private(set) var state: ClientConnectionState = .Disconnected
    
    public let host: String
    
    public let port: Int
    
    public init(loop: Loop = Loop.defaultLoop, host: String, port: Int? = nil) {
        self._stream = TCP(loop: loop)
        self.host = host
        self.port = port ?? 80
    }

    public var closed: Bool {
        return stream.isClosing()
    }
    
    public func open(timingOut deadline: Double = .never, completion: (Void throws -> AsyncConnection) -> Void) throws {
        stream.connect(host: host, port: port) {
            if case .Error(let error) = $0 {
                completion {
                    throw error
                }
                return
            }
            
            self.state = .Connected
            completion {
                self
            }
        }
    }
    
    public func send(_ data: Data, timingOut deadline: Double = .never, completion result: (Void throws -> Void) -> Void = { _ in}) {
        stream.write(buffer: data.bufferd) { res in
            result {
                if case .Error(let error) = res {
                    throw error
                }
            }
        }
    }
    
    public func receive(upTo byteCount: Int = 2048 /* ignored */, timingOut deadline: Double = .never, completion result: (Void throws -> Data) -> Void) {
        stream.read { res in
            if case .Data(let buf) = res {
                result {
                    buf.data
                }
            } else if case .Error(let error) = res {
                result {
                    throw error
                }
            } else {
                result {
                    throw SuvError.UVError(code: UV_EOF.rawValue)
                }
            }
        }
    }
    
    public func close() throws {
        if closed {
            throw StreamError.closedStream(data: [])
        }
        stream.close()
        self._stream = nil
        self.state = .Closed
    }
    
    public func unref() {
        stream.unref()
    }
    
    public func flush(timingOut deadline: Double, completion result: (Void throws -> Void) -> Void = {_ in }) {
        // noop
    }
}