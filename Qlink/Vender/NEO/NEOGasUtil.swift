//
//  NEOGasUtil.swift
//  Qlink
//
//  Created by Jelly Foo on 2018/11/20.
//  Copyright © 2018 pan. All rights reserved.
//

import UIKit

class NEOGasUtil: NSObject {
    
    static let swiftSharedInstance = NEOGasUtil()
    //在oc中这样写才能被调用
    @objc open class func sharedInstance() -> NEOGasUtil
    {
        return NEOGasUtil.swiftSharedInstance
    }
    
//    var claims: Claims?
    var claims: Claimable?
    var isClaiming: Bool = false
    
    var neoBalance: Int? = 0
//    var gasBalance: Double?
//    var refreshClaimableGasTimer: Timer?
    
    func configInit() {
        loadClaimableGAS { (amount) in
            
        }
//        refreshClaimableGasTimer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(NEOGasUtil.loadClaimableGAS), userInfo: nil, repeats: true)
//        refreshClaimableGasTimer?.fire()
    }
    
    @objc func reloadAllData() {
        loadClaimableGAS { (amount) in
            
        }
    }
    
    func claimGas() {
        self.enableClaimButton(enable: false)
        //refresh the amount of claimable gas
//        self.loadClaimableGAS { (amount) in
//        }
        NEOWalletManage.sharedInstance().account?.claimGas(network: AppState.network, seedURL: AppState.bestSeedNodeURL, completion: { (_, error) in
//            <#code#>
//        })
//        NEOWalletManage.sharedInstance().account?.claimGas { _, error in
            if error != nil {
                //if error then try again in 10 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                    self.claimGas()
                }
                return
            }
            
            DispatchQueue.main.async {
                //HUD something to notify user that claim succeeded
                //done claiming
                
                DispatchQueue.main.async {
                    print("Your claim has succeeded, it may take a few minutes to be reflected in your transaction history. You can claim again after 5 minutes")
                }
                
                //save latest claim time interval here to limit user to only claim every 5 minutes
                let now = Date().timeIntervalSince1970
                UserDefaults.standard.set(now, forKey: "lastetClaimDate")
                UserDefaults.standard.synchronize()
                
                self.isClaiming = false
                //if claim succeeded then fire the timer to refresh claimable gas again.
//                self.refreshClaimableGasTimer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(NEOGasUtil.loadClaimableGAS), userInfo: nil, repeats: true)
//                self.refreshClaimableGasTimer?.fire()
                
                self.loadClaimableGAS({ (amount) in
                    
                })
                
            }
        })
    }
    
    func enableClaimButton(enable: Bool) {
//        claimButton.isEnabled = enable && isClaiming == false
    }
    
    @objc open func neoClaimGas(_ complete:@escaping (_ success : Bool) ->()) {
        print("Claiming GAS, This might take a little while...")
        
        //select best node
//        if let bestNode = NEONetworkMonitor.autoSelectBestNode() {
//            UserDefaultsManager.seed = bestNode
//            UserDefaultsManager.useDefaultSeed = false
//        }
        let network = Network.main
        var node = AppState.bestSeedNodeURL
        if let bestNode = NEONetworkMonitor.autoSelectBestNode(network: network) {
            node = bestNode
            UserDefaultsManager.seed = node
            UserDefaultsManager.useDefaultSeed = false
            AppState.bestSeedNodeURL = bestNode
        }
        
        //we are able to claim gas only when there is data in the .claims array
        if self.claims != nil && self.claims!.claims.count > 0 {
            DispatchQueue.main.async {
                let account1 = NEOWalletManage.sharedInstance().account
                if (account1 != nil) {
                    account1!.claimGas(network: AppState.network, seedURL: AppState.bestSeedNodeURL, completion: { (_, error) in
                        if error != nil {
                            //if error then try again in 10 seconds
    //                        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
    //                            self.claimGas()
    //                        }
                            DispatchQueue.main.async {
                                complete(false)
                            }
                            return
                        }
                        
                        DispatchQueue.main.async {
                            //HUD something to notify user that claim succeeded
                            //done claiming
                            
                            DispatchQueue.main.async {
                                print("Your claim has succeeded, it may take a few minutes to be reflected in your transaction history. You can claim again after 5 minutes")
                            }
                            
                            //save latest claim time interval here to limit user to only claim every 5 minutes
    //                        let now = Date().timeIntervalSince1970
    //                        UserDefaults.standard.set(now, forKey: "lastetClaimDate")
    //                        UserDefaults.standard.synchronize()
                            DispatchQueue.main.async {
                            
                                self.isClaiming = false
                                //if claim succeeded then fire the timer to refresh claimable gas again.
                                //                self.refreshClaimableGasTimer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(NEOGasUtil.loadClaimableGAS), userInfo: nil, repeats: true)
                                //                self.refreshClaimableGasTimer?.fire()
                                self.claims = nil
                                complete(true)
                            }
                        }
                    })
                } else {
                    complete(false)
                }
            }
        } else {
            complete(false)
        }
    }
    
    func prepareClaimingGAS() {
//        if self.neoBalance == nil || self.neoBalance == 0 {
//            return
//        }
//        refreshClaimableGasTimer?.invalidate()
        //disable the button after tapped
        enableClaimButton(enable: false)
        
        print("Claiming GAS, This might take a little while...")
        
        //select best node
//        if let bestNode = NEONetworkMonitor.autoSelectBestNode() {
//            UserDefaultsManager.seed = bestNode
//            UserDefaultsManager.useDefaultSeed = false
//        }
        let network = Network.main
        var node = AppState.bestSeedNodeURL
        if let bestNode = NEONetworkMonitor.autoSelectBestNode(network: network) {
            node = bestNode
            UserDefaultsManager.seed = node
            UserDefaultsManager.useDefaultSeed = false
            AppState.bestSeedNodeURL = bestNode
        }
        
        //we are able to claim gas only when there is data in the .claims array
        if self.claims != nil && self.claims!.claims.count > 0 {
            DispatchQueue.main.async {
                self.claimGas()
            }
            return
        }
        let mainNet = true
        let assetHash = ""
        let remarkStr:String? = nil
        let fee = NEO_fee
        //to be able to claim. we need to send the entire NEO to ourself.
        NEOWalletManage.sharedInstance().account?.sendAssetTransaction(assetHash: assetHash, asset: AssetId.neoAssetId, amount: Double(self.neoBalance!), toAddress: (NEOWalletManage.sharedInstance().account?.address)!, mainNet: mainNet, remarkStr: remarkStr, network: network, fee:fee) { (txHex, error) in
            if error == nil {
//                HUD.hide()
                //HUD or something
                //in case it's error we then enable the button again.
                self.enableClaimButton(enable: true)
                return
            }
            
            DispatchQueue.main.async {
                //if completed then mark the flag that we are claiming GAS
                self.isClaiming = true
                //disable button and invalidate the timer to refresh claimable GAS
//                self.refreshClaimableGasTimer?.invalidate()
                //try to claim gas after 10 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                    self.claimGas()
                }
            }
        }
    }
    
    @objc open func loadClaimableGAS(_ complete:@escaping (_ amount : String) ->()) {
        if NEOWalletManage.sharedInstance().haveDefaultWallet() == false {
            return
        }
        let network = Network.main
        O3APIClient(network: network).getClaims(address: (NEOWalletManage.sharedInstance().account?.address)!) { result in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    complete("0")
                }
            case .success(let claims):
                self.claims = claims
//                let amount: Double = Double(claims.totalUnspentClaim) / 100000000.0
                let gasDec = NSDecimalNumber(decimal: self.claims!.gas)
                let amount: String = gasDec.stringValue
                DispatchQueue.main.async {
                    complete(amount)
//                    self.showClaimableGASAmount(amount: amount)
                }
            }
        }
    }
    
    func showClaimableGASAmount(amount: Double) {
        DispatchQueue.main.async {
            
//            amountLabel.text = amount.string(8)
            
            //only enable button if latestClaimDate is more than 5 minutes
            let latestClaimDateInterval: Double = UserDefaults.standard.double(forKey: "lastetClaimDate")
            let latestClaimDate: Date = Date(timeIntervalSince1970: latestClaimDateInterval)
            let diff = Date().timeIntervalSince(latestClaimDate)
            if diff > (5 * 60) {
//                claimButton.isEnabled = true
            } else {
//                claimButton.isEnabled = false
            }
            
            //amount needs to be more than zero
//            claimButton.isEnabled = amount > 0
        }
    }
    
}
