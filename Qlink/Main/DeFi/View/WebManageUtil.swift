////
////  WebManageUtil.swift
////  web3Test
////
////  Created by 旷自辉 on 2020/8/6.
////  Copyright © 2020 旷自辉. All rights reserved.
////
//
//import UIKit
//import BigInt
//import SwiftTheme
//class WebManageUtil: NSObject {
//    @objc static func teststst() throws {
//        let yourContractABI: String = "[{\"name\":\"NewExchange\",\"inputs\":[{\"type\":\"address\",\"name\":\"token\",\"indexed\":true},{\"type\":\"address\",\"name\":\"exchange\",\"indexed\":true}],\"anonymous\":false,\"type\":\"event\"},{\"name\":\"initializeFactory\",\"outputs\":[],\"inputs\":[{\"type\":\"address\",\"name\":\"template\"}],\"constant\":false,\"payable\":false,\"type\":\"function\",\"gas\":35725},{\"name\":\"createExchange\",\"outputs\":[{\"type\":\"address\",\"name\":\"out\"}],\"inputs\":[{\"type\":\"address\",\"name\":\"token\"}],\"constant\":false,\"payable\":false,\"type\":\"function\",\"gas\":187911},{\"name\":\"getExchange\",\"outputs\":[{\"type\":\"address\",\"name\":\"out\"}],\"inputs\":[{\"type\":\"address\",\"name\":\"token\"}],\"constant\":true,\"payable\":false,\"type\":\"function\",\"gas\":715},{\"name\":\"getToken\",\"outputs\":[{\"type\":\"address\",\"name\":\"out\"}],\"inputs\":[{\"type\":\"address\",\"name\":\"exchange\"}],\"constant\":true,\"payable\":false,\"type\":\"function\",\"gas\":745},{\"name\":\"getTokenWithId\",\"outputs\":[{\"type\":\"address\",\"name\":\"out\"}],\"inputs\":[{\"type\":\"uint256\",\"name\":\"token_id\"}],\"constant\":true,\"payable\":false,\"type\":\"function\",\"gas\":736},{\"name\":\"exchangeTemplate\",\"outputs\":[{\"type\":\"address\",\"name\":\"out\"}],\"inputs\":[],\"constant\":true,\"payable\":false,\"type\":\"function\",\"gas\":633},{\"name\":\"tokenCount\",\"outputs\":[{\"type\":\"uint256\",\"name\":\"out\"}],\"inputs\":[],\"constant\":true,\"payable\":false,\"type\":\"function\",\"gas\":663}]"
//
//        let toEthereumAddress: EthereumAddress = EthereumAddress("0xc0a47dFe034B400B47bDaD5FecDa2621de6c4d95")!
//        let abiVersion: Int = 2
//        let parametersCall = ["0x4ddc2d193948926d02f9b1fe9e1daa0718270ed5"] as [AnyObject]
//
//        let webMain = Web3.InfuraMainnetWeb3()
//        let transactionOptions: TransactionOptions = webMain.transactionOptions
//             //  options.from = address
//
//        let contract = webMain.contract(yourContractABI, at: toEthereumAddress, abiVersion: abiVersion)
//
//        let transactionIntermediate = contract?.method("getExchange", parameters: parametersCall, transactionOptions: transactionOptions)
//
//        let result = try transactionIntermediate!.call(transactionOptions: transactionOptions)
//        print(result)
//    }
//}
