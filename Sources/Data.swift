//
//  Data.swift
//  Hanger
//
//  Created by Yuki Takei on 5/2/16.
//
//

extension Buffer {
    public var data: Data {
        return Data(self.bytes)
    }
}

extension Data {
    public var signedBytes: [Int8] {
        return self.bytes.map { Int8(bitPattern: $0) }
    }
    
    public var bufferd: Buffer {
        return Buffer(bytes: self.bytes)
    }
}

