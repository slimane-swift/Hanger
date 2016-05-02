//
//  Response.swift
//  Hanger
//
//  Created by Yuki Takei on 5/2/16.
//
//

extension Response {
    var bodyData: Data {
        switch body {
        case .buffer(let data):
            return data
        default:
            return []
        }
    }
}
