//
//  PacketTunnelProvider.swift
//  PacketTunnel
//
//  Created by 周荣水 on 2017/12/5.
//Copyright © 2017年 周荣水. All rights reserved.
//

import NetworkExtension
import OpenVPNAdapter
import KeychainAccess
import MMWormhole

let GROUP_WORMHOLE : String = "group.qlink.winq"
let DIRECTORY_WORMHOLE : String = "wormhole"
let VPN_EVENT_IDENTIFIER : String = "vpn_event"
let VPN_MESSAGE_IDENTIFIER : String = "vpn_message"
let VPN_ERROR_REASON_IDENTIFIER : String = "vpn_error_reason"
//let CONNECT_VPN_TIMEOUT = 20

enum PacketTunnelProviderError: Error {
    case fatalError(message: String)
}

class PacketTunnelProvider: NEPacketTunnelProvider {
    
    lazy var vpnAdapter: OpenVPNAdapter = {
        let adapter = OpenVPNAdapter()
        adapter.delegate = self
        
        return adapter
    }()
    
    let wormhole = MMWormhole(applicationGroupIdentifier: GROUP_WORMHOLE, optionalDirectory: DIRECTORY_WORMHOLE)
    
    let vpnReachability = OpenVPNReachability()
    
    var startHandler: ((Error?) -> Void)?
    var stopHandler: (() -> Void)?
    
    let keychain = Keychain(service: "me.ss-abramchuk.Qlink", accessGroup: "6Z83F6YM43.keychain-shared")
    
    override func startTunnel(options: [String : NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        // There are many ways to provide OpenVPN settings to the tunnel provider. For instance,
        // you can use `options` argument of `startTunnel(options:completionHandler:)` method or get
        // settings from `protocolConfiguration.providerConfiguration` property of `NEPacketTunnelProvider`
        // class. Also you may provide just content of a ovpn file or use key:value pairs
        // that may be provided exclusively or in addition to file content.
        
        // In our case we need providerConfiguration dictionary to retrieve content
        // of the OpenVPN configuration file. Other options related to the tunnel
        // provider also can be stored there.
        guard
            let protocolConfiguration = protocolConfiguration as? NETunnelProviderProtocol,
            let providerConfiguration = protocolConfiguration.providerConfiguration
            else {
                fatalError()
        }
        
        guard let ovpnFileContent: Data = providerConfiguration["ovpn"] as? Data else {
            fatalError()
        }
        
        let configuration = OpenVPNConfiguration()
        configuration.fileContent = ovpnFileContent
//        configuration.connectionTimeout = CONNECT_VPN_TIMEOUT // 连接超时时间
//        let privateKey : String? = providerConfiguration["privateKey"] as? String
//        if privateKey != nil { //
//            configuration.privateKeyPassword = privateKey!
//        }
        //        configuration.settings = [
        //            // Additional parameters as key:value pairs may be provided here
        //        ]
        
        // Apply OpenVPN configuration
        let properties: OpenVPNProperties
        do {
            properties = try vpnAdapter.apply(configuration: configuration)
        } catch {
            completionHandler(error)
            return
        }
        
        var connectType : Int = 0
        if properties.isPrivateKeyPasswordRequired {
            if properties.autologin { // 1 私钥
                connectType = 1
            } else { // 3 私钥和用户名密码
                connectType = 3
            }
        } else {
            if properties.autologin { // 0 自动登录
                connectType = 0
            } else { // 2 用户名密码
                connectType = 2
            }
        }
        
        if connectType == 0 { // 0 自动登录
        } else if connectType == 1 { // 1 私钥
            guard let privateKeyPassword: String = providerConfiguration["privateKey"] as? String else {
                fatalError()
            }
            
            configuration.privateKeyPassword = privateKeyPassword
            do {
                try vpnAdapter.apply(configuration: configuration)
            } catch {
                completionHandler(error)
                return
            }
        } else if connectType == 2 { // 2 用户名密码
            guard let username: String = providerConfiguration["userName"] as? String else {
                fatalError()
            }
            guard let password: String = providerConfiguration["password"] as? String else {
                fatalError()
            }
            let credentials = OpenVPNCredentials()
            credentials.username = username
            credentials.password = password
            
            do {
                try vpnAdapter.provide(credentials: credentials)
            } catch {
                completionHandler(error)
                return
            }
        } else if connectType == 3 { // 3 私钥和用户名密码
            // 私钥
            guard let privateKeyPassword: String = providerConfiguration["privateKey"] as? String else {
                fatalError()
            }
            configuration.privateKeyPassword = privateKeyPassword
            do {
                try vpnAdapter.apply(configuration: configuration)
            } catch {
                completionHandler(error)
                return
            }
            
            // 用户名密码
            guard let username: String = providerConfiguration["userName"] as? String else {
                fatalError()
            }
            guard let password: String = providerConfiguration["password"] as? String else {
                fatalError()
            }
            let credentials = OpenVPNCredentials()
            credentials.username = username
            credentials.password = password
            
            do {
                try vpnAdapter.provide(credentials: credentials)
            } catch {
                completionHandler(error)
                return
            }
        }
        
        // Checking reachability. In some cases after switching from cellular to
        // WiFi the adapter still uses cellular data. Changing reachability forces
        // reconnection so the adapter will use actual connection.
        vpnReachability.startTracking { [weak self] status in
            guard status != .notReachable else { return }
            //            self?.vpnAdapter.reconnect(interval: 5)
            self?.vpnAdapter.reconnect(afterTimeInterval: 5)
        }
        
        // Establish connection and wait for .connected event
        startHandler = completionHandler
        vpnAdapter.connect()
    }
    
    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        stopHandler = completionHandler
        
        if vpnReachability.isTracking {
            vpnReachability.stopTracking()
        }
        
        vpnAdapter.disconnect()
    }
    
}

