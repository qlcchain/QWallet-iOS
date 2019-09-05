//
//  O3APIClient.swift
//  O3
//
//  Created by Apisit Toompakdee on 5/23/18.
//  Copyright © 2018 drei. All rights reserved.
//

import UIKit
import Neoutils

public enum O3APIClientError: Error {
    case invalidSeed, invalidBodyRequest, invalidData, invalidRequest, noInternet, invalidAddress

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
        case .invalidAddress:
            return "Invalid address"
        }

    }
}

public enum O3APIClientResult<T> {
    case success(T)
    case failure(O3APIClientError)
}

class O3APIClient: NSObject {

    public var apiBaseEndpoint = "https://platform.o3.network/api"
    public var apiWithCacheBaseEndpoint = "https://api.o3.network"
    public var network: NeoNetwork = .main

    public var useCache: Bool = false
    init(network: NeoNetwork, useCache: Bool = false) {
        self.network = network
        self.useCache = useCache
    }
    
    static var shared: O3APIClient = O3APIClient(network: AppState.network)

    enum o3APIResource: String {
        case getBalances = "balances"
        case getUTXO = "utxo"
        case getClaims = "claimablegas"
        case getInbox = "inbox"
        case postTokenSaleLog = "tokensales"
    }

    func queryString(_ value: String, params: [String: String]) -> String? {
        var components = URLComponents(string: value)
        components?.queryItems = params.map { element in URLQueryItem(name: element.key, value: element.value) }
        
        return components?.url?.absoluteString
    }
    
    func sendRESTAPIRequest(_ resourceEndpoint: String, data: Data?, requestType: String = "GET", params: [String: String] = [:], completion :@escaping (O3APIClientResult<JSONDictionary>) -> Void) {

        var fullURL = useCache ? apiWithCacheBaseEndpoint + resourceEndpoint : apiBaseEndpoint + resourceEndpoint
        var updatedParams = params
        if network == .test {
            updatedParams["network"] = "test"
        } else if network == .privateNet {
            updatedParams["network"] = "private"
        }
        
        fullURL =  self.queryString(fullURL, params: updatedParams)!

        let request = NSMutableURLRequest(url: URL(string: fullURL)!)
        request.httpMethod = requestType
        request.timeoutInterval = 60
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.httpBody = data

        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, result, err) in
            #if DEGUB
            print(result)
            #endif
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

            if let code = json!["code"] as? Int {
                if code != 200 {
                    completion(.failure(.invalidData))
                    return
                }
            }

