//
//  Data.swift
//  Hanger
//
//  Created by Yuki Takei on 5/2/16.
//
//

extension Buffer {
    var data: Data {
        return Data(self.bytes)
    }
}

extension Data {
    var signedBytes: [Int8] {
        return self.bytes.map { Int8(bitPattern: $0) }
    }
    
    var bufferd: Buffer {
        return Buffer(bytes: self.bytes)
    }
}

