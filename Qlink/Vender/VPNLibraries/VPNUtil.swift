//
//  VPNUtil.swift
//  openVPN-Test
//
//  Created by Jelly Foo on 2018/4/10.
//  Copyright © 2018年 周荣水. All rights reserved.
//

import UIKit
import NetworkExtension
import OpenVPNAdapter

class VPNUtil: NSObject {
    
    public enum VPNOperationStatus : Int {
        case none
        case connect
        case disconnect
    }
    
    static var shareInstance : VPNUtil {
        struct MyStatic{
            static var instance :VPNUtil = VPNUtil()
        }
        return MyStatic.instance;
    }
    
    private let customFlow = CustomFlow()
    var providerManager : NETunnelProviderManager?
    private var currentData : Data?
    var operationStatus : VPNOperationStatus = .none
    
    override init() {
        super.init()
        self.addObserve()
    }
    
    func addObserve() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.vpnchange), name: NSNotification.Name.NEVPNStatusDidChange, object: nil)
    }
    
    func removeObserve() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.NEVPNStatusDidChange, object: nil)
    }
    
    func getOperationStatus() -> Int {
        var status = 0
        if self.operationStatus == .none {
            status = 0
        } else if self.operationStatus == .connect {
            status = 1
        } else if self.operationStatus == .disconnect {
            status = 2
        }
        return status
    }
    
    func configVPN(vpnData:Data?) {
        guard let data = vpnData else { return }
        currentData = data
        self.removeFromPreferences()
        operationStatus = .none
        self.getProviderManager(connect: true)
    }
    
    func stopVPN() {
        operationStatus = .disconnect
        self.stopTunnel()
    }
    
    func vpnConnectStatus() -> NEVPNStatus {
//        self.getProviderManager(connect: false)
        guard let manager = self.providerManager else { return NEVPNStatus.invalid }
        return manager.connection.status;
    }
    
    private func getProviderManager(connect:Bool) {
        NETunnelProviderManager.loadAllFromPreferences { (managers, error) in
            guard error == nil else {
                // Handle an occured error
                return
            }
            
            self.providerManager = managers?.first ?? NETunnelProviderManager()
//            self.providerManager = NETunnelProviderManager()
            
            if connect {
                self.loadFromPreferences(connect: connect)
            }
        }
    }
    
    private func loadFromPreferences(connect:Bool) {
        self.providerManager?.loadFromPreferences(completionHandler: { (error) in
            guard error == nil else {
                // Handle an occured error
                return
            }
            
            // Assuming the app bundle contains a configuration file named 'client.ovpn' lets get its
            // Data representation
            let configurationFileContent = self.currentData!
//            guard
//                let configurationFileURL = Bundle.main.url(forResource: "winqvpn", withExtension: "ovpn"),
//                let configurationFileContent = try? Data(contentsOf: configurationFileURL)
//                else {
//                    fatalError()
//            }
            
            let tunnelProtocol = NETunnelProviderProtocol()
            
            // If the ovpn file doesn't contain server address you can use this property
            // to provide it. Or just set an empty string value because `serverAddress`
            // property must be set to a non-nil string in either case.
            tunnelProtocol.serverAddress = ""
            
            // The most important field which MUST be the bundle ID of our custom network
            // extension target.
            tunnelProtocol.providerBundleIdentifier = PacketTunnelBundleID
            
            // Use `providerConfiguration` to save content of the ovpn file.
            tunnelProtocol.providerConfiguration = ["ovpn": configurationFileContent]
            
            // Provide user credentials if needed. It is highly recommended to use
            // keychain to store a password.
            //            tunnelProtocol.username = "username"
            //            tunnelProtocol.passwordReference = ... // A persistent keychain reference to an item containing the password
            
            // Finish configuration by assigning tunnel protocol to `protocolConfiguration`
            // property of `providerManager` and by setting description.
            self.providerManager?.protocolConfiguration = tunnelProtocol
            self.providerManager?.localizedDescription = WINQ_VPN
//            self.providerManager?.isOnDemandEnabled = true
            self.providerManager?.isEnabled = true
            // Save configuration in the Network Extension preferences
            self.providerManager?.saveToPreferences(completionHandler: { (error) in
                if let error = error  {
                    print(error)
                    
                    // Handle an occured error
                    let nserro = error as NSError
                    print(nserro.code)
//                    if nserro.code == 4 || nserro.code == 5  {return}
                    if nserro.code == 4 {return}
                    NotificationCenter.default.post(name: Notification.Name(rawValue: SAVE_VPN_PREFERENCE_FAIL_NOTI), object: nil)
                } else {
                    print("保存手机vpn配置文件成功")
                    if connect {
//                        self.operationStatus = .connect
                        self.startConnect()
                    }
                }
            })
        })
    }
    
    private func startConnect() {
        self.providerManager?.loadFromPreferences(completionHandler: { (error) in
            guard error == nil else {
                // Handle an occured error
                return
            }

            self.startTunnel()
        })
    }
    
    func removeFromPreferences() {
        print("调用removeFromPreferences 移除手机vpn配置")
        self.providerManager?.removeFromPreferences(completionHandler: { (error) in
            guard error == nil else {
                // Handle an occured error
                return
            }
        })
    }
    
    @objc func vpnchange() {
        if self.providerManager == nil {
            print("vpn providerManager未初始化")
            return
        }
        var statusIsValid : Bool = false  // 有效状态才会发通知出去
        let status : NEVPNStatus = (self.providerManager?.connection.status)!
        print("VPN连接状态：",status.rawValue,"操作：",operationStatus.rawValue)
        var statusStr : String = "0"
        switch status {
        case .invalid:
            DDLogDebug("********************invalid******************")
            statusStr = "0"
            operationStatus = .none
            break
        case .disconnected:
            DDLogDebug("********************disconnected******************")
            statusStr = "1"
            if operationStatus == .disconnect { // 如果是进行 断开vpn  操作
                statusIsValid = true
            }
            if operationStatus == .connect { // 如果是  连接 操作
            }
            operationStatus = .none
            UserDefaults.standard.removeObject(forKey: Current_Connenct_VPN) // 删除当前连接的vpn对象
            break
        case .connecting:
            DDLogDebug("********************connecting******************")
            statusStr = "2"
            operationStatus = .connect
            statusIsValid = true
            break
        case .connected:
            DDLogDebug("********************connected******************")
            statusStr = "3"
            operationStatus = .none
            statusIsValid = true
            break
        case .reasserting:
            DDLogDebug("********************reasserting******************")
            statusStr = "4"
            operationStatus = .none
            break
        case .disconnecting:
            DDLogDebug("********************disconnecting******************")
            statusStr = "5"
            statusIsValid = true
            break
        default:
            break
        }
        print("VPN连接状态更新：",status.rawValue,"操作：",operationStatus.rawValue)
        if statusIsValid { // 状态有效才发送通知
            NotificationCenter.default.post(name: Notification.Name(rawValue: VPN_STATUS_CHANGE_NOTI), object: statusStr)
        }
    }
    
    private func startTunnel() {
        do {
            try self.providerManager?.connection.startVPNTunnel()
        } catch {
            // Handle an occured error
            print(error.localizedDescription)
        }
    }
    
    private func stopTunnel() {
        self.providerManager?.connection.stopVPNTunnel()
    }
    
}