            let resultJson = O3APIClientResult.success(json!)
            completion(resultJson)
        }
        task.resume()
    }

    public func getUTXO(for address: String, completion: @escaping(O3APIClientResult<Assets>) -> Void) {
        
        // 交易的地址
        let dict = ["address" : address]
        // 获取所有未花费的交易输出
        
        var url:String = allUnpspentAsset_v2_url // 正式接口（neo及其token转账）
//        if mainNet == false { // 注册和连接vpn用测试接口
//            url = "/api/neo/allUnpspentAsset.json"
//        }
        RequestService.request(withUrl10: url, params: dict, httpMethod: HttpMethodPost, serverType:RequestServerTypeRelease, successBlock: { (request, responseObject) in
            
            var endDatas = Array<Any>()
            let responser = responseObject as! Dictionary<String,AnyObject>
            if (responser == nil && responser.count == 0) {
                completion(.failure(.invalidData))
                return
            }
            
            let amountFormatter = NumberFormatter()
            amountFormatter.minimumFractionDigits = 0
            amountFormatter.maximumFractionDigits = 8
            amountFormatter.numberStyle = .decimal
            
            if responser["data"] == nil {
                completion(.failure(.invalidData))
                return
            }
            
            let dataArr = responser["data"] as! Array<AnyObject>
            if dataArr != nil {
                for valueDic in dataArr {
                    let assetDic = NSMutableDictionary(dictionary: valueDic as! Dictionary<String , AnyObject>)
                    let valueStr = assetDic["value"]
                    var str:String = "0.00000001";
                    if let strTemp = valueStr {
                        if strTemp is String {
                            let num = NSDecimalNumber(string: (strTemp as! String))
                            str = num.stringValue
                        } else if strTemp is NSNumber {
                            str = amountFormatter.string(from:strTemp as! NSNumber)!
                        }
                    }
                    assetDic["value"] = str

                    endDatas.append(assetDic)
                }
            }
            
            if endDatas.count == 0 {
                completion(.failure(.invalidData))
                return
            }
            
            let jsonObject:[String:Any] = ["data":endDatas]
            let decoder = JSONDecoder()
            guard let data = try? JSONSerialization.data(withJSONObject:jsonObject, options: .prettyPrinted),
                let assets = try? decoder.decode(Assets.self, from: data) else {
                    completion(.failure(.invalidData))
                    return
            }
            let result = O3APIClientResult.success(assets)
            completion(result)
            
            
        }) { (request, error) in
            completion(.failure(O3APIClientError.noInternet))
        }
    }

    public func getClaims(address: String, completion: @escaping(O3APIClientResult<Claimable>) -> Void) {
        // 交易的地址
        let dict = ["address" : address]
        //        let dict = ["address" : "AZRSCc47KuUae93AFowfdBTHr77KZGSnqp"]
        
        RequestService.request(withUrl5: "/api/neo/getClaims.json", params: dict, httpMethod: HttpMethodPost, successBlock: { (request, responseObject) in
            
            var responser: Dictionary<String,AnyObject>? = nil
            if responseObject is NSDictionary {
                responser = responseObject as? Dictionary<String,AnyObject>
            } else {
                return
            }
            
            var claimsArr = Array<Any>()
            var gas : String = "0"
            let codeInt: Int = Int(responser!["code"] as! String)!
            if codeInt != 0 {
                //                let msg : String = responser!["msg"] as! String? ?? ""
                completion(.failure(O3APIClientError.invalidBodyRequest))
                return
            }
            let dataDic = responser!["data"] as! Dictionary<String,AnyObject>
            if dataDic.count > 0 {
                let dataArr = dataDic["claims"] as! Array<AnyObject>
                if dataArr.count > 0 {
                    //                    for (idx,tempDic) in dataArr.enumerated() {
                    for tempDic in dataArr {
                        
                        let claimsDic = NSMutableDictionary(dictionary: tempDic as! Dictionary<String , AnyObject>)
                        
                        let num = NSDecimalNumber(string: claimsDic["claim"] as? String)
                        let gasNum = NSDecimalNumber(string: gas)
                        let allGasNum = (gasNum.decimalValue + num.decimalValue)
                        gas = NSDecimalNumber(decimal: allGasNum).stringValue
                        
                        var indexValue:Int = 0
                        if let indexTemp = claimsDic["index"] {
                            indexValue = (indexTemp as! NSNumber).intValue
                        }
                        
                        var valueStr:String = "0.00000001";
                        if let strTemp = claimsDic["value"] {
                            let num = NSDecimalNumber(string: (strTemp as! NSNumber).stringValue)
                            valueStr = num.stringValue
                        }
                        
                        let createdAtBlock: Int = Int(claimsDic["end"] as! String) ?? 0
                        
                        let txid = "0x" + (claimsDic["txid"] as! String)
                        
                        let claim:[String : Any] = ["asset":"0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b","index":indexValue,"txid":txid,"value":valueStr,"createdAtBlock":createdAtBlock]
                        
                        claimsArr.append(claim)
                        
                    }
                }
            }
            
            let jsonObject:[String:Any] = ["gas":gas,"claims":claimsArr]
            let decoder = JSONDecoder()
            guard let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
                let claims = try? decoder.decode(Claimable.self, from: data) else {
                    completion(.failure(.invalidData))
                    return
            }
            
            let result = O3APIClientResult.success(claims)
            completion(result)
            
        }) { (request, error) in
            completion(.failure(O3APIClientError.noInternet))
        }
        
//        let url = "/v1/neo/" + address + "/" + o3APIResource.getClaims.rawValue
//        sendRESTAPIRequest(url, data: nil) { result in
//            switch result {
//            case .failure(let error):
//                completion(.failure(error))
//            case .success(let response):
//                let decoder = JSONDecoder()
//
//                guard let dictionary = response["result"] as? JSONDictionary,
//                    let data = try? JSONSerialization.data(withJSONObject: dictionary["data"] as Any, options: .prettyPrinted),
//                    let claims = try? decoder.decode(Claimable.self, from: data) else {
//                        completion(.failure(.invalidData))
//                        return
//                }
//
//                let claimsResult = O3APIClientResult.success(claims)
//                completion(claimsResult)
//            }
//        }
    }

    func getAccountState(address: String, completion: @escaping(O3APIClientResult<AccountState>) -> Void) {
        let url = "/v1/neo/" + address + "/" + o3APIResource.getBalances.rawValue
        sendRESTAPIRequest(url, data: nil) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                let decoder = JSONDecoder()
                guard let dictionary = response["result"] as? JSONDictionary,
                    let data = try? JSONSerialization.data(withJSONObject: dictionary["data"] as Any, options: .prettyPrinted),
                    let accountState = try? decoder.decode(AccountState.self, from: data) else {
                        return
                }
                let balancesResult = O3APIClientResult.success(accountState)
                completion(balancesResult)
            }
        }
    }

