//
//  QlcClient.swift
//  qlc-ios-sdk
//
//  Created by Jelly Foo on 2019/5/14.
//  Copyright © 2019 Jelly Foo. All rights reserved.
//

import Foundation
import APIKit
import JSONRPCKit

//public let qlc_seed:String = "https://rpc.qlcchain.online" // 测试
//public let qlc_seed:String = "http://wrpc.qlcchain.org:9735" // 生产
public let qlc_seed:String = "http://47.103.40.20:19735" // 测试
//public let qlc_seed:String = "http://178.63.50.78:9735" // 欧洲生产

//public typealias JSONDictionary_qlc = [String: Any]

let timeoutInterval: Double = 30.0

public struct StringIdGenerator: IdGenerator {
    
    private var currentId = 1
    
    public mutating func next() -> Id {
        defer {
            currentId += 1
        }
        
        return .string("id\(currentId)")
    }
}

//public enum QlcClientError: Error {
//    case invalidSeed, invalidBodyRequest, invalidData, invalidRequest, noInternet
//
//    var localizedDescription: String {
//        switch self {
//        case .invalidSeed:
//            return "Invalid seed"
//        case .invalidBodyRequest:
//            return "Invalid body Request"
//        case .invalidData:
//            return "Invalid response data"
//        case .invalidRequest:
//            return "Invalid server request"
//        case .noInternet:
//            return "No Internet connection"
//        }
//    }
//}
//
//public enum QlcClientResult<T> {
//    case success(T)
//    case failure(QlcClientError)
//}

public enum QlcNetwork: String {
    case test
    case main
}

//public class QlcNetworkMonitor {
//
//    public static let sharedInstance = QlcNetworkMonitor()
//
//    public static func autoSelectBestNode(network: QlcNetwork) -> String? {
//
//        var bestNode = ""
        //load from https://platform.o3.network/api/v1/nodes instead
//        let semaphore = DispatchSemaphore(value: 0)
//        O3APIClient(network: network).getNodes { result in
//            switch result {
//            case .failure(let error):
//
//                #if DEBUG
//                print(error)
//                #endif
//                bestNode = ""
//            case .success(let nodes):
//                bestNode = nodes.neo.best
//            }
//            semaphore.signal()
//        }
//        semaphore.wait()
//        return bestNode
//    }
//
//}

public typealias QlcClientSuccessHandler = ((Any?) -> Void)
//public typealias QlcClientFailureHandler = ((Error?) -> Void)
public typealias QlcClientFailureHandler = ((Error?,String?) -> Void)

public class QlcClient  {
    
//    public var seed = testSeed
//    public init(seed: String?) {
//        self.seed = seed ?? testSeed
//    }
    
    public func call<Request: JSONRPCKit.Request>(_ request: Request, callbackQueue: CallbackQueue? = nil, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
        let batchFactory = BatchFactory(idGenerator: StringIdGenerator())
        let batch = batchFactory.create(request)
        let httpRequest = LedgerServiceRequest(batch: batch)
        
        Session.send(httpRequest, callbackQueue: callbackQueue) { result in
//        Session.send(httpRequest) { result in
            switch result {
            case .success(let answer):
                print(httpRequest.baseURL,request.method,request.parameters ?? "","🐵🐵🐵🐵🐵🐵🐵🐵🐵🐵🐵🐵🐵🐵🐵🐵🐵🐵🐵🐵🐵🐵🐵🐵 = ",answer)
//                let isMain = Thread.isMainThread
//                if isMain {
                    successHandler(answer)
//                } else {
//                    DispatchQueue.main.sync {
//                        successHandler(answer)
//                    }
//                }
            case .failure(let error):
                print(httpRequest.baseURL,request.method,request.parameters ?? "","🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶 = ",error)
//                let isMain = Thread.isMainThread
//                if isMain {
//
//                } else {
                    DispatchQueue.main.async {
                        var title:String?
                        var message:String?
                        switch error {
                        case .connectionError(let error as NSError):
                            title = error.localizedDescription
                            message = error.localizedRecoverySuggestion
                        case .responseError(let error as JSONRPCError):
                            if case .responseError(_, let errorMessage, let data as String?) = error {
                                title = errorMessage
                                message = data
                            } else {
                                fallthrough
                            }
                        default:
                            title = "Unknown error"
                            message = nil
                        }
                        failureHandler(error,title)
                    }
//                }
            }
        }
    }
//    public func call(method: String, params: [Any]?, successHandler: @escaping QlcClientSuccessHandler, failureHandler: @escaping QlcClientFailureHandler) {
//
//        guard let url = URL(string: seed) else {
////            failureHandler(.invalidSeed)
//            failureHandler("invalidSeed")
//            return
//        }
//
//        let request = NSMutableURLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json-rpc", forHTTPHeaderField: "Content-Type")
//        request.cachePolicy = .reloadIgnoringLocalCacheData
//        request.timeoutInterval = 30
//
//        let requestDictionary: [String: Any] = [
//            "jsonrpc": "2.0",
//            "id": UUID().uuidString.replacingOccurrences(of: "-", with: ""),
//            "method": method,
//            "params": params ?? []
//        ]
//
//        guard let body = try? JSONSerialization.data(withJSONObject: requestDictionary, options: .prettyPrinted) else {
////            failureHandler(.invalidBodyRequest)
//            failureHandler("invalidBodyRequest")
//            return
//        }
//        request.httpBody = body
//        print("url = ",url)
//        print("requestDictionary = ",requestDictionary)
//        let session = URLSession(configuration: .default)
//        let task = session.dataTask(with: request as URLRequest) { (data, response, err) in
//            print("err = ",err.debugDescription,"          data = ",data as Any)
//            if err != nil {
////                failureHandler(.invalidRequest)
//                DispatchQueue.main.async {
//                    failureHandler("invalidRequest")
//                }
//                return
//            }
//
//            if data == nil {
////                failureHandler(.invalidData)
//                DispatchQueue.main.async {
//                    failureHandler("invalidData")
//                }
//                return
//            }
//
//            guard let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) else {
////                failureHandler(.invalidData)
//                DispatchQueue.main.async {
//                    failureHandler("invalidData")
//                }
//                return
//            }
//
//            if json == nil {
////                failureHandler(.invalidData)
//                DispatchQueue.main.async {
//                    failureHandler("invalidData")
//                }
//                return
//            }
//
//            DispatchQueue.main.async {
//                successHandler(json as! JSONDictionary_qlc)
//            }
////            let resultJson = QlcClientResult.success(json!)
////            completionHandler(resultJson)
//        }
//        task.resume()
//    }
    
}
