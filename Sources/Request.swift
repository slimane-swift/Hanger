//
//  Request.swift
//  Hanger
//
//  Created by Yuki Takei on 5/2/16.
//
//

extension Request {
    mutating func buildRequest() throws -> Data {
        let CRLF = "\r\n"
        var requestData = "\(method) \(path ?? "/") HTTP/\(version.major).\(version.minor)\(CRLF)"
        
        if headers["Host"].first == nil {
            var host = uri.host!
            var port = uri.port ?? 80
            if port != 80 {
                host+=":\(port)"
            }
            headers["Host"] = Header(host)
        }
        
        if headers["Accept"].first == nil {
            headers["Accept"] = Header("*/*")
        }
        
        if headers["User-Agent"].first == nil {
            headers["User-Agent"] = Header("Hanger HTTP Client")
        }
        
        requestData += headers.filter({ _, v in v.first != nil }).map({ k, v in "\(k): \(v)" }).joined(separator: CRLF)
        
        let data = try body.becomeBuffer()
        
        requestData += CRLF + CRLF
        
        if !data.isEmpty {
            return requestData.data + data
        }
        
        return requestData.data
    }
}
