////
////  QETHManager.swift
////  Qlink
////
////  Created by 旷自辉 on 2020/8/3.
////  Copyright © 2020 pan. All rights reserved.
////
//
//import UIKit
//import BigInt
//import web3swift
//
////extension Web3 {
////    @available (*, unavailable, renamed: "contract(_:at:)")
////    func contract(_ abiString: String, at: Address? = nil, abiVersion: Int) throws -> Web3Contract {
////        return try Web3Contract(web3: self, abiString: abiString, at: at, options: options)
////    }
////}
//
//class QETHManager: NSObject {
//
//
//     @objc static func test() throws {
//            // create normal keystore
//
//            let userDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//            guard let keystoreManager = KeystoreManager.managerForPath(userDir + "/keystore") else { return }
//            var ks: EthereumKeystoreV3?
//            if (keystoreManager.addresses.count == 0) {
//                ks = try! EthereumKeystoreV3(password: "BANKEXFOUNDATION")
//                let keydata = try! JSONEncoder().encode(ks!.keystoreParams)
//                FileManager.default.createFile(atPath: userDir + "/keystore"+"/key.json", contents: keydata, attributes: nil)
//            } else {
//                ks = keystoreManager.walletForAddress((keystoreManager.addresses[0])) as? EthereumKeystoreV3
//            }
//            guard let sender = ks?.addresses.first else { return }
//            print(sender)
//
//            //create BIP32 keystore
//            guard let bip32keystoreManager = KeystoreManager.managerForPath(userDir + "/bip32_keystore", scanForHDwallets: true) else { return }
//            var bip32ks: BIP32Keystore!
//            if (bip32keystoreManager.addresses.count == 0) {
//                let mnemonics = try Mnemonics("normal dune pole key case cradle unfold require tornado mercy hospital buyer")
//                bip32ks = try BIP32Keystore(mnemonics: mnemonics, password: "BANKEXFOUNDATION")
//                let keydata = try! JSONEncoder().encode(bip32ks!.keystoreParams)
//                FileManager.default.createFile(atPath: userDir + "/bip32_keystore"+"/key.json", contents: keydata, attributes: nil)
//            } else {
//                bip32ks = bip32keystoreManager.walletForAddress((bip32keystoreManager.addresses[0])) as? BIP32Keystore
//            }
//            guard let bip32sender = bip32ks?.addresses.first else { return }
//            print(bip32sender)
//
//
//            // BKX TOKEN
//            let web3Main = Web3(infura: .mainnet)
//            let coldWalletAddress = Address("0x6394b37Cf80A7358b38068f0CA4760ad49983a1B")
//            let constractAddress = Address("0x45245bc59219eeaaf6cd3f382e078a461ff9de7b")
//
//
//
//
//
//            var gasPrice:BigUInt
//            var options = Web3Options.default
//            gasPrice =  try! web3Main.eth.getGasPrice()
//            options.gasPrice = gasPrice
//            options.from = Address("0xE6877A4d8806e9A9F12eB2e8561EA6c1db19978d")
//
//            web3Main.keystoreManager = keystoreManager
//            let contract = ERC20(constractAddress)
//            let tokenName = try contract.name()
//            print("BKX token name = \(tokenName)")
//            let balance = try contract.balance(of: coldWalletAddress)
//            print("BKX token balance = \(balance)")
//
//            //Send on Rinkeby using normal keystore
//            print("Rinkeby")
//            Web3.default = Web3(infura: .rinkeby)
//            let web3Rinkeby = Web3.default
//
//            web3Rinkeby.keystoreManager = keystoreManager
//            let coldWalletABI = "[{\"payable\":true,\"type\":\"fallback\"}]"
//            options = Web3Options.default
//            options.gasLimit = BigUInt(21000)
//            options.from = ks?.addresses.first!
//            options.value = BigUInt(1000000000000000)
//            options.from = sender
//            let estimatedGas = try web3Rinkeby.contract(coldWalletABI, at: coldWalletAddress).method(options: options).estimateGas(options: nil)
//            options.gasLimit = estimatedGas
//            var intermediateSend = try web3Rinkeby.contract(coldWalletABI, at: coldWalletAddress).method(options: options)
//            let sendingResult = try intermediateSend.send(password: "BANKEXFOUNDATION")
//            let txid = sendingResult.hash
//            print("On Rinkeby TXid = " + txid)
//
//            // Send ETH on Rinkeby using BIP32 keystore. Should fail due to insufficient balance
//            web3Rinkeby.keystoreManager = bip32keystoreManager
//            options.from = bip32ks?.addresses.first!
//            intermediateSend = try web3Rinkeby.contract(coldWalletABI, at: coldWalletAddress).method(options: options)
//            let transaction = try intermediateSend.send(password: "BANKEXFOUNDATION")
//            print(transaction)
//
//            //Send ERC20 token on Rinkeby
//            web3Rinkeby.addKeystoreManager(keystoreManager)
//            let testToken = ERC20("0xa407dd0cbc9f9d20cdbd557686625e586c85b20a")
//            testToken.options.from = ks!.addresses.first!
//
//            let transaction1 = try testToken.transfer(to: "0x6394b37Cf80A7358b38068f0CA4760ad49983a1B", amount: 1)
//            print(transaction1)
//
//            //Send ERC20 on Rinkeby using a convenience function
//            let transaction2 = try testToken.approve(to: "0x6394b37Cf80A7358b38068f0CA4760ad49983a1B", amount: NaturalUnits("0.0001"))
//            print(transaction2)
//
//            //Balance on Rinkeby
//            let rinkebyBalance = try web3Rinkeby.eth.getBalance(address: coldWalletAddress)
//            print("Balance of \(coldWalletAddress.address) = \(rinkebyBalance)")
//
//            let deployedTestAddress = Address("0x1e528b190b6acf2d7c044141df775c7a79d68eba")
//            options = Web3Options.default
//            options.gasLimit = BigUInt(100000)
//            options.value = BigUInt(0)
//            options.from = ks?.addresses[0]
//            let transaction3 = try deployedTestAddress.send("increaseCounter(uint8)", 1, password: "BANKEXFOUNDATION").wait()
//            print(transaction3)
//        }
//
//
//     //================================================华丽丽的分割线=================================================
//        //MARK:读取授权额度
//    @objc static func gettingAuthorizationLimit(symbolAddr: String, userAddr: String) throws -> String {
//
//            let jsonString = "abi" //ymbolAuthorizationABIStr
//
//    //        let web3Main = Web3.InfuraMainnetWeb3()
//            let url = URL(string: "https://ropsten.infura.io/")!
//            let web3Main = try Web3.new(url)!
//
//            let constractAddress = EthereumAddress(symbolAddr)    //to
//            var options = Web3Options.defaultOptions()
//            options.to = constractAddress
//
//            let contract = try web3Main.contract(jsonString, at: constractAddress)
//
//            let spender = "0x717d85f910953940cb480b567b4841cfe9650a1b"
//            let parameters = [userAddr, spender] as [AnyObject]
//
//
//             let bkxBalanceResult = try contract.method("allowance",args: parameters, options: options).call(options:nil)
//            let bal = bkxBalanceResult["0"] as? BigUInt
//
//        print("token allowance = " + String(describing: bal) )
//
//      return String(describing: bal)
//        //let bkxBalanceResult = try contract.method("allowance",args: parameters, options: options)
//
////        guard let tokenNameRes = try bkxBalanceResult.call(options: options) else {return ""}
////        guard case .success(let result) = tokenNameRes else {return ""}
//
//
//
//
//       // guard let bkxBalanceResult = try contract.method("", args: parameters, options: options).call(options: nil) else {return "0"}
////            guard case .success(let bkxBalance) = bkxBalanceResult, let bal = bkxBalance["0"] as? BigUInt else {return "0"}
////            print("token allowance = " + String(bal))
////            if !bkxBalance.isEmpty {
////                return String(bal)
////            } else {
////                return "0"
////            }
//            // contract.method("allowance", parameters: parameters, options: options)?.call(options: nil) else {return "0"}
//        }
//
//
//    //执行"addr"方法
//    @objc static func infuratestResolver(encodeStr: String) throws -> String {
//        let jsonString = "[{\"name\":\"NewExchange\",\"inputs\":[{\"type\":\"address\",\"name\":\"token\",\"indexed\":true},{\"type\":\"address\",\"name\":\"exchange\",\"indexed\":true}],\"anonymous\":false,\"type\":\"event\"},{\"name\":\"initializeFactory\",\"outputs\":[],\"inputs\":[{\"type\":\"address\",\"name\":\"template\"}],\"constant\":false,\"payable\":false,\"type\":\"function\",\"gas\":35725},{\"name\":\"createExchange\",\"outputs\":[{\"type\":\"address\",\"name\":\"out\"}],\"inputs\":[{\"type\":\"address\",\"name\":\"token\"}],\"constant\":false,\"payable\":false,\"type\":\"function\",\"gas\":187911},{\"name\":\"getExchange\",\"outputs\":[{\"type\":\"address\",\"name\":\"out\"}],\"inputs\":[{\"type\":\"address\",\"name\":\"token\"}],\"constant\":true,\"payable\":false,\"type\":\"function\",\"gas\":715},{\"name\":\"getToken\",\"outputs\":[{\"type\":\"address\",\"name\":\"out\"}],\"inputs\":[{\"type\":\"address\",\"name\":\"exchange\"}],\"constant\":true,\"payable\":false,\"type\":\"function\",\"gas\":745},{\"name\":\"getTokenWithId\",\"outputs\":[{\"type\":\"address\",\"name\":\"out\"}],\"inputs\":[{\"type\":\"uint256\",\"name\":\"token_id\"}],\"constant\":true,\"payable\":false,\"type\":\"function\",\"gas\":736},{\"name\":\"exchangeTemplate\",\"outputs\":[{\"type\":\"address\",\"name\":\"out\"}],\"inputs\":[],\"constant\":true,\"payable\":false,\"type\":\"function\",\"gas\":633},{\"name\":\"tokenCount\",\"outputs\":[{\"type\":\"uint256\",\"name\":\"out\"}],\"inputs\":[],\"constant\":true,\"payable\":false,\"type\":\"function\",\"gas\":663}]"
//
//
//        let web3 = Web3.InfuraMainnetWeb3()
//
//                   let constractAddress = EthereumAddress("0xc0a47dFe034B400B47bDaD5FecDa2621de6c4d95")
//                    var options = Web3Options.defaultOptions()
//                  // options.to = constractAddress
//                    options.from = "0x4ddc2d193948926d02f9b1fe9e1daa0718270ed5"
//                   let parametersCall = ["0x4ddc2d193948926d02f9b1fe9e1daa0718270ed5"] as [AnyObject]
//                   let contract = try web3.contract(jsonString, at: constractAddress)
//        let transactionIntermediate = try contract.method("getExchange", parameters:parametersCall, options: options)
//                 //  let transaction = try contract.method("setAddr",args: parametersCall, options: options)
//        let result = try transactionIntermediate.call(options: options)
//        print(result.dictionary)
//        return ""
//    }
//
//    //执行"addr"方法
//    @objc static func infuratestResolver2(encodeStr: String) throws -> String {
//         let jsonString = "[{\"constant\":true,\"inputs\":[{\"name\":\"interfaceID\",\"type\":\"bytes4\"}],\"name\":\"supportsInterface\",\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"node\",\"type\":\"bytes32\"},{\"name\":\"contentTypes\",\"type\":\"uint256\"}],\"name\":\"ABI\",\"outputs\":[{\"name\":\"contentType\",\"type\":\"uint256\"},{\"name\":\"data\",\"type\":\"bytes\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"node\",\"type\":\"bytes32\"},{\"name\":\"x\",\"type\":\"bytes32\"},{\"name\":\"y\",\"type\":\"bytes32\"}],\"name\":\"setPubkey\",\"outputs\":[],\"payable\":false,\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"node\",\"type\":\"bytes32\"}],\"name\":\"content\",\"outputs\":[{\"name\":\"ret\",\"type\":\"bytes32\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"node\",\"type\":\"bytes32\"}],\"name\":\"addr\",\"outputs\":[{\"name\":\"ret\",\"type\":\"address\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"node\",\"type\":\"bytes32\"},{\"name\":\"contentType\",\"type\":\"uint256\"},{\"name\":\"data\",\"type\":\"bytes\"}],\"name\":\"setABI\",\"outputs\":[],\"payable\":false,\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"node\",\"type\":\"bytes32\"}],\"name\":\"name\",\"outputs\":[{\"name\":\"ret\",\"type\":\"string\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"node\",\"type\":\"bytes32\"},{\"name\":\"name\",\"type\":\"string\"}],\"name\":\"setName\",\"outputs\":[],\"payable\":false,\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"node\",\"type\":\"bytes32\"},{\"name\":\"hash\",\"type\":\"bytes32\"}],\"name\":\"setContent\",\"outputs\":[],\"payable\":false,\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"node\",\"type\":\"bytes32\"}],\"name\":\"pubkey\",\"outputs\":[{\"name\":\"x\",\"type\":\"bytes32\"},{\"name\":\"y\",\"type\":\"bytes32\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"node\",\"type\":\"bytes32\"},{\"name\":\"addr\",\"type\":\"address\"}],\"name\":\"setAddr\",\"outputs\":[],\"payable\":false,\"type\":\"function\"},{\"inputs\":[{\"name\":\"ensAddr\",\"type\":\"address\"}],\"payable\":false,\"type\":\"constructor\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"node\",\"type\":\"bytes32\"},{\"indexed\":false,\"name\":\"a\",\"type\":\"address\"}],\"name\":\"AddrChanged\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"node\",\"type\":\"bytes32\"},{\"indexed\":false,\"name\":\"hash\",\"type\":\"bytes32\"}],\"name\":\"ContentChanged\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"node\",\"type\":\"bytes32\"},{\"indexed\":false,\"name\":\"name\",\"type\":\"string\"}],\"name\":\"NameChanged\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"node\",\"type\":\"bytes32\"},{\"indexed\":true,\"name\":\"contentType\",\"type\":\"uint256\"}],\"name\":\"ABIChanged\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"node\",\"type\":\"bytes32\"},{\"indexed\":false,\"name\":\"x\",\"type\":\"bytes32\"},{\"indexed\":false,\"name\":\"y\",\"type\":\"bytes32\"}],\"name\":\"PubkeyChanged\",\"type\":\"event\"}]"
//         do {
//
//             let web3 = Web3.InfuraMainnetWeb3()
//             let constractAddress = EthereumAddress("0x1da022710dF5002339274AaDEe8D58218e9D6AB5")
//             var options = Web3Options.defaultOptions()
//             options.to = constractAddress
//             options.from = constractAddress
//             let parametersCall = [encodeStr] as [AnyObject]
//             let contract = try web3.contract(jsonString, at: constractAddress)
//
//             let transaction = try contract.method("addr", parameters:parametersCall, options: options)
//
//            let tokenNameRes = try transaction.call(options: options)
//
//
//            return ""
//
//         } catch {
//
//             print(error)
//             return ""
//         }
//     }
//
//
//}