//    func getInbox(address: String, completion: @escaping(O3APIClientResult<Inbox>) -> Void) {
//        let url = "/v1/inbox/" + address
//        sendRESTAPIRequest(url, data: nil) { result in
//            switch result {
//            case .failure(let error):
//                completion(.failure(error))
//            case .success(let response):
//                let decoder = JSONDecoder()
//                guard let data = try? JSONSerialization.data(withJSONObject: response["result"] as Any, options: .prettyPrinted),
//                    let decoded = try? decoder.decode(Inbox.self, from: data) else {
//                        completion(.failure(.invalidData))
//                        return
//                }
//                let success = O3APIClientResult.success(decoded)
//                completion(success)
//            }
//        }
//    }

    func getNodes(completion: @escaping(O3APIClientResult<Nodes>) -> Void) {
        let url = "/v1/nodes"
        sendRESTAPIRequest(url, data: nil) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                let decoder = JSONDecoder()
                guard let dictionary = response["result"] as? JSONDictionary,
                    let data = try? JSONSerialization.data(withJSONObject: dictionary["data"] as Any, options: .prettyPrinted),
                    let decoded = try? decoder.decode(Nodes.self, from: data) else {
                        return
                }
                let success = O3APIClientResult.success(decoded)
                completion(success)
            }
        }
    }

//    func checkVerifiedAddress(address: String, completion: @escaping(O3APIClientResult<VerifiedAddress>) -> Void) {
//        let validAddress = NeoutilsValidateNEOAddress(address)
//        if validAddress == false {
//            completion(.failure(.invalidAddress))
//            return
//        }
//        let url = "/v1/verification/" + address
//        sendRESTAPIRequest(url, data: nil) { result in
//            switch result {
//            case .failure(let error):
//                completion(.failure(error))
//            case .success(let response):
//                let decoder = JSONDecoder()
//                guard let dictionary = response["result"] as? JSONDictionary,
//                    let data = try? JSONSerialization.data(withJSONObject: dictionary["data"] as Any, options: .prettyPrinted),
//                    let decoded = try? decoder.decode(VerifiedAddress.self, from: data) else {
//                        return
//                }
//                let success = O3APIClientResult.success(decoded)
//                completion(success)
//            }
//        }
//    }

//    func postTokenSaleLog(address: String, companyID: String, tokenSaleLog: TokenSaleLog,
//                          completion: @escaping(O3APIClientResult<Bool>) -> Void) {
//        let url = "/v1/neo/" + address + "/tokensales/" + companyID
//        let encoder = JSONEncoder()
//        encoder.outputFormatting = .sortedKeys
//        let data = try? encoder.encode(tokenSaleLog)
//        sendRESTAPIRequest(url, data: data!, requestType: "POST") { result in
//            switch result {
//            case .failure(let error):
//                completion(.failure(error))
//            case .success(let response):
//                let decoder = JSONDecoder()
//                guard let dictionary = response["result"] as? JSONDictionary,
//                    let data = try? JSONSerialization.data(withJSONObject: dictionary["data"] as Any, options: .prettyPrinted),
//                    let _ = try? decoder.decode(String.self, from: data) else {
//                        return
//                }
//                let success = O3APIClientResult.success(true)
//                completion(success)
//            }
//        }
//    }
    
    func getTxHistory(address: String, pageIndex: Int, completion: @escaping(O3APIClientResult<TransactionHistory>) -> Void) {
        let url = String(format:"/v1/history/%@?p=%d", address, pageIndex)
        sendRESTAPIRequest(url, data: nil) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                let decoder = JSONDecoder()
                guard let dictionary = response["result"] as? JSONDictionary,
                    let data = try? JSONSerialization.data(withJSONObject: dictionary["data"] as Any, options: .prettyPrinted),
                    let decoded = try? decoder.decode(TransactionHistory.self, from: data) else {
                        completion(.failure(O3APIClientError.invalidData))
                        return
                }
                let success = O3APIClientResult.success(decoded)
                completion(success)
            }
        }
    }
    
