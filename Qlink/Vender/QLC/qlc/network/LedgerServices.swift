//
//  LedgerServices.swift
//  TestJsonRPC
//
//  Created by Jelly Foo on 2019/5/29.
//  Copyright © 2019 Jelly Foo. All rights reserved.
//

import Foundation
import APIKit
import JSONRPCKit

struct LedgerServiceRequest<Batch: JSONRPCKit.Batch>: APIKit.Request {
    let batch: Batch
    
    typealias Response = Batch.Responses
    
    var baseURL: URL {
        return URL(string: qlc_seed)!
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var path: String {
        return "/"
    }
    
    var parameters: Any? {
        return batch.requestObject
    }
    
    public func intercept(urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        urlRequest.timeoutInterval = timeoutInterval
        return urlRequest
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try batch.responses(from: object)
    }
}

struct CastError<ExpectedType>: Error {
    let actualValue: Any
    let expectedType: ExpectedType.Type
}

struct AccountInfo: JSONRPCKit.Request {
    typealias Response = [String:Any]
    
    let address: String
    
    var method: String {
        return "ledger_accountInfo"
    }
    
    var parameters: Any? {
        return [address]
    }
    
    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? Response {
            return response
        } else {
            throw CastError(actualValue: resultObject, expectedType: Response.self)
        }
    }
}

struct AccountHistoryTopn: JSONRPCKit.Request {
    typealias Response = [Any]
    
    let address: String
    
    var method: String {
        return "ledger_accountHistoryTopn"
    }
    
    var parameters: Any? {
        return [address,20,0]
    }
    
    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? Response {
            return response
        } else {
            throw CastError(actualValue: resultObject, expectedType: Response.self)
        }
    }
}

struct TokenInfoByName: JSONRPCKit.Request {
    typealias Response = [String: Any]
    
    let token: String
    
    var method: String {
        return "ledger_tokenInfoByName"
    }
    
    var parameters: Any? {
        return [token]
    }
    
    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? Response {
            return response
        } else {
            throw CastError(actualValue: resultObject, expectedType: Response.self)
        }
    }
}

struct BlocksInfo: JSONRPCKit.Request {
    typealias Response = [Any]
    
    let hashArr: Array<String>
    
    var method: String {
        return "ledger_blocksInfo"
    }
    
    var parameters: Any? {
        return [hashArr]
    }
    
    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? Response {
            return response
        } else {
            throw CastError(actualValue: resultObject, expectedType: Response.self)
        }
    }
}

struct AccountsPending: JSONRPCKit.Request {
    typealias Response = [String: Any]
    
    let addressArr: Array<String>
//    let address : String
    
    var method: String {
        return "ledger_accountsPending"
    }
    
    var parameters: Any? {
        return [addressArr, -1]
//        return [[address], -1]
    }
    
    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? Response {
            return response
        } else {
            throw CastError(actualValue: resultObject, expectedType: Response.self)
        }
    }
}

struct Process: JSONRPCKit.Request {
    typealias Response = String
    
    let dic: Dictionary<String, Any>
    
    var method: String {
        return "ledger_process"
    }
    
    var parameters: Any? {
        return [dic]
    }
    
    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? Response {
            return response
        } else {
            throw CastError(actualValue: resultObject, expectedType: Response.self)
        }
    }
}


struct Tokens: JSONRPCKit.Request {
    typealias Response = [Any]
        
    var method: String {
        return "ledger_tokens"
    }
    
    var parameters: Any? {
        return []
    }
    
    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? Response {
            return response
        } else {
            throw CastError(actualValue: resultObject, expectedType: Response.self)
        }
    }
}


