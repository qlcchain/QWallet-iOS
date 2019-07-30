//
//  AppState.swift
//  O3
//
//  Created by Apisit Toompakdee on 5/23/18.
//  Copyright © 2018 O3 Labs Inc. All rights reserved.
//

import UIKit

class AppState: NSObject {

    static var network: NeoNetwork {
        #if TESTNET
        return .test
        #endif
        #if PRIVATENET
        return .privateNet
        #endif

        return .main
    }

    static var bestSeedNodeURL: String = ""
    static var bestOntologyNodeURL: String = ""

    enum ClaimingState: String {
        case Fresh = ""
        case WaitingForClaimableData = "0"
        case ReadyToClaim = "1"
    }

    static func claimingState(address: String) -> ClaimingState {
        if UserDefaults.standard.value(forKey: address + "_claimingState") == nil {
            return ClaimingState.Fresh
        }
        return  AppState.ClaimingState(rawValue: UserDefaults.standard.string(forKey: address + "_claimingState") ?? "")!
    }

    static func setClaimingState(address: String, claimingState: ClaimingState) {
        UserDefaults.standard.setValue(claimingState.rawValue, forKey: address + "_claimingState")
        UserDefaults.standard.synchronize()
    }
    
    static func dismissBackupNotification() -> Bool {
        if UserDefaults.standard.value(forKey: "dismissedBackupNotification_1.0") == nil {
            return false
        }
        return UserDefaults.standard.bool(forKey: "dismissedBackupNotification_1.0")
    }
    
    static func setDismissBackupNotification(dismiss: Bool) {
        UserDefaults.standard.setValue(dismiss, forKey: "dismissedBackupNotification_1.0")
        UserDefaults.standard.synchronize()
    }

    enum verificationType: Int {
        case screenshot = 0
        case byHand = 1
        case other = 2
    }
    
    static func getManualVerifyType(address: String) -> [verificationType] {
        if UserDefaults.standard.value(forKey: address + "_manualVerifyTypeArray") == nil {
            return []
        } else {
            let listType = UserDefaults.standard.array(forKey: address + "_manualVerifyTypeArray")
            return (listType as! [Int]).map { verificationType(rawValue: $0)! }
        }
    }
    
    static func setManualVerifyType(address: String, types: [verificationType]) {
        let typesRaw = types.map{ $0.rawValue }
        UserDefaults.standard.setValue(typesRaw, forKey: address + "_manualVerifyTypeArray")
        UserDefaults.standard.synchronize()
    }
    
//    static let protectedKeyValue = NEP6.getFromFileSystem() != nil ?  "ozoneActiveNep6Password" :  "ozonePrivateKey"
}
