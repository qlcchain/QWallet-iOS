//
//  NeoClient.swift
//  NeoSwift
//
//  Created by Andrei Terentiev on 8/19/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import Neoutils

typealias JSONDictionary = [String: Any]

public enum NeoClientError: Error {
    case invalidSeed, invalidBodyRequest, invalidData, invalidRequest, noInternet
    
    var localizedDescription: String {
        switch self {
        case .invalidSeed:
            return "Invalid seed"
        case .invalidBodyRequest:
            return "Invalid body Request"
        case .invalidData:
            return "Invalid response data"
        case .invalidRequest:
            return "Invalid server request"
        case .noInternet:
            return "No Internet connection"
        }
    }
}

public enum NeoClientResult<T> {
    case success(T)
    case failure(NeoClientError)
}

public enum NeoNetwork: String {
    case test
    case main
    case privateNet
}

public class NEONetworkMonitor {
    
    public static let sharedInstance = NEONetworkMonitor()
    
    public static func autoSelectBestNode(network: NeoNetwork) -> String? {
        
        var bestNode = ""
        //load from https://platform.o3.network/api/v1/nodes instead
        let semaphore = DispatchSemaphore(value: 0)
        O3APIClient(network: network).getNodes { result in
            switch result {
            case .failure(let error):

                #if DEBUG
                print(error)
                #endif
                bestNode = ""
            case .success(let nodes):
                bestNode = nodes.neo.best
            }
            semaphore.signal()
        }
        semaphore.wait()
        return bestNode
    }
    
}

public class NeoClient {
    
    //make it a subclass of neoclient to make it more organize
    
    
    public struct InvokeFunctionResult: Codable {
        let script, state, gasConsumed: String
        let stack: [Stack]
        
        enum CodingKeys: String, CodingKey {
            case script, state
            case gasConsumed = "gas_consumed"
            case stack
        }
    }
    
    struct Stack: Codable {
        let type, value: String
    }
    
    
    
    public var seed = "http://seed3.o3node.org:10332"
    
    private init() {}
    private let tokenInfoCache = NSCache<NSString, AnyObject>()
    
    enum RPCMethod: String {
        case getConnectionCount = "getconnectioncount"
        case sendTransaction = "sendrawtransaction"
        case invokeContract = "invokescript"
        case getMemPool = "getrawmempool"
        case getStorage = "getstorage"
        case invokefunction = "invokefunction"
        case getContractState = "getcontractstate"
    }
    
    public init(seed: String) {
        self.seed = seed
    }
    
    func sendJSONRPCRequest(_ method: RPCMethod, params: [Any]?, completion: @escaping (NeoClientResult<JSONDictionary>) -> Void) {
        guard let url = URL(string: seed) else {
            completion(.failure(.invalidSeed))
            return
        }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json-rpc", forHTTPHeaderField: "Content-Type")
        request.cachePolicy = .reloadIgnoringLocalCacheData
        
        let requestDictionary: [String: Any?] = [
            "jsonrpc": "2.0",
            "id": 2,
            "method": method.rawValue,
            "params": params ?? []
        ]
        
        guard let body = try? JSONSerialization.data(withJSONObject: requestDictionary, options: []) else {
            completion(.failure(.invalidBodyRequest))
            return
        }
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, _, err) in
            if err != nil {
                completion(.failure(.invalidRequest))
                return
            }
            
            if data == nil {
                completion(.failure(.invalidData))
                return
            }
            
            guard let json = ((try? JSONSerialization.jsonObject(with: data!, options: []) as? JSONDictionary) as JSONDictionary??) else {
                completion(.failure(.invalidData))
                return
            }
            
            if json == nil {
                completion(.failure(.invalidData))
                return
            }
            
            let resultJson = NeoClientResult.success(json!)
            completion(resultJson)
        }
        task.resume()
    }
    
    public func sendRawTransaction(with data: Data, completion: @escaping(NeoClientResult<Bool>) -> Void) {
        sendJSONRPCRequest(.sendTransaction, params: [data.fullHexString]) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                guard let success = response["result"] as? Bool else {
                    completion(.failure(.invalidData))
                    return
                }
                let result = NeoClientResult.success(success)
                completion(result)
            }
        }
    }
    
    public func getMempoolHeight(completion: @escaping(NeoClientResult<Int>) -> Void) {
        sendJSONRPCRequest(.getMemPool, params: []) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                guard let mempool = response["result"] as? [String] else {
                    completion(.failure(.invalidData))
                    return
                }
                let result = NeoClientResult.success(mempool.count)
                completion(result)
            }
        }
    }
    
    public func getContractState(scriptHash: String, completion: @escaping(NeoClientResult<ContractState>) -> Void) {
        sendJSONRPCRequest(.getContractState, params: [scriptHash]) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                
                let decoder = JSONDecoder()
                guard let dictionary = response["result"] as? JSONDictionary,
                    let data = try? JSONSerialization.data(withJSONObject: dictionary as Any, options: .prettyPrinted),
                    let decoded = try? decoder.decode(ContractState.self, from: data) else {
                        completion(.failure(.invalidData))
                        return
                }
                let result = NeoClientResult.success(decoded)
                completion(result)
            }
        }
    }
    
    
    public func getStorage(scriptHash: String, key: String, completion: @escaping(NeoClientResult<String>) -> Void) {
        sendJSONRPCRequest(.getStorage, params: [scriptHash, key]) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                guard let s = response["result"] as? String else {
                    completion(.failure(.invalidData))
                    return
                }
                let result = NeoClientResult.success(s)
                completion(result)
            }
        }
    }
    
    public func invokeFunction(scriptHash: String, operation: String, arguments: [[String: String]], completion: @escaping(NeoClientResult<InvokeFunctionResult>) -> Void) {
        sendJSONRPCRequest(.invokefunction, params: [scriptHash, operation, arguments]) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                
                let decoder = JSONDecoder()
                guard let dictionary = response["result"] as? JSONDictionary,
                    let data = try? JSONSerialization.data(withJSONObject: dictionary as Any, options: .prettyPrinted),
                    let decoded = try? decoder.decode(InvokeFunctionResult.self, from: data) else {
                        completion(.failure(.invalidData))
                        return
                }
                let result = NeoClientResult.success(decoded)
                completion(result)
            }
        }
    }
}