//    func tradingBalances(address: String, completion: @escaping(O3APIClientResult<TradingAccount>) -> Void) {
//        let validAddress = NeoutilsValidateNEOAddress(address)
//        if validAddress == false {
//            completion(.failure(.invalidAddress))
//            return
//        }
//        let url = "/v1/trading/" + address
//        sendRESTAPIRequest(url, data: nil, params: ["version": "3"]) { result in
//            switch result {
//            case .failure(let error):
//                completion(.failure(error))
//            case .success(let response):
//                let decoder = JSONDecoder()
//                guard let dictionary = response["result"] as? JSONDictionary,
//                    let data = try? JSONSerialization.data(withJSONObject: dictionary["data"] as Any, options: .prettyPrinted),
//                    let decoded = try? decoder.decode(TradingAccount.self, from: data) else {
//                        return
//                }
//                let success = O3APIClientResult.success(decoded)
//                completion(success)
//            }
//        }
//    }
//
//    func loadPricing(symbol: String, currency: String, completion: @escaping(O3APIClientResult<AssetPrice>) -> Void) {
//        let url = String(format: "/v1/pricing/%@/%@", symbol, currency)
//        sendRESTAPIRequest(url, data: nil) { result in
//            switch result {
//            case .failure(let error):
//                completion(.failure(error))
//            case .success(let response):
//                let decoder = JSONDecoder()
//                guard let dictionary = response["result"] as? JSONDictionary,
//                    let data = try? JSONSerialization.data(withJSONObject: dictionary["data"] as Any, options: .prettyPrinted),
//                    let decoded = try? decoder.decode(AssetPrice.self, from: data) else {
//                        return
//                }
//                let success = O3APIClientResult.success(decoded)
//                completion(success)
//            }
//        }
//    }
//
//    let cache = NSCache<NSString, AnyObject>()
//    func loadSupportedTokenSwitcheo(completion: @escaping(O3APIClientResult<[TradableAsset]>) -> Void) {
//        let cacheKey: NSString = "SUPPORTED_TOKENS_SWITCHEO"
//        if let cached = cache.object(forKey: cacheKey) {
//            // use the cached version
//            let decoded = cached as! [TradableAsset]
//            let w = O3APIClientResult.success(decoded)
//            completion(w)
//            return
//        }
//
//        let url = String(format: "/v1/trading/%@/tokens", "switcheo")
//        sendRESTAPIRequest(url, data: nil, params: ["version": "3"]) { result in
//            switch result {
//            case .failure(let error):
//                completion(.failure(error))
//            case .success(let response):
//                let decoder = JSONDecoder()
//                guard let dictionary = response["result"] as? JSONDictionary,
//                    let data = try? JSONSerialization.data(withJSONObject: dictionary["data"] as Any, options: .prettyPrinted),
//                    let decoded = try? decoder.decode([TradableAsset].self, from: data) else {
//                        return
//                }
//                self.cache.setObject(decoded as AnyObject, forKey: cacheKey)
//                let success = O3APIClientResult.success(decoded)
//                completion(success)
//            }
//        }
//    }
//
//    func loadTradablePairsSwitcheo(completion: @escaping(O3APIClientResult<[TradablePair]>) -> Void) {
//        let cacheKey: NSString = "TRADABLE_PAIRS_SWITCHEO"
//        if let cached = cache.object(forKey: cacheKey) {
//            // use the cached version
//            let decoded = cached as! [TradablePair]
//            let w = O3APIClientResult.success(decoded)
//            completion(w)
//            return
//        }
//
//        let url = String(format: "/v1/trading/%@/pairs?show_details=1", "switcheo")
//        sendRESTAPIRequest(url, data: nil, params: ["version": "3"]) { result in
//            switch result {
//            case .failure(let error):
//                completion(.failure(error))
//            case .success(let response):
//                let decoder = JSONDecoder()
//                guard let dictionary = response["result"] as? JSONDictionary,
//                    let data = try? JSONSerialization.data(withJSONObject: dictionary["data"] as Any, options: .prettyPrinted),
//                    let decoded = try? decoder.decode([TradablePair].self, from: data) else {
//                        return
//                }
//                self.cache.setObject(decoded as AnyObject, forKey: cacheKey)
//                let success = O3APIClientResult.success(decoded)
//                completion(success)
//            }
//        }
//    }
//
//    func loadSwitcheoOrders(address: String, status: SwitcheoOrderStatus, pair: String? = nil, completion: @escaping(O3APIClientResult<TradingOrders>) -> Void) {
//
//        let url = String(format: "/v1/trading/%@/orders", address)
//        var params: [String: String] = [:]
//        if status.rawValue != "" {
//            params["status"] = status.rawValue
//        }
//
//        if pair != nil {
//            params["pair"] = pair!
//        }
//        params["version"] = "3"
//
//        sendRESTAPIRequest(url, data: nil, params: params) { result in
//            switch result {
//            case .failure(let error):
//                completion(.failure(error))
//            case .success(let response):
//                let decoder = JSONDecoder()
//                guard let dictionary = response["result"] as? JSONDictionary,
//                    let data = try? JSONSerialization.data(withJSONObject: dictionary["data"] as Any, options: .prettyPrinted),
//                    let decoded = try? decoder.decode(TradingOrders.self, from: data) else {
//                        return
//                }
//                let success = O3APIClientResult.success(decoded)
//                completion(success)
//            }
//        }
//    }
//
//    func loadDapps(completion: @escaping(O3APIClientResult<[Dapp]>) -> Void) {
//        let url = String(format: "/v1/dapps")
//        sendRESTAPIRequest(url, data: nil) { result in
//            switch result {
//            case .failure(let error):
//                completion(.failure(error))
//            case .success(let response):
//                let decoder = JSONDecoder()
//                guard let dictionary = response["result"] as? JSONDictionary,
//                    let data = try? JSONSerialization.data(withJSONObject: dictionary["data"] as Any, options: .prettyPrinted),
//                    let decoded = try? decoder.decode([Dapp].self, from: data) else {
//                        return
//                }
//                let success = O3APIClientResult.success(decoded)
//                completion(success)
//            }
//        }
//    }
//
//    func domainLookup(domain: String, completion: @escaping(O3APIClientResult<String>) -> Void) {
//        struct domainInfo: Codable {
//            let address, expiration: String
//        }
//        let url = String(format: "/v1/neo/nns/%@", domain)
//        sendRESTAPIRequest(url, data: nil) { result in
//            switch result {
//            case .failure(let error):
//                completion(.failure(error))
//            case .success(let response):
//                let decoder = JSONDecoder()
//                guard let dictionary = response["result"] as? JSONDictionary,
//                    let data = try? JSONSerialization.data(withJSONObject: dictionary["data"] as Any, options: .prettyPrinted),
//                    let decoded = try? decoder.decode(domainInfo.self, from: data) else {
//                        return
//                }
//                let success = O3APIClientResult.success(decoded.address)
//                completion(success)
//            }
//        }
//    }
//
//    struct reverseDomainInfo: Codable {
//        let address, expiration, domain: String
//    }
//
//    func reverseDomainLookup(address: String, completion: @escaping(O3APIClientResult<[reverseDomainInfo]>) -> Void) {
//        let url = String(format: "/v1/neo/nns/%@/domains", address)
//        sendRESTAPIRequest(url, data: nil) { result in
//            switch result {
//            case .failure(let error):
//                completion(.failure(error))
//            case .success(let response):
//                let decoder = JSONDecoder()
//                guard let dictionary = response["result"] as? JSONDictionary,
//                    let data = try? JSONSerialization.data(withJSONObject: dictionary["data"] as Any, options: .prettyPrinted),
//                    let decoded = try? decoder.decode([reverseDomainInfo].self, from: data) else {
//                        return
//                }
//                let success = O3APIClientResult.success(decoded)
//                completion(success)
//            }
//        }
//    }
}
