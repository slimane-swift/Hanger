//
//  Hanger.swift
//  Hanger
//
//  Created by Yuki Takei on 5/2/16.
//
//

public struct Hanger {
    public init(request: Request, completion: (Void throws -> Response) -> Void) throws {
        var request = request
        let connection = try ClientConnection(request: request)
        
        try connection.open { [unowned connection] in
            do {
                try $0()
                try connection.send(request.buildRequest())
                
                let parser = ResponseParser()
                
                connection.receive {
                    do {
                        let data = try $0()
                        if let response = try parser.parse(data) {
                            completion {
                                try connection.close()
                                return response
                            }
                        }
                    } catch {
                        completion {
                            try connection.close()
                            throw error
                        }
                        
                    }
                }
            } catch {
                completion {
                    try connection.close()
                    throw error
                }
            }
        }
    }
}