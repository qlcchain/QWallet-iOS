source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
inhibit_all_warnings!

use_frameworks!

#  shadowsock-----pod

def model
#    3.11.1
    pod 'RealmSwift', '3.7.6'
end

def socket
    pod 'CocoaAsyncSocket', '~> 7.4.3'
end

def library
    pod 'KissXML', '~> 5.2.2'
    #pod 'ICSMainFramework', :path => "./Library/ICSMainFramework/"
    pod 'MMWormhole', '~> 2.0.0'
    pod 'KeychainAccess'
end

def tunnel
    pod 'MMWormhole', '~> 2.0.0'
end

def eth
    pod 'BigInt', '~> 3.0'
    pod 'R.swift'
    pod 'JSONRPCKit', :git=> 'https://github.com/bricklife/JSONRPCKit.git'
    pod 'PromiseKit', '~> 6.0'
    pod 'APIKit'
    pod 'Eureka'
    pod 'KeychainSwift'
    pod 'Moya', '~> 10.0.1'
    pod 'TrustCore', :git=>'https://github.com/TrustWallet/trust-core', :branch=>'master'
    pod 'TrustKeystore', :git=>'https://github.com/TrustWallet/trust-keystore', :branch=>'master'
    pod 'TrezorCrypto'
    pod 'TrustWeb3Provider', :git=>'https://github.com/TrustWallet/trust-web3-provider', :commit=>'f4e0ebb1b8fa4812637babe85ef975d116543dfd'
    pod 'TrustWalletSDK', :git=>'https://github.com/TrustWallet/TrustSDK-iOS', :branch=>'master'
end

target "Qlink" do

    pod 'AFNetworking'
    pod 'IQKeyboardManager'
    pod 'Masonry'
    pod 'MJExtension'
    pod 'MBProgressHUD'
    pod 'SDWebImage'
#    pod 'MJRefresh'
    pod 'Hero'
#    pod 'FMDB'
    pod 'BGFMDB'
    pod 'CocoaLumberjack/Swift'
    pod 'Bugly'
    pod 'OLImageView'
    pod 'Firebase/Core', '~> 5.4.1'
#    pod 'MMWormhole'
    pod 'TagListView', '1.2.0'
    pod 'Charts'

#  shadowsock
    pod 'SwiftColor'
    pod 'AsyncSwift'
    pod 'Appirater'

    tunnel
    library
    #fabric
    socket
    model
    eth

end


target "ShadowsockLibrary" do
    library
    model
    # YAML-Framework 0.0.3 is not available in cocoapods so we install it from local using git submodule
    # pod 'YAML-Framework', :path => "./Library/YAML-Framework"
end

target "ShadowsockModel" do
    model
end

target "ShadowsockTunnel" do
    tunnel
    socket
end

target "ShadowsockProcessor" do
    socket
end


post_install do |installer|
    installer.pods_project.targets.each do |target|
        if ['JSONRPCKit'].include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.0'
            end
        end
        if ['TrustKeystore'].include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'
            end
        end
        # if target.name != 'Realm'
        #     target.build_configurations.each do |config|
        #         config.build_settings['MACH_O_TYPE'] = 'staticlib'
        #     end
        # end
    end
end