extension PacketTunnelProvider: OpenVPNAdapterDelegate {
    
    // OpenVPNAdapter calls this delegate method to configure a VPN tunnel.
    // `completionHandler` callback requires an object conforming to `OpenVPNAdapterPacketFlow`
    // protocol if the tunnel is configured without errors. Otherwise send nil.
    // `OpenVPNAdapterPacketFlow` method signatures are similar to `NEPacketTunnelFlow` so
    // you can just extend that class to adopt `OpenVPNAdapterPacketFlow` protocol and
    // send `self.packetFlow` to `completionHandler` callback.
    func openVPNAdapter(_ openVPNAdapter: OpenVPNAdapter, configureTunnelWithNetworkSettings networkSettings: NEPacketTunnelNetworkSettings, completionHandler: @escaping (OpenVPNAdapterPacketFlow?) -> Void) {
        setTunnelNetworkSettings(networkSettings) { (error) in
            completionHandler(error == nil ? self.packetFlow : nil)
        }
    }
    
    // Process events returned by the OpenVPN library
    func openVPNAdapter(_ openVPNAdapter: OpenVPNAdapter, handleEvent event: OpenVPNAdapterEvent, message: String?) {
        let num = NSNumber(value: event.rawValue)
        wormhole.passMessageObject(num, identifier: VPN_EVENT_IDENTIFIER)
        switch event {
        case .connected:
            if reasserting {
                reasserting = false
            }
            
            guard let startHandler = startHandler else { return }
            
            startHandler(nil)
            self.startHandler = nil
            
        case .disconnected:
            guard let stopHandler = stopHandler else { return }
            
            if vpnReachability.isTracking {
                vpnReachability.stopTracking()
            }
            
            stopHandler()
            self.stopHandler = nil
            
        case .reconnecting:
            reasserting = true
            
        default:
            break
        }
    }
    
    // Handle errors thrown by the OpenVPN library
    func openVPNAdapter(_ openVPNAdapter: OpenVPNAdapter, handleError error: Error) {
        // 传递错误原因
        let localizedFailureReason = error.localizedDescription ?? (error as NSError).userInfo["NSLocalizedFailureReason"]
//        let localizedFailureReason = (error as NSError).userInfo["NSLocalizedFailureReason"] ?? error.localizedDescription
        wormhole.passMessageObject(localizedFailureReason as? NSCoding, identifier: VPN_ERROR_REASON_IDENTIFIER)
        
        // Handle only fatal errors
        guard let fatal = (error as NSError).userInfo[OpenVPNAdapterErrorFatalKey] as? Bool, fatal == true else {
            return
        }
        
        if vpnReachability.isTracking {
            vpnReachability.stopTracking()
        }
        
        if let startHandler = startHandler {
            startHandler(error)
            self.startHandler = nil
        } else {
            cancelTunnelWithError(error)
        }
    }
    
    // Use this method to process any log message returned by OpenVPN library.
    func openVPNAdapter(_ openVPNAdapter: OpenVPNAdapter, handleLogMessage logMessage: String) {
        // Handle log messages
        wormhole.passMessageObject(logMessage as NSCoding, identifier: VPN_MESSAGE_IDENTIFIER)
    }
}

// Extend NEPacketTunnelFlow to adopt OpenVPNAdapterPacketFlow protocol so that
// `self.packetFlow` could be sent to `completionHandler` callback of OpenVPNAdapterDelegate
// method openVPNAdapter(openVPNAdapter:configureTunnelWithNetworkSettings:completionHandler).
//extension NEPacketTunnelFlow: OpenVPNAdapterPacketFlow {}
