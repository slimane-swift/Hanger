//
//  Hanger.swift
//  Hanger
//
//  Created by Yuki Takei on 5/2/16.
//
//


public struct Hanger {

    public init(connection: ClientConnection, request: Request, completion: ((Void) throws -> Response) -> Void) throws {
        if case .Closed = connection.state {
            throw StreamError.closedStream(data: [])
        }
        
        if case .Disconnected = connection.state {
            let connection = ClientConnection(uri: request.uri)
            
            try connection.open {
                do {
                    try $0()
                    try writeRequest(connection: connection, request: request, completion: completion)
                } catch {
                    completion {
                        try connection.close()
                        throw error
                    }
                }
            }
        } else {
            try writeRequest(connection: connection, request: request, completion: completion)
        }
    }
    
    public init(request: Request, completion: ((Void) throws -> Response) -> Void) throws {
        let connection = ClientConnection(uri: request.uri)
        
        try connection.open {
            do {
                try $0()
                try writeRequest(connection: connection, request: request, forceClose: true, completion: completion)
            } catch {
                completion {
                    try connection.close()
                    throw error
                }
            }
        }
    }
}

private func writeRequest(connection: ClientConnection, request: Request, forceClose: Bool = false, completion: ((Void) throws -> Response) -> Void) throws {
    var request = request
    try connection.send(request.serialize())
    
    let parser = ResponseParser()
    
    connection.receive { [unowned connection] in
        do {
            let data = try $0()
            if let response = try parser.parse(data) {
                completion {
                    try closeConnection(shouldClose: forceClose || !request.isKeepAlive, connection: connection)
                    return response
                }
            }
        } catch {
            completion {
                try closeConnection(shouldClose: forceClose || !request.isKeepAlive, connection: connection)
                throw error
            }
        }
    }
}

private func closeConnection(shouldClose: Bool, connection: ClientConnection) throws {
    if shouldClose {
        try connection.close()
    } else {
        connection.unref()
    }
}