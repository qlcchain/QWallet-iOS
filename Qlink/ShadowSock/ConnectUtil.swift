//
//  ConnectUtil.swift
//  ShadowsockTest
//
//  Created by Jelly Foo on 2018/8/14.
//  Copyright © 2018年 qlink. All rights reserved.
//

import UIKit
import ShadowsockLibrary
import ShadowsockModel
import MMWormhole

class ConnectUtil: NSObject {
    
    static func managerInit() {
        Manager.sharedManager.setup()
    }
    
    static func postMessage() {
        Manager.sharedManager.postMessage()
    }
    
    var group: ConfigurationGroup {
        return CurrentGroupManager.shared.group
    }
    
//    var proxy: Proxy? {
//        return group.proxies.first
//    }
    
    var upstreamProxy: Proxy?
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(onVPNStatusChanged), name: NSNotification.Name(rawValue: kProxyServiceVPNStatusNotification), object: nil)
        CurrentGroupManager.shared.onChange = { group in
//            self.delegate?.handleRefreshUI()
        }
        self.observe()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func onVPNStatusChanged() {
//        self.delegate?.handleRefreshUI()
    }
    
    func observe() {
        let wormhole = MMWormhole(applicationGroupIdentifier: Potatso.sharedGroupIdentifier(), optionalDirectory: "wormhole")
        wormhole.listenForMessage(withIdentifier: "tunnelStatus") { (messageObject) in
            print("tunnelStatus:\(messageObject ?? "")")
        }
        wormhole.listenForMessage(withIdentifier: "startVPNConfig") { (messageObject) in
            print("startVPNConfig:\(messageObject ?? "")")
        }
        wormhole.listenForMessage(withIdentifier: "startVPN") { (messageObject) in
            print("startVPN:\(messageObject ?? "")")
        }
        
    }
    
    func configSS() {
        do {
            self.upstreamProxy = Proxy()
            upstreamProxy!.type = .Shadowsocks
            upstreamProxy!.name = "香港"
            upstreamProxy!.host = "13.230.53.97"
            upstreamProxy!.port = 8866
            upstreamProxy!.authscheme = "aes-256-cfb"
            upstreamProxy!.user = nil
            upstreamProxy!.password = "Winq@123"
            upstreamProxy!.ota = false
            upstreamProxy!.ssrProtocol = nil
            upstreamProxy!.ssrObfs = nil
            upstreamProxy!.ssrObfsParam = nil
            try DBUtils.add(upstreamProxy!)
        }catch {
            print("\(error)")
        }
        
        do {
            try ConfigurationGroup.changeProxy(forGroupId: self.group.uuid, proxyId: upstreamProxy!.uuid)
//            self.delegate?.handleRefreshUI()
        }catch {
            print("\("Fail to change proxy".localized()): \((error as NSError).localizedDescription)")
//            self.vc.showTextHUD("\("Fail to change proxy".localized()): \((error as NSError).localizedDescription)", dismissAfterDelay: 1.5)
        }
    }
    
    func switchVPN() {
        VPN.switchVPN(group) { [unowned self] (error) in
            if let error = error {
                print("\("Fail to switch VPN.".localized()) (\(error))")
//                Alert.show(self.vc, message: "\("Fail to switch VPN.".localized()) (\(error))")
            }
        }
    }
    
    static func regenerateConfigFiles() {
        _ = try? Manager.sharedManager.regenerateConfigFiles()
    }

}

class CurrentGroupManager {
    
    static let shared = CurrentGroupManager()
    
    fileprivate init() {
        _groupUUID = Manager.sharedManager.defaultConfigGroup.uuid
    }
    
    var onChange: ((ConfigurationGroup?) -> Void)?
    
    fileprivate var _groupUUID: String {
        didSet(o) {
            self.onChange?(group)
        }
    }
    
    var group: ConfigurationGroup {
        if let group = DBUtils.get(_groupUUID, type: ConfigurationGroup.self, filter: "deleted = false") {
            return group
        } else {
            let defaultGroup = Manager.sharedManager.defaultConfigGroup
            setConfigGroupId(defaultGroup.uuid)
            return defaultGroup
        }
    }
    
    func setConfigGroupId(_ id: String) {
        if let _ = DBUtils.get(id, type: ConfigurationGroup.self, filter: "deleted = false") {
            _groupUUID = id
        } else {
            _groupUUID = Manager.sharedManager.defaultConfigGroup.uuid
        }
    }
    
}
